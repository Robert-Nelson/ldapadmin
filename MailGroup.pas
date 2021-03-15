  {      LDAPAdmin - MailGroup.pas
  *      Copyright (C) 2003 Tihomir Karlovic
  *
  *      Author: Simon Zsolt
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

unit MailGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Samba, Posix, LDAPClasses, RegAccnt, Postfix,
  Constant;

type
  TMailGroupDlg = class(TForm)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edDescription: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    UserList: TListView;
    AddUserBtn: TButton;
    RemoveUserBtn: TButton;
    TabSheet2: TTabSheet;
    mail: TListBox;
    AddMailBtn: TButton;
    EditMailBtn: TButton;
    DelMailBtn: TButton;
    edMailRoutingAddress: TEdit;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddUserBtnClick(Sender: TObject);
    procedure RemoveUserBtnClick(Sender: TObject);
    procedure UserListDeletion(Sender: TObject; Item: TListItem);
    procedure edNameChange(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure AddMailBtnClick(Sender: TObject);
    procedure EditMailBtnClick(Sender: TObject);
    procedure DelMailBtnClick(Sender: TObject);
    procedure mailClick(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
    procedure edMailRoutingAddressChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Entry: TLdapEntry;
    EditMode: TEditMode;
    ParentDn: string;
    Session: TLDAPSession;
    RegAccount: TAccountEntry;
    Group: TMailGroup;
    ColumnToSort: Integer;
    Descending: Boolean;
    procedure Load;
    function FindDataString(dstr: PChar): Boolean;
    procedure Save;
    procedure MailButtons(Enable: Boolean);
  public
    constructor Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  MailGroupDlg: TMailGroupDlg;

implementation

uses Pickup, WinLDAP, Input;

{$R *.DFM}

{ Note: Item.Caption = uid, Item.Data = dn }
procedure TMailGroupDlg.Load;
var
  ListItem: TListItem;
  i: Integer;
begin
  Entry.Read;
  edName.Text := Group.Cn;
  edMailRoutingAddress.Text := Group.MailRoutingAddress;
  for i := 0 to Group.AddressCount - 1 do
    mail.Items.Add(Group.Addresses[i]);
  edDescription.Text := Group.Description;
  for i := 0 to Group.MemberCount - 1 do
  begin
    ListItem := UserList.Items.Add;
    ListItem.Caption := GetNameFromDn(Group.Members[i]);
    ListItem.Data := StrNew(PChar(Group.Members[i]));
    ListItem.SubItems.Add(CanonicalName(PChar(GetDirFromDn(Group.Members[i]))));
  end;
  if UserList.Items.Count > 0 then
    RemoveUserBtn.Enabled := true;
  OkBtn.Enabled := (edName.Text <> '') and (mail.Items.Count > 0);
end;

constructor TMailGroupDlg.Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  ParentDn := dn;
  Self.Session := Session;
  Self.RegAccount := RegAccount;
  EditMode := Mode;
  Entry := TLdapEntry.Create(Session, dn);
  Group := TMailGroup.Create(Entry);
  if EditMode = EM_MODIFY then
  begin
    Load;
    edName.Enabled := false;
    Caption := Format(cPropertiesOf, [edName.Text]);
    UserList.AlphaSort;
  end
  else
    Group.New;
end;

procedure TMailGroupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  Action := caFree;
end;

procedure TMailGroupDlg.Save;
begin
  if edName.Text = '' then
    raise Exception.Create(stGroupNameReq);
  if mail.Items.Count = 0 then
    raise Exception.Create(stGroupMailReq);
  Entry.Write;
end;

function TMailGroupDlg.FindDataString(dstr: PChar): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to UserList.Items.Count - 1 do
    if AnsiStrComp(UserList.Items[i].Data, dstr) = 0 then
    begin
      Result := true;
      break;
    end;
end;

procedure TMailGroupDlg.AddUserBtnClick(Sender: TObject);
var
  UserItem, SelItem: TListItem;
begin
  with TPickupDlg.Create(Self), ListView do
  try
    MultiSelect := true;
    PopulateMailAccounts(Session);
    PopulateMailGroups(Session);
    if ShowModal = mrOk then
    begin
      SelItem := Selected;
      while Assigned(SelItem) do
      begin
        if not FindDataString(PChar(SelItem.Data)) then
        begin
          UserItem := UserList.Items.Add;
          UserItem.Caption := SelItem.Caption;
          UserItem.Data := StrNew(SelItem.Data);
          UserItem.SubItems.Add(CanonicalName(GetDirFromDn(PChar(SelItem.Data))));
          Group.AddMember({Session.GetNameFromDN(}PChar(SelItem.Data){)});
        end;
        SelItem := GetNextItem(SelItem, sdAll, [isSelected]);
      end;
      OkBtn.Enabled := true;
    end;
  finally
    Destroy;
    if UserList.Items.Count > 0 then
      RemoveUserBtn.Enabled := true;
  end;

  end;
procedure TMailGroupDlg.RemoveUserBtnClick(Sender: TObject);
var
  idx: Integer;
  dn: string;
begin
  with UserList do
  If Assigned(Selected) then
  begin
    idx := Selected.Index;
    dn := PChar(Selected.Data);
    Selected.Delete;
    Group.RemoveMember(dn);
    OkBtn.Enabled := true;
    if idx = Items.Count then
      Dec(idx);
    if idx > -1 then
      Items[idx].Selected := true
    else
      RemoveUserBtn.Enabled := false;
  end;
end;

procedure TMailGroupDlg.UserListDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    StrDispose(Item.Data);
end;

procedure TMailGroupDlg.edNameChange(Sender: TObject);
begin
  OkBtn.Enabled := (edName.Text <> '') and (mail.Items.Count > 0);
  if esNew in Entry.State then
    Entry.Dn := 'cn=' + edName.Text + ',' + ParentDn;
  Group.Cn := edName.Text;
end;

procedure TMailGroupDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
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

procedure TMailGroupDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
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

procedure TMailGroupDlg.MailButtons(Enable: Boolean);
begin
  Enable := Enable and (mail.ItemIndex > -1);
  DelMailBtn.Enabled := Enable;
  EditMailBtn.Enabled := Enable;
end;

procedure TMailGroupDlg.AddMailBtnClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputDlg(cAddAddress, cSmtpAddress, s) then
  begin
    mail.Items.Add(s);
    Group.AddMail(s);
    MailButtons(true);
    edNameChange(Sender);
  end;
end;

procedure TMailGroupDlg.EditMailBtnClick(Sender: TObject);
var
  s: string;
begin
  s := mail.Items[mail.ItemIndex];
  if InputDlg(cEditAddress, cSmtpAddress, s) then
  begin
    Group.RemoveMail(mail.Items[mail.ItemIndex]);
    Group.AddMail(s);
    mail.Items[mail.ItemIndex] := s;
    edNameChange(Sender);
  end;
end;

procedure TMailGroupDlg.DelMailBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with mail do begin
    idx := ItemIndex;
    Group.RemoveMail(Items[idx]);
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    if Items.Count = 0 then
      MailButtons(false);
    edNameChange(Sender);
  end;
end;

procedure TMailGroupDlg.mailClick(Sender: TObject);
begin
  MailButtons(true);
end;

procedure TMailGroupDlg.edDescriptionChange(Sender: TObject);
begin
  edDescription.Text := Group.Description;
end;

procedure TMailGroupDlg.edMailRoutingAddressChange(Sender: TObject);
begin
  Group.MailRoutingAddress := edMailRoutingAddress.Text;
end;

procedure TMailGroupDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
