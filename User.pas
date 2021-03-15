  {      LDAPAdmin - User.pas
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

unit User;

{ NOTE: Tag property of some editable elements like lists and memos is used to
        mark control as modified, providing replacement for missing Modified property }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, LDAPClasses, WinLDAP, ImgList, Posix, Shadow,
  InetOrg, Postfix, Samba, PropertyObject, Constant, ExtDlgs, TemplateCtrl,
  CheckLst, ShellApi;


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
    Label18: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    pager: TEdit;
    postalAddress: TMemo;
    st: TEdit;
    telephoneNumber: TEdit;
    postalCode: TEdit;
    physicalDeliveryOfficeName: TEdit;
    o: TEdit;
    facsimileTelephoneNumber: TEdit;
    l: TEdit;
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
    ImagePanel: TPanel;
    OpenPictureBtn: TButton;
    Label41: TLabel;
    Image1: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    DeleteJpegBtn: TButton;
    cbMail: TCheckBox;
    cbSamba: TCheckBox;
    CheckListBox: TCheckListBox;
    Bevel1: TBevel;
    title: TEdit;
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
    procedure CheckListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
    procedure PageControlResize(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
  private
    ParentDn: string;
    Entry: TLdapEntry;
    EventHandler: TEventHandler;
    PosixAccount: TPosixAccount;
    ShadowAccount: TShadowAccount;
    SambaAccount: TSamba3Account;
    MailAccount: TMailUser;
    InetOrgPerson: TInetOrgPerson;
    Session: TLDAPSession;
    origGroups: TStringList;
    ColumnToSort: Integer;
    Descending: Boolean;
    PageSetup: Boolean;
    DomList: TDomainList;
    AsTop: Integer;
    originalPanelWindowProc : TWndMethod;
    procedure PanelWindowProc (var Msg : TMessage) ;
    procedure PanelImageDrop (var Msg : TWMDROPFILES) ;
    function FormatString(const Src : string) : string;
    procedure SetCheckbox(Cbx: TCheckBox; Check: Boolean);
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
    constructor Create(AOwner: TComponent; adn: string; ASession: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  UserDlg: TUserDlg;

implementation

uses AdvSamba, Pickup, Input, Misc, Jpeg, Main, Templates, Config;

{$R *.DFM}

{ TUsrDlg }

procedure TUserDlg.PanelWindowProc(var Msg: TMessage) ;
begin
   if Msg.Msg = WM_DROPFILES then
     PanelImageDrop(TWMDROPFILES(Msg))
   else
     originalPanelWindowProc(Msg) ;
end;

procedure TUserDlg.PanelImageDrop(var Msg: TWMDROPFILES) ;
var
   buffer : array[0..MAX_PATH] of char;
begin
   DragQueryFile(Msg.Drop, 0, @buffer, sizeof(buffer)) ;
   Image1.Picture.LoadFromFile(buffer) ;
   InetOrgPerson.JPegPhoto := Image1.Picture.Graphic as TJpegImage;
   DeleteJpegBtn.Enabled := true;
   ImagePanel.Caption := '';
end;

function TUserDlg.FormatString(const Src : string) : string;
var
  p, p1: PChar;

  function CheckRange(var p1: PChar; src: string): string;
  var
    p: PChar;
    rg: string;
  begin
    p := CharNext(p1);
    if p^ = '[' then
    begin
      p := CharNext(p);
      p1 := p;
      while p1^ <> ']' do begin
        if p1 = #0 then
          raise Exception.Create(stUnclosedParam);
        p1 := CharNext(p1);
      end;
      SetString(rg, p, p1 - p);
      Result := Copy(src, 1, StrToInt(rg));
    end
    else
      Result := src;
  end;

begin
  Result := '';
  p := PChar(Src);
  while p^ <> #0 do begin
    p1 := CharNext(p);
    if (p^ = '%') then
    begin
      case p1^ of
        'u': Result := Result + Uid.Text;
        'f': Result := Result + CheckRange(p1, GivenName.Text);
        'F': Result := Result + GivenName.Text[1];
        'l': Result := Result + CheckRange(p1, Sn.Text);
        'L': Result := Result + Sn.Text[1];
        'n': Result := Result + AccountConfig.ReadString(rsambaNetbiosName, '');
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

procedure TUserDlg.SetCheckbox(Cbx: TCheckBox; Check: Boolean);
var
  ev: TNotifyEvent;
begin
  ev := Cbx.OnClick;
  try
    Cbx.OnClick := nil;
    Cbx.Checked := Check;
  finally
    Cbx.OnClick := ev;
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
  mail.Items.CommaText := InetOrgPerson.Mail;
  LoadControls(PrivateSheet);

  if sn.Modified then
  begin
    if givenName.Text <> '' then
    begin
      s := AnsiLowercase(FormatString(AccountConfig.ReadString(rposixUserName, '')));
      SetText(displayName, FormatString(AccountConfig.ReadString(rinetDisplayName, '')));
    end
    else begin
      s := AnsiLowercase(sn.Text);
      SetText(displayName, s);
    end;
    if uid.Text = '' then
    begin
      SetText(uid, ConvertUmlauts(s));
      SetText(homeDirectory, FormatString(AccountConfig.ReadString(rposixHomeDir)));
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
    cbDomain.ItemIndex := cbDomain.Items.IndexOf(AccountConfig.ReadString(rSambaDomainName));
    cbDomain.Enabled := true;
    if (uid.Text <> '') then
    begin
       if (AccountConfig.ReadString(rsambaNetbiosName) <> '') or (Pos('%n', AccountConfig.ReadString(rsambaHomeShare)) = 0) then
        SetText(sambaHomePath, FormatString(AccountConfig.ReadString(rsambaHomeShare)));
      if (AccountConfig.ReadString(rsambaNetbiosName) <> '') or (Pos('%n', AccountConfig.ReadString(rsambaProfilePath)) = 0) then
        SetText(sambaProfilePath, FormatString(AccountConfig.ReadString(rsambaProfilePath)));
      SetText(sambaLogonScript, FormatString(AccountConfig.ReadString(rsambaScript)));
      if sambaHomeDrive.ItemIndex = -1 then
      begin
        sambaHomeDrive.ItemIndex := sambaHomeDrive.Items.IndexOf(AccountConfig.ReadString(rsambaHomeDrive));
        SambaAccount.HomeDrive := AccountConfig.ReadString(rsambaHomeDrive);
      end;
    end;
   end
   else begin
     LoadControls(SambaSheet);
     cbDomain.ItemIndex := cbDomain.Items.IndexOf(SambaAccount.DomainName);
     cbDomain.Enabled := not (esBrowse in Entry.State) and (cbDomain.ItemIndex = -1);
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
     //cbAccntDisabled.Checked := Disabled;
     SetCheckbox(cbAccntDisabled, Disabled or Autolocked);
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
      if (maildrop.Text = '') and (AccountConfig.ReadString(rpostfixMaildrop) <> '') then
        SetText(maildrop, FormatString(AccountConfig.ReadString(rpostfixMaildrop)));
      if AccountConfig.ReadString(rpostfixMailAddress) <> '' then
      begin
        s := FormatString(AccountConfig.ReadString(rpostfixMailAddress));
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
      KickoffTime := LocalDateTimeToUTC(DateTimePicker.DateTime);
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
    if IsNull(eShadowExpire) or (ShadowExpire = SHADOW_EXPIRE) then
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
    if InetOrgPerson.Activated and (sn.text = '') then
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
      Entry.Dn := 'uid=' + PosixAccount.Uid + ',' + ParentDn;
      if InetOrgPerson.DisplayName <> '' then
        PosixAccount.Cn := InetOrgPerson.DisplayName
      else
        PosixAccount.Cn := PosixAccount.Uid;
      uidnr := Session.GetFreeUidNumber(AccountConfig.ReadInteger(rposixFirstUID, FIRST_UID), AccountConfig.ReadInteger(rposixLastUID, LAST_UID));
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

constructor TUserDlg.Create(AOwner: TComponent; adn: string; ASession: TLDAPSession; Mode: TEditMode);
var
  i: Integer;
  Oc: TLdapAttribute;
  TemplateList: TTemplateList;
begin
  inherited Create(AOwner);

  AsTop := AccountSheet.Top;

  Session := ASession;
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

  // Show template extensions
  TemplateList := nil;
  if GlobalConfig.ReadBool(rTemplateExtensions, true) then
    TemplateList := TemplateParser.Extensions['user'];
  if Assigned(TemplateList) then
  begin
    EventHandler := TEventHandler.Create;
    with TemplateList do
      for i := 0 to Count - 1 do
        CheckListBox.Items.AddObject(Templates[i].Name, Templates[i]);
    CheckListBox.ItemIndex := 0;
    CheckListBox.Enabled := true;
  end;

  if Mode = EM_ADD then
  begin
    PosixAccount.New;
    InetOrgPerson.New;
    PosixAccount.GidNumber := AccountConfig.ReadInteger(rposixGroup);
    SetText(loginShell, AccountConfig.ReadString(rposixLoginShell));
    DateTimePicker.Date := Date;
  end
  else begin
    //Fill out the form
    Entry.Read;
    if not InetOrgPerson.Activated then
    begin
      OfficeSheet.TabVisible := false;
      PrivateSheet.TabVisible := false;
    end;
    PosixPreset;
    if ShadowAccount.Activated then
      cbShadow.Checked := true;
    if SambaAccount.Activated then
      cbSamba.Checked := true;
    if MailAccount.Activated then
      cbMail.Checked := true;
    Caption := Format(cPropertiesOf, [uid.Text]);
    // Initialize the template extensions
    if Assigned(TemplateList) and GlobalConfig.ReadBool(rTemplateAutoload, true) then with CheckListBox do
    begin
      Oc := Entry.AttributesByName['objectclass'];
      for i := 0 to Items.Count - 1 do with TTemplate(Items.Objects[i]) do
        if Matches(Oc) then
        begin
          State[i] := cbChecked;
          ItemIndex := i;
          CheckListBoxClickCheck(nil);
        end;
    end;
  end;
  originalPanelWindowProc := ImagePanel.WindowProc;
  ImagePanel.WindowProc := PanelWindowProc;
  DragAcceptFiles(ImagePanel.Handle,true) ;
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
    Session.Search(Format(sMY_GROUP,[uid.Text, ParentDn]), Session.Base, LDAP_SCOPE_SUBTREE,
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
  if PageControl.ActivePage = GroupSheet then
  begin
    if GroupSheet.Tag = 0 then  // Tag = 0: list not yet populated
    begin
      edGidNumber.Text := Session.GetDN(Format(sGROUPBYGID, [PosixAccount.GidNumber]));
      if uid.Text <> '' then
      begin
        PopulateGroupList;
        GroupList.AlphaSort;
        GroupSheet.Tag := 1;
      end;
    end;
  end
  else
  if PageControl.ActivePage = PrivateSheet then
  begin
    if not Assigned(Image1.Picture.Graphic) then
    begin
      Image1.Picture.Graphic := InetOrgPerson.JPegPhoto;
      if Assigned(Image1.Picture.Graphic) then
      begin
        DeleteJpegBtn.Enabled := true;
        ImagePanel.Caption := '';
      end;
    end;
  end
  else
  if PageControl.ActivePage = OfficeSheet then
  begin
    Label11.Top := 256;
    Label11.Left := 16;
    AddMailBtn.Left := 296;
    AddMailBtn.Top := 272;
    EditMailBtn.Left := AddMailBtn.Left;
    EditMailBtn.Top := 304;
    DelMailBtn.Left := AddMailBtn.Left;
    DelMailBtn.Top := 336;
    mail.Top := 272;
    mail.Left := 16;
    mail.Width := 273;
    mail.Height := 89;
    Label11.Parent := OfficeSheet;
    mail.Parent := OfficeSheet;
    AddMailBtn.Parent := OfficeSheet;
    EditMailBtn.pArent := OfficeSheet;
    DelMailBtn.Parent := OfficeSheet;
  end
  else
  if PageControl.ActivePage = MailSheet then
  begin
    Label11.Top := 64;
    Label11.Left := 16;
    AddMailBtn.Left := 16;
    AddMailBtn.Top := 336;
    EditMailBtn.Left := 96;
    EditMailBtn.Top := AddMailBtn.Top;
    DelMailBtn.Left := 176;
    DelMailBtn.Top := AddMailBtn.Top;
    mail.Top := 80;
    mail.Left := 16;
    mail.Width := 353;
    mail.Height := 249;
    Label11.Parent := MailSheet;
    mail.Parent := MailSheet;
    AddMailBtn.Parent := MailSheet;
    EditMailBtn.pArent := MailSheet;
    DelMailBtn.Parent := MailSheet;
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
  we add it there. If it's already there add operation modus to its tag value
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
  GroupItem: TListItem;
  i: integer;
begin
  with TPickupDlg.Create(self) do begin
    Caption := cPickGroups;
    Columns[1].Caption:='Description';
    Populate(Session, sGROUPS, ['cn', 'description']);
    {Images:=MainFrm.ImageList;
    ImageIndex:=bmGroup;}

    if ShowModal=MrOK then begin
      CopyGroups;
      for i:=0 to SelCount-1 do  begin
        if FindDataString(PChar(Selected[i].dn)) then continue;

        GroupItem:=GroupList.Items.Add;
        GroupItem.Data := StrNew(pchar(Selected[i].DN));
        GroupItem.Caption := selected[i].AttributesByName['cn'].AsString;
        GroupItem.SubItems.Add(selected[i].AttributesByName['description'].AsString);
        HandleGroupModify(PChar(selected[i].dn), GRP_ADD);
      end;
      GroupList.Tag := 1;
    end;
    Free;
  end;
  RemoveGroupBtn.Enabled := GroupList.Items.Count > 0;
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
  with TPickupDlg.Create(self) do begin
    Caption := cPickGroups;
    Columns[1].Caption:='Description';
    Populate(Session, sGROUPS, ['cn', 'description']);
    Images:=MainFrm.ImageList;
    ImageIndex:=bmGroup;

    ShowModal;

    if (SelCount>0) and (AnsiCompareStr(edGidNumber.Text, Selected[0].Dn) <> 0) then begin
      gidnr := StrToInt(Session.Lookup(Selected[0].Dn, sANYCLASS, 'gidNumber', LDAP_SCOPE_BASE));
      if SambaAccount.Activated then
      begin
        gsid := Session.Lookup(Selected[0].Dn, sANYCLASS, 'sambasid', LDAP_SCOPE_BASE);
        if (Copy(gsid, 1, LastDelimiter('-', gsid) - 1) <> SambaAccount.DomainSID) and
           (MessageDlg(stGidNotSamba, mtWarning, [mbYes, mbNo], 0) = mrNo) then Abort;
        SambaAccount.GidNumber := gidnr;
      end
      else
        PosixAccount.GidNumber := gidnr;
        edGidNumber.Text := Selected[0].Dn;
        edGidNumber.Modified := true;
      end;

    Free;
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
var
  i: Integer;
begin
  Entry.Free;
  PosixAccount.Free;
  InetOrgPerson.Free;
  ShadowAccount.Free;
  SambaAccount.Free;
  MailAccount.Free;
  with CheckListBox.Items do
    for i := 0 to Count - 1 do
      if Objects[i] is TTabSheet then Objects[i].Free;
  EventHandler.Free;
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
  with SambaAccount do
  if cbAccntDisabled.Checked then
    Disabled := true
  else begin
    if Autolocked then
    begin
      if MessageDlg(stResetAutolock, mtWarning, [mbYes, mbNo], 0) = mrYes then
        Autolocked := false
      else
      begin
        try
          cbAccntDisabled.OnClick := nil;
          cbAccntDisabled.Checked := true;
        finally
          cbAccntDisabled.OnClick := cbAccntDisabledClick;
        end;
        Exit;
      end;
    end;
    Disabled := false;
  end;
  //SambaAccount.Disabled := cbAccntDisabled.Checked;
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
    ImagePanel.Caption := '';
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

procedure TUserDlg.CheckListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
begin
  with CheckListBox do begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.Font.Color := clBlack;
    Canvas.FillRect(Rect);
    Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    Inc(Rect.Left, 2);
    DrawText(Canvas.Handle, PChar(Items[Index]), Length(Items[Index]), Rect, Flags);
  end;
end;

procedure TUserDlg.CheckListBoxClickCheck(Sender: TObject);
var
  Template: TTemplate;
  TabSheet: TTabSheet;
  TemplatePanel: TTemplatePanel;
  i, j: Integer;
  s: string;

  function SafeDelete(const name: string): boolean;
  var
    i: Integer;
    s: string;
  begin
    Result := false;
    s := lowercase(name);
    for i := Low(InetOrg.PropAttrNames) to High(InetOrg.PropAttrNames) do
      if s = lowercase(InetOrg.PropAttrNames[i]) then Exit;
    for i := Low(Posix.PropAttrNames) to High(Posix.PropAttrNames) do
      if s = lowercase(Posix.PropAttrNames[i]) then Exit;
    Result := true;
  end;

begin
  { CheckListBox holds pointers to Templates or TabSheets in its Object array:
    Checked[i] = FALSE:  Objects[i] = Pointer(Template)
    Checked[i] = TRUE:   Objects[i] = Pointer(TTabSheet)
    TabSheet holds pointer to TemplatePanel in its Tag filed.
  }
  with CheckListBox do begin
    Tag := Integer(Sender);
    if State[ItemIndex] <> cbChecked then
    begin
      TabSheet := TTabSheet(Items.Objects[ItemIndex]);
      TemplatePanel := TTemplatePanel(TabSheet.Tag);
      Items.Objects[ItemIndex] := Pointer(TemplatePanel.Template);
      { Handle removing of the template - remove only attributes and
        objectclasses which are not used by builtin registers }
      for i := 0 to TemplatePanel.Attributes.Count - 1 do with TemplatePanel.Attributes[i] do
      begin
        Template := TemplatePanel.Template;
        if (lowercase(Name) = 'objectclass') then
        begin
          with Entry.AttributesByName['objectclass'] do
          for j := 0 to Template.ObjectclassCount - 1 do
          begin
            s := lowercase(Template.Objectclasses[j]);
            if (s <> 'top') and
               (s <> 'inetorgperson') and
               (s <> 'posixaccount') then
            begin
              DeleteValue(s);
              if AnsiCompareText(s, MailAccount.Objectclass) = 0 then
                cbMail.Checked := false
              else
              if AnsiCompareText(s, ShadowAccount.Objectclass) = 0 then
                cbShadow.Checked := false
              else
              if AnsiCompareText(s, SambaAccount.Objectclass) = 0 then
                cbSamba.Checked := false;
            end;
          end;
        end
        else
        if SafeDelete(Name) then
          Entry.AttributesByName[Name].Delete;
      end;
      TabSheet.Free;
      Exit;
    end;
    Template := TTemplate(Items.Objects[ItemIndex]);
    TabSheet := TTabSheet.Create(Self);
    TabSheet.Caption := Template.Name;

    TabSheet.PageControl := PageControl;
    TemplatePanel := TTemplatePanel.Create(Self);
    TemplatePanel.Parent := TabSheet;
    TemplatePanel.Align := alClient;
    TemplatePanel.LdapEntry := Entry;
    TemplatePanel.Template := Template;
    TemplatePanel.EventHandler := EventHandler;

    TabSheet.Tag := Integer(TemplatePanel);
    Items.Objects[ItemIndex] := TabSheet;
  end;
end;

procedure TUserDlg.CheckListBoxClick(Sender: TObject);
begin
  with CheckListBox do begin
    if Tag = 0 then
    begin
      if State[ItemIndex] = cbChecked then
        State[ItemIndex] := cbUnchecked
      else
        State[ItemIndex] := cbChecked;
      CheckListBoxClickCheck(nil);
    end;
    Tag := 0;
  end;
end;

procedure TUserDlg.PageControlResize(Sender: TObject);
begin
  PageControl.OnResize := nil;
  try
    Height := Height + AccountSheet.Top - AsTop;
    AsTop := AccountSheet.Top;
  finally
    PageControl.OnResize := PageControlResize;
  end;
end;

procedure TUserDlg.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  // (Try to:) Ensure that possible template changes reflect in standard tabs
  if PageControl.ActivePageIndex > 6 then
  begin
    PosixPreset;
    ShadowPreset;
    SambaPreset;
    MailPreset;
  end;
end;

end.

