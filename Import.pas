  {      LDAPAdmin - Import.pas
  *      Copyright (C) 2004 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic
  *
  *
  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  }

unit Import;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, WinLdap, LDAPClasses, ComCtrls;

type
  TImportDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Notebook: TNotebook;
    Bevel1: TBevel;
    Label1: TLabel;
    btnFileName: TSpeedButton;
    edFileName: TEdit;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    Label3: TLabel;
    ResultLabel: TLabel;
    Label5: TLabel;
    ImportingLabel: TLabel;
    cbStopOnError: TCheckBox;
    edRejected: TEdit;
    btnRejected: TSpeedButton;
    Label6: TLabel;
    OpenDialog: TOpenDialog;
    DetailBtn: TButton;
    mbErrors: TMemo;
    errResultLabel: TLabel;
    errLabel: TLabel;
    procedure btnFileNameClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure DetailBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure btnRejectedClick(Sender: TObject);
  private
    ObjCount: Integer;
    ErrCount: Integer;
    Session: TLDAPSession;
    Stop: Boolean;
    procedure ImportFile(const FileName: string);
  public
    constructor Create(AOwner: TComponent; const ASession: TLDAPSession); reintroduce;
  end;

var
  ImportDlg: TImportDlg;

implementation

uses LDIF, Constant;

{$R *.DFM}

constructor TImportDlg.Create(AOwner: TComponent; const ASession: TLDAPSession);
begin
  inherited Create(AOwner);
  Session := ASession;
end;

procedure TImportDlg.btnFileNameClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edFileName.Text := OpenDialog.FileName;
end;

procedure TImportDlg.ImportFile(const FileName: string);
var
  Entry: TLDAPEntry;
  F: File;
  R: TextFile;
  ldFile: TLdifFile;
  i: Integer;
  StopOnError: Boolean;
  RejectList: Boolean;
begin
  ObjCount := 0;
  ErrCount := 0;
  mbErrors.Clear;

  RejectList := edRejected.Text <> '';
  if RejectList then
  begin
    AssignFile(R, edRejected.Text);
    try
      Rewrite(R);
    except
      on E: Exception do
        raise Exception.Create(Format('%s: %s!', [edRejected.Text, E.Message]));
    end;
  end;

  StopOnError := cbStopOnError.Checked;

  try
    try
      System.Assign(F, FileName);
      FileMode := 0;
      Reset(F,1);
      ProgressBar.Max := FileSize(F);
    finally
      CloseFile(F);
    end;

    Entry := TLDAPEntry.Create(Session, '');
    ldFile := TLDIFFile.Create(edFileName.Text, fmRead);
    with ldFile do
    begin
      ProgressBar.Position := 0;
      while not (eof or Stop) do
      try
        ReadRecord;
        Entry.ClearAttrs;
        for i := 0 to Count - 1 do
          Entry.AddAttr(Attributes[i].Name, Attributes[i].Value, LDAP_MOD_ADD);
        Entry.dn := PChar(dn);
        ImportingLabel.Caption := dn;
        ProgressBar.Position := NumRead;
        Entry.New;
        inc(ObjCount);
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Inc(ErrCount);
          mbErrors.Lines.Add(dn);
          mbErrors.Lines.Add('  ' + E.Message);
          if RejectList then
          try
            WriteLn(R, dn);
            for i := 0 to RecordLines.Count - 1 do
              WriteLn(R, RecordLines[i]);
            WriteLn(R);
          except
            on E: EInOutError do
              RaiseLastWin32Error
            else
              raise //Exception.Create(Format('%s: %s!', [edRejected.Text, E.Message]));
          end;
          if StopOnError then
            case MessageDlg(Format(stSkipRecord, [E.Message]), mtError, [mbIgnore, mbCancel, mbAll], 0) of
              mrCancel: break;
              mrAll: StopOnError := false;
            end;
        end;
      end;
    end;
  finally
    if RejectList then try
      CloseFile(R);
    except end;
    FreeAndNil(Entry);
    FreeAndNil(ldFile);
  end;
end;

procedure TImportDlg.edFileNameChange(Sender: TObject);
begin
  OkBtn.Enabled := edFileName.Text <> '';
end;

procedure TImportDlg.OKBtnClick(Sender: TObject);
begin
  OKBtn.Enabled := false;
  Notebook.ActivePage := 'Progress';
  Application.ProcessMessages;
  try
    ImportFile(edFileName.Text);
    ResultLabel.Caption := Format(stLdifSuccess, [ObjCount]);
    if ErrCount > 0 then
    begin
      errLabel.Visible := true;
      errResultLabel.Caption := Format(stLdifFailure, [ErrCount]);
      DetailBtn.Visible := true;
    end;
  except
    OKBtn.Caption := '&Retry';
    OKBtn.Enabled := true;
    raise;
  end;
  OKBtn.Visible := false;
  CancelBtn.Caption := '&Close';
  CancelBtn.Left := (Width - CancelBtn.Width) div 2;
  CancelBtn.Default := true;
end;

procedure TImportDlg.DetailBtnClick(Sender: TObject);
begin
  if mbErrors.Visible then
  begin
    mbErrors.Visible := false;
    Height := 266;
    DetailBtn.Caption := '&Details >>';
  end
  else begin
    mbErrors.Visible := true;
    Height := 477;
    DetailBtn.Caption := '&Details <<';
  end;
end;

procedure TImportDlg.FormCreate(Sender: TObject);
begin
  Height := 266;
end;

procedure TImportDlg.CancelBtnClick(Sender: TObject);
begin
  Stop := true;
end;

procedure TImportDlg.btnRejectedClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edRejected.Text := OpenDialog.FileName;
end;

end.
