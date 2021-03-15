  {      LDAPAdmin - Export.pas
  *      Copyright (C) 2003-2006 Tihomir Karlovic
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

unit Export;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, WinLdap, LDAPClasses, ComCtrls;

type

  TExportDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    SaveDialog: TSaveDialog;
    Notebook: TNotebook;
    Bevel1: TBevel;
    Label1: TLabel;
    BrowseBtn: TSpeedButton;
    edFileName: TEdit;
    SubDirsCbk: TCheckBox;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    Label3: TLabel;
    ResultLabel: TLabel;
    Label5: TLabel;
    ExportingLabel: TLabel;
    Label4: TLabel;
    procedure BrowseBtnClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SubDirsCbkClick(Sender: TObject);
  private
    dn:           string;
    FAttributes:  array of string;
    FScope:       Cardinal;
    Session:      TLDAPSession;
    function      DumpTree(const Filter: string; UnixWrite: Boolean): Integer;
  public
    constructor   Create(const adn: string; const ASession: TLDAPSession; const CanSubDirs: boolean=true); reintroduce; overload;
    constructor   Create(const adn: string; const ASession: TLDAPSession; const Attributes: array of string; const CanSubDirs: boolean=true); reintroduce; overload;
  end;

var
  ExportDlg: TExportDlg;

implementation

uses LDIF, Constant;

{$R *.DFM}

function TrimPath(const s: string; const MaxLen: Integer): string;
var
  p, pr: PChar;
begin
  SetString(Result, PChar(s), Length(s));
  if length(Result) <= MaxLen then
    Exit;
  p := PChar(Result);
  p[MaxLen] := #0;

  pr := AnsiStrRScan(p, ',');
  if pr <> nil then
  begin
    SetLength(Result, pr-p+1);
    Result := Result + '..';
  end;
end;

constructor TExportDlg.Create(const adn: string; const ASession: TLDAPSession; const CanSubDirs: boolean=true);
begin
  Create(Adn, Asession, [], CanSubDirs);
end;

constructor TExportDlg.Create(const adn: string; const ASession: TLDAPSession; const Attributes: array of string; const CanSubDirs: boolean=true);
var
  i: integer;
begin
  inherited Create(nil);

  dn := adn;
  Session := ASession;
  ExportingLabel.Caption := TrimPath(dn, 40);
  Label4.Caption := Label4.Caption + ExportingLabel.Caption;
  Label4.Hint := dn;

  SubDirsCbk.Checked:=CanSubDirs;
  SubDirsCbk.Visible:=CanSubDirs;
  SubDirsCbkClick(nil);

  setlength(FAttributes, length(Attributes));
  for i:=0 to length(Attributes)-1 do FAttributes[i]:=Attributes[i];
end;

procedure TExportDlg.BrowseBtnClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    edFileName.Text := SaveDialog.FileName;
end;

function TExportDlg.DumpTree(const Filter: string; UnixWrite: Boolean): Integer;
var
  EntryList: TLdapEntryList;
  ldif: TLDIFFile;
  i: Integer;
begin
  ldif := TLDIFFile.Create(edFileName.Text, fmWrite);
  ldif.UnixWrite := UnixWrite;
  try
    EntryList := TLdapEntryList.Create;
    try
      Session.Search(Filter, dn, FScope, FAttributes, false, EntryList);
      ProgressBar.Max := EntryList.Count;
      Result := 0;
      for i := 0 to EntryList.Count - 1 do
      begin
        ldif.WriteRecord(EntryList[i]);
        inc(Result);
        ProgressBar.StepIt;
      end;
    finally
      EntryList.Free;
    end;
  finally
    ldif.Free;
  end;
end;


procedure TExportDlg.edFileNameChange(Sender: TObject);
begin
  OkBtn.Enabled := edFileName.Text <> '';
end;

procedure TExportDlg.OKBtnClick(Sender: TObject);
begin
  //ExportingLabel.Caption := dn;
  Notebook.ActivePage := 'Progress';
  Application.ProcessMessages;
  try
    ResultLabel.Caption := Format('Success: %d Object(s) succesfully exported!', [DumpTree(sANYCLASS, SaveDialog.FilterIndex = 2)]);
  except
    OKBtn.Caption := '&Retry';
    raise;
  end;
  OKBtn.Visible := false;
  CancelBtn.Caption := '&Close';
  CancelBtn.Left := (Width - CancelBtn.Width) div 2;
  CancelBtn.Default := true;
end;

procedure TExportDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=CaFree;
end;

procedure TExportDlg.SubDirsCbkClick(Sender: TObject);
begin
  if SubDirsCbk.Checked then
    FScope := LDAP_SCOPE_SUBTREE
  else
    FScope := LDAP_SCOPE_BASE;
end;

end.
