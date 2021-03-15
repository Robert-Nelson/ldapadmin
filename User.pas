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
  StdCtrls, ExtCtrls, ComCtrls, LDAPClasses, WinLDAP, ImgList, Constant;

const

  GRP_ADD           =  1;
  GRP_DEL           = -1;

  cEmptyMD5Password = '{MD5}1B2M2Y8AsgTpgAmY7PhCfg==';
  cEmptyNTPassword  = '31D6CFE0D16AE931B73C59D7E0C089C0';
  cEmptylmPassword  = 'AAD3B435B51404EEAAD3B435B51404EE';

  chomeDrive        = 'H:';
  sfUserName        = '%s.%s';
  sfDisplayName     = '%s, %s';
  sfHomeDir         = '/home/%s';
  sfsmbHome         = '\\SERVER\homes';
  sfProfilePath     = '\\SERVER\profiles\%s';
  //sfScriptPath      = '%s.cmd';
  sfScriptPath      = 'common.cmd';
  sfMail            = '%s@mydomain.com';
  sfMaildrop        = '%s@server.mydomain.com';

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
    gidNumber: TEdit;
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
  private
    Entry: TLDAPEntry;
    EditMode: TEditMode;
    dn: string;
    uidnr, gid: string;
    ldSession: TLDAPSession;
    origGroups: TStringList;
    ColumnToSort: Integer;
    Descending: Boolean;
    IsMailObject, IsSambaObject: Boolean;
    procedure GetInput(Page: TWinControl; EMode: TEditMode);
    procedure AddSambaAccount(uidnr, gidnr: Integer);
    procedure RemoveSambaAccount;
    procedure AddMailAccount;
    procedure RemoveMailAccount;
    procedure NewEntry;
    procedure ModifyEntry;
    procedure CheckSchema;
    function FormatMemoInput(Text: string): string;
    function FormatMemoOutput(Text: string): string;
    function NextUID: Integer;
    procedure PopulateGroupList;
    procedure MailButtons(Enable: Boolean);
    procedure CopyGroups;
    function FindDataString(dstr: PChar): Boolean;
    procedure HandleGroupModify(dn: string; ModOp: Integer);
    procedure SaveGroups;
    procedure SetText(Edit: TCustomEdit; Value: string);
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce; overload;
  end;

var
  UserDlg: TUserDlg;

implementation

uses Pickup, Input;

{$R *.DFM}

{ Address fields take $ sign as newline tag so we have to convert this to LF/CR }

function TUserDlg.FormatMemoInput(Text: string): string;
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

function TUserDlg.FormatMemoOutput(Text: string): string;
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

function TUSERDlg.NextUID: Integer;
begin
  Result := ldSession.Max(sPOSIXACCNT, 'uidNumber') + 1;
  if Result < START_UID then
    Result := START_UID;
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
            s := gid
          else
            s := TCustomEdit(Component).Text;
          s := Trim(s);
          if EMode = EM_ADD then
          begin
            if s <> '' then
              Entry.AddAttr(Component.Name, s, LDAP_MOD_ADD);
          end
          else begin
            if s = '' then
              Mode := LDAP_MOD_DELETE
            else
              Mode := LDAP_MOD_REPLACE;
            Entry.AddAttr(Component.Name, s, Mode);
          end;
        end
        else
        if (Component.Tag = 1) then // handle special cases
        begin
          if Component.Name = 'mail' then
          begin
            // if modifying then delete all attributes/value pairs first
            if EMode = EM_MODIFY then
              Entry.AddAttr('mail', '', LDAP_MOD_DELETE);
            // Handle mail list
            for m := 0 to mail.Items.Count - 1 do
              Entry.AddAttr('mail', mail.Items[m], LDAP_MOD_ADD);
          end;
        end;
      end;
  end;
end;

// Adds SAMBA account to existing POSIX account
procedure TUserDlg.AddSambaAccount(uidnr, gidnr: Integer);
var
  rid, grouprid: Integer;

begin
  with Entry do
  begin
    // Calculate related SAMBA attributes
    rid := 2*uidnr + 1000;
    grouprid := 2*gidnr + 1001;

    AddAttr('objectclass', 'sambaAccount', LDAP_MOD_ADD);
    //AddAttr('primaryGroupID', , LDAP_MOD_ADD);
    AddAttr('rid', IntToStr(rid), LDAP_MOD_ADD);
    AddAttr('primaryGroupID', IntToStr(grouprid), LDAP_MOD_ADD);
    AddAttr('pwdMustChange', '2147483647', LDAP_MOD_ADD);
    AddAttr('pwdCanChange', '0', LDAP_MOD_ADD);
    AddAttr('pwdLastSet', '0', LDAP_MOD_ADD);
    AddAttr('kickoffTime', '2147483647', LDAP_MOD_ADD);
    AddAttr('logOnTime', '2147483647', LDAP_MOD_ADD);
    AddAttr('logoffTime', '0', LDAP_MOD_ADD);
    AddAttr('acctFlags', '[UX         ]', LDAP_MOD_ADD);
    AddAttr('ntPassword', cEmptyNTPassword, LDAP_MOD_ADD);
    AddAttr('lmPassword', cEmptylmPassword, LDAP_MOD_ADD);
  end;
end;

procedure TUserDlg.RemoveSambaAccount;
begin
  with Entry do
  begin
    AddAttr('objectclass', 'sambaAccount', LDAP_MOD_DELETE);
    //AddAttr('primaryGroupID', , LDAP_MOD_DELETE);
    AddAttr('rid', '', LDAP_MOD_DELETE);
    AddAttr('primaryGroupID', '', LDAP_MOD_DELETE);
    AddAttr('pwdMustChange', '', LDAP_MOD_DELETE);
    AddAttr('pwdCanChange', '', LDAP_MOD_DELETE);
    AddAttr('pwdLastSet', '', LDAP_MOD_DELETE);
    AddAttr('kickoffTime', '', LDAP_MOD_DELETE);
    AddAttr('logOnTime', '', LDAP_MOD_DELETE);
    AddAttr('logoffTime', '', LDAP_MOD_DELETE);
    AddAttr('acctFlags', '', LDAP_MOD_DELETE);
    AddAttr('ntPassword', '', LDAP_MOD_DELETE);
    AddAttr('lmPassword', '', LDAP_MOD_DELETE);
    if Items.IndexOf('homeDrive') <> -1 then
      AddAttr('homeDrive', '', LDAP_MOD_DELETE);
    if Items.IndexOf('smbHome') <> -1 then
      AddAttr('smbHome', '', LDAP_MOD_DELETE);
    if Items.IndexOf('loginShell') <> -1 then
      AddAttr('loginShell', '', LDAP_MOD_DELETE);
    if Items.IndexOf('scriptPath') <> -1 then
      AddAttr('scriptPath', '', LDAP_MOD_DELETE);
    if Items.IndexOf('profilePath') <> -1 then
      AddAttr('profilePath', '', LDAP_MOD_DELETE);
  end;
end;

procedure TUserDlg.AddMailAccount;
begin
  Entry.AddAttr('objectclass', 'mailUser', LDAP_MOD_ADD);
end;

procedure TUserDlg.RemoveMailAccount;
begin
  with Entry do
  begin
    AddAttr('objectclass', 'mailUser', LDAP_MOD_DELETE);
    if Items.IndexOf('mail') <> -1 then
      AddAttr('mail', '', LDAP_MOD_DELETE);
    if Items.IndexOf('maildrop') <> -1 then
      AddAttr('maildrop', '', LDAP_MOD_DELETE);
  end;
end;

procedure TUserDlg.NewEntry;
var
  uidnr, gidnr: Integer;
begin

    // Aquire next available uidNumber
    uidnr := NextUID;
    gidnr := StrToInt(gid);

    Entry := TLDAPEntry.Create(ldSession.pld, 'uid=' + uid.Text + ',' + dn);
    with Entry do
    begin

      AddAttr('objectclass', 'top', LDAP_MOD_ADD);
      AddAttr('objectclass', 'posixAccount', LDAP_MOD_ADD);
      AddAttr('objectclass', 'shadowAccount', LDAP_MOD_ADD);
      AddAttr('objectclass', 'inetOrgPerson', LDAP_MOD_ADD);
      // Posix Stuff
      AddAttr('uidNumber', IntToStr(uidnr), LDAP_MOD_ADD);
      AddAttr('gidNumber', IntToStr(gidnr), LDAP_MOD_ADD);
      AddAttr('cn', uid.Text, LDAP_MOD_ADD); // set cn to be equal to uid
      AddAttr('userPassword', cEmptyMD5Password, LDAP_MOD_ADD);
      // Shadow Stuff
      AddAttr('shadowFlag', '0', LDAP_MOD_ADD);
      AddAttr('shadowMin', '0', LDAP_MOD_ADD);             // min number of days between password changes
      AddAttr('shadowMax', '99999', LDAP_MOD_ADD);         // max number of days password is valid
      AddAttr('shadowWarning', '0', LDAP_MOD_ADD);         // numer of days before password expiry to warn user
      AddAttr('shadowInactive', '99999', LDAP_MOD_ADD);    // numer of days to allow account to be inactive
      AddAttr('shadowLastChange', '12011', LDAP_MOD_ADD);  // last change of shadow info, int value
      AddAttr('shadowExpire', '99999', LDAP_MOD_ADD);      // absolute date to expire account counted in days since 1.1.1970
      // Outlook Stuff
      //AddAttr('rdn', 'uid=' + uid.Text, LDAP_MOD_ADD);

      GetInput(AccountSheet, EM_ADD);
      GetInput(OfficeSheet, EM_ADD);
      GetInput(PrivateSheet, EM_ADD);

      // Samba Stuff
      if cbSamba.Checked then
      begin
        AddSambaAccount(uidnr, gidnr);
        GetInput(SambaSheet, EM_ADD);
      end;

      if cbMail.Checked then
      begin
        AddMailAccount;
        GetInput(MailSheet, EM_ADD);
      end;

      try
        Entry.Add;
      except
        Entry.ClearAttrs;
        raise;
      end;

    end;

    if GroupList.Tag = 1 then
      SaveGroups;
end;

procedure TUserDlg.ModifyEntry;
begin

  GetInput(AccountSheet, EM_MODIFY);
  GetInput(OfficeSheet, EM_MODIFY);
  GetInput(PrivateSheet, EM_MODIFY);
  GetInput(GroupSheet, EM_MODIFY);

  if cbSamba.Checked then
  begin
    if not isSambaObject then
    begin
      AddSambaAccount(StrToInt(uidnr), StrToInt(gid));
      GetInput(SambaSheet, EM_ADD);
    end
    else begin
      GetInput(SambaSheet, EM_MODIFY);
      if gidNumber.Modified then
        Entry.AddAttr('primaryGroupID', IntToStr(2 * StrToInt(gid) + 1001), LDAP_MOD_REPLACE);
    end;
  end
  else
  if isSambaObject then
    RemoveSambaAccount;

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

  try
    Entry.Modify;
  except
    Entry.ClearAttrs;
    raise;
  end;

  if GroupList.Tag = 1 then
    SaveGroups;

end;

procedure TUserDlg.CheckSchema;
begin
  if (sn.text) = '' then
    raise Exception.Create(Format(stReqNoEmpty, ['Nachname']));
  if cbSamba.Checked and (homeDirectory.text = '') then
    raise Exception.Create(Format(stReqNoEmpty, ['Home Verzeichnis']));
  if cbMail.Checked then
  begin
    if (mail.Items.Count = 0) then
      raise Exception.Create(stReqMail);
    if (maildrop.text = '') then
       raise Exception.Create(Format(stReqNoEmpty, ['Maildrop']));
  end;
end;

procedure TUserDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    CheckSchema;
    if EditMode = EM_ADD then
      NewEntry
    else
      ModifyEntry;
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

constructor TUserDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
var
  attrName, attrValue: string;
  I, C: Integer;

begin
  inherited Create(AOwner);
  Self.dn := dn;
  ldSession := Session;
  EditMode := Mode;
  SambaSheet.TabVisible := false;
  MailSheet.TabVisible := false;
  if EditMode = EM_ADD then
  begin
    { Set standard values TODO: shoud read from registry settings }
    gid := '100';
    SetText(loginShell, '/bin/false');
  end
  else
  begin
    //Fill out the form
    Entry := TLDAPEntry.Create(ldSession.pld, dn);
    Entry.Read;

    for I := 0 to Entry.Items.Count - 1 do
    begin
      attrName := lowercase(Entry.Items[i]);
      attrValue := PChar(Entry.Items.Objects[i]);
      if attrName = 'objectclass' then
      begin
        if AnsiStrIComp(PChar(attrValue), 'sambaaccount') = 0 then
        begin
          cbSamba.Checked := true;
          IsSambaObject := true;
        end
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
        if attrName = 'gidnumber' then
          gid := attrValue
        else
        if attrName = 'uidnumber' then
          uidnr := attrValue
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

  pld := ldSession.pld;
  // set result to cn and description only
  SetLength(attrs, 3);
  attrs[0] := 'cn';
  attrs[1] := 'description';
  attrs[2] := nil;

  LdapCheck(ldap_search_s(pld, PChar(ldSession.Base), LDAP_SCOPE_SUBTREE,
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
    gidNumber.Text := ldSession.GetDN(Format(sGROUPBYsGID, [gid]));
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

{ This works like this: if cn is new group then it wont be in origGroup list so
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
    PopulateGroups(ldSession);
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
        Entry := TLDAPEntry.Create(ldSession.pld, origGroups[i]);
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
    PopulateGroups(ldSession);
    if ShowModal = mrOk then
    begin
      if Assigned(Selected) and (AnsiStrComp(PChar(gidNumber.Text), PChar(Selected.Data)) <> 0) then
      begin
        gid := ldSession.Lookup(PChar(Selected.Data), sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE);
        GidNumber.Text := PChar(Selected.Data);
        gidNumber.Modified := true;
      end;
    end;
  finally
    Destroy;
  end;
end;

procedure TUserDlg.snExit(Sender: TObject);
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
      s := AnsiLowercase(Format(sfUserName, [givenName.Text, sn.Text]));
      SetText(displayName, Format(sfDisplayName, [sn.Text, givenName.Text]));
    end
    else begin
      s := AnsiLowercase(sn.Text);
      SetText(displayName, s);
    end;
    if uid.Text = '' then
    begin
      SetText(uid, ConvertUmlauts(s));
      uidExit(nil);
    end;
  end;
end;

procedure TUserDlg.uidExit(Sender: TObject);
var
  s: string;
begin

  if uid.Text <> '' then
  begin
    s := uid.Text;
    SetText(homeDirectory, Format(sfHomeDir, [s]));
    SetText(smbHome, Format(sfsmbHome, [s]));
    SetText(profilePath, Format(sfprofilePath, [s]));
    SetText(scriptPath, Format(sfscriptPath, [s]));
    if maildrop.Text = '' then
      SetText(maildrop, Format(sfMaildrop, [s]));
    s := Format(sfMail, [s]);
    if mail.Items.IndexOf(s) = -1 then
    begin
      mail.Items.Add(s);
      mail.Tag := 1; // modified
    end;
  end;
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
begin
  SambaSheet.TabVisible := cbSamba.Checked;
end;

procedure TUserDlg.cbMailClick(Sender: TObject);
begin
  MailSheet.TabVisible := cbMail.Checked;
end;

procedure TUserDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.

