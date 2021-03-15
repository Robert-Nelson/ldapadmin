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
  ComCtrls, Menus, ImgList, ToolWin, WinLdap, StdCtrls, ExtCtrls, Posix, Samba,
  LDAPClasses, RegAccnt;

const
  bmRoot           =  0;
  bmRootSel        =  1;
  bmEntry          =  2;
  bmEntrySel       =  3;
  bmPosixUser      =  4;
  bmPosixUserSel   =  4;
  bmSamba3User     =  5;
  bmSamba3UserSel  =  5;
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
  bmSamba2User     = 19;
  bmSamba2UserSel  = 19;
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
    N9: TMenuItem;
    mbPreferences: TMenuItem;
    pbCopy: TMenuItem;
    mbCopy: TMenuItem;
    mbMove: TMenuItem;
    pbMove: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
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
    procedure mbPreferencesClick(Sender: TObject);
    procedure mbInfoClick(Sender: TObject);
    procedure mbCopyClick(Sender: TObject);
    procedure mbMoveClick(Sender: TObject);
    procedure LDAPTreeEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
  private
    Root: TTreeNode;
    regAccount: TAccountEntry;
    ldapSession: TLDAPSession;
    procedure ExpandNode(Node: TTreeNode);
    procedure RefreshTree;
  public
    function PickEntry(const ACaption: string): string;
  end;

var
  MainFrm: TMainFrm;

implementation

uses EditEntry, Group, User, Computer, PassDlg, ConnList, Transport, Search, Ou,
     LdapOp, Constant, Export, Prefs, About;

{$R *.DFM}

function CustomSortProc(Node1, Node2: TTreeNode; Data: Integer): Integer; stdcall;
var
  n1, n2: Integer;
begin
  n1 := Node1.ImageIndex;
  n2 := Node2.ImageIndex;
  if ((n1 = bmOu) and (n2 <> bmOu)) then
    Result := -1
  else
  if ((n2 = bmOu) and (n1 <> bmOu))then
    Result := 1
  else
    Result := AnsiStrIComp(PChar(Node1.Text), PChar(Node2.Text));
end;

function TMainFrm.PickEntry(const ACaption: string): string;
var
  DirDlg: TForm;
  ddTree: TTreeView;
  ddPanel:TPanel;
  ddOkBtn: TButton;
  ddCancelBtn: TButton;
  ddRoot: TTreeNode;
begin

  DirDlg := TForm.Create(Self);

  ddTree := TTreeView.Create(DirDlg);
  ddTree.Parent := DirDlg;
  ddTree.Align := alClient;
  ddTree.Images := ImageList;
  ddTree.ReadOnly := true;
  ddTree.OnExpanding := LDAPTreeExpanding;
  ddTree.OnDeletion := LDapTreeDeletion;

  ddPanel := TPanel.Create(DirDlg);
  ddPanel.Parent := DirDlg;
  ddPanel.Align := alBottom;
  ddPanel.Height := 34;

  ddOkBtn := TButton.Create(DirDlg);
  ddOkBtn.Parent := ddPanel;
  ddOkBtn.Top := 4;
  ddOkBtn.Left := 4;
  ddOkBtn.ModalResult := mrOk;
  ddOkBtn.Caption := '&OK';

  ddCancelBtn := TButton.Create(DirDlg);
  ddCancelBtn.Parent := ddPanel;
  ddCancelBtn.Top := 4;
  ddCancelBtn.Left := ddOkBtn.Width + 8;
  ddCancelBtn.ModalResult := mrCancel;
  ddCancelBtn.Caption := '&Cancel';


  with DirDlg do
  try
    Caption := ACaption;
    Position := poMainFormCenter;
    ddRoot := ddTree.Items.Add(nil, ldapSession.Base);
    ddRoot.Data := Pointer(StrNew(PChar(ldapSession.Base)));
    ExpandNode(ddRoot);
    ddRoot.ImageIndex := bmRoot;
    ddRoot.SelectedIndex := bmRootSel;
    //ddTree.Alphasort;
    ddTree.CustomSort(@CustomSortProc, 0);
    ddRoot.Expand(false);
    if (ShowModal = mrOk) and Assigned(ddTree.Selected) then
      Result := PChar(ddTree.Selected.Data)
    else
      Result := '';
  finally
    ddTree.Free;
  end;

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

  pld := ldapSession.pld;

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
        rdn := ldapSession.GetRdn(pszdn);
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
              if CNode.ImageIndex = bmEntry then // if not yet assigned to Samba account
              begin
                CNode.ImageIndex := bmPosixUser;
                CNode.SelectedIndex := bmPosixUserSel;
                Container := false;
              end;
            end
            else if (s = 'sambaaccount') or (s = 'sambasamaccount') then
            begin
              if rdn[Length(rdn)] = '$' then // it's samba computer account
              begin
                CNode.ImageIndex := bmComputer;
                CNode.SelectedIndex := bmComputerSel;
              end
              else begin // it's samba user account
                if (s = 'sambaaccount') then
                begin
                  CNode.ImageIndex := bmSamba2User;
                  CNode.SelectedIndex := bmSamba2UserSel;
                end
                else begin
                  CNode.ImageIndex := bmSamba3User;
                  CNode.SelectedIndex := bmSamba3UserSel;
                end;
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
    Root := LDAPTree.Items.Add(nil, ldapSession.Base);
    Root.Data := Pointer(StrNew(PChar(ldapSession.Base)));
    ExpandNode(Root);

    Root.ImageIndex := bmRoot;
    Root.SelectedIndex := bmRootSel;

    LDAPTree.CustomSort(@CustomSortProc, 0);
    //LDAPTree.Alphasort;

  finally
    LDAPTree.Items.EndUpdate;
  end;
  Root.Expand(false);

end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  ldapSession := TLDAPSession.Create;
end;

procedure TMainFrm.mbConnectClick(Sender: TObject);
begin

  with TConnListFrm.Create(Self, regAccount) do
  begin
    if ShowModal = mrOk then
    try
      Screen.Cursor := crHourGlass;
      with ldapSession do
      begin
        Server := regAccount.ldapServer;
        Base := regAccount.ldapBase;
        User := regAccount.ldapUser;
        Password := regAccount.ldapPassword;
        SSL := regAccount.ldapUseSSL;
        Port := regAccount.ldapPort;
        Version := regAccount.ldapVersion;
        Connect;
      end;
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
  ldapSession.Disconnect;
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
  ldapSession.Disconnect;
end;

procedure TMainFrm.LDAPTreeExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if (Node.Count > 0) and (Integer(Node.Item[0].Data) = ncDummyNode) then
  with (Sender as TTreeView) do
  try
    Items.BeginUpdate;
    Node.Item[0].Delete;
    ExpandNode(Node);
    //Alphasort;
    CustomSort(@CustomSortProc, 0);
  finally
    Items.EndUpdate;
  end;
end;

procedure TMainFrm.LDAPTreeDeletion(Sender: TObject; Node: TTreeNode);
begin
  if (Node.Data <> nil) and (Integer(Node.Data) <> ncDummyNode) then
    StrDispose(Node.Data);
end;

procedure TMainFrm.LDAPTreeChange(Sender: TObject; Node: TTreeNode);
var
  Entry: TLDAPEntry;
  i: Integer;
  ListItem: TListItem;
begin

    Entry := TLDAPEntry.Create(ldapSession, PChar(LDAPTree.Selected.Data));

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
    1: TEditEntryFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).Show;
    2: TUserDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_ADD).ShowModal;
    3: TComputerDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_ADD).ShowModal;
    4: TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_ADD).ShowModal;
    //5: TMailGroupDlg
    6: TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    7: TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
  else
    Exit;
  end;
  pbRefreshClick(nil);
end;

procedure TMainFrm.pbDeleteClick(Sender: TObject);
begin
  if Assigned(LdapTree.Selected) and (
     MessageDlg(Format(stConfirmDel, [PChar(LdapTree.Selected.Data)]), mtConfirmation,
                                     [mbYes, mbNo], 0) = mrYes) then
  with TLdapOpDlg.Create(Self, ldapSession) do
  try
    try
      DeleteTree(PChar(LDAPTree.Selected.Data));
      LdapTree.Selected.Delete;
    except
      pbRefreshClick(nil);
    end;
  finally
    Free;
  end;
end;

procedure TMainFrm.pbRefreshClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
  try
    LdapTree.Items.BeginUpdate;
    LdapTree.Selected.DeleteChildren;
    ExpandNode(LDAPTree.Selected);
    LDAPTree.Selected.Expand(false);
    //LDAPTree.Alphasort;
    LDAPTree.CustomSort(@CustomSortProc, 0);
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
  Account: TPosixAccount;
begin
  with TPasswordDlg.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      case LDAPTree.Selected.ImageIndex of
        bmSamba2User: Account := TSambaAccount.Create(ldapSession, PChar(LDAPTree.Selected.Data));
        bmSamba3User: Account := TSamba3Account.Create(ldapSession, PChar(LDAPTree.Selected.Data));
        bmPosixUser: Account := TPosixAccount.Create(ldapSession, PChar(LDAPTree.Selected.Data));
      else
        Abort;
      end;
      try
        Account.Read;
        Account.UserPassword := Password.Text;
        Account.Modify;
      finally
        Account.Destroy;
      end;
    end;
  finally
    Destroy;
  end;
end;


procedure TMainFrm.pbEditClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
    TEditEntryFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).Show
end;

procedure TMainFrm.pbPropertiesClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
  begin
    case LDAPTree.Selected.ImageIndex of
      bmSamba2User,
      bmSamba3User,
      bmPosixUser: TUserDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmGroup:     TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmComputer:  TComputerDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmTransport: TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).ShowModal;
      bmOu:        TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).ShowModal;
    end;
    LDAPTreeChange(nil, LDAPTree.Selected);
  end;
end;

procedure TMainFrm.LDAPTreeDblClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) and (LDAPTree.Selected.ImageIndex <> bmOu) then
    pbPropertiesClick(Sender)
end;

procedure TMainFrm.pbSearchClick(Sender: TObject);
begin
  TSearchFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession).Show;
end;

procedure TMainFrm.mbExportClick(Sender: TObject);
begin
  TExportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession).ShowModal;
end;

procedure TMainFrm.mbPreferencesClick(Sender: TObject);
begin
  TPrefDlg.Create(Self, regAccount, ldapSession).ShowModal;
end;

procedure TMainFrm.mbInfoClick(Sender: TObject);
begin
  TAboutDlg.Create(Self).ShowModal;
end;

procedure TMainFrm.mbCopyClick(Sender: TObject);
var
  pdn: string;
begin
  if Assigned(LDAPTree.Selected.Data) then
  begin
    pdn := PickEntry(Format(cCopyTo, [ldapSession.GetNameFromDN(PChar(LDAPTree.Selected.Data))]));
    if (pdn <> '') then
    with TLdapOpDlg.Create(Self, ldapSession) do
    try
      CopyTree(PChar(LDAPTree.Selected.Data),pdn, '');
    finally
      Free;
    end;
  end;
end;

procedure TMainFrm.mbMoveClick(Sender: TObject);
var
  pdn: string;
begin
  if Assigned(LDAPTree.Selected.Data) then
  begin
    pdn := PickEntry(Format(cMoveTo, [ldapSession.GetNameFromDN(PChar(LDAPTree.Selected.Data))]));
    if (pdn <> '') then
    with TLdapOpDlg.Create(Self, ldapSession) do
    try
     MoveTree(PChar(LDAPTree.Selected.Data),pdn, '');
     LdapTree.Selected.Delete;
    finally
      Free;
    end;
  end;
end;

procedure TMainFrm.LDAPTreeEdited(Sender: TObject; Node: TTreeNode; var S: String);
var
  pdn: string;
begin
  with TLdapOpDlg.Create(Self, ldapSession) do
  try
    pdn := ldapSession.GetDirFromDN(PChar(LDAPTree.Selected.Data));
    MoveTree(PChar(LDAPTree.Selected.Data), pdn, S);
    StrDispose(LdapTree.Selected.Data);
    LdapTree.Selected.Data := Pointer(StrNew(PChar(S + ',' + pdn)));
    pbRefreshClick(nil);
  finally
    Free;
  end;
end;

end.
