  {      LDAPAdmin - Main.pas
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

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, ToolWin, WinLdap, StdCtrls, ExtCtrls, Posix, Samba,
  LDAPClasses, RegAccnt, ActnList;

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
    StatusBar: TStatusBar;
    mbConnect: TMenuItem;
    mbDisconnect: TMenuItem;
    N1: TMenuItem;
    mbExit: TMenuItem;
    Splitter1: TSplitter;
    ListView: TListView;
    mbEdit: TMenuItem;
    mbNew: TMenuItem;
    TreePopup: TPopupMenu;
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
    ActionList: TActionList;
    ActConnect: TAction;
    ActDisconnect: TAction;
    ActExit: TAction;
    ActSchema: TAction;
    ActImport: TAction;
    ActExport: TAction;
    ActPreferences: TAction;
    ActAbout: TAction;
    ActPassword: TAction;
    ActEditEntry: TAction;
    ActCopyEntry: TAction;
    ActMoveEntry: TAction;
    ActDeleteEntry: TAction;
    ActRefresh: TAction;
    ActSearch: TAction;
    ActProperties: TAction;
    ToolButton1: TToolButton;
    SearchBtn: TToolButton;
    SchemaBtn: TToolButton;
    N12: TMenuItem;
    mbSchema: TMenuItem;
    ListPopup: TPopupMenu;
    pbViewBinary: TMenuItem;
    ActViewBinary: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LDAPTreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure LDAPTreeDeletion(Sender: TObject; Node: TTreeNode);
    procedure LDAPTreeChange(Sender: TObject; Node: TTreeNode);
    procedure LDAPTreeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure LDAPTreeDblClick(Sender: TObject);
    procedure LDAPTreeEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure LDAPTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LDAPTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LDAPTreeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure LDAPTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure pbNewClick(Sender: TObject);
    procedure ActConnectExecute(Sender: TObject);
    procedure ActExitExecute(Sender: TObject);
    procedure ActDisconnectExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActSchemaExecute(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActPreferencesExecute(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActEditEntryExecute(Sender: TObject);
    procedure ActDeleteEntryExecute(Sender: TObject);
    procedure ActRefreshExecute(Sender: TObject);
    procedure ActSearchExecute(Sender: TObject);
    procedure ActPropertiesExecute(Sender: TObject);
    procedure ActPasswordExecute(Sender: TObject);
    procedure ActCopyEntryExecute(Sender: TObject);
    procedure ActMoveEntryExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure ActViewBinaryExecute(Sender: TObject);
  private
    Root: TTreeNode;
    regAccount: TAccountEntry;
    ldapSession: TLDAPSession;
    procedure InitStatusBar;
    procedure RefreshStatusBar;
    procedure ClassifyEntry(Entry: TLdapEntry; CNode: TTreeNode);
    procedure ExpandNode(Node: TTreeNode; Session: TLDAPSession);
    procedure RefreshTree;
    procedure CopyMoveEntry(Move: Boolean);
    function IsActPropertiesEnable: Boolean;
  public
    function PickEntry(const ACaption: string): string;
    function LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
  end;

var
  MainFrm: TMainFrm;

implementation

uses EditEntry, Group, User, Computer, PassDlg, ConnList, Transport, Search, Ou,
     Host, Locality, LdapOp, Constant, Export, Import, Mailgroup, Prefs,
     LdapCopy, Schema, uSchemaDlg, BinView, Misc, About, Input;

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

procedure TMainFrm.InitStatusBar;
begin
  if (ldapSession <> nil) and (ldapSession.Connected) then begin
    StatusBar.Panels[1].Style := psOwnerDraw;
    StatusBar.Panels[0].Text := ' Server: ' + ldapSession.Server;
    StatusBar.Panels[2].Text := ' User: ' + ldapSession.User;
  end
  else begin
    StatusBar.Panels[1].Style := psText;
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := '';
    StatusBar.Panels[3].Text := '';
  end;
end;

procedure TMainFrm.RefreshStatusBar;
begin
  if LDAPTree.Selected <> nil then
    StatusBar.Panels[3].Text := ' ' + PChar(LDAPTree.Selected.Data)
  else
    StatusBar.Panels[3].Text := '';
  //StatusBar.Repaint;
  Application.ProcessMessages;
end;

procedure TMainFrm.ClassifyEntry(Entry: TLdapEntry; CNode: TTreeNode);
var
  Container: Boolean;
  Attr: TLdapAttribute;
  j: integer;
  s: string;
begin
  Container := true;
  CNode.ImageIndex := bmEntry;
  CNode.SelectedIndex := bmEntrySel;
  Attr := Entry.AttributesByName['objectclass'];
  j := Attr.ValueCount - 1;
  while j >= 0 do
  begin
    s := lowercase(Attr.Values[j].AsString);
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
      if CNode.Text[Length(CNode.Text)] = '$' then // it's samba computer account
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
    Dec(j);
  end;
  { Add dummy node to make node expandable }
  if not CNode.HasChildren and Container then
    LDAPTree.Items.AddChildObject(CNode, '', Pointer(ncDummyNode));
end;

procedure TMainFrm.ExpandNode(Node: TTreeNode; Session: TLDAPSession);
var
  CNode: TTreeNode;
  i: Integer;
  List: TLdapEntryList;
  attrs: PCharArray;
  Entry: TLDapEntry;
begin
  List := TLdapEntryList.Create;
  try
    SetLength(attrs, 2);
    attrs[0] := 'objectclass';
    attrs[1] := nil;
    Session.Search(sAnyClass, PChar(Node.Data), LDAP_SCOPE_ONELEVEL, attrs, false, List);
    for i := 0 to List.Count - 1 do
    begin
      Entry := TLdapEntry(List[i]);
      CNode := LDAPTree.Items.AddChildObject(Node, GetRdnFromDn(Entry.dn), Pointer(StrNew(PChar(Entry.dn))));
      //CNode := LDAPTree.Items.AddChildObject(Node, rdn, TLDAPEntry.Create);
      ClassifyEntry(Entry, CNode);
    end;
  finally
    List.Free;
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


procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  ldapSession.Disconnect;
  ldapSession.Free;
  regAccount.Free;
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
  i, j: Integer;
  ListItem: TListItem;
begin
    Entry := TLDAPEntry.Create(ldapSession, PChar(Node.Data));
    with Entry do
    try
      Read;
      try
        ListView.Items.BeginUpdate;
        ListView.Items.Clear;
        for i := 0 to Entry.Attributes.Count - 1 do with Entry.Attributes[i] do
        for j := 0 to ValueCount - 1 do
        begin
          ListItem := ListView.Items.Add;
          ListItem.Caption := Name;
          ListItem.SubItems.Add(Values[j].AsString);
          ListItem.Data := Pointer(j); // TODO -> used by BinaryViewer
        end;
        RefreshStatusBar;
        if Sender = nil then
          ClassifyEntry(Entry, Node);
      finally
        ListView.Items.EndUpdate;
      end;
    finally
      Entry.Free;
    end;
end;

procedure TMainFrm.LDAPTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node := LDAPTree.GetNodeAt(MousePos.X, MousePos.Y);
  if (Node <> nil) then
    Node.Selected := true;
end;

procedure TMainFrm.LDAPTreeDblClick(Sender: TObject);
begin
  if LDAPTree.Selected=nil then exit;
  with LDAPTree.Selected do begin
    if PtInRect(DisplayRect(false), LDAPTree.ScreenToClient(Mouse.CursorPos)) and
      (ImageIndex <> bmOu) and (ImageIndex <> bmLocality) then
        ActPropertiesExecute(Sender)
  end;
end;

procedure TMainFrm.CopyMoveEntry(Move: Boolean);
var
  Node: TTreeNode;
begin
  if Assigned(LDAPTree.Selected.Data) then
  begin
    with TCopyDlg.Create(Self, PChar(LDAPTree.Selected.Data), RegAccount.Name, ldapSession, ImageList, ExpandNode, @CustomSortProc) do
    try
      if Move then
        Caption := Format(cMoveTo, [PChar(LDAPTree.Selected.Data)])
      else
        Caption := Format(cCopyTo, [PChar(LDAPTree.Selected.Data)]);
      ShowModal;
      if ModalResult = mrOk then with TLdapOpDlg.Create(Self, ldapSession) do
      try
        DestSession := TargetSession;
        if not Move then
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
    pdn := GetDirFromDn(PChar(LDAPTree.Selected.Data));
    MoveTree(PChar(LDAPTree.Selected.Data), pdn, S);
    StrDispose(LdapTree.Selected.Data);
    LdapTree.Selected.Data := Pointer(StrNew(PChar(S + ',' + pdn)));
    ActRefreshExecute(nil);
  finally
    Free;
  end;
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

procedure TMainFrm.ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if odd(Item.Index) then ListView.Canvas.Brush.Color:=$00f0f0f0;
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
  ActRefreshExecute(nil);
end;

procedure TMainFrm.ActConnectExecute(Sender: TObject);
begin
  with TConnListFrm.Create(Self, regAccount) do
  try
    if ShowModal = mrOk then
    begin
      if (RegAccount.ldapPassword = '') and
         not InputDlg('Enter password', 'Password:', RegAccount.ldapPassword, '*', true) then
      begin
        FreeAndNil(RegAccount);
        Abort;
      end;
      Application.ProcessMessages;
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
      LDAPTree.PopupMenu := TreePopup;
      //ListView.PopupMenu := ListPopup;
      ListPopup.AutoPopup := true;
      MainFrm.Caption := cAppName + ': ' + ListView.Selected.Caption;
      RefreshTree;
    end;
  finally
    Screen.Cursor := crDefault;
    Destroy;
  end;
  InitStatusBar;
end;

procedure TMainFrm.ActDisconnectExecute(Sender: TObject);
begin
  ldapSession.Disconnect;
  LDAPTree.PopupMenu := nil;
  //ListView.PopupMenu := nil;
  ListPopup.AutoPopup := false;
  MainFrm.Caption := cAppName;
  LDAPTree.Items.BeginUpdate;
  LDAPTree.Items.Clear;
  LDAPTree.Items.EndUpdate;
  ListView.Items.Clear;
  //StatusBar.Panels[0].Text:='';
  InitStatusBar;
end;

procedure TMainFrm.ActExitExecute(Sender: TObject);
begin
  Application.MainForm.Close;
end;

procedure TMainFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Enbl: boolean;
begin
  Enbl:=ldapSession.Connected;
  ActConnect.Enabled:= not Enbl;
  ActDisconnect.Enabled:= Enbl;
  ActSchema.Enabled:= Enbl;
  ActImport.Enabled:= Enbl;
  ActRefresh.Enabled:=Enbl;
  ActSearch.Enabled:=Enbl;
  ActPreferences.Enabled:=Enbl;

  Enbl:=Enbl and (LDAPTree.Selected<>nil);
  ActExport.Enabled:= Enbl;
  ActPassword.Enabled:=Enbl;

  ActPassword.Enabled:=Enbl;
  ActEditEntry.Enabled:=Enbl;
  ActCopyEntry.Enabled:=Enbl;
  ActMoveEntry.Enabled:=Enbl;
  ActDeleteEntry.Enabled:=Enbl;
  ActProperties.Enabled:=Enbl and IsActPropertiesEnable;
  ActViewBinary.Enabled := Enbl and Assigned(ListView.Selected);
  mbNew.Enabled:=Enbl;
end;

procedure TMainFrm.ActSchemaExecute(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to Screen.FormCount-1 do begin
    if Screen.Forms[i] is TSchemaDlg then begin
      Screen.Forms[i].Show;
      exit;
    end;
  end;
  TSchemaDlg.Create(ldapSession);
end;

procedure TMainFrm.ActImportExecute(Sender: TObject);
begin
  if TImportDlg.Create(Self, ldapSession).ShowModal = mrOk then
    RefreshTree;
end;

procedure TMainFrm.ActExportExecute(Sender: TObject);
begin
  TExportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession).ShowModal;
end;

procedure TMainFrm.ActPreferencesExecute(Sender: TObject);
begin
  TPrefDlg.Create(Self, regAccount, ldapSession).ShowModal;
end;

procedure TMainFrm.ActAboutExecute(Sender: TObject);
begin
  TAboutDlg.Create(Self).ShowModal;
end;

procedure TMainFrm.ActEditEntryExecute(Sender: TObject);
begin
  if Assigned(LDAPTree.Selected) then
    TEditEntryFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_MODIFY).Show
end;

procedure TMainFrm.ActDeleteEntryExecute(Sender: TObject);
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
      ActRefreshExecute(nil);
      raise;
    end;
  finally
    Free;
  end;
end;

procedure TMainFrm.ActRefreshExecute(Sender: TObject);
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

procedure TMainFrm.ActSearchExecute(Sender: TObject);
begin
  if LDAPTree.Selected = nil then LDAPTree.Selected := LDAPTree.TopItem;
  TSearchFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession).Show;
end;

procedure TMainFrm.ActPropertiesExecute(Sender: TObject);
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
    try
      LDAPTreeChange(nil, LDAPTree.Selected);
    except
      { Could be deleted or renamed, so try to refresh parent instead }
      LdapTree.Selected := LdapTree.Selected.Parent;
      ActRefreshExecute(nil);
    end;
  end;
end;

function TMainFrm.IsActPropertiesEnable: boolean;
begin
  result:=false;
  if Assigned(LDAPTree.Selected) then
  begin
    case LDAPTree.Selected.ImageIndex of
      bmSamba2User,
      bmSamba3User,
      bmPosixUser,
      bmGroup,
      bmMailGroup,
      bmComputer,
      bmTransport,
      bmOu,
      bmLocality,
      bmHost: result:=true;
    end;
  end;
end;

procedure TMainFrm.ActPasswordExecute(Sender: TObject);
var
  Entry: TLdapEntry;
begin
  Entry := TLdapEntry.Create(ldapSession, PChar(LDAPTree.Selected.Data));
  Entry.Read;
  try
    with TPasswordDlg.Create(Self, Entry) do
    try
      if ShowModal = mrOk then
        Entry.Write;
    finally
      Free;
    end;
  finally
    Entry.Free;
  end;
end;

procedure TMainFrm.ActCopyEntryExecute(Sender: TObject);
begin
  CopyMoveEntry(false);
end;

procedure TMainFrm.ActMoveEntryExecute(Sender: TObject);
begin
  CopyMoveEntry(true);
end;

procedure TMainFrm.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  if (ldapSession<>nil) and (ldapSession.Connected) and ldapSession.SSL then
    ImageList.Draw(StatusBar.Canvas,Rect.Left+2,Rect.Top, bmLocked)
  else
    ImageList.Draw(StatusBar.Canvas,Rect.Left+2,Rect.Top,bmUnlocked);
end;

procedure TMainFrm.ActViewBinaryExecute(Sender: TObject);
var
  Entry: TLdapEntry;
begin
  if Assigned(LdapTree.Selected) and Assigned(ListView.Selected) then
  begin
    Entry := TLdapEntry.Create(ldapSession, PChar(LdapTree.Selected.Data));
    try
      Entry.Read;
      with THexView.Create(Self) do
      try
        with Entry.AttributesByName[ListView.Selected.Caption] do
          //StreamCopy(Values[IndexOf(PChar(ListView.Selected.SubItems[0]))].SaveToStream, LoadFromStream);
          StreamCopy(Values[Integer(ListView.Selected.Data)].SaveToStream, LoadFromStream);
        ShowModal;
      finally
        Free;
      end;
    finally
      Entry.Free;
    end;
  end;
end;

end.
