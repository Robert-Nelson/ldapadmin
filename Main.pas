  {      LDAPAdmin - Main.pas
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

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, ToolWin, WinLdap, StdCtrls, ExtCtrls, LDAPClasses;

const
  bmRoot           =  0;
  bmRootSel        =  1;
  bmEntry          =  2;
  bmEntrySel       =  3;
  bmPosixUser      =  4;
  bmPosixUserSel   =  4;
  bmUser           =  5;
  bmUserSel        =  5;
  bmGroup          =  6;
  bmGroupSel       =  6;
  bmComputer       =  7;
  bmComputerSel    =  7;
  bmMailGroup      =  9;
  bmMailGroupSel   =  9;
  bmOu             = 13;
  bmOuSel          = 13;
  bmTransport      = 15;
  bmTransportSel   = 15;
  ncDummyNode      = -1;


type
  TMainFrm = class(TForm)
    ToolBar: TToolBar;
    ConnectBtn: TToolButton;
    ToolButton6: TToolButton;
    PropertiesBtn: TToolButton;
    DeleteBtn: TToolButton;
    ToolButton2: TToolButton;
    EditBtn: TToolButton;
    RefreshBtn: TToolButton;
    ExitBtn: TToolButton;
    ImageList: TImageList;
    LDAPTree: TTreeView;
    MainMenu: TMainMenu;
    mbStart: TMenuItem;
    StatusBar1: TStatusBar;
    mbConnect: TMenuItem;
    mbDisconnect: TMenuItem;
    N1: TMenuItem;
    mbExit: TMenuItem;
    Splitter1: TSplitter;
    ListView: TListView;
    mbEdit: TMenuItem;
    mbNew: TMenuItem;
    PopupMenu: TPopupMenu;
    pbNew: TMenuItem;
    pbNewEntry: TMenuItem;
    pbNewUser: TMenuItem;
    pbNewGroup: TMenuItem;
    pbNewVerteiler: TMenuItem;
    pbNewTransporttable: TMenuItem;
    pbEdit: TMenuItem;
    pbDelete: TMenuItem;
    N2: TMenuItem;
    pbRefresh: TMenuItem;
    N3: TMenuItem;
    pbChangePassword: TMenuItem;
    DisconnectBtn: TToolButton;
    pbNewComputer: TMenuItem;
    mbNewEntry: TMenuItem;
    mbNewUser: TMenuItem;
    mbNewComputer: TMenuItem;
    mbNewGroup: TMenuItem;
    mbNewVerteiler: TMenuItem;
    mbNewTransporttable: TMenuItem;
    mbEditEntry: TMenuItem;
    mbDeleteEntry: TMenuItem;
    N4: TMenuItem;
    mbRefresh: TMenuItem;
    pbProperties: TMenuItem;
    mbProperties: TMenuItem;
    N5: TMenuItem;
    mbSetpass: TMenuItem;
    N6: TMenuItem;
    pbSearch: TMenuItem;
    pbNewOu: TMenuItem;
    mbTools: TMenuItem;
    mbExport: TMenuItem;
    mbImport: TMenuItem;
    N7: TMenuItem;
    mbSearch: TMenuItem;
    Organizationalunit1: TMenuItem;
    N8: TMenuItem;
    mbInfo: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mbConnectClick(Sender: TObject);
    procedure mbDisconnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LDAPTreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure LDAPTreeDeletion(Sender: TObject; Node: TTreeNode);
    procedure LDAPTreeChange(Sender: TObject; Node: TTreeNode);
    procedure pbNewClick(Sender: TObject);
    procedure pbDeleteClick(Sender: TObject);
    procedure pbRefreshClick(Sender: TObject);
    procedure mbExitClick(Sender: TObject);
    procedure LDAPTreeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure pbChangePasswordClick(Sender: TObject);
    procedure pbEditClick(Sender: TObject);
    procedure pbPropertiesClick(Sender: TObject);
    procedure pbSearchClick(Sender: TObject);
    procedure LDAPTreeDblClick(Sender: TObject);
    procedure mbExportClick(Sender: TObject);
  private
    Root: TTreeNode;
    lSession: TLDAPSession;
    function GetRdn(dn: string): string;
    procedure ExpandNode(Node: TTreeNode);
    procedure RefreshTree;
  public
    {}
  end;

var
  MainFrm: TMainFrm;

implementation

uses EditEntry, Group, User, Computer, PassDlg, ConnList, Transport, Search, Ou,
     Constant, Export;

{$R *.DFM}

function CustomSortProc(Node1, Node2: TTreeNode; Data: Integer): Integer; stdcall;
begin
  if (Node1.ImageIndex <> Node2.ImageIndex) then
    Result := -1
  else
    Result := AnsiStrIComp(PChar(Node1.Text), PChar(Node2.Text));
    //Result := AnsiStrIComp(PChar(Copy(Node1.Text, Pos('=', Node1.Text), 32275)), PChar(Copy(Node2.Text, Pos('=', Node2.Text), 32275)));
end;

function TMainFrm.GetRdn(dn: string): string;
var
  p: Integer;
begin
  p := Pos(',', dn);
  if p > 0 then
    Result := Copy(dn, 1, p - 1)
  else
    Result := dn;
end;

procedure TMainFrm.ExpandNode(Node: TTreeNode);
var
  CNode: TTreeNode;
  plmSearch, plmEntry: PLDAPMessage;
  ppcVals: PPChar;
  attrs: PCharArray;
  pszdn: PChar;
  s, rdn: string;
  Container: boolean;
  I: Integer;
  pld: PLDAP;

begin

  pld := lSession.pld;

  // set result to objectclass only
  SetLength(attrs, 2);
  attrs[0] := 'objectclass';
  attrs[1] := nil;
  LdapCheck(ldap_search_s(pld, PChar(Node.Data), LDAP_SCOPE_ONELEVEL, '(objectclass=*)', PChar(attrs), 0, plmSearch));

  try

    plmEntry := ldap_first_entry(pld, plmSearch);

    while Assigned(plmEntry) do begin

      pszdn := ldap_get_dn(pld, plmEntry);

      if Assigned(pszdn) then
      try
        rdn := GetRdn(pszdn);
        CNode := LDAPTree.Items.AddChildObject(Node, rdn, Pointer(StrNew(pszdn)));
        //CNode := LDAPTree.Items.AddChildObject(Node, rdn, TLDAPEntry.Create);

        Container := true;
        CNode.ImageIndex := bmEntry;
        CNode.SelectedIndex := bmEntrySel;

        // Check if this node is any of known node types

        // get objecclass values
        ppcVals := ldap_get_values(pld, plmEntry, 'objectclass');
        if Assigned(ppcVals) then
        try

          I := 0;
          while Assigned(PCharArray(ppcVals)[I]) do
          begin
            s := lowercase(PCharArray(ppcVals)[I]);

            if s = 'organizationalunit' then
            begin
              CNode.ImageIndex := bmOu;
              CNode.SelectedIndex := bmOuSel;
            end
            else if s = 'posixaccount' then
            begin
              if CNode.ImageIndex <> bmUser then // if not yet assigned to SambaUser
              begin
                CNode.ImageIndex := bmPosixUser;
                CNode.SelectedIndex := bmPosixUserSel;
                Container := false;
              end;
            end
            else if s = 'sambaaccount' then
            begin
              if rdn[Length(rdn)] = '$' then // it's samba computer account
              begin
                CNode.ImageIndex := bmComputer;
                CNode.SelectedIndex := bmComputerSel;
              end
              else begin // it's samba user account
                CNode.ImageIndex := bmUser;
                CNode.SelectedIndex := bmUserSel;
              end;
              Container := false;
            end
            else if s = 'mailgroup' then
            begin
              CNode.ImageIndex := bmMailGroup;
              CNode.SelectedIndex := bmMailGroupSel;
              Container := false;
            end
            else if s = 'posixgroup' then
            begin
              CNode.ImageIndex := bmGroup;
              CNode.SelectedIndex := bmGroupSel;
              Container := false;
            end
            else if s = 'transporttable' then
            begin
              CNode.ImageIndex := bmTransport;
              CNode.SelectedIndex := bmTransport;
              Container := false;
            end;


            Inc(I);
          end;

        { Add dummy node to make node expandable }
        if Container then
           LDAPTree.Items.AddChildObject(CNode, '', Pointer(ncDummyNode));


        finally
          LDAPCheck(ldap_value_free(ppcVals));
        end;

      finally
        ldap_memfree(pszdn);
      end;

      plmEntry := ldap_next_entry(pld, plmEntry);

    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;

end;

procedure TMainFrm.RefreshTree;
begin

  LDAPTree.Items.BeginUpdate;
  try
    LDAPTree.Items.Clear;
    Root := LDAPTree.Items.Add(nil, lSession.Base);
    Root.Data := Pointer(StrNew(PChar(lSession.Base)));
    ExpandNode(Root);

    Root.ImageIndex := bmRoot;
    Root.SelectedIndex := bmRootSel;

    //LDAPTree.CustomSort(@CustomSortProc, 0);
    LDAPTree.Alphasort;

  finally
    LDAPTree.Items.EndUpdate;
  end;
  Root.Expand(false);

end;



procedure TMainFrm.FormCreate(Sender: TObject);
begin
  // Set deafult values for LDAP conection
  lSession := TLDAPSession.Create;
  {with lSession do begin
    Port := LDAP_PORT;
    SSL := false;
    Version := LDAP_VERSION3;
  end;}
end;

procedure TMainFrm.mbConnectClick(Sender: TObject);
begin

  with TConnListFrm.Create(Self, lSession) do begin
    if ShowModal = mrOk then
    try
      Screen.Cursor := crHourGlass;
      lSession.Connect;
      mbConnect.Enabled := false;
      mbDisconnect.Enabled := true;
      ConnectBtn.Enabled := false;
      DisconnectBtn.Enabled := true;
      mbEdit.Visible := true;
      mbTools.Visible := true;
      LDAPTree.PopupMenu := MainFrm.PopupMenu;
      RefreshTree;
    finally
      Screen.Cursor := crDefault;
      Destroy;
    end;
  end;
end;

procedure TMainFrm.mbDisconnectClick(Sender: TObject);
begin
  lSession.Disconnect;
  mbConnect.Enabled := true;
  mbDisconnect.Enabled := false;
  ConnectBtn.Enabled := true;
  DisconnectBtn.Enabled := false;
  mbEdit.Visible := false;
  mbTools.Visible := false;
  LDAPTree.PopupMenu := nil;
  LDAPTree.Items.BeginUpdate;
  LDAPTree.Items.Clear;
  LDAPTree.Items.EndUpdate;
  ListView.Items.Clear;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  lSession.Disconnect;
end;

procedure TMainFrm.LDAPTreeExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin

  if (Node.Count > 0) and (Integer(Node.Item[0].Data) = ncDummyNode) then
  try
    LDAPTree.Items.BeginUpdate;
    Node.Item[0].Delete;
    ExpandNode(Node);
    //LDAPTree.CustomSort(@CustomSortProc, 0);
    LDAPTree.Alphasort;
  finally
    LDAPTree.Items.EndUpdate;
  end;

end;

procedure TMainFrm.LDAPTreeDeletion(Sender: TObject; Node: TTreeNode);
begin
  if (Node.Data <> nil) and (Integer(Node.Data) <> ncDummyNode) then
    StrDispose(Node.Data);
    //TLDAPEntry(Node.Data).Destroy;
end;

procedure TMainFrm.LDAPTreeChange(Sender: TObject; Node: TTreeNode);
var
  Entry: TLDAPEntry;
  i: Integer;
  ListItem: TListItem;
begin

    Entry := TLDAPEntry.Create(lSession.pld, PChar(LDAPTree.Selected.Data));

    with Entry do
    try
      Read;
      try
        ListView.Items.BeginUpdate;
        ListView.Items.Clear;
        for i := 0 to Items.Count - 1 do
        begin
          ListItem := ListView.Items.Add;
          ListItem.Caption := Items[i];
          ListItem.SubItems.Add(PChar(Items.Objects[i]));
        end;
      finally
        ListView.Items.EndUpdate;
      end;
    finally
      Entry.Free;
    end;

    mbExport.Enabled := LDAPTree.Selected <> nil;

end;

procedure TMainFrm.pbNewClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    1: TEditEntryFrm.Create(Self, PChar(LDAPTree.Selected.Data), lSession.pld, EM_ADD).ShowModal;
    2: TUserDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_ADD).ShowModal;
    3: TComputerDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_ADD).ShowModal;
    4: TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_ADD).ShowModal;
    //5: TMailGroupDlg
    6: TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_ADD).ShowModal;
    7: TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_ADD).ShowModal;
  else
    Exit;
  end;
  pbRefreshClick(nil);
end;

procedure TMainFrm.pbDeleteClick(Sender: TObject);

  // Remove any references to uid from groups before deleting user itself;
  procedure RemoveUserRefs(uid: string);
    var
      plmSearch, plmEntry: PLDAPMessage;
      ppcVals: PPChar;
      pld: PLDAP;
      attrs: PCharArray;
      Entry: TLDAPEntry;
  begin

    pld := lSession.pld;
    SetLength(attrs, 2);
    attrs[0] := 'cn';
    attrs[1] := nil;

    LdapCheck(ldap_search_s(pld, PChar(lSession.Base), LDAP_SCOPE_SUBTREE,
                               PChar(Format(sMY_GROUP,[uid])), PChar(attrs), 0, plmSearch));
    try
      plmEntry := ldap_first_entry(pld, plmSearch);
      while Assigned(plmEntry) do
      begin
        ppcVals := ldap_get_values(pld, plmEntry, attrs[0]);
        if Assigned(ppcVals) then
        begin
          Entry := TLDAPEntry.Create(pld, ldap_get_dn(pld, plmEntry));
          try
            Entry.AddAttr('memberUid', uid, LDAP_MOD_DELETE);
            Entry.Modify;
          finally
            LDAPCheck(ldap_value_free(ppcVals));
            Entry.Free;
          end;
        end;
        plmEntry := ldap_next_entry(pld, plmEntry);
      end;
    finally
      LDAPCheck(ldap_msgfree(plmSearch));
    end;
  end;

begin
  if Assigned(LDAPTree.Selected) then
  begin
    if Application.MessageBox(PChar(Format(stConfirmDel,
        [PChar(LDAPTree.Selected.Data)])), PChar(cConfirmDel), MB_YESNO) = IDYES then
    begin
      if (LDAPTree.Selected.ImageIndex = bmUser) or (LDAPTree.Selected.ImageIndex = bmPosixUser) then
        RemoveUserRefs(lSession.GetNameFromDN(PChar(LDAPTree.Selected.Data)));
      LdapCheck(ldap_delete_s(lSession.pld, PChar(LDAPTree.Selected.Data)));
      LdapTree.Selected.Delete;
    end;
  end;
end;

procedure TMainFrm.pbRefreshClick(Sender: TObject);
begin
  //if PopupComponent = LDAPTree then
  try
    LdapTree.Items.BeginUpdate;
    LdapTree.Selected.DeleteChildren;
    ExpandNode(LDAPTree.Selected);
    LDAPTree.Selected.Expand(false);
    LDAPTree.Alphasort;
  finally
    LdapTree.Items.EndUpdate;
  end;
end;

procedure TMainFrm.mbExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainFrm.LDAPTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node := LDAPTree.GetNodeAt(MousePos.X, MousePos.Y);
  if (Node <> nil) then
    Node.Selected := true;
  { TODO: enable/disable popup menu items based on Assigned(Selected) }
end;

procedure TMainFrm.pbChangePasswordClick(Sender: TObject);
var
  Entry: TLDAPEntry;
begin
  with TPasswordDlg.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      Entry := TLDAPEntry.Create(lSession.pld, PChar(LDAPTree.Selected.Data));
      try
        // TODO: make change password TLDAPEntry method which should determine
        // which fields to update
        case LDAPTree.Selected.ImageIndex of
          bmUser: begin
                    Entry.AddAttr('ntPassword', NTPassword, LDAP_MOD_REPLACE);
                    Entry.AddAttr('lmPassword', lmPassword, LDAP_MOD_REPLACE);
                    Entry.AddAttr('userPassword', MD5Password, LDAP_MOD_REPLACE);
                  end;
          bmPosixUser: Entry.AddAttr('userPassword', MD5Password, LDAP_MOD_REPLACE);
        end;
        Entry.Modify;
      finally
        Entry.Destroy;
      end;
      //ShowMessage(MD5Password);
    end;
  finally
    Destroy;
  end;
end;

procedure TMainFrm.pbEditClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
    TEditEntryFrm.Create(Self, PChar(LDAPTree.Selected.Data), lSession.pld, EM_MODIFY).Show
end;

procedure TMainFrm.pbPropertiesClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
  begin
    case LDAPTree.Selected.ImageIndex of
      bmUser, bmPosixUser: TUserDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_MODIFY).ShowModal;
      bmGroup: TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_MODIFY).ShowModal;
      bmComputer: TComputerDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_MODIFY).ShowModal;
      bmTransport: TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_MODIFY).ShowModal;
      bmOu: TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession, EM_MODIFY).ShowModal;
    end;
    LDAPTreeChange(nil, LDAPTree.Selected);
  end;
end;

procedure TMainFrm.LDAPTreeDblClick(Sender: TObject);
begin
  if LDAPTree.Selected.ImageIndex <> bmOu then
    pbPropertiesClick(Sender)
end;

procedure TMainFrm.pbSearchClick(Sender: TObject);
begin
  TSearchFrm.Create(Self, PChar(LDAPTree.Selected.Data), lSession).Show;
end;

procedure TMainFrm.mbExportClick(Sender: TObject);
begin
  TExportDlg.Create(Self, PChar(LDAPTree.Selected.Data), lSession.pld).ShowModal;
end;

end.
