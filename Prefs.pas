  {      LDAPAdmin - Prefs.pas
  *      Copyright (C) 2003-2011 Tihomir Karlovic
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
  StdCtrls, ComCtrls, ExtCtrls, Constant, Samba, LDAPClasses;

type
  TPrefDlg = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
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
    cbDomain: TComboBox;
    edDisplayName: TEdit;
    edUsername: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    BtnWizard: TButton;
    cbxLMPasswords: TCheckBox;
    TabSheet4: TTabSheet;
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
    GroupBox7: TGroupBox;
    Label15: TLabel;
    edGroup: TEdit;
    SetBtn: TButton;
    cbxExtendGroups: TCheckBox;
    cbExtendGroups: TComboBox;
    IDGroup: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BtnWizardClick(Sender: TObject);
    procedure cbxExtendGroupsClick(Sender: TObject);
    procedure IDGroupClick(Sender: TObject);
  private
    Session: TLDAPSession;
    DomList: TDomainList;
  public
    constructor Create(AOwner: TComponent; lSession: TLDAPSession); reintroduce; overload;
  end;

var
  PrefDlg: TPrefDlg;

implementation

uses Pickup, WinLdap, PrefWiz, Main, Config;

{$R *.DFM}

constructor TPrefDlg.Create(AOwner: TComponent; lSession: TLDAPSession);
var
  idx: Integer;
begin
  inherited Create(AOwner);
  Session := lSession;
  with AccountConfig do
  begin
    try
      IDGroup.ItemIndex    := ReadInteger(rPosixIDType, POSIX_ID_RANDOM)
    except end;
    IDGroup.OnClick        := IDGroupClick;
    edFirstUID.Text        := IntToStr(ReadInteger(rposixFirstUID, FIRST_UID));
    edLastUID.Text         := IntToStr(ReadInteger(rposixLastUID,  LAST_UID));
    edFirstGID.Text        := IntToStr(ReadInteger(rposixFirstGID, FIRST_GID));
    edLastGID.Text         := IntToStr(ReadInteger(rposixLastGID,  LAST_GID));
    edUserName.Text        := ReadString(rposixUserName, '');
    edDisplayName.Text     := ReadString(rinetDisplayName, '');
    edHomeDir.Text         := ReadString(rposixHomeDir, '');
    edLoginShell.Text      := ReadString(rposixLoginShell, '');
    if ReadInteger(rposixGroup, NO_GROUP) <> NO_GROUP then
      edGroup.Text         := Session.GetDN(Format(sGROUPBYGID, [ReadInteger(rposixGroup, NO_GROUP)]));
    edNetbios.Text         := ReadString(rsambaNetbiosName, '');
    edHomeShare.Text       := ReadString(rsambaHomeShare, '');
    cbHomeDrive.ItemIndex  := cbHomeDrive.Items.IndexOf(ReadString(rsambaHomeDrive, ''));
    edScript.Text          := ReadString(rsambaScript, '');
    edProfilePath.Text     := ReadString(rsambaProfilePath, '');
    cbxLMPasswords.Checked := ReadBool(rSambaLMPasswords);
    edMailAddress.Text     := ReadString(rpostfixMailAddress, '');
    edMaildrop.Text        := ReadString(rpostfixMaildrop, '');
    idx := ReadInteger(rPosixGroupOfUnames, 0) - 1;
    if idx >= 0 then
    begin
      cbxExtendGroups.Checked := true;
      cbExtendGroups.ItemIndex := idx;
    end
    else
      cbxExtendGroupsClick(nil);
  end;
end;

procedure TPrefDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  with AccountConfig do begin
    WriteInteger(rPosixIDType,        IDGroup.ItemIndex);
    WriteInteger(rposixFirstUID,      StrToInt(edFirstUID.Text));
    WriteInteger(rposixLastUID,       StrToInt(edLastUID.Text));
    WriteInteger(rposixFirstGID,      StrToInt(edFirstGID.Text));
    WriteInteger(rposixLastGID,       StrToInt(edLastGID.Text));
    WriteString (rposixUserName,      edUserName.Text);
    WriteString (rinetDisplayName,    edDisplayName.Text);
    WriteString (rposixHomeDir,       edHomeDir.Text);
    WriteString (rposixLoginShell,    edLoginShell.Text);
    WriteInteger(rposixGroup,         StrToIntDef(Session.Lookup(edGroup.Text, sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE), NO_GROUP));
    WriteString (rsambaNetbiosName,   edNetbios.Text);
    WriteString (rsambaDomainName,    cbDomain.Text);
    WriteString (rsambaHomeShare,     edHomeShare.Text);
    WriteString (rsambaHomeDrive,     cbHomeDrive.Text);
    WriteString (rsambaScript,        edScript.Text);
    WriteString (rsambaProfilePath,   edProfilePath.Text);
    WriteBool   (rSambaLMPasswords,   cbxLMPasswords.Checked);
    WriteString (rpostfixMailAddress, edMailAddress.Text);
    WriteString (rpostfixMaildrop,    edMaildrop.Text);
    WriteInteger(rPosixGroupOfUnames, cbExtendGroups.ItemIndex + 1);
  end;
end;

procedure TPrefDlg.SetBtnClick(Sender: TObject);
begin
  with TPickupDlg.Create(self) do begin
    Caption := cPickGroups;
    Columns[1].Caption:='Description';
    Populate(Session, sPOSIXGROUPS, ['cn', 'description']);
    Images:=MainFrm.ImageList;
    ImageIndex:=bmGroup;

    ShowModal;

    if (SelCount>0) then edGroup.Text:=Selected[0].Dn;

    Free;
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
      for i := 0 to DomList.Count - 1 do
        Items.Add(DomList.Items[i].DomainName);
      ItemIndex := Items.IndexOf(AccountConfig.ReadString(rSambaDomainName, ''));
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

procedure TPrefDlg.cbxExtendGroupsClick(Sender: TObject);
begin
  with cbExtendGroups do
  if cbxExtendGroups.Checked then
  begin
    Enabled := true;
    Color := clWindow;
    ItemIndex := 0;
  end
  else begin
    Enabled := false;
    Color := clBtnFace;
    ItemIndex := -1;
  end;
end;

procedure TPrefDlg.IDGroupClick(Sender: TObject);
var
  Msg: string;
begin
  Case IDGroup.ItemIndex of
    0: Msg := stNoPosixID;
    2: Msg := stSequentialID;
  else
    Msg := '';
  end;
  if Msg <> '' then
    MessageDlg(Msg, mtWarning, [mbOk], 0);
end;

end.
