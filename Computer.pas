  {      LDAPAdmin - Computer.pas
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

unit Computer;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, LDAPClasses, Constant;

type
  TComputerDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Computername: TEdit;
    Label1: TLabel;
    Description: TEdit;
    Label2: TLabel;
    procedure ComputernameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    dn: string;
    ldSession: TLDAPSession;
    EditMode: TEditMode;
    function NextUID: Integer;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  ComputerDlg: TComputerDlg;

implementation

uses WinLDAP;

{$R *.DFM}

constructor TComputerDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  Self.dn := dn;
  ldSession := Session;
  EditMode := Mode;
  if EditMode = EM_MODIFY then
  begin
    Computername.Enabled := False;
    Computername.Text := ldSession.GetNameFromDN(dn);
    Caption := Format(cPropertiesOf, [Computername.Text]);
    //TODO: LookupList: func gets attrs list returns list or array of results
    //Computername.text := ldSession.Lookup(dn, sANYCLASS, 'uid', LDAP_SCOPE_BASE);
    Description.text := ldSession.Lookup(dn, sANYCLASS, 'description', LDAP_SCOPE_BASE);
  end;
end;


procedure TComputerDlg.ComputernameChange(Sender: TObject);
begin
  OKBtn.Enabled := Computername.Text <> '';
end;

function TComputerDlg.NextUID: Integer;
begin
  Result := ldSession.Max(sSAMBAACCNT, 'uidNumber') + 1;
  if Result < START_UID then
    Result := START_UID;
end;

procedure TComputerDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Entry: TLDAPEntry;
  uidnr, gidnr, rid, grouprid: Integer;
  nbName, mPass: string;
begin
  if ModalResult = mrOk then
  begin
    if EditMode = EM_ADD then
    begin
      // Aquire next available uidNumber and calculate related SAMBA attributes
      uidnr := NextUID;
      gidnr := COMPUTER_GROUP;
      rid := 2*uidnr + 1000;
      grouprid := 2*gidnr + 1001;
      // Machine account password is lowercase name
      mPass := lowercase(Computername.Text);
      nbName := uppercase(Computername.Text) + '$';

      Entry := TLDAPEntry.Create(ldSession.pld, 'uid=' + nbName + ',' + dn);
      with Entry do
      try
        AddAttr('objectclass', 'top', LDAP_MOD_ADD);
        AddAttr('objectclass', 'account', LDAP_MOD_ADD);
        AddAttr('objectclass', 'posixAccount', LDAP_MOD_ADD);
        AddAttr('objectclass', 'shadowAccount', LDAP_MOD_ADD);
        AddAttr('objectclass', 'sambaAccount', LDAP_MOD_ADD);
        // Posix Stuff
        AddAttr('uidNumber', IntToStr(uidnr), LDAP_MOD_ADD);
        AddAttr('gidNumber', IntToStr(gidnr), LDAP_MOD_ADD);
        AddAttr('cn', nbName, LDAP_MOD_ADD); // set cn to be equal to uid
        AddAttr('uid', nbName, LDAP_MOD_ADD);
        if Description.Text <> '' then
          AddAttr('description', Description.Text, LDAP_MOD_ADD);
        //AddAttr('displayName', uppercase(Computername.Text), LDAP_MOD_ADD);
        AddAttr('homeDirectory', '/dev/null', LDAP_MOD_ADD);
        AddAttr('loginShell', '/bin/false', LDAP_MOD_ADD);
        // Samba Stuff
        AddAttr('rid', IntToStr(rid), LDAP_MOD_ADD);
        AddAttr('primaryGroupID', IntToStr(grouprid), LDAP_MOD_ADD);
        AddAttr('pwdMustChange', '2147483647', LDAP_MOD_ADD);
        AddAttr('pwdCanChange', '0', LDAP_MOD_ADD);
        AddAttr('pwdLastSet', '0', LDAP_MOD_ADD);
        AddAttr('kickoffTime', '2147483647', LDAP_MOD_ADD);
        AddAttr('logOnTime', '2147483647', LDAP_MOD_ADD);
        AddAttr('logoffTime', '0', LDAP_MOD_ADD);
        AddAttr('acctFlags', '[W          ]', LDAP_MOD_ADD);
        AddAttr('ntPassword', mPass, LDAP_MOD_ADD);
        //AddAttr('lmPassword', mPass, LDAP_MOD_ADD);
        Add;
      finally
        Entry.Free;
      end;
    end
    else
    if Description.Modified then
    begin
      Entry := TLDAPEntry.Create(ldSession.pld, dn);
      with Entry do
      try
        AddAttr('description', Description.Text, LDAP_MOD_REPLACE);
        Modify;
      finally
        Entry.Free;
      end;
    end;
  end;
end;

end.
