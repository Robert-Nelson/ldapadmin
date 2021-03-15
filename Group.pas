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
  StdCtrls, ComCtrls, ExtCtrls, Samba, Posix, LDAPClasses, RegAccnt, Constant;

const

  USR_ADD           =  1;
  USR_DEL           = -1;

type
  TGroupDlg = class(TForm)
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
    AddResBtn: TButton;
    DelResBtn: TButton;
    EditResBtn: TButton;
    ResourceList: TListBox;
    TabSheet3: TTabSheet;
    cbSambaDomain: TComboBox;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    cbBuiltin: TComboBox;
    edRid: TEdit;
    Label4: TLabel;
    cbSambaGroup: TCheckBox;
    Bevel1: TBevel;
    edDisplayName: TEdit;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddUserBtnClick(Sender: TObject);
    procedure RemoveUserBtnClick(Sender: TObject);
    procedure UserListDeletion(Sender: TObject; Item: TListItem);
    procedure edDescriptionChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure AddResBtnClick(Sender: TObject);
    procedure EditResBtnClick(Sender: TObject);
    procedure DelResBtnClick(Sender: TObject);
    procedure ResourceListClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure cbSambaDomainChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure cbBuiltinChange(Sender: TObject);
    procedure cbSambaGroupClick(Sender: TObject);
  private
    EditMode: TEditMode;
    ParentDn: string;
    Session: TLDAPSession;
    RegAccount: TAccountEntry;
    Group: TPosixGroup;
    IsSambaGroup, IsResourceGroup: Boolean;
    ColumnToSort: Integer;
    Descending: Boolean;
    DomList: TDomainList;
    procedure EnableControls(const Controls: array of TControl; Color: TColor; Enable: Boolean);
    procedure EnableResButtons(Enable: Boolean);
    procedure Load;
    function FindDataString(dstr: PChar): Boolean;
    procedure Save;
    function GroupType: Integer;
  public
    constructor Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  GroupDlg: TGroupDlg;

implementation

uses Pickup, WinLDAP, Input;

{$R *.DFM}

procedure TGroupDlg.EnableControls(const Controls: array of TControl; Color: TColor; Enable: Boolean);
var
  Control: TControl;
  i: Integer;
begin
  for i := Low(Controls) to High(Controls) do
  begin
    Control := Controls[i];
    if Assigned(Control) then
    begin
      if Control is TEdit then
        TEdit(Control).Color := Color
      else
      if Control is TComboBox then
        TComboBox(Control).Color := Color;
      if Control is TMemo then
        TMemo(Control).Color := Color;
      Control.Enabled := Enable;
    end;
  end;
end;

procedure TGroupDlg.EnableResButtons(Enable: Boolean);
begin
  Enable := Enable and (ResourceList.ItemIndex > -1);
  DelResBtn.Enabled := Enable;
  EditResBtn.Enabled := Enable;
end;

{ Note: Item.Caption = uid, Item.Data = dn }
procedure TGroupDlg.Load;
var
  ListItem: TListItem;
  i: Integer;
  attrname: string;
begin
  Group.Read;
  edName.Text := Group.Cn;
  edDescription.Text := Group.Description;
  for i := 0 to Group.Members.Count - 1 do
  begin
    ListItem := UserList.Items.Add;
    ListItem.Caption := Group.Members[i];
    //ListItem.Data := StrNew(PChar(GetDirectory(Format(sACCNTBYUID, [PCharArray(ppcVals)[I]]))));
    ListItem.Data := StrNew(PChar(Session.GetDN(Format(sACCNTBYUID, [Group.Members[i]]))));
    ListItem.SubItems.Add(Session.CanonicalName(Session.GetDirFromDN(PChar(ListItem.Data))));
  end;
  if UserList.Items.Count > 0 then
    RemoveUserBtn.Enabled := true;
  for i := 0 to Group.Items.Count - 1 do //TODO: ResourceObject
  begin
    attrname := lowercase(Group.Items[i]);
    if attrname = 'resource' then
      ResourceList.Items.Add(PChar(Group.Items.Objects[i]))
    else
    if (attrname = 'objectclass') and (lowercase(PChar(Group.Items.Objects[i])) = 'sambagroupmapping') then
      IsSambaGroup := true;
  end;
end;

constructor TGroupDlg.Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode);
var
  Temp: TPosixGroup;
  n: Integer;
begin
  inherited Create(AOwner);
  ParentDn := dn;
  Self.Session := Session;
  Self.RegAccount := RegAccount;
  EditMode := Mode;
  Group := TPosixGroup.Create(Session, dn);
  if EditMode = EM_MODIFY then
  begin
    Load;
    if IsSambaGroup then
    begin
      Temp := Group;
      Group := TSamba3Group.Copy(Temp);
      Temp.Free;
      cbSambaGroup.Checked := true;
      with RadioGroup1 do
      case TSamba3Group(Group).GroupType of
        2: ItemIndex := 0;
        4: ItemIndex := 1;
        5: begin
             ItemIndex := 2;
             n := StrToInt(TSamba3Group(Group).Rid) - 512;
             if (n >=0) and (n < cbBuiltin.Items.Count) then
               cbBuiltin.ItemIndex := n
             else
               cbBuiltin.ItemIndex := -1;
           end;

      end;
      edRid.Text := TSamba3Group(Group).Rid;
      edDisplayName.Text := TSamba3Group(Group).DisplayName;
    end;
    edName.Enabled := false;
    Caption := Format(cPropertiesOf, [edName.Text]);
    UserList.AlphaSort;
  end;
  IsResourceGroup := ResourceList.Items.Count > 0;
end;

procedure TGroupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  Action := caFree;
end;

procedure TGroupDlg.Save;
var
  i: Integer;
  Temp: TPosixGroup;
  arid: string;
begin

  if edName.Text = '' then
    raise Exception.Create(stGroupNameReq);

  try
    with Group do
    begin
      Cn := edName.Text;
      if EditMode = EM_ADD then
      begin
        dn := PChar('cn=' + edName.Text + ',' + ParentDn);
        Description := edDescription.Text;
        GidNumber := Session.GetFreeGidNumber(RegAccount.posixFirstGid, RegAccount.posixLastGID);
      end;
    end;

    if cbSambaGroup.Checked then
    begin
      if not IsSambaGroup then
      begin
        if cbSambaDomain.ItemIndex = -1 then
          raise Exception.Create(stSmbDomainReq);
        Temp := Group;
        Group := TSamba3Group.Copy(Temp);
        Temp.Free;
        with TSamba3Group(Group) do
        begin
          if EditMode = EM_MODIFY then
            Add;
          if edDisplayName.Text <> '' then
            DisplayName := edDisplayName.Text
          else
            DisplayName := CN;
          GroupType := Self.GroupType;
          arid := edRid.Text;
          if arid = '' then
            arid := IntToStr(2 * Group.gidNumber + DomList.Items[cbSambaDomain.ItemIndex].AlgorithmicRIDBase + 1);
          Sid := Format('%s-%s', [DomList.Items[cbSambaDomain.ItemIndex].SID, arid])
        end;
      end;
    end
    else
    if IsSambaGroup then
       TSamba3Group(Group).Remove;

    with Group do
    begin

      // Handle Resources
      if ResourceList.Tag = 1 then with ResourceList do
      begin
        // First delete all attributes/value pairs
        if IsResourceGroup then
          AddAttr('resource', '', LDAP_MOD_DELETE);
        if Items.Count > 0 then
        begin
          if not IsResourceGroup then
            AddAttr('objectclass', 'resourceObject', LDAP_MOD_ADD);
          for i := 0 to ResourceList.Items.Count - 1 do
            AddAttr('resource', ResourceList.Items[i], LDAP_MOD_ADD);
        end
        else
        if IsResourceGroup then
          AddAttr('objectclass', 'resourceObject', LDAP_MOD_DELETE);
      end;

      if EditMode = EM_ADD then
        New
      else
        Modify;
    end;
  except
    Group.ClearAttrs;
    raise;
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
    PopulateAccounts(Session);
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
          UserItem.SubItems.Add(Session.CanonicalName(Session.GetDirFromDN(PChar(SelItem.Data))));
          Group.AddMember(Session.GetNameFromDN(PChar(SelItem.Data)));
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
    idx := Selected.Index;
    dn := PChar(Selected.Data);
    Selected.Delete;
    Group.RemoveMember(Session.GetNameFromDN(dn));
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

procedure TGroupDlg.edDescriptionChange(Sender: TObject);
begin
  OkBtn.Enabled := true;
end;

procedure TGroupDlg.edNameChange(Sender: TObject);
begin
  OkBtn.Enabled := edName.Text <> '';
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
    EnableResButtons(true);
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
      EnableResButtons(false);
  end;
end;

procedure TGroupDlg.ResourceListClick(Sender: TObject);
begin
  EnableResButtons(true);
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

procedure TGroupDlg.PageControl1Change(Sender: TObject);
var
  i: Integer;
begin
  if not Assigned(DomList) then
  try
    DomList := TDomainList.Create(Session);
    with cbSambaDomain do
    begin
      if (Group is TSamba3Group) and (EditMode = EM_MODIFY) then
      begin
        if RadioGroup1.ItemIndex = 2 then
          EnableControls([cbBuiltin], clWindow, false);
        i := DomList.Count - 1;
        while (i >= 0) do begin
          if (Group as TSamba3Group).DomainSid = DomList.Items[i].SID then
          begin
            Items.Add(DomList.Items[i].DomainName);
            ItemIndex := 0;
            break;
          end;
          dec(i);
        end;
        cbSambaGroup.Checked := true;
      end
      else
      begin
        EnableControls([edDisplayName, cbSambaDomain, edRid, RadioGroup1, cbBuiltin], clBtnFace, false);
        cbSambaGroup.Enabled := DomList.Count > 0;
        for i := 0 to DomList.Count - 1 do
          Items.Add(DomList.Items[i].DomainName);
        ItemIndex := Items.IndexOf(RegAccount.SambaDomainName);
      end;
    end;
  except
  // TODO
  end;
end;

procedure TGroupDlg.cbSambaDomainChange(Sender: TObject);
var
  AlgRidBase: Integer;
begin
  if (Group.gidNumber <> 0) and (cbSambaDomain.ItemIndex <> -1) then
  begin
    if cbBuiltin.ItemIndex = -1 then
    begin
      AlgRidBase := DomList.Items[cbSambaDomain.ItemIndex].AlgorithmicRIDBase + 1;
      edRid.Text := IntToStr(2 * Group.gidNumber + AlgRidBase);
    end;
  end
  else
    edRid.Text := '';
end;

procedure TGroupDlg.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 2 then
  begin
    EnableControls([cbBuiltin], clWindow, true);
    EnableControls([edRid], clWindow, false);
    cbBuiltin.ItemIndex := 0;
    cbBuiltinChange(nil);
  end
  else begin
    EnableControls([cbBuiltin], clBtnFace, false);
    EnableControls([edRid], clWindow, true);
    cbBuiltin.ItemIndex := -1;
    cbSambaDomainChange(nil); // Refresh RID
  end;

end;

procedure TGroupDlg.cbBuiltinChange(Sender: TObject);
begin
  if cbBuiltin.ItemIndex <> -1 then
    edRid.Text := IntToStr(WKRids[cbBuiltin.ItemIndex + 2]);
end;

function TGroupDlg.GroupType: Integer;
begin
  case RadioGroup1.ItemIndex of
    1: Result := 4;
    2: Result := 5;
  else
    Result := 2;
  end;
end;

procedure TGroupDlg.cbSambaGroupClick(Sender: TObject);
var
  Color: TColor;
  Enable: Boolean;
begin
  if cbSambaGroup.Checked then
  begin
    Color := clWindow;
    Enable := not IsSambaGroup;
  end
  else begin
    Color := clBtnFace;
    Enable := false;
  end;
  EnableControls([edDisplayName, cbSambaDomain, edRid, RadioGroup1], Color, Enable);
  if RadioGroup1.ItemIndex = 2 then
    cbBuiltin.Color := Color;
  if not (Group is TSamba3Group) then
  begin
    edDisplayName.Text := Group.Cn;
    cbSambaDomainChange(nil); // Refresh Rid
  end;
end;
        
end.
