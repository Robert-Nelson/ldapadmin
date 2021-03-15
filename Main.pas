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
  ScrollAccMargin  = 40;

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
    mbNewOu: TMenuItem;
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
    mbNewHost: TMenuItem;
    mbNewLocality: TMenuItem;
    Host1: TMenuItem;
    pbLocality: TMenuItem;
    ScrollTimer: TTimer;
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
    procedure mbCopyMoveClick(Sender: TObject);
    //procedure mbMoveClick(Sender: TObject);
    procedure LDAPTreeEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure mbImportClick(Sender: TObject);
    procedure LDAPTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LDAPTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LDAPTreeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure LDAPTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ScrollTimerTimer(Sender: TObject);
  private
    Root: TTreeNode;
    regAccount: TAccountEntry;
    ldapSession: TLDAPSession;
    procedure ExpandNode(Node: TTreeNode; Session: TLDAPSession);
    procedure RefreshTree;
  public
    function PickEntry(const ACaption: string): string;
    function LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
  end;

var
  MainFrm: TMainFrm;

implementation

uses EditEntry, Group, User, Computer, PassDlg, ConnList, Transport, Search, Ou,
     Host, Locality, LdapOp, Constant, Export, Import, Mailgroup, Prefs,
     LdapCopy, About;

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
    ExpandNode(ddRoot, ldapSession);
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

function TMainFrm.LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
var
  sdn: string;
  comp: PPChar;
  i: Integer;
  Parent: TTreeNode;
begin
  Result := nil;
  sdn := System.Copy(dn, 1, Length(dn) - Length(LdapSession.Base));
  comp := ldap_explode_dn(PChar(sdn), 0);
  try
    if Assigned(comp) then
    begin
      Parent := Root;
      Parent.Expand(false);
      i := 0;
      while PCharArray(comp)[i] <> nil do inc(i);
      while (i > 0) do
      begin
        dec(i);
        Result := Parent.GetFirstChild;
        while Assigned(Result) do
        begin
          if AnsiStrIComp(PChar(Result.Text), PCharArray(comp)[i]) = 0 then
          begin
            Parent := Result;
            Result.Expand(false);
            break;
          end;
          Result := LDAPTree.Selected.GetNextChild(Result);
        end;
      end;
    end;
    if Select then
      Result.Selected := true;
  finally
    ldap_value_free(comp);
  end;
end;

procedure TMainFrm.ExpandNode(Node: TTreeNode; Session: TLDAPSession);
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

  pld := Session.pld;

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
        rdn := Session.GetRdn(pszdn);
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
            end
            else if s = 'sudorole' then
            begin
              CNode.ImageIndex := bmSudoer;
              CNode.SelectedIndex := bmSudoerSel;
              Container := false;
            end
            else if s = 'iphost' then
            begin
              CNode.ImageIndex := bmHost;
              CNode.SelectedIndex := bmHostSel;
              Container := false;
            end
            else if s = 'locality' then
            begin
              CNode.ImageIndex := bmLocality;
              CNode.SelectedIndex := bmLocalitySel;
            end
            else if s = 'sambadomain' then
            begin
              CNode.ImageIndex := bmSambaDomain;
              CNode.SelectedIndex := bmSambaDomainSel;
              Container := false;
            end
            else if s = 'sambaunixidpool' then
            begin
              CNode.ImageIndex := bmIdPool;
              CNode.SelectedIndex := bmIdPoolSel;
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
    Root := LDAPTree.Items.Add(nil, Format('%s [%s]', [ldapSession.Base, ldapSession.Server]));
    Root.Data := Pointer(StrNew(PChar(ldapSession.Base)));
    ExpandNode(Root, ldapSession);

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
      MainFrm.Caption := cAppName + ': ' + ListView.Selected.Caption;
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
  MainFrm.Caption := cAppName;
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
    ExpandNode(Node, ldapSession);
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
    5: TMailGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_ADD).ShowModal;
    6: TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    7: TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    8: THostDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    9: TLocalityDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
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
      raise;
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
    ExpandNode(LDAPTree.Selected, ldapSession);
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
      bmPosixUser:   TUserDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmGroup:       TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmMailGroup:   TMailGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmComputer:    TComputerDlg.Create(Self, PChar(LDAPTree.Selected.Data), regAccount, ldapSession, EM_MODIFY).ShowModal;
      bmTransport:   TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).ShowModal;
      bmOu:          TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).ShowModal;
      bmLocality:    TLocalityDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).ShowModal;
      bmHost:        THostDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).ShowModal;
    end;
    LDAPTreeChange(nil, LDAPTree.Selected);
  end;
end;

procedure TMainFrm.LDAPTreeDblClick(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) and
     (LDAPTree.Selected.ImageIndex <> bmOu) and (LDAPTree.Selected.ImageIndex <> bmLocality) then
    pbPropertiesClick(Sender)
end;

procedure TMainFrm.pbSearchClick(Sender: TObject);
begin
  if LDAPTree.Selected = nil then LDAPTree.Selected := LDAPTree.TopItem;
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

procedure TMainFrm.mbCopyMoveClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  if Assigned(LDAPTree.Selected.Data) then
  begin
    with TCopyDlg.Create(Self, PChar(LDAPTree.Selected.Data), RegAccount.Name, ldapSession, ImageList, ExpandNode, @CustomSortProc) do
    try
      Caption := Format(cCopyTo, [PChar(LDAPTree.Selected.Data)]);
      ShowModal;
      if ModalResult = mrOk then with TLdapOpDlg.Create(Self, ldapSession) do
      try
        DestSession := TargetSession;
        if (Sender = pbCopy) or (Sender = mbCopy) then
          CopyTree(PChar(LDAPTree.Selected.Data),TargetDn, TargetRdn)
        else
        begin
          MoveTree(PChar(LDAPTree.Selected.Data),TargetDn, TargetRdn);
          LDAPTree.Selected.Delete;
        end;
        if TargetSession = ldapSession then
        begin
          Node := LocateEntry(TargetDn, false);
          if Assigned(Node) then
          begin
            LDAPTree.Items.BeginUpdate;
            try
              Node.DeleteChildren;
              ExpandNode(Node, ldapSession);
              Node.Expand(false);
              LDAPTree.CustomSort(@CustomSortProc, 0);
            finally
              LDAPTree.Items.EndUpdate;
            end;
          end;
        end;
      finally
        Free;
      end;
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

procedure TMainFrm.mbImportClick(Sender: TObject);
begin
  TImportDlg.Create(Self, ldapSession).ShowModal;
end;

procedure TMainFrm.LDAPTreeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Accept and (LDAPTree.DropTarget = LDAPTree.GetNodeAt(X, Y)) and
    (LDAPTree.DropTarget <> LDAPTree.Selected) and
    (LDAPTree.DropTarget.ImageIndex in [bmOu, bmLocality, bmEntry, bmRoot]) and
    (Pos(PChar(LDAPTree.Selected.Data),PChar(LDAPTree.DropTarget.Data)) = 0);
end;

procedure TMainFrm.LDAPTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  msg: String;
  cpy: boolean;
begin
  cpy := GetKeyState(VK_CONTROL) < 0;
  if cpy then
    msg := stAskTreeCopy
  else
    msg := stAskTreeMove;

  if Assigned(LDAPTree.Selected.Data) and Assigned(LDAPTree.DropTarget.Data) and
    (MessageDlg(Format(msg, [LDAPTree.Selected.Text, LDAPTree.DropTarget.Text]), mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
  begin
    with TLdapOpDlg.Create(Self, ldapSession) do
    try
      if cpy then
        CopyTree(PChar(LDAPTree.Selected.Data),PChar(LDAPTree.DropTarget.Data), '')
      else
      begin
        MoveTree(PChar(LDAPTree.Selected.Data),PChar(LDAPTree.DropTarget.Data), '');
        LdapTree.Selected.Delete;
      end;
      if LDAPTree.DropTarget.Expanded then
      begin
        LDAPTree.Items.BeginUpdate;
        try
          LDAPTree.DropTarget.DeleteChildren;
          ExpandNode(LDAPTree.DropTarget, ldapSession);
          LDAPTree.DropTarget.Expand(false);
          LDAPTree.CustomSort(@CustomSortProc, 0);
        finally
          LDAPTree.Items.EndUpdate;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TMainFrm.LDAPTreeStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  ScrollTimer.Enabled := True;
end;

procedure TMainFrm.LDAPTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TMainFrm.ScrollTimerTimer(Sender: TObject);
var
  Pt: TPoint;
begin
  GetCursorPos(pt);
  pt := LDAPTree.ScreenToClient (pt);
  if (pt.y < -ScrollAccMargin) or (pt.y > LDAPTree.ClientHeight + ScrollAccMargin) then
  begin
    if ScrollTimer.Interval <> 10 then
      ScrollTimer.Interval := 10 // accelerate
  end
  else begin
    if ScrollTimer.Interval <> 100 then
      ScrollTimer.Interval := 100 // deccelerate
  end;
  if pt.y < 0 then
    SendMessage(LdapTree.Handle, WM_VSCROLL, SB_LINEUP, 0)
  else
  if pt.y > LDAPTree.ClientHeight then
    SendMessage(LdapTree.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
end;

end.
