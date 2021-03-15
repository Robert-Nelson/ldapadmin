  {      LDAPAdmin - Group.pas
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

unit Group;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, LDAPClasses, Constant;

const

  USR_ADD           =  1;
  USR_DEL           = -1;

type
  TGroupDlg = class(TForm)
    Label1: TLabel;
    Name: TEdit;
    Label2: TLabel;
    Description: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    UserList: TListView;
    AddUserBtn: TButton;
    RemoveUserBtn: TButton;
    TabSheet2: TTabSheet;
    AddResBtn: TButton;
    DelResBtn: TButton;
    EditResBtn: TButton;
    ResourceList: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddUserBtnClick(Sender: TObject);
    procedure RemoveUserBtnClick(Sender: TObject);
    procedure UserListDeletion(Sender: TObject; Item: TListItem);
    procedure DescriptionChange(Sender: TObject);
    procedure NameChange(Sender: TObject);
    procedure AddResBtnClick(Sender: TObject);
    procedure EditResBtnClick(Sender: TObject);
    procedure DelResBtnClick(Sender: TObject);
    procedure ResourceListClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    EditMode: TEditMode;
    dn: string;
    ldSession: TLDAPSession;
    origUsers: TStringList;
    IsResourceGroup: Boolean;
    ColumnToSort: Integer;
    Descending: Boolean;
    procedure ResButtons(Enable: Boolean);
    procedure Load;
    procedure CopyUsers;
    procedure HandleGroupModify(dn: string; ModOp: Integer);
    function FindDataString(dstr: PChar): Boolean;
    function NextGID: Integer;
    procedure Save;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  GroupDlg: TGroupDlg;

implementation

uses Pickup, WinLDAP, Input;

{$R *.DFM}

procedure TGroupDlg.ResButtons(Enable: Boolean);
begin
  Enable := Enable and (REsourceList.ItemIndex > -1);
  DelResBtn.Enabled := Enable;
  EditResBtn.Enabled := Enable;
end;

{ Note: Item.Caption = uid, Item.Data = dn }

procedure TGroupDlg.Load;
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
  SetLength(attrs, 5);
  attrs[0] := 'cn';
  attrs[1] := 'description';
  attrs[2] := 'memberUid';
  attrs[3] := 'resource';
  attrs[4] := nil;

  LdapCheck(ldap_search_s(pld, PChar(dn), LDAP_SCOPE_BASE,
                               PChar(sANYCLASS), PChar(attrs), 0, plmSearch));

  try
      UserList.Items.BeginUpdate;
      // loop thru entries
      plmEntry := ldap_first_entry(pld, plmSearch);
      if Assigned(plmEntry) then
      begin
        // Get CN
        ppcVals := ldap_get_values(pld, plmEntry, attrs[0]);
        if Assigned(ppcVals) then
          Name.Text := PCharArray(ppcVals)[0];
        // Get Description
        ppcVals := ldap_get_values(pld, plmEntry, attrs[1]);
        if Assigned(ppcVals) then
          Description.Text := PCharArray(ppcVals)[0];
        // Get memberUid
        ppcVals := ldap_get_values(pld, plmEntry, attrs[2]);
        if Assigned(ppcVals) then
        try
          I := 0;
          while Assigned(PCharArray(ppcVals)[I]) do
          begin
            ListItem := UserList.Items.Add;
            ListItem.Caption := PCharArray(ppcVals)[I];
            //ListItem.Data := StrNew(PChar(GetDirectory(Format(sACCNTBYUID, [PCharArray(ppcVals)[I]]))));
            ListItem.Data := StrNew(PChar(ldSession.GetDN(Format(sACCNTBYUID, [PCharArray(ppcVals)[I]]))));
            ListItem.SubItems.Add(ldSession.CanonicalName(ldSession.GetDirFromDN(PChar(ListItem.Data))));
            Inc(I);
          end;
        finally
          LDAPCheck(ldap_value_free(ppcVals));
        end;
        // Get Resource
        ppcVals := ldap_get_values(pld, plmEntry, attrs[3]);
        if Assigned(ppcVals) then
        try
          I := 0;
          while Assigned(PCharArray(ppcVals)[I]) do
          begin
            ResourceList.Items.Add(PCharArray(ppcVals)[I]);
            Inc(I);
          end;
        finally
          LDAPCheck(ldap_value_free(ppcVals));
        end;

      end;
    finally
      UserList.Items.EndUpdate;
      // free search results
      LDAPCheck(ldap_msgfree(plmSearch));
    end;

    if UserList.Items.Count > 0 then
      RemoveUserBtn.Enabled := true;
end;


constructor TGroupDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  Self.dn := dn;
  ldSession := Session;
  EditMode := Mode;
  if EditMode = EM_MODIFY then
  begin
    Load;
    Name.Enabled := false;
    Caption := Format(cPropertiesOf, [Name.Text]);
    UserList.AlphaSort;
  end;
  IsResourceGroup := ResourceList.Items.Count > 0;
  ResButtons(IsResourceGroup);
end;

procedure TGroupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  origUsers.Free;
  Action := caFree;
end;

function TGroupDlg.NextGID: Integer;
begin
  Result := ldSession.Max(sGROUPS, 'gidNumber') + 1;
  if Result < START_GID then
    Result := START_GID;
end;

procedure TGroupDlg.Save;
var
  i, modop: Integer;
  Entry: TLDAPEntry;

begin

  if Name.Text = '' then
    raise Exception.Create(stGroupNameReq);

  if EditMode = EM_ADD then
    dn := 'cn=' + Name.Text + ',' + dn;
  Entry := TLDAPEntry.Create(ldSession.pld, dn);
  try
    if EditMode = EM_ADD then
    begin
      Entry.AddAttr('objectclass', 'top', LDAP_MOD_ADD);
      Entry.AddAttr('objectclass', 'posixGroup', LDAP_MOD_ADD);
      Entry.AddAttr('cn', Name.Text, LDAP_MOD_ADD);
      Entry.AddAttr('gidNumber', IntToStr(NextGID), LDAP_MOD_ADD);
      if Description.Text <> '' then
        Entry.AddAttr('description', Description.Text, LDAP_MOD_ADD);
    end
    else
      if Description.Modified then
        Entry.AddAttr('description', Description.Text, LDAP_MOD_REPLACE);

    // Handle Members
    if Assigned(origUsers) then with origUsers do
    begin
      for i := 0 to Count-1 do
      begin
        modop := Integer(Objects[i]);
        if modop > 0 then
          Entry.AddAttr('memberUid', ldSession.GetNameFromDN(origUsers[i]), LDAP_MOD_ADD)
        else
        if modop < 0 then
          Entry.AddAttr('memberUid', ldSession.GetNameFromDN(origUsers[i]), LDAP_MOD_DELETE);
        end;
    end;

    // Handle Resources
    if ResourceList.Tag = 1 then with ResourceList do
    begin
      // First delete all attributes/value pairs
      if IsResourceGroup then
        Entry.AddAttr('resource', '', LDAP_MOD_DELETE);
      if Items.Count > 0 then
      begin
        if not IsResourceGroup then
          Entry.AddAttr('objectclass', 'resourceObject', LDAP_MOD_ADD);
        for i := 0 to ResourceList.Items.Count - 1 do
          Entry.AddAttr('resource', ResourceList.Items[i], LDAP_MOD_ADD);
      end
      else
      if IsResourceGroup then
        Entry.AddAttr('objectclass', 'resourceObject', LDAP_MOD_DELETE);
    end;

    if EditMode = EM_ADD then
      Entry.Add
    else
      Entry.Modify;
  finally
    Entry.Free;
  end;

end;

procedure TGroupDlg.CopyUsers;
var
  I: Integer;
begin
  if not Assigned(origUsers) then
  begin
    // Keep copy of original group list
    origUsers := TStringList.Create;
    for I := 0 to UserList.Items.Count - 1 do
      origUsers.Add(PChar(UserList.Items[i].Data));
  end;
end;

{ This works like this: if uid is new user then it won't be in origUsers list so
  we add it there. If its already there add operation modus to its tag value
  (which is casted Objects array). This way we can handle repeatingly adding and
  removing of same users: if it sums up to 0 we dont have to do anything, if
  its > 0 we add user to this group in LDAP directory and if its < 0 we remove
  user from this group in LDAP directory }

procedure TGroupDlg.HandleGroupModify(dn: string; ModOp: Integer);
var
  i,v: Integer;

begin
  i := origUsers.IndexOf(dn);
  if i < 0 then
  begin
    i := origUsers.Add(dn);
    origUsers.Objects[i] := Pointer(USR_ADD);
  end
  else begin
    v := Integer(origUsers.Objects[I]) + ModOp;
    origUsers.Objects[i] := Pointer(v);
  end;
end;

function TGroupDlg.FindDataString(dstr: PChar): Boolean;
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

procedure TGroupDlg.AddUserBtnClick(Sender: TObject);
var
  UserItem, SelItem: TListItem;
begin
  with TPickupDlg.Create(Self), ListView do
  try
    MultiSelect := true;
    PopulateAccounts(ldSession);
    if ShowModal = mrOk then
    begin
      CopyUsers;
      SelItem := Selected;
      while Assigned(SelItem) do
      begin
        if not FindDataString(PChar(SelItem.Data)) then
        begin
          UserItem := UserList.Items.Add;
          UserItem.Caption := SelItem.Caption;
          UserItem.Data := StrNew(SelItem.Data);
          UserItem.SubItems.Add(ldSession.CanonicalName(ldSession.GetDirFromDN(PChar(SelItem.Data))));
          HandleGroupModify(PChar(SelItem.Data), USR_ADD);
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
procedure TGroupDlg.RemoveUserBtnClick(Sender: TObject);
var
  idx: Integer;
  dn: string;
begin
  with UserList do
  If Assigned(Selected) then
  begin
    CopyUsers;
    idx := Selected.Index;
    dn := PChar(Selected.Data);
    Selected.Delete;
    HandleGroupModify(dn, USR_DEL);
    OkBtn.Enabled := true;
    if idx = Items.Count then
      Dec(idx);
    if idx > -1 then
      Items[idx].Selected := true
    else
      RemoveUserBtn.Enabled := false;
  end;
end;

procedure TGroupDlg.UserListDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    StrDispose(Item.Data);
end;

procedure TGroupDlg.DescriptionChange(Sender: TObject);
begin
  OkBtn.Enabled := true;
end;

procedure TGroupDlg.NameChange(Sender: TObject);
begin
  OkBtn.Enabled := true;
end;

procedure TGroupDlg.AddResBtnClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputDlg(cNewResource, cResource, s) then
  begin
    ResourceList.Items.Add(s);
    ResourceList.tag := 1;
    ResButtons(true);
  end;
end;

procedure TGroupDlg.EditResBtnClick(Sender: TObject);
var
  s: string;
begin
  s := ResourceList.Items[ResourceList.ItemIndex];
  if InputDlg(cEditResource, cResource, s) then
  begin
    ResourceList.Items[ResourceList.ItemIndex] := s;
    ResourceList.tag := 1;
  end;
end;

procedure TGroupDlg.DelResBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with ResourceList do begin
    idx := ItemIndex;
    Items.Delete(idx);
    if idx < Items.Count then
      ItemIndex := idx
    else
      ItemIndex := Items.Count - 1;
    Tag := 1;
    if Items.Count = 0 then
      ResButtons(false);
  end;
end;

procedure TGroupDlg.ResourceListClick(Sender: TObject);
begin
  ResButtons(true);
end;

procedure TGroupDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
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

procedure TGroupDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
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

end.
