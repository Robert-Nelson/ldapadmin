  {      LDAPAdmin - User.pas
  *      Copyright (C) 2003-2005 Tihomir Karlovic
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
  StdCtrls, ExtCtrls, ComCtrls, LDAPClasses, WinLDAP, ImgList, Posix, Shadow,
  InetOrg, Postfix, Samba, PropertyObject, RegAccnt, Constant, ExtDlgs;

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
    sambaLogonScript: TEdit;
    sambaHomeDrive: TComboBox;
    sambaProfilePath: TEdit;
    sambaHomePath: TEdit;
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
    cbAccntDisabled: TCheckBox;
    ShadowSheet: TTabSheet;
    RadioGroup1: TRadioGroup;
    DateTimePicker: TDateTimePicker;
    cbShadow: TCheckBox;
    ShadowPropertiesGroup: TGroupBox;
    ShadowMin: TEdit;
    ShadowWarning: TEdit;
    ShadowInactive: TEdit;
    ShadowLastChange: TEdit;
    ShadowMax: TEdit;
    Label35: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Panel2: TPanel;
    OpenPictureBtn: TButton;
    Label41: TLabel;
    Image1: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    DeleteJpegBtn: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AddMailBtnClick(Sender: TObject);
    procedure EditMailBtnClick(Sender: TObject);
    procedure DelMailBtnClick(Sender: TObject);
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
    procedure EditChange(Sender: TObject);
    procedure cbShadowClick(Sender: TObject);
    procedure cbDomainChange(Sender: TObject);
    procedure sambaHomeDriveChange(Sender: TObject);
    procedure cbAccntDisabledClick(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure OpenPictureBtnClick(Sender: TObject);
    procedure DeleteJpegBtnClick(Sender: TObject);
    procedure BtnAdvancedClick(Sender: TObject);
  private
    ParentDn: string;
    Entry: TLdapEntry;
    PosixAccount: TPosixAccount;
    ShadowAccount: TShadowAccount;
    SambaAccount: TSamba3Account;
    MailAccount: TMailUser;
    InetOrgPerson: TInetOrgPerson;
    Session: TLDAPSession;
    RegAccount: TAccountEntry;
    origGroups: TStringList;
    ColumnToSort: Integer;
    Descending: Boolean;
    PageSetup: Boolean;
    DomList: TDomainList;
    function FormatString(const Src : string) : string;
    procedure LoadControls(Parent: TWinControl);
    procedure PosixPreset;
    procedure ShadowPreset;
    procedure SambaPreset;
    procedure MailPreset;
    procedure SetSambaTime;    
    procedure SetShadowTime;
    procedure GetShadowTime;
    procedure CheckSchema;
    procedure PopulateGroupList;
    procedure MailButtons(Enable: Boolean);
    procedure CopyGroups;
    function FindDataString(dstr: PChar): Boolean;
    procedure HandleGroupModify(dn: string; ModOp: Integer);
    procedure SaveGroups;
    procedure SetText(Edit: TCustomEdit; Value: string);
  public
    constructor Create(AOwner: TComponent; adn: string; ARegAccount: TAccountEntry; ASession: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  UserDlg: TUserDlg;

implementation

uses AdvSamba, Pickup, Input, Misc, Jpeg;

{$R *.DFM}

{ TUsrDlg }

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

procedure TUserDlg.LoadControls(Parent: TWinControl);
var
  Control: TControl;
  i: Integer;
  s: string;
begin
  PageSetup := true;
  for i := 0 to Parent.ControlCount - 1 do
  begin
    Control := Parent.Controls[i];
    s := Entry.AttributesByName[Control.Name].AsString;
    if Control is TCustomEdit then
    begin
      if Control is TMemo then
        s := FormatMemoInput(s);
      TCustomEdit(Control).Text := s;
    end
    else
    if Control is TComboBox then
      with TComboBox(Control) do
        ItemIndex :=  Items.IndexOf(s);
  end;
  PageSetup := false;
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

  LoadControls(AccountSheet);
  LoadControls(OfficeSheet);
  LoadControls(PrivateSheet);

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
    end;
  end;
end;

procedure TUserDlg.ShadowPreset;
begin
  if not ShadowAccount.Activated then
    ShadowAccount.New;
  LoadControls(ShadowPropertiesGroup);
  GetShadowTime;
end;

procedure TUserDlg.SambaPreset;
var
  i: Integer;
  Active: Boolean;
begin
  if not cbSamba.Checked then
    Exit;

  if not Assigned(DomList) then // first time, initialize domain list
  begin
    cbDomain.Items.Clear;
    DomList := TDomainList.Create(Session);
    for i := 0 to DomList.Count - 1 do
      cbDomain.Items.Add(DomList.Items[i].DomainName);
  end;

  Active := SambaAccount.Activated;
  if not Active then
  begin
    LoadControls(SambaSheet);
    SetSambaTime;
    cbDomain.ItemIndex := cbDomain.Items.IndexOf(RegAccount.SambaDomainName);
    cbDomain.Enabled := true;
    if (uid.Text <> '') then
    begin
      if RegAccount.sambaNetbiosName <> '' then
      begin
        SetText(sambaHomePath, FormatString(RegAccount.sambaHomeShare));
        SetText(sambaProfilePath, FormatString(RegAccount.sambaProfilePath));
      end;
      SetText(sambaLogonScript, FormatString(RegAccount.sambaScript));
      if sambaHomeDrive.ItemIndex = -1 then
      begin
        sambaHomeDrive.ItemIndex := sambaHomeDrive.Items.IndexOf(RegAccount.sambaHomeDrive);
        SambaAccount.HomeDrive := RegAccount.sambaHomeDrive;
      end;
    end;
   end
   else begin
     LoadControls(SambaSheet);
     cbDomain.ItemIndex := cbDomain.Items.IndexOf(SambaAccount.DomainName);
     cbDomain.Enabled := false;
   end;

   with SambaAccount do
   begin
     i := cbDomain.ItemIndex;
     if i = -1 then
       DomainData := nil
     else
       DomainData := DomList.Items[i];
     try
       cbPwdCantChange.Checked := PwdCanChange = 2147483647;
     except end; // not critical
     try
       cbPwdMustChange.Checked := PwdMustChange = 0;
     except end; // not critical
     cbAccntDisabled.Checked := Disabled;
     if not Active then
     begin
       New;
       UserAccount := true;
     end;
   end;
end;

procedure TUserDlg.MailPreset;
var
  s: string;
begin
  if not cbMail.Checked then
    Exit;

  if not MailAccount.Activated then
  begin
    MailAccount.New;
    if uid.Text <> '' then
    begin
      if (maildrop.Text = '') and (RegAccount.postfixMaildrop <> '') then
        SetText(maildrop, FormatString(RegAccount.postfixMaildrop));
      if RegAccount.postfixMailAddress <> '' then
      begin
        s := FormatString(RegAccount.postfixMailAddress);
        if mail.Items.IndexOf(s) = -1 then
        begin
          mail.Items.Add(s);
          MailAccount.AddAddress(s);
        end;
      end;
    end;
  end
  else
  begin
    LoadControls(MailSheet);
    mail.Items.CommaText := MailAccount.AsCommaText;
  end;
end;

procedure TUserDlg.SetSambaTime;
begin
  with SambaAccount do
  begin
    if RadioGroup1.ItemIndex = 0 then
      KickoffTime := SAMBA_MAX_KICKOFF_TIME
    else
      KickoffTime := DateTimePicker.DateTime;
  end;
end;

procedure TUserDlg.SetShadowTime;
begin
  with ShadowAccount do
  begin
    if RadioGroup1.ItemIndex = 0 then
      ShadowExpire := SHADOW_MAX
    else
      ShadowExpire := trunc(DateTimePicker.Date) - 25569;
  end;
  if SambaAccount.Activated then
    SetSambaTime;
end;

procedure TUserDlg.GetShadowTime;
begin
  try with ShadowAccount do
    if ShadowExpire = SHADOW_EXPIRE then
      DateTimePicker.DateTime := Date
    else begin
      DateTimePicker.DateTime := 25569 + ShadowExpire;
      RadioGroup1.ItemIndex := 1;
    end;
  except
    on E: Exception do
    if not (E is EConvertError) then
      raise;
  end;
end;

procedure TUserDlg.CheckSchema;
begin
  try
    if (uid.Text) = '' then
      raise Exception.Create(Format(stReqNoEmpty, [cUsername]));
    if (sn.text) = '' then
      raise Exception.Create(Format(stReqNoEmpty, [cSurname]));
    if (homeDirectory.text) = '' then
      raise Exception.Create(Format(stReqNoEmpty, [cHomeDir]));
  except
    PageControl.ActivePage := AccountSheet;
    raise;
  end;
  if cbSamba.Checked then
  try
    if homeDirectory.text = '' then
      raise Exception.Create(Format(stReqNoEmpty, [cHomeDir]));
    if cbDomain.ItemIndex = -1 then
      raise Exception.Create(Format(stReqNoEmpty, [cSambaDomain]));
  except
    PageControl.ActivePage := SambaSheet;
    raise;
  end;
  if cbMail.Checked then
  try
    if (mail.Items.Count = 0) then
      raise Exception.Create(stReqMail);
    if (maildrop.text = '') then
       raise Exception.Create(Format(stReqNoEmpty, [cMaildrop]));
  except
    PageControl.ActivePage := MailSheet;
    raise;
  end;
end;

procedure TUserDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  uidnr: Integer;
  newdn: string;
begin
  if ModalResult = mrOk then
  begin
    CheckSchema;
    if esNew in Entry.State then
    begin
      Entry.Dn := 'uid=' + uid.Text + ',' + ParentDn;
      PosixAccount.Cn := PosixAccount.Uid;
      uidnr := Session.GetFreeUidNumber(RegAccount.posixFirstUID, RegAccount.posixLastUID);
      if cbSamba.Checked then
        SambaAccount.UidNumber := uidnr
      else
        PosixAccount.UidNumber := uidnr;
    end
    else
    if uid.Modified then
    begin
      { Handle username change }
      newdn := 'uid=' + uid.Text + ',' + GetDirFromDn(ParentDn);
      if newdn <> Entry.Dn then
      begin
        Entry.Delete;
        Entry.Dn := newdn;
      end;
    end;
    Entry.Write;
    if GroupList.Tag = 1 then
      SaveGroups;
  end;
end;

procedure TUserDlg.MailButtons(Enable: Boolean);
begin
  Enable := Enable and (mail.ItemIndex > -1);
  DelMailBtn.Enabled := Enable;
  EditMailBtn.Enabled := Enable;
end;

constructor TUserDlg.Create(AOwner: TComponent; adn: string; ARegAccount: TAccountEntry; ASession: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  Session := ASession;
  RegAccount := ARegAccount;
  ParentDn := adn;

  Entry := TLdapEntry.Create(ASession, adn);

  PosixAccount := TPosixAccount.Create(Entry);
  InetOrgPerson := TInetOrgPerson.Create(Entry);
  ShadowAccount := TShadowAccount.Create(Entry);
  SambaAccount := TSamba3Account.Create(Entry);
  MailAccount := TMailUser.Create(Entry);

  ShadowSheet.TabVisible := false;
  SambaSheet.TabVisible := false;
  MailSheet.TabVisible := false;

  if Mode = EM_ADD then
  begin
    PosixAccount.New;
    InetOrgPerson.New;
    PosixAccount.GidNumber := RegAccount.posixGroup;
    SetText(loginShell, RegAccount.posixLoginShell);
    DateTimePicker.Date := Date;
  end
  else begin
    //Fill out the form
    Entry.Read;
    PosixPreset;
    if ShadowAccount.Activated then
      cbShadow.Checked := true;
    if SambaAccount.Activated then
      cbSamba.Checked := true;
    if MailAccount.Activated then
      cbMail.Checked := true;
    Caption := Format(cPropertiesOf, [uid.Text]);
  end;
end;

procedure TUserDlg.AddMailBtnClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputDlg(cAddAddress, cSmtpAddress, s) then
  begin
    mail.Items.Add(s);
    MailAccount.AddAddress(s);
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
    MailAccount.RemoveAddress(mail.Items[mail.ItemIndex]);
    MailAccount.AddAddress(s);
    mail.Items[mail.ItemIndex] := s;
  end;
end;

procedure TUserDlg.DelMailBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with mail do begin
    idx := ItemIndex;
    MailAccount.RemoveAddress(Items[ItemIndex]);
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    if Items.Count = 0 then
      MailButtons(false);
  end;
end;

{ Note: Item.Caption = cn, Item.Data = dn, Subitem[0] = description }

procedure TUserDlg.PopulateGroupList;
var
  i: Integer;
  EntryList: TLdapEntryList;
  ListItem: TListItem;
begin

  EntryList := TLdapEntryList.Create;
  try
    Session.Search(Format(sMY_GROUP,[uid.Text]), Session.Base, LDAP_SCOPE_SUBTREE,
                   ['cn', 'description'], false, EntryList);
    for i := 0 to EntryList.Count - 1 do with EntryList[i] do
    begin
      ListItem := GroupList.Items.Add;
      ListItem.Caption := Attributes[0].AsString;
      ListItem.Data := StrNew(PChar(Dn));
      if Attributes.Count > 1 then
        ListItem.SubItems.Add(Attributes[1].AsString);
    end;
  finally
    EntryList.Free;
  end;

  if GroupList.Items.Count > 0 then
    RemoveGroupBtn.Enabled := true;
end;

procedure TUserDlg.PageControlChange(Sender: TObject);
begin
  if (PageControl.ActivePage = GroupSheet) and (GroupSheet.Tag = 0) then  // Tag = 0: list not yet populated
  begin
    edGidNumber.Text := Session.GetDN(Format(sGROUPBYGID, [PosixAccount.GidNumber]));
    if uid.Text <> '' then
    begin
      PopulateGroupList;
      GroupList.AlphaSort;
      GroupSheet.Tag := 1;
    end;
  end
  else
  if (PageControl.ActivePage = PrivateSheet) and not Assigned(Image1.Picture.Graphic) then
  begin
    Image1.Picture.Graphic := InetOrgPerson.JPegPhoto;
    DeleteJpegBtn.Enabled := true;
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
    PopulateGroups(Session);
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
  Entry: TLdapEntry;
begin
  if Assigned(origGroups) then with origGroups do
  begin
    for i := 0 to Count -1 do
    begin
      modop := Integer(Objects[i]);
      if modop <> 0 then
      begin
        Entry := TLdapEntry.Create(Session, origGroups[i]);
        Entry.Read;
        try
          // modify user attributes always must happend before savegroups so we don't get inconsistent here
          if modop > 0 then
            Entry.AttributesByName['memberUid'].AddValue(uid.Text)
          else
            Entry.AttributesByName['memberUid'].DeleteValue(uid.Text);
          Entry.Write;
        finally
          Entry.Free;
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
var
  gidnr: Integer;
  gsid: string;
begin
  with TPickupDlg.Create(Self), ListView do
  try
    PopulateGroups(Session);
    if ShowModal = mrOk then
    begin
      if Assigned(Selected) and (AnsiStrComp(PChar(edGidNumber.Text), PChar(Selected.Data)) <> 0) then
      begin
        gidnr := StrToInt(Session.Lookup(PChar(Selected.Data), sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE));
        if SambaAccount.Activated then
        begin
          gsid := Session.Lookup(PChar(Selected.Data), sANYCLASS, 'sambasid', LDAP_SCOPE_BASE);
          if (Copy(gsid, 1, LastDelimiter('-', gsid) - 1) <> SambaAccount.DomainSID) and
             (MessageDlg('Selected primary group is not a Samba group or it does not map to user domain. Do you still want to continue?', mtWarning, [mbYes, mbNo], 0) = mrNo) then Abort;
          SambaAccount.GidNumber := gidnr;
        end
        else
          PosixAccount.GidNumber := gidnr;
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
  if uid.Modified then
  begin
    SambaPreset;
    MailPreset;
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
  if cbSamba.Checked then
  begin
    SambaPreset;
    SambaSheet.TabVisible := true;
  end
  else begin
    SambaAccount.Remove;
    SambaSheet.TabVisible := false;
  end;

end;

procedure TUserDlg.cbMailClick(Sender: TObject);
begin
  if cbMail.Checked then
  begin
    MailSheet.TabVisible := true;
    MailPreset;
  end
  else begin
    MailSheet.TabVisible := false;
    MailAccount.Remove;
  end;
end;

procedure TUserDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
  PosixAccount.Free;
  InetOrgPerson.Free;
  ShadowAccount.Free;
  SambaAccount.Free;
  MailAccount.Free;
end;

procedure TUserDlg.cbPwdMustChangeClick(Sender: TObject);
begin
  if cbPwdMustChange.Checked then
  begin
    SambaAccount.PwdMustChange := 0;
    cbPwdCantChange.Checked := false;
  end
  else
    SambaAccount.PwdMustChange := 2147483647;
end;

procedure TUserDlg.cbPwdCantChangeClick(Sender: TObject);
begin
  if cbPwdCantChange.Checked then
  begin
    cbPwdMustChange.Checked := false;
    SambaAccount.PwdCanChange := 2147483647;
  end
  else
    SambaAccount.PwdCanChange := 0;
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
  SetShadowTime;
end;

procedure TUserDlg.EditChange(Sender: TObject);
var
  s: string;
begin
  if not PageSetup then with Sender as TCustomEdit do
  begin
    s := Trim(Text);
    if Sender is TMemo then
      s := FormatMemoInput(s);
    Entry.AttributesByName[TControl(Sender).Name].AsString := s;
  end;
end;

procedure TUserDlg.cbShadowClick(Sender: TObject);
begin
  if cbShadow.Checked then
  begin
    ShadowPreset;
    ShadowSheet.TabVisible := true;
  end
  else begin
    ShadowAccount.Remove;
    ShadowSheet.TabVisible := false;
  end;
end;

procedure TUserDlg.cbDomainChange(Sender: TObject);
begin
  SambaAccount.DomainData := DomList.Items[cbDomain.ItemIndex];
end;

procedure TUserDlg.sambaHomeDriveChange(Sender: TObject);
begin
  //TODO -> combo change?//
  SambaAccount.HomeDrive := sambaHomeDrive.Text;
end;

procedure TUserDlg.cbAccntDisabledClick(Sender: TObject);
begin
  SambaAccount.Disabled := cbAccntDisabled.Checked;
end;

procedure TUserDlg.DateTimePickerChange(Sender: TObject);
begin
  SetShadowTime;
end;

procedure TUserDlg.OpenPictureBtnClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog.fileName);
    InetOrgPerson.JPegPhoto := Image1.Picture.Graphic as TJpegImage;
    DeleteJpegBtn.Enabled := true;
  end;
end;

procedure TUserDlg.DeleteJpegBtnClick(Sender: TObject);
begin
  Image1.Picture.Bitmap.FreeImage;
  InetOrgPerson.JPegPhoto := nil;
  DeleteJpegBtn.Enabled := false;
end;

procedure TUserDlg.BtnAdvancedClick(Sender: TObject);
begin
  TSambaAdvancedDlg.Create(Self, Session, SambaAccount).ShowModal;
end;

end.

