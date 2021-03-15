  {      LDAPAdmin - Main.pas
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

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, ToolWin, WinLdap, StdCtrls, ExtCtrls, Posix, Samba,
  LDAPClasses, Clipbrd, ActnList, Config;

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
    MainMenu: TMainMenu;
    mbStart: TMenuItem;
    StatusBar: TStatusBar;
    mbConnect: TMenuItem;
    mbDisconnect: TMenuItem;
    N1: TMenuItem;
    mbExit: TMenuItem;
    TreeSplitter: TSplitter;
    mbEdit: TMenuItem;
    mbNew: TMenuItem;
    EditPopup: TPopupMenu;
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
    ListViewPanel: TPanel;
    ValueListView: TListView;
    EntryListView: TListView;
    ViewSplitter: TSplitter;
    mbView: TMenuItem;
    mbShowValues: TMenuItem;
    mbShowEntires: TMenuItem;
    ActValues: TAction;
    ActEntries: TAction;
    ActIconView: TAction;
    ActListView: TAction;
    N13: TMenuItem;
    mbIconView: TMenuItem;
    mbListView: TMenuItem;
    ActSmallView: TAction;
    mbViewStyle: TMenuItem;
    mbSmallView: TMenuItem;
    ActOptions: TAction;
    N14: TMenuItem;
    Options1: TMenuItem;
    TreeViewPanel: TPanel;
    LDAPTree: TTreeView;
    SearchPanel: TPanel;
    edSearch: TEdit;
    Label1: TLabel;
    ActLocateEntry: TAction;
    N15: TMenuItem;
    Locateentry1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    ActCopyDn: TAction;
    Copydntoclipboard1: TMenuItem;
    Copydntoclipboard2: TMenuItem;
    ViewEdit: TAction;
    ActCopy: TAction;
    ActCopyValue: TAction;
    ActCopyName: TAction;
    N18: TMenuItem;
    pbViewCopy: TMenuItem;
    pbViewCopyName: TMenuItem;
    pbViewCopyValue: TMenuItem;
    mbNewGoUN: TMenuItem;
    pbGroupOfUN: TMenuItem;
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
    procedure ValueListViewCustomDrawItem(Sender: TCustomListView;
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
    procedure ActValuesExecute(Sender: TObject);
    procedure ActEntriesExecute(Sender: TObject);
    procedure EntryListViewDblClick(Sender: TObject);
    procedure ActIconViewExecute(Sender: TObject);
    procedure ActListViewExecute(Sender: TObject);
    procedure ActSmallViewExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActOptionsExecute(Sender: TObject);
    procedure ActLocateEntryExecute(Sender: TObject);
    procedure edSearchExit(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ActCopyDnExecute(Sender: TObject);
    procedure ActCopyExecute(Sender: TObject);
    procedure ActCopyValueExecute(Sender: TObject);
    procedure ActCopyNameExecute(Sender: TObject);
  private
    Root: TTreeNode;
    ldapSession: TLDAPSession;
    fViewSplitterPos: Integer;
    fLdapTreeWidth: Integer;
    fSearchList: TLdapEntryList;
    fLocateList: TLdapEntryList;
    fTemplateMenu: TMenuItem;
    fTemplatePopupMenu: TMenuItem;
    fTickCount: Cardinal;
    fIdObject: Boolean;
    fEnforceContainer: Boolean;
    fLocatedEntry: Integer;
    fQuickSearchFilter: string;
    fTemplateProperties: Boolean;
    procedure EntrySortProc(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer);
    procedure SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
    procedure DoTemplateMenu;
    procedure InitStatusBar;
    procedure RefreshStatusBar;
    procedure ClassifyEntry(Entry: TLdapEntry; CNode: TTreeNode);
    procedure ExpandNode(Node: TTreeNode; Session: TLDAPSession);
    procedure RefreshTree;
    procedure RefreshListView(Node: TTreeNode);
    procedure RefreshEntryListView(Node: TTreeNode);
    procedure DoCopyMove(TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
    procedure CopyMoveEntry(Move: Boolean);
    function IsActPropertiesEnable: Boolean;
    function SelectedNode: TTreeNode;
    function IsContainer(ANode: TTreeNode): Boolean;
    procedure NewTemplateClick(Sender: TObject);
  public
    function  PickEntry(const ACaption: string): string;
    function  LocateEntry(const dn: string; const Select: Boolean): TTreeNode;
    procedure EditProperty(AOwner: TControl; const Index: Integer; const dn: string);
    procedure ServerConnect(Account: TAccount);
    procedure ServerDisconnect;
    procedure ReadConfig;
  end;

var
  MainFrm: TMainFrm;

implementation

uses EditEntry, Group, User, Computer, PassDlg, ConnList, Transport, Search, Ou,
     Host, Locality, LdapOp, Constant, Export, Import, Mailgroup, Prefs,
     LdapCopy, Schema, uSchemaDlg, BinView, Misc, Input, ConfigDlg,
     Templates, TemplateCtrl, About;

{$R *.DFM}

{$DEFINE XPSTYLE}

{$IFDEF VER100} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 3
{$IFDEF VER120} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 4
{$IFDEF VER130} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 5
{$IFDEF VER140} {$UNDEF XPSTYLE} {$ENDIF} //Delphi 6

{$IFDEF XPSTYLE} {$R Manifest.res} {$ENDIF}

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
    Result := CompareText(Node1.Text, Node2.Text);
end;

procedure TMainFrm.EntrySortProc(Entry1, Entry2: TLdapEntry; Data: pointer; out Result: Integer);
var
  c: boolean;
begin
  if Entry1.Tag = 0 then
    ClassifyLdapEntry(Entry1, c, Entry1.Tag);
  if Entry2.Tag = 0 then
    ClassifyLdapEntry(Entry2, c, Entry2.Tag);
  if ((Entry1.Tag = bmOu) and (Entry2.Tag <> bmOu)) then
    Result := -1
  else
  if ((Entry2.Tag = bmOu) and (Entry1.Tag <> bmOu))then
    Result := 1
  else
    Result := CompareText(Entry1.dn, Entry2.dn);
end;

procedure TMainFrm.SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
begin
  if GetTickCount > FTickCount then
  begin
    Screen.Cursor := crHourGlass;
    StatusBar.Panels[3].Width := 20000;
    StatusBar.Panels[3].Text := Format(stRetrieving, [Sender.Count]);
    StatusBar.Repaint;
  end;
  if PeekKey = VK_ESCAPE then
    AbortSearch := true;
end;

procedure TMainFrm.DoTemplateMenu;
var
  i: Integer;
  Item: TMenuItem;
begin
  FreeAndNil(fTemplateMenu);
  FreeAndNil(fTemplatePopupMenu);
  if fTemplateProperties and (TemplateParser.Count > 0) then
  begin
    fTemplateMenu := TMenuItem.Create(Self);
    fTemplatePopupMenu := TMenuItem.Create(Self);
    fTemplateMenu.Caption := 'More...';
    fTemplatePopupMenu.Caption := 'More...';
    for i := 0 to TemplateParser.Count - 1 do
    begin
      Item := TMenuItem.Create(Self);
      Item.Caption := TemplateParser.Templates[i].Name;
      Item.Tag := Integer(TemplateParser.Templates[i]);
      Item.OnClick := NewTemplateClick;
      fTemplateMenu.Add(Item);
      Item := TMenuItem.Create(Self);
      Item.Caption := TemplateParser.Templates[i].Name;
      Item.Tag := Integer(TemplateParser.Templates[i]);
      Item.OnClick := NewTemplateClick;
      fTemplatePopupMenu.Add(Item);
    end;
    pbNew.Add(fTemplatePopupMenu);
    mbNew.Add(fTemplateMenu);
  end;
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
          Result := Result.GetNextChild(Result);
        end;
      end;
    end;
    if Select and Assigned(Result) then
      Result.Selected := true;
  finally
    ldap_value_free(comp);
  end;
end;

procedure TMainFrm.ServerConnect(Account: TAccount);
begin
  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;
  with ldapSession do
  try
    Server             := Account.Server;
    Base               := Account.Base;
    User               := Account.User;
    Password           := Account.Password;
    SSL                := Account.SSL;
    Port               := Account.Port;
    Version            := Account.LdapVersion;
    TimeLimit          := Account.TimeLimit;
    SizeLimit          := Account.SizeLimit;
    PagedSearch        := Account.PagedSearch;
    PageSize           := Account.PageSize;
    DereferenceAliases := Account.DereferenceAliases;
    ChaseReferrals     := Account.ChaseReferrals;
    ReferralHops       := Account.ReferralHops;
    Connect;
  finally
    Screen.Cursor := crDefault;
  end;
  LDAPTree.PopupMenu := EditPopup;
  EntryListView.PopupMenu := EditPopup;
  ListPopup.AutoPopup := true;
  try
    fLdapTreeWidth :=  GlobalConfig.ReadInteger(rMwLTWidth);
    LdapTree.Width := fLdapTreeWidth;
  except
    fLdapTreeWidth := LdapTree.Width
  end;
  try
    fViewSplitterPos := GlobalConfig.ReadInteger(rMwViewSplit);
  except
    fViewSplitterPos := ListViewPanel.Height div 2;
  end;
  try
    if Boolean(GlobalConfig.ReadInteger(rMwShowEntries)) <> ActEntries.Checked then
      ActEntriesExecute(nil);
  except end;
  try
    if Boolean(GlobalConfig.ReadInteger(rMwShowValues)) <> ActValues.Checked then
      ActValuesExecute(nil);
  except end;
  try
    EntryListView.ViewStyle := TViewStyle(GlobalConfig.ReadInteger(rEvViewStyle));
    case Ord(EntryListView.ViewStyle) of
      0: ActIconView.Checked := true;
      1: ActSmallView.Checked := true;
      2: ActListView.Checked := true;
    end;
  except end;
  RefreshTree;
  InitStatusBar;
end;

procedure TMainFrm.ServerDisconnect;
begin
  ldapSession.Disconnect;
  ClearLdapSchema;
  LDAPTree.PopupMenu := nil;
  ListPopup.AutoPopup := false;
  MainFrm.Caption := cAppName;
  LDAPTree.Items.BeginUpdate;
  LDAPTree.Items.Clear;
  LDAPTree.Items.EndUpdate;
  ValueListView.Items.Clear;
  EntryListView.Items.Clear;
  GlobalConfig.WriteInteger(rMwLTWidth, LdapTree.Width);
  GlobalConfig.WriteInteger(rMwShowEntries, Ord(ActEntries.Checked));
  GlobalConfig.WriteInteger(rMwShowValues, Ord(ActValues.Checked));
  GlobalConfig.WriteInteger(rMwViewSplit, ViewSplitter.Top);
  GlobalConfig.WriteInteger(rEvViewStyle, Ord(EntryListView.ViewStyle));
  ValueListView.Align := alClient;
  ValueListView.Visible := true;
  EntryListView.Visible := false;
  ViewSplitter.Visible := false;
  ActValues.Checked := true;
  ActEntries.Checked := false;
  SetAccount(nil);
  if Visible then
    LDAPTree.SetFocus;
end;

procedure TMainFrm.InitStatusBar;
var
 s: string;
begin
  if (ldapSession <> nil) and (ldapSession.Connected) then begin
    s := ' Server: ' + ldapSession.Server;
    StatusBar.Panels[1].Style := psOwnerDraw;
    StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(s) + 16;
    StatusBar.Panels[0].Text := s;
    s := ' User: ' + ldapSession.User;
    StatusBar.Panels[2].Width := StatusBar.Canvas.TextWidth(s) + 16;
    StatusBar.Panels[2].Text := s;
  end
  else begin
    StatusBar.Panels[1].Style := psText;
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := '';
    StatusBar.Panels[3].Text := '';
  end;
end;

procedure TMainFrm.ReadConfig;
var
  a, b: Boolean;
begin
  fQuickSearchFilter := GlobalConfig.ReadString(rQuickSearchFilter, sDEFQUICKSRCH);
  fLocatedEntry := -1;
  a := fIdObject;
  b := fEnforceContainer;
  fIdObject := GlobalConfig.ReadBool(rMwLTIdentObject, true);
  fEnforceContainer := GlobalConfig.ReadBool(rMwLTEnfContainer, true);
  fTemplateProperties := GlobalConfig.ReadBool(rTemplateProperties, true);
  if Visible then
  begin
    DoTemplateMenu;
    if ((a <> fIdObject) or (b <> fEnforceContainer)) then
      RefreshTree;
  end;
end;

procedure TMainFrm.RefreshStatusBar;
var
  s3, s4: string;
begin
  s4 := '';
  if LDAPTree.Selected <> nil then with LDAPTree.Selected do
  begin
    s3 := ' ' + PChar(Data);
    //StatusBar.Panels[3].Width := StatusBar.Canvas.TextWidth(s3) + 16;
    if (Count=0) or (Integer(Item[0].Data) <> ncDummyNode) then
    begin
      s4 := Format(stCntSubentries, [Count]);
      StatusBar.Panels[3].Width := StatusBar.Canvas.TextWidth(s3) + 16;
    end
    else
      StatusBar.Panels[3].Width := 20000;
  end
  else
    s3 := '';
  StatusBar.Panels[3].Text := s3;
  StatusBar.Panels[4].Text := s4;
  Application.ProcessMessages;
end;

function TMainFrm.SelectedNode: TTreeNode;
begin
  Result := nil;
  if EntryListView.Focused then
  begin
    if Assigned(EntryListView.Selected) then
      Result := EntryListView.Selected.Data;
  end
  else
    Result := LDAPTree.Selected
end;

procedure TMainFrm.ClassifyEntry(Entry: TLdapEntry; CNode: TTreeNode);
var
  Container: Boolean;
  bmIndex: Integer;
begin
  Container := true;
  if CNode.Parent=nil then // if root node
  begin
    CNode.ImageIndex := bmRoot;
    CNode.SelectedIndex := bmRootSel;
  end
  else begin
    if fidObject then
      ClassifyLdapEntry(Entry, Container, bmIndex)
    else
      bmIndex := bmEntry;
    CNode.ImageIndex := bmIndex;
    CNode.SelectedIndex := bmIndex;
  end;
  { Add dummy node to make node expandable }
  if not CNode.HasChildren and (not fEnforceContainer or Container) then
    LDAPTree.Items.AddChildObject(CNode, '', Pointer(ncDummyNode));
end;

function TMainFrm.IsContainer(ANode: TTreeNode): Boolean;
begin
  Result := not fEnforceContainer or (ANode.ImageIndex in [bmOu, bmLocality, bmEntry, bmRoot]);
end;

procedure TMainFrm.ExpandNode(Node: TTreeNode; Session: TLDAPSession);
var
  CNode: TTreeNode;
  i: Integer;
  attrs: PCharArray;
  Entry: TLDapEntry;
begin
  FTickCount := GetTickCount + 500;
  try
    SetLength(attrs, 2);
    attrs[0] := 'objectclass';
    attrs[1] := nil;
    Session.Search(sAnyClass, PChar(Node.Data), LDAP_SCOPE_ONELEVEL, attrs, false, fSearchList, SearchCallback);
    for i := 0 to fSearchList.Count - 1 do
    begin
      Entry := fSearchList[i];
      CNode := LDAPTree.Items.AddChildObject(Node, GetRdnFromDn(Entry.dn), Pointer(StrNew(PChar(Entry.dn))));
      ClassifyEntry(Entry, CNode);
    end;
  finally
    RefreshStatusBar;
    fSearchList.Clear;
    Node.CustomSort(@CustomSortProc, 0);
    Screen.Cursor := crDefault;
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
    Root.Selected := true;
  finally
    LDAPTree.Items.EndUpdate;
  end;
  Root.Expand(false);
end;

procedure TMainFrm.RefreshListView(Node: TTreeNode);
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
      ValueListView.Items.BeginUpdate;
      ValueListView.Items.Clear;
      for i := 0 to Entry.Attributes.Count - 1 do with Entry.Attributes[i] do
      for j := 0 to ValueCount - 1 do
      begin
        ListItem := ValueListView.Items.Add;
        ListItem.Caption := Name;
        with Values[j] do begin
          if DataType = dtText then
          begin
            ListItem.SubItems.Add(AsString);
            ListItem.SubItems.Add('Text');
          end
          else begin
            ListItem.SubItems.Add(HexMem(Data, DataSize, true));
            ListItem.SubItems.Add('Binary');
          end;
          ListItem.SubItems.Add(IntToStr(DataSize));
        end;
        ListItem.Data := Pointer(j); // TODO -> used by BinaryViewer to identify value index
      end;
      RefreshStatusBar;
    finally
      ValueListView.Items.EndUpdate;
    end;
  finally
    Entry.Free;
  end;
end;

procedure TMainFrm.RefreshEntryListView(Node: TTreeNode);
var
  s: string;
  ListItem: TListItem;
  ANode: TTreeNode;
begin
  with EntryListView, Items do
  try
    BeginUpdate;
    Clear;
    ANode := Node.GetFirstChild;
    while Assigned(ANode) do begin
      s := ANode.Text;
      ListItem := Add;
      with ListItem do begin
        Caption := Copy(s, Pos('=', s) + 1, MaxInt);
        Data := ANode;
        ImageIndex := ANode.ImageIndex;
      end;
      ANode := Node.GetNextChild(ANode);
    end;
    finally
      EndUpdate;
    end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  ldapSession := TLDAPSession.Create;
  fSearchList := TLdapEntryList.Create;
  fLocateList := TLdapEntryList.Create;
  ValueListView.Align := alClient;
  ViewSplitter.Visible := false;
  ReadConfig;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  ServerDisconnect;
  fSearchList.Free;
  fLocateList.Free;
end;

procedure TMainFrm.LDAPTreeExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if (Node.Count > 0) and (Integer(Node.Item[0].Data) = ncDummyNode) then
  with (Sender as TTreeView) do
  try
    Items.BeginUpdate;
    Node.Item[0].Delete;
    ExpandNode(Node, ldapSession);
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
  CanExpand: Boolean;
begin
    // Update Value List
    if ValueListView.Visible then
      RefreshListView(Node);

    // Update Attribute List
    if EntryListView.Visible and (Sender <> nil) then
    begin
      CanExpand := false;
      LDAPTreeExpanding(Node.TreeView, Node, CanExpand);
      RefreshEntryListView(Node);
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
  if PtInRect(LDAPTree.Selected.DisplayRect(false), LdapTree.ScreenToClient(Mouse.CursorPos)) and
    not IsContainer(LdapTree.Selected) then
      ActPropertiesExecute(Sender)
end;

procedure TMainFrm.DoCopyMove(TargetSession: TLdapSession; TargetDn, TargetRdn: string; Move: Boolean);
var
  SelItem, tItem: TListItem;
  Node: TTreeNode;
begin
  with TLdapOpDlg.Create(Self, ldapSession) do
  try
    DestSession := TargetSession;
    if LDAPTree.Focused then
    begin
      if not Move then
        CopyTree(PChar(LDAPTree.Selected.Data),TargetDn, TargetRdn)
      else
      begin
        MoveTree(PChar(LDAPTree.Selected.Data),TargetDn, TargetRdn);
        LDAPTree.Selected.Delete;
      end;
    end
    else begin
      SelItem := EntryListView.Selected;
      Show;
      repeat
        Exporting.Caption := PChar(TTreeNode(SelItem.Data).Data);
        Application.ProcessMessages;
        if ModalResult = mrCancel then
          break;
        if not Move then
        begin
          CopyTree(PChar(TTreeNode(SelItem.Data).Data),TargetDn, '');
          SelItem:= EntryListView.GetNextItem(SelItem, sdAll, [isSelected]);
        end
        else begin
          MoveTree(PChar(TTreeNode(SelItem.Data).Data),TargetDn, '');
          tItem := SelItem;
          SelItem:= EntryListView.GetNextItem(SelItem, sdAll, [isSelected]);
          if ModalResult = mrNone then
          begin
            TTreeNode(tItem.Data).Delete;
            tItem.Delete;
          end;
        end;
      until SelItem = nil;
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
        finally
          LDAPTree.Items.EndUpdate;
        end;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TMainFrm.CopyMoveEntry(Move: Boolean);
var
  tgt: string;
  Node: TTreeNode;
begin
  Node := SelectedNode;
  if Assigned(Node) then
  begin
    with TCopyDlg.Create(Self, PChar(Node.Data), ldapSession, ImageList, ExpandNode, @CustomSortProc) do
    try
      if EntryListView.Focused and (EntryListView.SelCount > 1) then
      begin
        edName.Visible := false;
        label2.Visible := false;
        tgt := Format(stNumObjects, [EntryListView.SelCount])
      end
      else
        tgt := '"' + PChar(LDAPTree.Selected.Data) + '"';
      if Move then
        Caption := Format(cMoveTo, [tgt])
      else
        Caption := Format(cCopyTo, [tgt]);
      ShowModal;
      if ModalResult = mrOk then
        DoCopyMove(TargetSession, TargetDn, TargetRdn, Move);
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
  Accept := Accept and Assigned(LDAPTree.DropTarget) and (LDAPTree.DropTarget = LDAPTree.GetNodeAt(X, Y)) and
    (LDAPTree.DropTarget <> SelectedNode) and
    IsContainer(LDAPTree.DropTarget) and
    (Copy(PChar(LDAPTree.DropTarget.Data), Length(PChar(LDAPTree.DropTarget.Data)) - Length(PChar(SelectedNode.Data)) + 1, MaxInt) <> PChar(SelectedNode.Data));
end;

procedure TMainFrm.LDAPTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  msg: String;
  cpy: boolean;
  SelNode: TTreeNode;
begin
  cpy := GetKeyState(VK_CONTROL) < 0;
  if cpy then
    msg := stAskTreeCopy
  else
    msg := stAskTreeMove;

  SelNode := SelectedNode;

  if EntryListView.Focused and (EntryListView.SelCount > 1) then
    msg := Format(msg, [Format(stNumObjects, [EntryListView.SelCount]), LDAPTree.DropTarget.Text])
  else
    msg := Format(msg, [SelNode.Text, LDAPTree.DropTarget.Text]);

  if Assigned(SelNode.Data) and Assigned(LDAPTree.DropTarget.Data) and
    (MessageDlg(msg, mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
    DoCopyMove(ldapSession, PChar(LDAPTree.DropTarget.Data), '', not cpy);
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

procedure TMainFrm.ValueListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if odd(Item.Index) then ValueListView.Canvas.Brush.Color:=$00f0f0f0;
end;

procedure TMainFrm.pbNewClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    1: begin
         TEditEntryFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).Show;
         Exit;
       end;
    2: TUserDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    3: TComputerDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    4: TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD, true, AccountConfig.ReadBool(rPosixGroupOfUnames, false)).ShowModal;
    5: TMailGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    6: TTransportDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    7: TOuDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    8: THostDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
    9: TLocalityDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD).ShowModal;
   10: TGroupDlg.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD, false, true).ShowModal;
  else
    Exit;
  end;
  ActRefreshExecute(nil);
end;

procedure TMainFrm.ActConnectExecute(Sender: TObject);
begin
  with TConnListFrm.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      ServerConnect(AccountConfig);
      MainFrm.Caption := cAppName + ': ' + AccountConfig.Name;
    end;
  finally
    Screen.Cursor := crDefault;
    Destroy;
  end;
end;

procedure TMainFrm.ActDisconnectExecute(Sender: TObject);
begin
  ServerDisconnect;
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
  ActEntries.Enabled:= Enbl;
  ActValues.Enabled:= Enbl;
  ActLocateEntry.Enabled := Enbl;

  Enbl:=Enbl and (SelectedNode <> nil);
  ActExport.Enabled:= Enbl;
  ActPassword.Enabled:=Enbl;
  ActCopyDn.Enabled := Enbl;
  ActEditEntry.Enabled:=Enbl;
  ActCopyEntry.Enabled:=Enbl;
  ActMoveEntry.Enabled:=Enbl;
  ActDeleteEntry.Enabled:=Enbl;
  ActProperties.Enabled:=Enbl and IsActPropertiesEnable;
  ActViewBinary.Enabled := Enbl and Assigned(ValueListView.Selected);
  ActCopy.Enabled := ActViewBinary.Enabled;
  ActCopyValue.Enabled := ActViewBinary.Enabled;
  ActCopyName.Enabled := ActViewBinary.Enabled;

  mbViewStyle.Enabled := EntryListView.Visible;
  Enbl := Enbl and IsContainer(SelectedNode);
  mbNew.Enabled:=Enbl;
  pbNew.Enabled:=Enbl;
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
  TExportDlg.Create(PChar(SelectedNode.Data), ldapSession).ShowModal;
end;

procedure TMainFrm.ActPreferencesExecute(Sender: TObject);
begin
  TPrefDlg.Create(Self, ldapSession).ShowModal;
end;

procedure TMainFrm.ActAboutExecute(Sender: TObject);
begin
  TAboutDlg.Create(Self).ShowModal;
end;

procedure TMainFrm.ActEditEntryExecute(Sender: TObject);
begin
  if SelectedNode <> nil then
    TEditEntryFrm.Create(Self, PChar(SelectedNode.Data), ldapSession, EM_MODIFY).Show
end;

procedure TMainFrm.ActDeleteEntryExecute(Sender: TObject);
var
  SelItem, tItem: TListItem;
  msg: string;
begin
  if SelectedNode <> nil then
  begin
    if EntryListView.Focused and (EntryListView.SelCount > 1) then
      msg := Format(stConfirmMultiDel, [EntryListView.SelCount])
    else
      msg := Format(stConfirmDel, [PChar(SelectedNode.Data)]);
    if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    with TLdapOpDlg.Create(Self, ldapSession) do
    begin
      try
        LdapTree.Items.BeginUpdate;
        try
          if LDAPTree.Focused then
          begin
            DeleteTree(PChar(LDAPTree.Selected.Data));
            if ModalResult = mrNone then
              LDAPTree.Selected.Delete;
            RefreshEntryListView(LDAPTree.Selected);
          end
          else begin
            SelItem := EntryListView.Selected;
            Show;
            repeat
              Exporting.Caption := PChar(TTreeNode(SelItem.Data).Data);
              Application.ProcessMessages;
              if ModalResult = mrCancel then
                break;
              DeleteTree(PChar(TTreeNode(SelItem.Data).Data));
              tItem := SelItem;
              SelItem:= EntryListView.GetNextItem(SelItem, sdAll, [isSelected]);
              if ModalResult = mrNone then
              begin
                TTreeNode(tItem.Data).Delete;
                tItem.Delete;
              end;
            until (SelItem = nil);
          end;
        except
          ActRefreshExecute(nil);
          raise;
        end;
      finally
        LdapTree.Items.EndUpdate;
        Free;
      end;
    end;
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
    if EntryListView.Visible then
      RefreshEntryListView(LDAPTree.Selected);
  finally
    LdapTree.Items.EndUpdate;
  end;
end;

procedure TMainFrm.ActSearchExecute(Sender: TObject);
begin
  if LDAPTree.Selected = nil then LDAPTree.Selected := LDAPTree.TopItem;
  TSearchFrm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession).Show;
end;

procedure TMainFrm.EditProperty(AOwner: TControl; const Index: Integer; const dn: string);
begin
    case Index of
      bmSamba2User,
      bmSamba3User,
      bmPosixUser:    TUserDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmGroup,
      bmGrOfUnqNames: TGroupDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmMailGroup:    TMailGroupDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmComputer:     TComputerDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmTransport:    TTransportDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmOu:           TOuDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmLocality:     TLocalityDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
      bmHost:         THostDlg.Create(AOwner, dn, ldapSession, EM_MODIFY).ShowModal;
    else
      with TTemplateForm.Create(AOwner, dn, ldapSession, EM_MODIFY) do
      try
        LoadMatching;
        if Templates.Count > 0 then
          ShowModal;
      finally
        Free;
      end;
    end;
end;

procedure TMainFrm.ActPropertiesExecute(Sender: TObject);
begin
  if SelectedNode <> nil then with SelectedNode do
  begin
    EditProperty(Self, ImageIndex, PChar(Data));
    try
      LDAPTreeChange(nil, LDAPTree.Selected);
    except
      { Could be deleted or renamed, so try to refresh parent instead }
      LdapTree.Selected := LDAPTree.Selected.Parent;
      ActRefreshExecute(nil);
    end;
  end;
end;

function TMainFrm.IsActPropertiesEnable: boolean;
var
  Node: TTreeNode;
begin
  if fTemplateProperties then
    Result := true
  else begin
    Node := SelectedNode;
    if Node <> nil then
      Result := SupportedPropertyObjects(Node.ImageIndex)
    else
      Result := false;
  end;
end;

procedure TMainFrm.ActPasswordExecute(Sender: TObject);
var
  Entry: TLdapEntry;
begin
  Entry := TLdapEntry.Create(ldapSession, PChar(SelectedNode.Data));
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
  if Assigned(LdapTree.Selected) and Assigned(ValueListView.Selected) then
  begin
    Entry := TLdapEntry.Create(ldapSession, PChar(LdapTree.Selected.Data));
    try
      Entry.Read;
      with THexView.Create(Self) do
      try
        with Entry.AttributesByName[ValueListView.Selected.Caption] do
          StreamCopy(Values[Integer(ValueListView.Selected.Data)].SaveToStream, LoadFromStream);
        ShowModal;
      finally
        Free;
      end;
    finally
      Entry.Free;
    end;
  end;
end;

procedure TMainFrm.ActValuesExecute(Sender: TObject);
begin
  ActValues.Checked := not ActValues.Checked;
  if ActValues.Checked then
  begin
    ListViewPanel.Visible := true;
    TreeViewPanel.Align := alLeft;
    TreeViewPanel.Width := fLdapTreeWidth;
    TreeSplitter.Visible := true;
    if EntryListView.Visible then
    begin
      ValueListView.Align := alTop;
      ValueListView.Height := fViewSplitterPos + ViewSplitter.Height;
      ViewSplitter.Visible := true;
    end
    else
      ValueListView.Align := alClient;
    ValueListView.Visible := true;
    if Assigned(LDAPTree.Selected) then
      LDAPTreeChange(LDAPTree, LDAPTree.Selected);
  end
  else begin
    if EntryListView.Visible then
    begin
      fViewSplitterPos := ViewSplitter.Top;
    end
    else begin
      TreeSplitter.Visible := false;
      ListViewPanel.Visible := false;
      fLdapTreeWidth := TreeViewPanel.Width;
      TreeViewPanel.Align := alClient;
    end;
    ValueListView.Visible := false;
    ViewSplitter.Visible := false;
  end;
end;

procedure TMainFrm.ActEntriesExecute(Sender: TObject);
begin
  ActEntries.Checked := not ActEntries.Checked;
  if ActEntries.Checked then
  begin
    ListViewPanel.Visible := true;
    TreeViewPanel.Align := alLeft;
    TreeViewPanel.Width := fLdapTreeWidth;
    TreeSplitter.Visible := true;
    EntryListView.Visible := true;
    if ValueListView.Visible then
    begin
      ValueListView.Align := alTop;
      ValueListView.Height := fViewSplitterPos + ViewSplitter.Height;
      ViewSplitter.Top := ValueListView.Height;
      ViewSplitter.Visible := true;
    end;
    if Assigned(LDAPTree.Selected) then
      LDAPTreeChange(LDAPTree, LDAPTree.Selected);
  end
  else begin
    EntryListView.Visible := false;
    ViewSplitter.Visible := false;
    EntryListView.Items.Clear;
    if not ValueListView.Visible then
    begin
      TreeSplitter.Visible := false;
      ListViewPanel.Visible := false;
      fLdapTreeWidth := TreeViewPanel.Width;
      TreeViewPanel.Align := alClient;
    end
    else begin
      fViewSplitterPos := ViewSplitter.Top;
      ValueListView.Align := alClient;
    end;
  end;
end;

procedure TMainFrm.EntryListViewDblClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := SelectedNode;
  if Node=nil then exit;
  with EntryListView do
  begin
    if PtInRect(Selected.DisplayRect(drSelectBounds), ScreenToClient(Mouse.CursorPos)) then
    begin
      if Node.HasChildren then
        Node.Selected := true
      else
        ActPropertiesExecute(Sender);
    end;
  end;
end;

procedure TMainFrm.ActIconViewExecute(Sender: TObject);
begin
  EntryListView.ViewStyle := vsIcon;
  mbIconView.Checked := true;
end;

procedure TMainFrm.ActListViewExecute(Sender: TObject);
begin
  EntryListView.ViewStyle := vsList;
  mbListView.Checked := true;
end;

procedure TMainFrm.ActSmallViewExecute(Sender: TObject);
begin
  EntryListView.ViewStyle := vsSmallIcon;
  mbSmallView.Checked := true;
end;

procedure TMainFrm.FormShow(Sender: TObject);
var
  aproto, auser, apassword, ahost, abase: string;
  aport, i:     integer;
  SessionName, StorageName: string;
  AStorage: TConfigStorage;
  FakeAccount: TFakeAccount;
begin
  DoTemplateMenu;
  GlobalConfig.CheckProtocol;
  // ComandLine params /////////////////////////////////////////////////////////
  if ParamCount <> 0 then
  begin
    aproto:='ldap';
    aport:=LDAP_PORT;
    auser:='';
    apassword:='';
    ParseURL(ParamStr(1), aproto, auser, apassword, ahost, abase, aport);
    FakeAccount := TFakeAccount.Create(nil, 'FAKE');
    with FakeAccount do try
      Server := ahost;
      Port := aport;
      Base := abase;
      User := auser;
      Password := apassword;
      SSL := aproto='ldaps';
      LdapVersion := LDAP_VERSION3;
      ServerConnect(FakeAccount);
    finally
      FakeAccount.Free;
    end;
    Exit;
  end;
  // Autostart
  with GlobalConfig do
  begin
    SessionName := ReadString('StartupSession');
    if SessionName <> '' then
    begin
      i := Pos(':', SessionName);
      StorageName := Copy(SessionName, 1, i - 1);
      SessionName := Copy(SessionName, i + 1, MaxInt);
      AStorage := StorageByName(StorageName);
      if Assigned(AStorage) then
      begin
        SetAccount(AStorage.AccountByName(SessionName));
        ServerConnect(AccountConfig);
      end;
    end;
  end;
end;

procedure TMainFrm.ActOptionsExecute(Sender: TObject);
begin
  if TConfigDlg.Create(Self, ldapSession).ShowModal = mrOk then
    ReadConfig;
end;

procedure TMainFrm.ActLocateEntryExecute(Sender: TObject);
begin
  if SearchPanel.Visible then
    SearchPanel.Visible := false
  else begin
    SearchPanel.Visible := true;
    edSearch.SetFocus;
  end;
end;

procedure TMainFrm.edSearchExit(Sender: TObject);
begin
  SearchPanel.Visible := false;
  LdapTree.SetFocus;
  fLocatedEntry := -1;
  fLocateList.Clear;
end;

procedure TMainFrm.edSearchKeyPress(Sender: TObject; var Key: Char);

  function Parse(const Param, Val: string): string;
  var
    p, p1: PChar;
  begin
    Result := '';
    p := PChar(Param);
    while p^ <> #0 do begin
      p1 := CharNext(p);
      if (p^ = '%') and ((p1^ = 's') or (p1^ = 'S')) then
      begin
        Result := Result + Val;
        p1 := CharNext(p1);
      end
      else
        Result := Result + p^;
      p := p1;
    end;
  end;

begin
  if Key = #27 then
    LDAPTree.SetFocus
  else
  if Key = #13 then
  try
    if edSearch.Text = '' then
    begin
      Beep;
      Exit;
    end;
    if fLocatedEntry = -1 then
    begin
      ldapSession.Search(Parse(fQuickSearchFilter, edSearch.Text), PChar(ldapSession.Base), LDAP_SCOPE_SUBTREE, ['objectclass'], false, fLocateList, SearchCallback);
      fLocateList.Sort(EntrySortProc, true);
    end;
    if fLocateList.Count > 0 then
    begin
      inc(fLocatedEntry);
      if fLocatedEntry > fLocateList.Count - 1 then
        fLocatedEntry := 0;
      LocateEntry(fLocateList[fLocatedEntry].dn, true);
    end;
  finally
    Screen.Cursor := crDefault;
    RefreshStatusBar;
    Key := #0;
  end;
end;

procedure TMainFrm.edSearchChange(Sender: TObject);
begin
  fLocateList.Clear;
  fLocatedEntry := -1;
end;

procedure TMainFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and not edSearch.Focused then
  begin
    ActPropertiesExecute(nil);
    Key := #0;
  end;
end;

procedure TMainFrm.NewTemplateClick(Sender: TObject);
begin
  with TTemplateForm.Create(Self, PChar(LDAPTree.Selected.Data), ldapSession, EM_ADD) do
  try
    AddTemplate(TTemplate((Sender as TMenuItem).Tag));
    if ShowModal = mrOk then
      ActRefresh.Execute;
  finally
    Free;
  end;
end;

procedure TMainFrm.ActCopyDnExecute(Sender: TObject);
begin
  Clipboard.AsText := PChar(SelectedNode.Data);
end;

procedure TMainFrm.ActCopyExecute(Sender: TObject); begin
  if ValueListView.Selected=nil then exit;
  if ValueListView.Selected.SubItems.Count=0 then ActCopyNameExecute(Sender)
  else Clipboard.SetTextBuf(pchar(ValueListView.Selected.Caption+': '+ValueListView.Selected.SubItems[0]));
end;

procedure TMainFrm.ActCopyValueExecute(Sender: TObject); begin
  if ValueListView.Selected=nil then exit;
  if ValueListView.Selected.SubItems.Count=0 then exit;
  Clipboard.SetTextBuf(pchar(ValueListView.Selected.SubItems[0]));
end;

procedure TMainFrm.ActCopyNameExecute(Sender: TObject); begin
  if ValueListView.Selected=nil then exit;
  Clipboard.SetTextBuf(pchar(ValueListView.Selected.Caption));
end;

end.

