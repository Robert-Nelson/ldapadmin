  {      LDAPAdmin - Export.pas
  *      Copyright (C) 2003 Tihomir Karlovic
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

const
  C_WRAP = 80;

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
    CheckBox1: TCheckBox;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    Label3: TLabel;
    ResultLabel: TLabel;
    Label5: TLabel;
    ExportingLabel: TLabel;
    procedure BrowseBtnClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    dn: string;
    pld: PLDAP;
    function DumpTree(const Filter: string): Integer;
  public
    constructor Create(AOwner: TComponent; const dn: string; const pld: PLDAP); reintroduce;
  end;

var
  ExportDlg: TExportDlg;

implementation

uses Constant;

{$R *.DFM}

constructor TExportDlg.Create(AOwner: TComponent; const dn: string; const pld: PLDAP);
begin
  inherited Create(AOwner);
  Self.dn := dn;
  Self.pld := pld;
end;

procedure TExportDlg.BrowseBtnClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    edFileName.Text := SaveDialog.FileName;
end;

function TExportDlg.DumpTree(const Filter: string): Integer;
var
  plmSearch, plmEntry: PLDAPMessage;
  attrs: PCharArray;
  pszdn: PChar;
  Entry: TLDAPEntry;
  F: TextFile;

begin

  AssignFile(F, edFileName.Text);
  try
    Rewrite(F);
  except
    RaiseLastWin32Error;
  end;

  try

  // set result to objectclass only
  SetLength(attrs, 2);
  attrs[0] := 'objectclass';
  attrs[1] := nil;
  LdapCheck(ldap_search_s(pld, PChar(dn), LDAP_SCOPE_SUBTREE, PChar(Filter), PChar(attrs), 0, plmSearch));

  try

    Result := 0;
    plmEntry := ldap_first_entry(pld, plmSearch);

    ProgressBar.Max := ldap_count_entries(pld, plmSearch);

    while Assigned(plmEntry) do
    begin

      pszdn := ldap_get_dn(pld, plmEntry);

      if Assigned(pszdn) then
      try
        Entry := TLDAPEntry.Create(pld, pszdn);
        try
          Entry.Read;
          Entry.ToLdif(F, C_WRAP);
        finally
          Entry.Free;
        end;
      finally
        ldap_memfree(pszdn);
      end;

      inc(Result);
      ProgressBar.StepIt;

      plmEntry := ldap_next_entry(pld, plmEntry);

    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;

  finally
    CloseFile(F);
  end;

end;


procedure TExportDlg.edFileNameChange(Sender: TObject);
begin
  OkBtn.Enabled := edFileName.Text <> '';
end;

procedure TExportDlg.OKBtnClick(Sender: TObject);
begin
  ExportingLabel.Caption := dn;
  Notebook.ActivePage := 'Progress';
  Application.ProcessMessages;
  try
    ResultLabel.Caption := Format('Success: %d Object(s) succesfully exported!', [DumpTree(sANYCLASS)]);
  except
    OKBtn.Caption := '&Retry';
    raise;
  end;
  OKBtn.Visible := false;
  CancelBtn.Caption := '&Close';
  CancelBtn.Left := (Width - CancelBtn.Width) div 2;
  CancelBtn.Default := true;
end;

end.
