  {      LDAPAdmin - User.pas
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

unit User;

{ NOTE: Tag property of some editable elements like lists and memos is used to
        mark control as modified, providing replacement for missing Modified property }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, LDAPClasses, WinLDAP, ImgList, Posix, Samba,
  RegAccnt, Constant;

const

  GRP_ADD           =  1;
  GRP_DEL           = -1;

type
  TUserDlg = class(TForm)
    PageControl: TPageControl;
    AccountSheet: TTabSheet;
    Panel1: TPanel;
    OkBtn: TButton;
    CancelBtn: TButton;
    givenName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    sn: TEdit;
    displayName: TEdit;
    Label3: TLabel;
    uid: TEdit;
    Label4: TLabel;
    initials: TEdit;
    Label5: TLabel;
    homeDirectory: TEdit;
    Label9: TLabel;
    gecos: TEdit;
    Label12: TLabel;
    loginShell: TEdit;
    Label14: TLabel;
    SambaSheet: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    scriptPath: TEdit;
    homeDrive: TComboBox;
    profilePath: TEdit;
    smbHome: TEdit;
    Label21: TLabel;
    description: TMemo;
    cbSamba: TCheckBox;
    cbMail: TCheckBox;
    GroupBox1: TGroupBox;
    MailSheet: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    maildrop: TEdit;
    mail: TListBox;
    AddMailBtn: TButton;
    EditMailBtn: TButton;
    DelMailBtn: TButton;
    UpBtn: TButton;
    DownBtn: TButton;
    OfficeSheet: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    pager: TEdit;
    URL: TEdit;
    postalAddress: TMemo;
    st: TEdit;
    IPPhone: TEdit;
    telephoneNumber: TEdit;
    postalCode: TEdit;
    physicalDeliveryOfficeName: TEdit;
    title: TComboBox;
    o: TEdit;
    facsimileTelephoneNumber: TEdit;
    l: TEdit;
    c: TEdit;
    PrivateSheet: TTabSheet;
    Label17: TLabel;
    Label23: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    homePostalAddress: TMemo;
    otherFacsimiletelephoneNumber: TEdit;
    homePhone: TEdit;
    mobile: TEdit;
    GroupSheet: TTabSheet;
    Label34: TLabel;
    Label33: TLabel;
    GroupList: TListView;
    AddGroupBtn: TButton;
    RemoveGroupBtn: TButton;
    PrimaryGroupBtn: TButton;
    edGidNumber: TEdit;
    cbDomain: TComboBox;
    Label36: TLabel;
    cbPwdMustChange: TCheckBox;
    cbPwdCantChange: TCheckBox;
    BtnAdvanced: TButton;
    RadioGroup1: TRadioGroup;
    DateTimePicker: TDateTimePicker;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComboChange(Sender: TObject);
    procedure AddMailBtnClick(Sender: TObject);
    procedure EditMailBtnClick(Sender: TObject);
    procedure DelMailBtnClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure AddGroupBtnClick(Sender: TObject);
    procedure RemoveGroupBtnClick(Sender: TObject);
    procedure GroupListDeletion(Sender: TObject; Item: TListItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrimaryGroupBtnClick(Sender: TObject);
    procedure snExit(Sender: TObject);
    procedure uidExit(Sender: TObject);
    procedure mailClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure cbSambaClick(Sender: TObject);
    procedure cbMailClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbPwdMustChangeClick(Sender: TObject);
    procedure cbPwdCantChangeClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    Account: TPosixAccount;
    EditMode: TEditMode;
    dn: string;
    gid: Integer;
    ldapSession: TLDAPSession;
    RegAccount: TAccountEntry;
    origGroups: TStringList;
    ColumnToSort: Integer;
    Descending: Boolean;
    IsMailObject: Boolean;
    SambaVersion: Integer;
    DomList: TDomainList;
    function IsSambaObject: Boolean;
    function FormatMemoInput(const Text: string): string;
    function FormatMemoOutput(const Text: string): string;
    function FormatString(const Src : string) : string;
    procedure GetInput(Page: TWinControl; EMode: TEditMode);
    procedure PosixPreset;
    procedure SambaPreset;
    procedure MailPreset;
    procedure AddMailAccount;
    procedure RemoveMailAccount;
    procedure SetShadowTime;
    procedure GetShadowTime;
    procedure NewAccount;
    procedure ModifyAccount;
    procedure CheckSchema;
    function PrimaryGroupSid: string;
    procedure PopulateGroupList;
    procedure MailButtons(Enable: Boolean);
    procedure CopyGroups;
    function FindDataString(dstr: PChar): Boolean;
    procedure HandleGroupModify(dn: string; ModOp: Integer);
    procedure SaveGroups;
    procedure SetText(Edit: TCustomEdit; Value: string);
  public
    constructor Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode); reintroduce; overload;
  end;

var
  UserDlg: TUserDlg;

implementation

uses Pickup, Input;

{$R *.DFM}

{ TUsrDlg }

function TUserDlg.IsSambaObject: Boolean;
begin
  Result := SambaVersion <> 0;
end;

{ Address fields take $ sign as newline tag so we have to convert this to LF/CR }

function TUserDlg.FormatMemoInput(const Text: string): string;
var
  p: PChar;
begin
  Result := '';
  p := PChar(Text);
  while p^ <> #0 do begin
    if p^ = '$' then
      Result := Result + #$D#$A
    else
      Result := Result + p^;
    p := CharNext(p);
  end;
end;

function TUserDlg.FormatMemoOutput(const Text: string): string;
var
  p, p1: PChar;
begin
  Result := '';
  p := PChar(Text);
  while p^ <> #0 do begin
    p1 := CharNext(p);
    if (p^ = #$D) and (p1^ = #$A) then
    begin
      Result := Result + '$';
      p1 := CharNext(p1);
    end
    else
      Result := Result + p^;
    p := p1;
  end;
end;

function TUserDlg.FormatString(const Src : string) : string;
var
  p, p1: PChar;
begin
  Result := '';
  p := PChar(Src);
  while p^ <> #0 do begin
    p1 := CharNext(p);
    if (p^ = '%') then
    begin
      case p1^ of
        'u': Result := Result + Uid.Text;
        'f': Result := Result + GivenName.Text;
        'F': Result := Result + GivenName.Text[1];
        'l': Result := Result + Sn.Text;
        'L': Result := Result + Sn.Text[1];
        'n': Result := Result + RegAccount.sambaNetbiosName;
      else
        Result := Result + p^ + p1^;
      end;
      p1 := CharNext(p1);
    end
    else
      Result := Result + p^;
    p := p1;
  end;
end;

// Read attribute values from tab page
procedure TUserDlg.GetInput(Page: TWinControl; EMode: TEditMode);
var
  Component: TComponent;
  i, m: Integer;
  s: string;
  Mode: ULONG;

begin
  with Page do
  begin
      for I := 0 to Page.ControlCount - 1 do
      begin
        Component := Page.Controls[i];
        if ((Component is TCustomEdit) and (TCustomEdit(Component).Modified)) or
           ((Component is TComboBox) and (Component.Tag = 1)) then
        begin
          if Component is TMemo then
            s := FormatMemoOutput(TCustomEdit(Component).Text)
          else
          if Component.Name = 'gidNumber' then // special case
            s := IntToStr(gid)
          else
            s := TCustomEdit(Component).Text;
          s := Trim(s);
          if EMode = EM_ADD then
          begin
            if s <> '' then
              Account.AddAttr(Component.Name, s, LDAP_MOD_ADD);
          end
          else begin
            if s = '' then
              Mode := LDAP_MOD_DELETE
            else
              Mode := LDAP_MOD_REPLACE;
            Account.AddAttr(Component.Name, s, Mode);
          end;
        end
        else
        if (Component.Tag = 1) then // handle special cases
        begin
          if Component.Name = 'mail' then
          begin
            // If modifying then delete all attributes/value pairs first
            if EMode = EM_MODIFY then
              Account.AddAttr('mail', '', LDAP_MOD_DELETE);
            // Handle mail list
            for m := 0 to mail.Items.Count - 1 do
              Account.AddAttr('mail', mail.Items[m], LDAP_MOD_ADD);
          end;
        end;
      end;
  end;
end;

procedure TUserDlg.PosixPreset;
var
  s: string;

  function ConvertUmlauts(s: string): string;
  var
    p: PChar;
  begin
    REsult := '';
    p := PChar(s);
    while p^ <> #0 do begin
      case p^ of
        'ä': Result := Result + 'ae';
        'ö': Result := Result + 'oe';
        'ü': Result := Result + 'ue';
      else
        Result := Result + p^;
      end;
      p := CharNext(p);
    end;
  end;

begin
  if sn.Modified then
  begin
    if givenName.Text <> '' then
    begin
      s := AnsiLowercase(FormatString(RegAccount.posixUserName));
      SetText(displayName, FormatString(RegAccount.inetDisplayName));
    end
    else begin
      s := AnsiLowercase(sn.Text);
      SetText(displayName, s);
    end;
    if uid.Text = '' then
    begin
      SetText(uid, ConvertUmlauts(s));
      SetText(homeDirectory, FormatString(RegAccount.posixHomeDir));
      SambaPreset;
      PosixPreset;
    end;
  end;
end;

procedure TUserDlg.SambaPreset;
begin
  if cbSamba.Checked and (uid.Text <> '') then
  begin
    if RegAccount.sambaNetbiosName <> '' then
    begin
      SetText(smbHome, FormatString(RegAccount.sambaHomeShare));
      SetText(profilePath, FormatString(RegAccount.sambaProfilePath));
    end;
    SetText(scriptPath, FormatString(RegAccount.sambaScript));
    if homeDrive.ItemIndex = -1 then
      homeDrive.ItemIndex := homeDrive.Items.IndexOf(RegAccount.sambaHomeDrive);
  end;
end;

procedure TUserDlg.MailPreset;
var
  s: string;
begin
  if cbMail.Checked and (uid.Text <> '') then
  begin
    if (maildrop.Text = '') and (RegAccount.postfixMaildrop <> '') then
      SetText(maildrop, FormatString(RegAccount.postfixMaildrop));
    s := FormatString(RegAccount.postfixMailAddress);
    if mail.Items.IndexOf(s) = -1 then
    begin
      mail.Items.Add(s);
      mail.Tag := 1; // modified
    end;
  end;
end;

procedure TUserDlg.SetShadowTime;
begin
  with Account do
  begin
    if RadioGroup1.ItemIndex = 0 then
      ShadowExpire := SHADOW_MAX_DATE
    else
      ShadowExpire := trunc(DateTimePicker.Date) - 25569;
  end;
end;

procedure TUserDlg.GetShadowTime;
begin
  with Account do
  try
    if ShadowExpire = SHADOW_MAX_DATE then
      DateTimePicker.DateTime := Date
    else begin
      RadioGroup1.ItemIndex := 1;
      DateTimePicker.DateTime := 25569.0 + Account.ShadowExpire;
    end;
  except
  //TODO
  end;
end;

procedure TUserDlg.NewAccount;
var
  pDom: PDomainRec;
  NewDN: string;
begin

  NewDN := 'uid=' + uid.Text + ',' + dn;
  if cbSamba.Checked then
  begin
    if cbDomain.ItemIndex = 0 then
      Account := TSambaAccount.Create(ldapSession.pld, NewDN)
    else
      Account := TSamba3Account.Create(ldapSession.pld, NewDN)
  end
  else
    Account := TPosixAccount.Create(ldapSession.pld, NewDN);

  with Account do
  begin
    Shadow := true;
    InetOrg := true;
    Uid := Self.Uid.Text;
    UidNumber := ldapSession.GetFreeUidNumber(RegAccount.posixFirstUID, RegAccount.posixLastUID);
    GidNumber := gid;
    Cn := Uid;                        // set cn to be equal to uid
    Sn := Self.Sn.Text;
    GivenName := Self.GivenName.Text;
    Initials := Self.Initials.Text;
    DisplayName := Self.DisplayName.Text;
    LoginShell := Self.LoginShell.Text;
    HomeDirectory := Self.HomeDirectory.Text;
    Gecos := Self.Gecos.Text;
    SetShadowTime;
    UserPassword := '';

    if Account is TSambaAccount then with TSambaAccount(Account) do
    begin
      Rid := 1000 + 2 * uidNumber;
      PrimaryGroupID := 2 * gid + 1001;
      HomeDrive := Self.homeDrive.Text;
      SmbHome:= Self.smbHome.Text;
      LoginShell:= Self.loginShell.Text;
      ScriptPath:= Self.scriptPath.Text;
      ProfilePath:= Self.profilePath.Text;
      AcctFlags := '[UX         ]';
    end
    else
    if Account is TSamba3Account then with TSamba3Account(Account) do
    begin
      pDom := DomList.Items[cbDomain.ItemIndex - 1];
      DomainName := pDom.DomainName;
      SID := Format('%s-%d', [pDom.SID, pDom.AlgorithmicRIDBase + 2 * UidNumber]);
      GroupSID := PrimaryGroupSID;
      HomeDrive := Self.homeDrive.Text;
      HomePath:= Self.smbHome.Text;
      loginShell:= Self.loginShell.Text;
      LogonScript:= Self.scriptPath.Text;
      ProfilePath:= Self.profilePath.Text;
      if cbPwdMustChange.Checked then
        PwdMustChange := 0
      else
        PwdMustChange := 2147483647;
      if cbPwdCantChange.Checked then
        PwdCanChange := 2147483647
      else
        PwdCanChange := 0;
      AcctFlags := '[U          ]';
    end;

    GetInput(OfficeSheet, EM_ADD);
    GetInput(PrivateSheet, EM_ADD);

    if cbMail.Checked then
    begin
      AddMailAccount;
      GetInput(MailSheet, EM_ADD);
    end;

    try
      New;
      if GroupList.Tag = 1 then
        SaveGroups;
    finally
      Free;
      Account := nil;
    end;

  end;

end;

procedure TUserDlg.ModifyAccount;
var
  Temp: TPosixAccount;
  pDom: PDomainRec;
begin

  try
    with Account do
    begin
      GidNumber := gid;
      Cn := Uid;                        // set cn to be equal to uid
      Sn := Self.Sn.Text;
      GivenName := Self.GivenName.Text;
      Initials := Self.Initials.Text;
      DisplayName := Self.DisplayName.TExt;
      LoginShell := Self.LoginShell.Text;
      HomeDirectory := Self.HomeDirectory.Text;
      Gecos := Self.Gecos.Text;
    end;

    GetInput(OfficeSheet, EM_MODIFY);
    GetInput(PrivateSheet, EM_MODIFY);

    if (IsSambaObject or cbSamba.Checked) then
    begin
      // TODO -> Mutate
      if SambaVersion = 0 then
      begin
        Temp := Account;
        if cbDomain.ItemIndex = 0 then
          Account := TSambaAccount.Copy(Temp)
        else
          Account := TSamba3Account.Copy(Temp);
        Temp.Free;
      end;


      if Account is TSambaAccount then
        with Account as TSambaAccount do
        begin
          if cbSamba.Checked then
          begin
            if not IsSambaObject then
            begin
              Add;
              rid := 1000 + 2 * uidNumber;
              primaryGroupID := 2 * gid + 1001;
              AcctFlags := '[UX         ]';
            end;
            HomeDrive := Self.homeDrive.Text;
            SmbHome:= Self.smbHome.Text;
            ScriptPath:= Self.scriptPath.Text;
            ProfilePath:= Self.profilePath.Text;
            GidNumber := gid;
          end
          else
            Remove;
        end
      else
        with Account as TSamba3Account do
        begin
          if cbSamba.Checked then
          begin
            if not IsSambaObject then
            begin
              Add;
              pDom := DomList.Items[cbDomain.ItemIndex - 1];
              DomainName := pDom.DomainName;
              SID := Format('%s-%d', [pDom.SID, pDom.AlgorithmicRIDBase + 2 * UidNumber]);
              if not edGidNumber.Modified then // avoid calling PrimaryGroupSid twice
                GroupSID := PrimaryGroupSID;
              acctFlags := '[U           ]';
            end;
            HomeDrive := Self.homeDrive.Text;
            HomePath:= Self.smbHome.Text;
            LoginShell:= Self.loginShell.Text;
            LogonScript:= Self.scriptPath.Text;
            ProfilePath:= Self.profilePath.Text;
            if cbPwdMustChange.Checked then
              PwdMustChange := 0
            else
              PwdMustChange := 2147483647;
            if cbPwdCantChange.Checked then
              PwdCanChange := 2147483647
            else
              PwdCanChange := 0;
            if edGidNumber.Modified then
            begin
              GidNumber := gid;
              GroupSID := PrimaryGroupSID;
            end;
          end
          else
            Remove;
        end;

    end;

    SetShadowTime;

    if cbMail.Checked then
    begin
      if not isMailObject then
      begin
        AddMailAccount;
        GetInput(MailSheet, EM_ADD);
      end
      else
        GetInput(MailSheet, EM_MODIFY);
    end
    else
    if isMailObject then
      RemoveMailAccount;

    Account.Modify;
  except
    Account.ClearAttrs;
    raise;
  end;

  if GroupList.Tag = 1 then
    SaveGroups;

end;

procedure TUserDlg.AddMailAccount;
begin
  Account.AddAttr('objectclass', 'mailUser', LDAP_MOD_ADD);
end;

procedure TUserDlg.RemoveMailAccount;
begin
  with Account do
  begin
    AddAttr('objectclass', 'mailUser', LDAP_MOD_DELETE);
    if Items.IndexOf('mail') <> -1 then
      AddAttr('mail', '', LDAP_MOD_DELETE);
    if Items.IndexOf('maildrop') <> -1 then
      AddAttr('maildrop', '', LDAP_MOD_DELETE);
  end;
end;

procedure TUserDlg.CheckSchema;
begin
  if (sn.text) = '' then
    raise Exception.Create(Format(stReqNoEmpty, [cSurname]));
  if cbSamba.Checked and (homeDirectory.text = '') then
    raise Exception.Create(Format(stReqNoEmpty, [cHomeDir]));
  if cbMail.Checked then
  begin
    if (mail.Items.Count = 0) then
      raise Exception.Create(stReqMail);
    if (maildrop.text = '') then
       raise Exception.Create(Format(stReqNoEmpty, [cMaildrop]));
  end;
end;

function TUserDlg.PrimaryGroupSid: string;
var
  gdn: string;
begin
  with Account as TSamba3Account do
  begin
    if edGidNumber.Text = '' then
      gdn := ldapSession.GetDN(Format(sGROUPBYGID, [gid]))
    else
      gdn := edGidNumber.Text;
    Result := ldapSession.Lookup(gdn, sANYCLASS, 'sambasid', LDAP_SCOPE_BASE);
    if (System.Copy(Result, 1, LastDelimiter('-', Result) - 1) <> DomainSID) and
      (MessageDlg('Selected primary group is not a Samba group or it does not map to user domain. Do you still want to continue?', mtWarning, [mbYes, mbNo], 0) = mrNo) then Abort;
  end;
end;


procedure TUserDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    CheckSchema;
    if EditMode = EM_ADD then
      NewAccount
    else
      ModifyAccount;
  end;
end;

procedure TUserDlg.MailButtons(Enable: Boolean);
begin
  Enable := Enable and (mail.ItemIndex > -1);
  DelMailBtn.Enabled := Enable;
  EditMailBtn.Enabled := Enable;
  UpBtn.Enabled := Enable;
  DownBtn.Enabled := Enable;
end;

constructor TUserDlg.Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode);
const
  TheMap: array [0..3,0..1] of string = (
  ('homedrive','sambahomedrive'),
  ('smbhome','sambahomepath'),
  ('scriptpath','sambalogonscript'),
  ('profilepath','sambaprofilepath'));
var
  attrName, attrValue: string;
  I, C: Integer;
  Temp: TPosixAccount;

  function Map(const s: string): string;
  var
    i: Integer;
  begin
    Result := s;
    for i := 0 to 3 do
      if TheMap[i,1] = s then
      begin
        Result := TheMap[i,0];
        break;
      end;
  end;

begin
  inherited Create(AOwner);
  Self.dn := dn;
  ldapSession := Session;
  Self.RegAccount := RegAccount;
  EditMode := Mode;
  SambaSheet.TabVisible := false;
  MailSheet.TabVisible := false;
  if EditMode = EM_ADD then
  begin
    gid := RegAccount.posixGroup;
    SetText(loginShell, RegAccount.posixLoginShell);
    DateTimePicker.Date := Date;
  end
  else
  begin
    //Fill out the form
    Account := TPosixAccount.Create(ldapSession.pld, dn);
    Account.Read;
    gid := Account.GidNumber;
    GetShadowTime;

    for I := 0 to Account.Items.Count - 1 do
    begin
      attrName := Map(lowercase(Account.Items[i]));
      attrValue := PChar(Account.Items.Objects[i]);
      if attrName = 'objectclass' then
      begin
        if AnsiStrIComp(PChar(attrValue), 'sambaaccount') = 0 then
          SambaVersion := SAMBA_VERSION2
        else
        if AnsiStrIComp(PChar(attrValue), 'sambasamaccount') = 0 then
          SambaVersion := SAMBA_VERSION3
        else
        if AnsiStrIComp(PChar(attrValue), 'mailuser') = 0 then
        begin
          cbMail.Checked := true;
          IsMailObject := true;
        end;
      end
      else
        if attrName = 'homedrive' then
          homeDrive.ItemIndex := homeDrive.Items.IndexOf(attrValue)
        else
        if attrName = 'mail' then
          mail.Items.Add(attrValue)
        else
          for C := 0 to ComponentCount - 1 do
          begin
            if AnsiStrIComp(PChar(Components[C].Name), PChar(attrName)) = 0 then
            begin
              if Components[C] is TMemo then
                TMemo(Components[C]).Text := FormatMemoInput(attrValue)
              else
                TEdit(Components[C]).Text := attrValue;
            end;
          end;
    end;

    // TODO -> Mutate
    if SambaVersion > 0 then
    begin
      Temp := Account;
      if (SambaVersion = SAMBA_VERSION2) then
        Account := TSambaAccount.Copy(Temp)
      else begin
        Account := TSamba3Account.Copy(Temp);
        with TSamba3Account(Account) do begin
          cbPwdCantChange.Checked := PwdCanChange = 2147483647;
          cbPwdMustChange.Checked := PwdMustChange = 0;
        end;
      end;
      cbSamba.Checked := true;
      Temp.Free;
    end;

    if IsSambaObject then
      cbDomain.Enabled := false;

    if mail.Items.Count > 0 then
      MailButtons(true);
  end;
end;

procedure TUserDlg.ComboChange(Sender: TObject);
begin
  (Sender as TComponent).Tag := 1;
end;

procedure TUserDlg.AddMailBtnClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputDlg(cAddAddress, cSmtpAddress, s) then
  begin
    mail.Items.Add(s);
    mail.tag := 1;
    MailButtons(true);
  end;
end;

procedure TUserDlg.EditMailBtnClick(Sender: TObject);
var
  s: string;
begin
  s := mail.Items[mail.ItemIndex];
  if InputDlg(cEditAddress, cSmtpAddress, s) then
  begin
    mail.Items[mail.ItemIndex] := s;
    mail.tag := 1;
  end;
end;

procedure TUserDlg.DelMailBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with mail do begin
    idx := ItemIndex;
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    Tag := 1;
    if Items.Count = 0 then
      MailButtons(false);
  end;
end;

procedure TUserDlg.UpBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with mail do begin
    idx := ItemIndex;
    if idx > 0 then
    begin
      Items.Move(idx, idx - 1);
      ItemIndex := idx - 1;
    end;
    Tag := 1;
  end;
end;

procedure TUserDlg.DownBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with mail do begin
    idx := ItemIndex;
    if idx < Items.Count - 1 then
    begin
      Items.Move(idx, idx + 1);
      ItemIndex := idx + 1;
    end;
    Tag := 1;
  end;
end;

{ Note: Item.Caption = cn, Item.Data = dn, Subitem[0] = description }

procedure TUserDlg.PopulateGroupList;
var
  plmSearch, plmEntry: PLDAPMessage;
  ppcVals: PPChar;
  pld: PLDAP;
  attrs: PCharArray;
  ListItem: TListItem;
  i: Integer;

begin

  pld := ldapSession.pld;
  // set result to cn and description only
  SetLength(attrs, 3);
  attrs[0] := 'cn';
  attrs[1] := 'description';
  attrs[2] := nil;

  LdapCheck(ldap_search_s(pld, PChar(ldapSession.Base), LDAP_SCOPE_SUBTREE,
                               PChar(Format(sMY_GROUP,[uid.Text])), PChar(attrs), 0, plmSearch));

  try
      //GroupList.Items.BeginUpdate;
      // loop thru entries
      plmEntry := ldap_first_entry(pld, plmSearch);
      while Assigned(plmEntry) do
      begin
        ListItem := GroupList.Items.Add;
        for i := 0 to 1 do
        begin
          ppcVals := ldap_get_values(pld, plmEntry, attrs[i]);
          if Assigned(ppcVals) then
          try
            if i = 0 then
            begin
              ListItem.Caption := PCharArray(ppcVals)[0];
              ListItem.Data := StrNew(ldap_get_dn(pld, plmEntry));
            end
            else
              ListItem.SubItems.Add(PCharArray(ppcVals)[0]);
              //ListItem.SubItems.Add(CanonicalName(ldap_get_dn(pld, plmEntry)));
          finally
            LDAPCheck(ldap_value_free(ppcVals));
          end;
        end;
        plmEntry := ldap_next_entry(pld, plmEntry);
      end;
    finally
      //GroupList.Items.EndUpdate;
      // free search results
      LDAPCheck(ldap_msgfree(plmSearch));
    end;

    if GroupList.Items.Count > 0 then
      RemoveGroupBtn.Enabled := true;
end;

procedure TUserDlg.PageControlChange(Sender: TObject);
begin
  if (PageControl.ActivePage = GroupSheet) and (GroupSheet.Tag = 0) then  // Tag = 0: list not yet populated
  begin
    edGidNumber.Text := ldapSession.GetDN(Format(sGROUPBYGID, [gid]));
    if uid.Text <> '' then
    begin
      PopulateGroupList;
      GroupList.AlphaSort;
      GroupSheet.Tag := 1;
    end;
  end;
end;

procedure TUserDlg.CopyGroups;
var
  I: Integer;
begin
  if not Assigned(origGroups) then
  begin
    // Keep copy of original group list
    origGroups := TStringList.Create;
    for I := 0 to GroupList.Items.Count - 1 do
      origGroups.Add(PChar(GroupList.Items[i].Data));
  end;
end;

function TUserDlg.FindDataString(dstr: PChar): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to GroupList.Items.Count - 1 do
    if AnsiStrComp(GroupList.Items[i].Data, dstr) = 0 then
    begin
      Result := true;
      break;
    end;
end;

{ This works as follows: if cn is new group then it wont be in origGroup list so
  we add it there. If its already there add operation modus to its tag value
  (which is casted Objects array). This way we can handle repeatingly adding and
  removing of same groups: if it sums up to 0 we dont have to do anything, if
  its > 0 we add user to this group in LDAP directory and if its < 0 we remove
  user from this group in LDAP directory }

procedure TUserDlg.HandleGroupModify(dn: string; ModOp: Integer);
var
  i,v: Integer;

begin
  i := origGroups.IndexOf(dn);
  if i < 0 then
  begin
    i := origGroups.Add(dn);
    origGroups.Objects[i] := Pointer(GRP_ADD);
  end
  else begin
    v := Integer(origGroups.Objects[I]) + ModOp;
    origGroups.Objects[i] := Pointer(v);
  end;
end;

procedure TUserDlg.AddGroupBtnClick(Sender: TObject);
var
  SelItem, GroupItem: TListItem;
begin
  with TPickupDlg.Create(Self), ListView do
  try
    MultiSelect := true;
    PopulateGroups(ldapSession);
    if ShowModal = mrOk then
    begin
      CopyGroups;
      SelItem := Selected;
      while Assigned(SelItem) do
      begin
        if not FindDataString(PChar(SelItem.Data)) then
        begin
          GroupItem := GroupList.Items.Add;
          GroupItem.Caption := SelItem.Caption;
          if SelItem.SubItems.Count > 0 then
            GroupItem.SubItems.Add(SelItem.SubItems[0]);
          GroupItem.Data := StrNew(SelItem.Data);
          HandleGroupModify(PChar(SelItem.Data), GRP_ADD);
        end;
        SelItem := GetNextItem(SelItem, sdAll, [isSelected]);
      end;
      GroupList.Tag := 1;
    end;
  finally
    Destroy;
    if GroupList.Items.Count > 0 then
      RemoveGroupBtn.Enabled := true;
  end;
end;

procedure TUserDlg.RemoveGroupBtnClick(Sender: TObject);
var
  idx: Integer;
  dn: string;
begin
  with GroupList do
  If Assigned(Selected) then
  begin
    CopyGroups;
    idx := Selected.Index;
    dn := PChar(Selected.Data);
    Selected.Delete;
    HandleGroupModify(dn, GRP_DEL);
    GroupList.Tag := 1;
    if idx = Items.Count then
      Dec(idx);
    if idx > -1 then
      Items[idx].Selected := true
    else
      RemoveGroupBtn.Enabled := false;
  end;
end;

procedure TUserDlg.SaveGroups;
var
  i, modop: Integer;
  Entry: TLDAPEntry;
begin
  if Assigned(origGroups) then with origGroups do
  begin
    for i := 0 to Count -1 do
    begin
      modop := Integer(Objects[i]);
      if modop <> 0 then
      begin
        Entry := TLDAPEntry.Create(ldapSession.pld, origGroups[i]);
        try
          // modify user attributes always must happend before savegroups so we don't get inconsistent here
          if modop > 0 then
            Entry.AddAttr('memberUid', uid.Text, LDAP_MOD_ADD)
          else
            Entry.AddAttr('memberUid', uid.Text, LDAP_MOD_DELETE);
          Entry.Modify;
        finally
          Entry.Destroy;
        end;
      end;
    end;
  end;
end;

procedure TUserDlg.GroupListDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    StrDispose(Item.Data);
end;

procedure TUserDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  origGroups.Free;
  Action := caFree;
end;

procedure TUserDlg.PrimaryGroupBtnClick(Sender: TObject);
begin
  with TPickupDlg.Create(Self), ListView do
  try
    PopulateGroups(ldapSession);
    if ShowModal = mrOk then
    begin
      if Assigned(Selected) and (AnsiStrComp(PChar(edGidNumber.Text), PChar(Selected.Data)) <> 0) then
      begin
        gid := StrToInt(ldapSession.Lookup(PChar(Selected.Data), sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE));
        edGidNumber.Text := PChar(Selected.Data);
        edGidNumber.Modified := true;
      end;
    end;
  finally
    Destroy;
  end;
end;

procedure TUserDlg.snExit(Sender: TObject);
begin
  PosixPreset;
end;

procedure TUserDlg.uidExit(Sender: TObject);
begin
  SambaPreset;
  MailPreset;
end;

procedure TUserDlg.SetText(Edit: TCustomEdit; Value: string);
begin
  Edit.Text := Value;
  Edit.Modified := true;
end;

procedure TUserDlg.mailClick(Sender: TObject);
begin
  MailButtons(true);
end;

procedure TUserDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ColumnToSort <> Column.Index then
  begin
    ColumnToSort := Column.Index;
    Descending := false;
  end
  else
    Descending := not Descending;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TUserDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  begin
    Compare := -1;
    ix := ColumnToSort - 1;
    if Item1.SubItems.Count > ix then
    begin
      Compare := 1;
      if Item2.SubItems.Count > ix then
        Compare := AnsiCompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
    end;
  end;
  if Descending then
    Compare := - Compare;
end;

procedure TUserDlg.cbSambaClick(Sender: TObject);
var
  i: Integer;
begin
  if cbSamba.Checked then
  begin
    if not Assigned(DomList) then // first time in
    begin
      cbDomain.Items.Clear;
      cbDomain.Items.Add(cSamba2Accnt);
      
      if SambaVersion = SAMBA_VERSION2 then
        cbDomain.ItemIndex := 0
      else
      begin
        DomList := TDomainList.Create(ldapSession);
        for i := 0 to DomList.Count - 1 do
          cbDomain.Items.Add(DomList.Items[i].DomainName);
        if SambaVersion = SAMBA_VERSION3 then
          i := cbDomain.Items.IndexOf(TSamba3Account(Account).DomainName)
        else
          i := cbDomain.Items.IndexOf(RegAccount.SambaDomainName);
        if i <> -1 then
          cbDomain.ItemIndex := i
        else
          cbDomain.ItemIndex := 0;
      end;
    end;
    SambaPreset;
  end;
  SambaSheet.TabVisible := cbSamba.Checked;
end;

procedure TUserDlg.cbMailClick(Sender: TObject);
begin
  MailSheet.TabVisible := cbMail.Checked;
  MailPreset;
end;

procedure TUserDlg.FormDestroy(Sender: TObject);
begin
  Account.Free;
end;

procedure TUserDlg.cbPwdMustChangeClick(Sender: TObject);
begin
  if cbPwdMustChange.Checked then
    cbPwdCantChange.Checked := false;
end;

procedure TUserDlg.cbPwdCantChangeClick(Sender: TObject);
begin
  if cbPwdCantChange.Checked then
    cbPwdMustChange.Checked := false;
end;

procedure TUserDlg.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
  begin
    DateTimePicker.Enabled := false;
    DateTimePicker.Color := clBtnFace;
  end
  else begin
    DateTimePicker.Enabled := true;
    DateTimePicker.Color := clWindow;
  end;

end;

end.

