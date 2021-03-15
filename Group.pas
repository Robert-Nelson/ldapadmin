  {      LDAPAdmin - Group.pas
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

unit Group;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Samba, Posix, LDAPClasses, RegAccnt, Constant;

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
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure cbSambaDomainChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure cbBuiltinChange(Sender: TObject);
    procedure cbSambaGroupClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
    procedure edDisplayNameChange(Sender: TObject);
    procedure edRidChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ParentDn: string;
    Session: TLDAPSession;
    RegAccount: TAccountEntry;
    Entry: TLdapEntry;
    PosixGroup: TPosixGroup;
    SambaGroup: TSamba3Group;
    IsSambaGroup: Boolean;
    ColumnToSort: Integer;
    Descending: Boolean;
    DomList: TDomainList;
    procedure EnableControls(const Controls: array of TControl; Color: TColor; Enable: Boolean);
    procedure Load;
    function FindDataString(dstr: PChar): Boolean;
    procedure Save;
    function GetGroupType: Integer;
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

{ Note: Item.Caption = uid, Item.Data = dn }
procedure TGroupDlg.Load;
var
  ListItem: TListItem;
  i: Integer;
begin
  Entry.Read;
  edName.Text := PosixGroup.Cn;
  edDescription.Text := PosixGroup.Description;
  for i := 0 to PosixGroup.MembersCount - 1 do
  begin
    ListItem := UserList.Items.Add;
    ListItem.Caption := PosixGroup.Members[i];
    //ListItem.Data := StrNew(PChar(GetDirectory(Format(sACCNTBYUID, [PCharArray(ppcVals)[I]]))));
    ListItem.Data := StrNew(PChar(Session.GetDN(Format(sACCNTBYUID, [PosixGroup.Members[i]]))));
    ListItem.SubItems.Add(CanonicalName(GetDirFromDN(PChar(ListItem.Data))));
  end;
  if UserList.Items.Count > 0 then
    RemoveUserBtn.Enabled := true;
  IsSambaGroup := Entry.AttributesByName['objectclass'].IndexOf('sambagroupmapping') <> -1;
end;

constructor TGroupDlg.Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode);
var
  n: Integer;
begin
  inherited Create(AOwner);
  ParentDn := dn;
  Self.Session := Session;
  Self.RegAccount := RegAccount;
  Entry := TLdapEntry.Create(Session, dn);
  PosixGroup := TPosixGroup.Create(Entry);
  if Mode = EM_MODIFY then
  begin
    Load;
    if IsSambaGroup then
    begin
      //SambaGroup := TSamba3Group.Create(Entry); -> happens in cbSambaGroupOnCheck
      cbSambaGroup.Checked := true;
      with RadioGroup1 do
      case SambaGroup.GroupType of
        2: ItemIndex := 0;
        4: ItemIndex := 1;
        5: begin
             ItemIndex := 2;
             n := StrToInt(SambaGroup.Rid) - 512;
             if (n >=0) and (n < cbBuiltin.Items.Count) then
               cbBuiltin.ItemIndex := n
             else
               cbBuiltin.ItemIndex := -1;
           end;
      end;
      edRid.Text := SambaGroup.Rid;
      edRid.Enabled := false;
      edDisplayName.Text := SambaGroup.DisplayName;
    end;
    edName.Enabled := false;
    Caption := Format(cPropertiesOf, [edName.Text]);
    UserList.AlphaSort;
  end
  else
    PosixGroup.New;
end;

procedure TGroupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    Save;
  Action := caFree;
end;

procedure TGroupDlg.Save;
begin
  if edName.Text = '' then //TODO: Need this?
    raise Exception.Create(stGroupNameReq);
  if cbSambaGroup.Checked and Assigned(DomList) and (cbSambaDomain.ItemIndex = -1) then
    raise Exception.Create(Format(stReqNoEmpty, [cSambaDomain]));
  if esNew in Entry.State then
  begin
    PosixGroup.GidNumber := Session.GetFreeGidNumber(RegAccount.posixFirstGid, RegAccount.posixLastGID);
    edRidChange(nil);  // Update sambaSid
  end;
  Entry.Write;
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
          UserItem.SubItems.Add(CanonicalName(GetDirFromDN(PChar(SelItem.Data))));
          PosixGroup.AddMember(GetNameFromDN(PChar(SelItem.Data)));
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
    PosixGroup.RemoveMember(GetNameFromDN(dn));
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
      if Assigned(SambaGroup) and not (esNew in Entry.State) then
      begin
        if RadioGroup1.ItemIndex = 2 then
          EnableControls([cbBuiltin], clWindow, false);
        i := DomList.Count - 1;
        while (i >= 0) do begin
          if SambaGroup.DomainSid = DomList.Items[i].SID then
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
  if (PosixGroup.gidNumber <> 0) and (cbSambaDomain.ItemIndex <> -1) then
  begin
    RadioGroup1.Enabled := true;
    if cbBuiltin.ItemIndex = -1 then
    begin
      AlgRidBase := DomList.Items[cbSambaDomain.ItemIndex].AlgorithmicRIDBase + 1;
      edRid.Text := IntToStr(2 * PosixGroup.gidNumber + AlgRidBase);
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
  SambaGroup.GroupType := GetGroupType;
end;

procedure TGroupDlg.cbBuiltinChange(Sender: TObject);
begin
  if cbBuiltin.ItemIndex <> -1 then
    edRid.Text := IntToStr(WKRids[cbBuiltin.ItemIndex + 2]);
end;

function TGroupDlg.GetGroupType: Integer;
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
    SambaGroup := TSamba3Group.Create(Entry);
    if not SambaGroup.Activated then
      SambaGroup.New;
    Color := clWindow;
    Enable := not IsSambaGroup;
  end
  else begin
    RadioGroup1.ItemIndex := 0;
    SambaGroup.Remove;
    IsSambaGroup := false;
    FreeAndNil(SambaGroup);
    cbSambaDomain.ItemIndex := -1;
    edDisplayName.Text := '';
    edRid.Text := '';
    Color := clBtnFace;
    Enable := false;
  end;
  RadioGroup1.Enabled := false;
  EnableControls([edDisplayName, cbSambaDomain, edRid], Color, Enable);
  if RadioGroup1.ItemIndex = 2 then
    cbBuiltin.Color := Color;
  if Assigned(SambaGroup) then
  begin
    if edDisplayName.Text = '' then
      edDisplayName.Text := PosixGroup.Cn;
    cbSambaDomainChange(nil); // Refresh Rid
  end;
end;

procedure TGroupDlg.edNameChange(Sender: TObject);
begin
  if esNew in Entry.State then
    Entry.Dn := 'cn=' + edName.Text + ',' + ParentDn;
  PosixGroup.Cn := edName.Text;
  OkBtn.Enabled := edName.Text <> '';
end;

procedure TGroupDlg.edDescriptionChange(Sender: TObject);
begin
  PosixGroup.Description := edDescription.Text;
  OkBtn.Enabled := edName.Text <> '';
end;

procedure TGroupDlg.edDisplayNameChange(Sender: TObject);
begin
  if Assigned(SambaGroup) then
  begin
    SambaGroup.DisplayName := edDisplayName.Text;
    OkBtn.Enabled := edName.Text <> '';
  end;
end;

procedure TGroupDlg.edRidChange(Sender: TObject);
var
  arid: string;
begin
  if Assigned(SambaGroup) and Assigned(DomList) then
  begin
    arid := edRid.Text;
    if arid = '' then
      arid := IntToStr(2 * PosixGroup.gidNumber + DomList.Items[cbSambaDomain.ItemIndex].AlgorithmicRIDBase + 1);
    SambaGroup.Sid := Format('%s-%s', [DomList.Items[cbSambaDomain.ItemIndex].SID, arid]);
    OkBtn.Enabled := edName.Text <> '';
  end;
end;

procedure TGroupDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
