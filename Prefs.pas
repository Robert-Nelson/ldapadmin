  {      LDAPAdmin - Prefs.pas
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

unit Prefs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, RegAccnt, Constant, Samba, LDAPClasses;

type
  TPrefDlg = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edFirstUID: TEdit;
    edLastUID: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edFirstGID: TEdit;
    edLastGID: TEdit;
    Panel1: TPanel;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    edHomeDir: TEdit;
    edLoginShell: TEdit;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edScript: TEdit;
    edHomeShare: TEdit;
    edProfilePath: TEdit;
    cbHomeDrive: TComboBox;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    edMaildrop: TEdit;
    edMailAddress: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    GroupBox6: TGroupBox;
    Label7: TLabel;
    edNetbios: TEdit;
    Label14: TLabel;
    edGroup: TEdit;
    SetBtn: TButton;
    Label15: TLabel;
    cbDomain: TComboBox;
    edDisplayName: TEdit;
    edUsername: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    BtnWizard: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BtnWizardClick(Sender: TObject);
  private
    Account: TAccountEntry;
    Session: TLDAPSession;
    DomList: TDomainList;
  public
    constructor Create(AOwner: TComponent; rAccount: TAccountEntry; lSession: TLDAPSession); reintroduce; overload;
  end;

var
  PrefDlg: TPrefDlg;

implementation

uses Pickup, WinLdap, PrefWiz;

{$R *.DFM}

constructor TPrefDlg.Create(AOwner: TComponent; rAccount: TAccountEntry; lSession: TLDAPSession);
begin
  inherited Create(AOwner);
  Account := rAccount;
  Session := lSession;
  with Account do
  begin
    edFirstUID.Text := IntToStr(posixFirstUID);
    edLastUID.Text := IntToStr(posixLastUID);
    edFirstGID.Text := IntToStr(posixFirstGID);
    edLastGID.Text := IntToStr(posixLastGID);
    edUserName.Text := posixUserName;
    edDisplayName.Text := inetDisplayName;
    edHomeDir.Text := posixHomeDir;
    edLoginShell.Text := posixLoginShell;
    if posixGroup <> NO_GROUP then
      edGroup.Text := Session.GetDN(Format(sGROUPBYGID, [posixGroup]));
    edNetbios.Text := sambaNetbiosName;
    edHomeShare.Text := sambaHomeShare;
    cbHomeDrive.ItemIndex := cbHomeDrive.Items.IndexOf(sambaHomeDrive);
    edScript.Text := sambaScript;
    edProfilePath.Text := sambaProfilePath;
    edMailAddress.Text := postfixMailAddress;
    edMaildrop.Text := postfixMaildrop;
  end;
end;

procedure TPrefDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  with Account do begin
    posixFirstUID := StrToInt(edFirstUID.Text);
    posixLastUID := StrToInt(edLastUID.Text);
    posixFirstGID := StrToInt(edFirstGID.Text);
    posixLastGID := StrToInt(edLastGID.Text);
    posixUserName := edUserName.Text;
    inetDisplayName := edDisplayName.Text;
    posixHomeDir := edHomeDir.Text;
    posixLoginShell := edLoginShell.Text;
    if edGroup.Text <> '' then
      posixGroup := StrToInt(Session.Lookup(edGroup.Text, sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE))
    else
      posixGroup := NO_GROUP;
    sambaNetbiosName := edNetbios.Text;
    sambaDomainName := cbDomain.Text;
    sambaHomeShare := edHomeShare.Text;
    sambaHomeDrive := cbHomeDrive.Text;
    sambaScript := edScript.Text;
    sambaProfilePath := edProfilePath.Text;
    postfixMailAddress := edMailAddress.Text;
    postfixMaildrop := edMaildrop.Text;
    Write;
  end;
end;

procedure TPrefDlg.SetBtnClick(Sender: TObject);
begin
  with TPickupDlg.Create(Self), ListView do
  begin
    PopulateGroups(Session);
    if ShowModal = mrOk then
      EdGroup.Text := PChar(Selected.Data);
  end;
end;

procedure TPrefDlg.PageControl1Change(Sender: TObject);
var
  i: Integer;
begin
  if not Assigned(DomList) then
  try
    DomList := TDomainList.Create(Session);
    with cbDomain do
    begin
      Items.Add(cSamba2Accnt);
      for i := 0 to DomList.Count - 1 do
        Items.Add(DomList.Items[i].DomainName);
      ItemIndex := Items.IndexOf(Account.SambaDomainName);
      if ItemIndex = -1 then
        ItemIndex := 0;
    end;
  except
  // TODO
  end;
end;

procedure TPrefDlg.BtnWizardClick(Sender: TObject);
begin
  PageControl1Change(nil); // Get domain list
  TPrefWizDlg.Create(Self).ShowModal;
end;

end.
