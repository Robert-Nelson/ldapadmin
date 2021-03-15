  {      LDAPAdmin - Search.pas
  *      Copyright (C) 2003-2006 Tihomir Karlovic
  *
  *      Author: Tihomir Karlovic & Alexander Sokoloff
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

unit Search;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, LDAPClasses, Menus, ExtCtrls, Misc, WinLdap, ToolWin,
  ImgList, ActnList, Buttons;

type

  TResultTabSheet=class(TTabSheet)
  private
    FListView:    TListView;
    FFilter:      string;
    FAttributes:  TStringList;
    FEntries:     TLdapEntryList;
    FBase:        string;
    FSorter:      TListViewSorter;
    FStatusBar:   TStatusBar;
    FSearchLevel: Integer;
    FDerefAliases: Integer;
    procedure     SetFilter(const Value: string);
    procedure     ListViewSort(SortColumn:  TListColumn; SortAsc: boolean);
    procedure     ListViewData(Sender: TObject; Item: TListItem);
    procedure     SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
  protected
  public
    constructor   Create(AOwner: TComponent); override;
    destructor    Destroy; override;
    property      Filter: string read FFilter write SetFilter;
    property      Attributes: TStringList read FAttributes;
    property      Entries: TLdapEntryList read FEntries;
    procedure     Search(Session: TLdapSession);
    property      ListView: TListView read FListView;
    property      Base: string read FBase write FBase;
    property      SearchLevel: Integer read fSearchLevel write fSearchLevel default LDAP_SCOPE_SUBTREE;
    property      DerefAliases: Integer read fDerefAliases write fDerefAliases;
    property      StatusBar: TStatusBar read FStatusBar write FStatusBar;
  end;

  TResultPageControl=class(TPageControl)
  private
    function      GetActiveListView: TListView;
    function      GetActivePage: TResultTabSheet;
    procedure     SetActivePage(Value: TResultTabSheet);
  protected
    procedure     MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure     Change; override;
  public
    function      AddPage: TResultTabSheet;
    property      ActiveList: TListView read GetActiveListView;
    property      ActivePage: TResultTabSheet read GetActivePage write SetActivePage;
  end;

  TSearchFrm = class(TForm)
    StatusBar: TStatusBar;
    PopupMenu1: TPopupMenu;
    pbGoto: TMenuItem;
    Panel1: TPanel;
    pbProperties: TMenuItem;
    ActionList: TActionList;
    ActStart: TAction;
    ActGoto: TAction;
    ActProperties: TAction;
    ActSave: TAction;
    ActEdit: TAction;
    ActClose: TAction;
    Editentry1: TMenuItem;
    N1: TMenuItem;
    SaveDialog: TSaveDialog;
    ResultPanel: TPanel;
    PickListBox: TListBox;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Label5: TLabel;
    Bevel2: TBevel;
    cbBasePath: TComboBox;
    PathBtn: TButton;
    Panel42: TPanel;
    Panel6: TPanel;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    cbAttributes: TComboBox;
    edAttrBtn: TButton;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    cbSearchLevel: TComboBox;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    cbDerefAliases: TComboBox;
    Panel5: TPanel;
    Label1: TLabel;
    Memo1: TMemo;
    Panel4: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    edName: TEdit;
    edEmail: TEdit;
    StartBtn: TBitBtn;
    GotoBtn: TBitBtn;
    SaveBtn: TBitBtn;
    CloseBtn: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PickListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PickListBoxClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PathBtnClick(Sender: TObject);
    procedure ActStartExecute(Sender: TObject);
    procedure ActGotoExecute(Sender: TObject);
    procedure ActPropertiesExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActEditExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewDblClick(Sender: TObject);
    procedure edAttrBtnClick(Sender: TObject);
  private
    Session: TLDAPSession;
    RList: TLdapEntryList;
    TopPanel: TPanel;
    ResultPages: TResultPageControl;
    procedure Search(const Filter: string);
  public
    constructor Create(AOwner: TComponent; const dn: string; const Session: TLDAPSession); reintroduce;
  end;

var
  SearchFrm: TSearchFrm;

implementation

uses EditEntry, Constant, Main, Ldif, PickAttr, Schema, Config;

{$R *.DFM}

{ TResultsPageControl }

function TResultPageControl.GetActiveListView: TListView;
begin
  if Assigned(ActivePage) then
    Result := TResultTabSheet(ActivePage).ListView
  else
    Result := nil;
end;

function TResultPageControl.GetActivePage: TResultTabSheet;
begin
  Result := TResultTabSheet(inherited ActivePage);
end;

procedure TResultPageControl.SetActivePage(Value: TResultTabSheet);
begin
  inherited ActivePage := Value;
end;

procedure TResultPageControl.Change;
begin
  inherited;
  with (ActivePage as TResultTabSheet) do StatusBar.SimpleText := Format(stCntObjects, [FEntries.Count]);
end;

function TResultPageControl.AddPage: TResultTabSheet;
begin
  result:=TResultTabSheet.Create(self);
  result.PageControl:=self;
end;

procedure TResultPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Tab: TResultTabSheet;
begin
  if (ssDouble in Shift) then begin
    Tab:=TResultTabSheet(ActivePage);
    Tab.PageControl:=nil;
    Tab.Free;
  end;
  inherited;
end;

{ TResultsTabSheet }

constructor TResultTabSheet.Create(AOwner: TComponent);
begin
  inherited;
  FAttributes:=TStringList.Create;
  FEntries:=TLdapEntryList.Create;

  FListView:=TListView.Create(self);
  with FListView do begin
    Parent:=self;
    Align:=alClient;
    ViewStyle:=vsReport;
    ReadOnly:=true;
    RowSelect:=true;
    GridLines:=true;
    OwnerData:=true;
    DoubleBuffered:=true;
    OnData:=ListViewData;
    FullDrag:=true;
    SmallImages:=MainFrm.ImageList;

    with Columns.Add do begin
      Caption:='DN';
      Width:=150;
      Tag:=-1;
    end;
  end;

  FSorter:=TListViewSorter.Create;
  FSorter.ListView:=FListView;
  FSorter.OnSort:=ListViewSort;
end;

destructor TResultTabSheet.Destroy;
begin
  FSorter.Free;
  FListView.Free;
  FAttributes.Free;
  FEntries.Free;
  inherited;
end;

procedure TResultTabSheet.ListViewData(Sender: TObject; Item: TListItem);
var
  i: integer;
  ImgIndex: integer;
  Container: boolean;
begin
  ClassifyLdapEntry(FEntries[Item.Index], Container, ImgIndex);
  Item.ImageIndex:=ImgIndex;

  Item.Caption:=FEntries[Item.Index].dn;

  for i:=0 to FAttributes.Count-1 do begin
    Item.SubItems.Add(FEntries[Item.Index].AttributesByName[FAttributes[i]].AsString);
  end;
end;

procedure TResultTabSheet.ListViewSort(SortColumn: TListColumn; SortAsc: boolean);
begin
  if SortColumn.Tag<0 then FEntries.Sort([PSEUDOATTR_DN], SortAsc)
  else FEntries.Sort([FAttributes[SortColumn.Tag]], SortAsc);
  ListView.Repaint;
end;

procedure TResultTabSheet.Search(Session: TLdapSession);
var
  i, w: integer;
  attrs: array of string;
  CallBackProc: TSearchCallback;
begin
  if Assigned(fStatusBar) then
    CallbackProc := SearchCallback
  else
    CallbackProc := nil;
  ldap_set_option(Session.pld, LDAP_OPT_DEREF, @fDerefAliases);
  Session.Search(FFilter, FBase, FSearchLevel, attrs, false, FEntries, CallbackProc);
  try
    FListView.Items.BeginUpdate;
    FListView.Columns.BeginUpdate;
    setlength(attrs, FAttributes.Count+1);
    w := Width;
    if FAttributes.Count > 0 then
      w := (w - 400) div FAttributes.Count;
    if w < 40 then w := 40;
    for i:=0 to FAttributes.Count-1 do begin
      with FListView.Columns.Add do begin
        Caption:=FAttributes[i];
        Width:=w;
        Tag:=i;
      end;
      attrs[i]:=FAttributes[i];
    end;
    FListView.Columns[0].Width := 400;
    attrs[length(attrs)-1]:='objectClass';
  finally
    FListView.Columns.EndUpdate;
    FListView.Items.EndUpdate;
  end;
  {ldap_set_option(Session.pld, LDAP_OPT_DEREF, @fDerefAliases);
  Session.Search(FFilter, FBase, FSearchLevel, attrs, false, FEntries, CallbackProc);}
  FListView.Items.Count:=FEntries.Count;
  fStatusBar.SimpleText := Format(stCntObjects, [FEntries.Count]);
end;

procedure TResultTabSheet.SetFilter(const Value: string);
begin
  FFilter := Value;
  Caption:=Value;
end;

procedure TResultTabSheet.SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
begin
  fStatusBar.SimpleText := Format(stRetrieving, [Sender.Count]);
  if PeekKey = VK_ESCAPE then
    AbortSearch := true;
end;

{ TSearchForm }

procedure TSearchFrm.Search(const Filter: string);
var
  Page: TResultTabSheet;
begin
  if Assigned(ResultPages.ActivePage) and (ResultPages.ActivePage.Filter = '') then
    Page := ResultPages.ActivePage
  else
    Page := ResultPages.AddPage;
  Page.Base:=cbBasePath.Text;
  Page.Filter:=Filter;
  Page.StatusBar := StatusBar;
  ResultPages.ActivePage := Page;

  Page.Attributes.CommaText := cbAttributes.Text;
  case cbSearchLevel.ItemIndex of
    0: Page.SearchLevel := LDAP_SCOPE_BASE;
    1: Page.SearchLevel := LDAP_SCOPE_ONELEVEL;
  else
    Page.SearchLevel := LDAP_SCOPE_SUBTREE;
  end;
  Page.DerefAliases := cbDerefAliases.ItemIndex;
  Screen.Cursor := crHourGlass;
  try
    Page.Search(Session);
    Page.ListView.PopupMenu := PopupMenu1;
    Page.ListView.OnDblClick := ListViewDblClick;
  finally
    Screen.Cursor := crDefault;
  end;
end;

constructor TSearchFrm.Create(AOwner: TComponent; const dn: string; const Session: TLDAPSession);
begin
  inherited Create(AOwner);
  RList := TLdapEntryList.Create;
  Self.Session := Session;
  if dn <> '' then
    cbBasePath.Text := dn
  else
    cbBasePath.Text := Session.Base;
  PickListBox.ItemIndex := 0;
  ResultPages := TResultPageControl.Create(self);
  ResultPages.Align := alClient;
  ResultPages.Parent := ResultPanel;
  ResultPages.AddPage;
  ResultPages.ActivePage.Caption := cSearchResults;
  topPanel := Panel4;
  with AccountConfig do begin
    cbBasePath.Items.CommaText := ReadString(rSearchBase, '');
    cbAttributes.Items.CommaText := ReadString(rSearchAttributes, '');
    cbSearchLevel.ItemIndex := ReadInteger(rSearchScope, 2);
    cbDerefAliases.ItemIndex := ReadInteger(rSearchDerefAliases, 0);
  end;
end;

procedure TSearchFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  RList.Free;
  with AccountConfig do begin
    WriteString(rSearchBase, cbBasePath.Items.CommaText);
    WriteString(rSearchAttributes, cbAttributes.Items.CommaText);
    WriteInteger(rSearchScope, cbSearchLevel.ItemIndex);
    WriteInteger(rSearchDerefAliases, cbDerefAliases.ItemIndex);
  end;
end;

procedure TSearchFrm.PickListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with PickListBox do begin
    Canvas.Brush.Color:=Color;
    Canvas.FillRect(Rect);
    InflateRect(Rect, -2, -2);
    if odSelected in State then begin
      Canvas.Brush.Color:=clBtnFace;
      Canvas.Font.Color:=clBtnText;
      Frame3D(Canvas, Rect, clBtnShadow, clBtnHighLight, BevelWidth);
    end
    else begin
      Canvas.Brush.Color:=Color;
      Canvas.Font.Color:=Font.Color;
    end;
    Canvas.FillRect(Rect);
    DrawText(Canvas.Handle, pchar(Items[Index]), -1, Rect, DT_SINGLELINE or DT_CENTER or DT_VCENTER );
  end;
end;

procedure TSearchFrm.PickListBoxClick(Sender: TObject);
begin
  LockControl(Panel1, true);
  case PickListBox.ItemIndex of
    0: TopPanel := Panel4;
    1: TopPanel := Panel5;
    2: TopPanel := Panel6;
  end;
  if TopPanel = Panel6 then
  begin
    ResultPanel.Visible := false;
    Panel1.Align := alClient;
  end
  else begin
    Panel1.Align := alTop;
    Panel1.Height := 169;
    ResultPanel.Visible := true;
  end;
  Panel4.Visible := false;
  Panel5.Visible := false;
  Panel6.Visible := false;
  Toppanel.visible := true;
  //TopPanel.BringToFront;
  LockControl(Panel1, false);
end;

procedure TSearchFrm.FormDestroy(Sender: TObject);
begin
  ResultPanel.Free;
end;

procedure TSearchFrm.PathBtnClick(Sender: TObject);
var
  s: string;
begin
  s := MainFrm.PickEntry('Search base');
  if s <> '' then
    cbBasePath.Text := s;
end;

procedure TSearchFrm.ActStartExecute(Sender: TObject);
var
  s: string;

  function Prepare(const Filter: string): string;
  var
    len: Integer;
  begin
    Result := Trim(Filter);
    if Result = '' then Exit;
    if Result[1] = '''' then
    begin
     len := Length(Result);
      if Result[len] <> '''' then
        raise Exception.Create(stUnclosedStr);
      Result := Copy(Result, 2, len - 2);
    end;
  end;

  procedure ComboHistory(Combo: TComboBox);
  begin
    with Combo do
    if (Text <> '') and (Items.IndexOf(Text) = -1) then
    begin
      if Items.Count > COMBO_HISTORY then
        Items.Delete(COMBO_HISTORY);
      Items.Insert(0, Text);
    end;
  end;

begin
  ComboHistory(cbBasePath);
  ComboHistory(cbAttributes);
  if TopPanel = Panel4 then
  begin
    s := '';
    if edName.Text <> '' then
      s := Format('(|(uid=*%s*)(displayName=*%s*))', [edName.Text, edName.Text]);
    if edEmail.Text <> '' then
      s := Format('%s(mail=*%s*)', [s, edEMail.Text]);
    if s = '' then
      s := sANYCLASS
    else
      s := '(&' + s + ')';
    Search(s);
  end
  else
    Search(Prepare(Memo1.Text));
end;

procedure TSearchFrm.ActGotoExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    MainFrm.LocateEntry(Selected.Caption, true);
end;

procedure TSearchFrm.ActPropertiesExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    MainFrm.EditProperty(Self, Selected.ImageIndex, Selected.Caption);
end;

procedure TSearchFrm.ActSaveExecute(Sender: TObject);
var
  ldif: TLdifFile;
  i: Integer;
begin
  with ResultPages, ActivePage do
  if Assigned(ActivePage) and (Entries.Count > 0) and SaveDialog.Execute then
  begin
    ldif := TLDIFFile.Create(SaveDialog.FileName, fmWrite);
    ldif.UnixWrite := SaveDialog.FilterIndex = 2;
    try
      for i := 0 to Entries.Count - 1 do
        ldif.WriteRecord(Entries[i]);
    finally
      ldif.Free;
    end;
  end;
end;

procedure TSearchFrm.ActEditExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    TEditEntryFrm.Create(Self, Selected.Caption, Session, EM_MODIFY).ShowModal;
end;

procedure TSearchFrm.ActCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TSearchFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Enbl: Boolean;
begin
  ActStart.Enabled := TopPanel <> Panel6;
  Enbl := Assigned(ResultPages.ActiveList) and (ResultPages.ActiveList.Items.Count > 0);
  ActSave.Enabled := Enbl;
  Enbl := Enbl and ActStart.Enabled and Assigned(ResultPages.ActiveList.Selected);
  ActGoto.Enabled := Enbl;
  ActEdit.Enabled := Enbl;
  ActProperties.Enabled := Enbl and SupportedPropertyObjects(ResultPages.ActiveList.Selected.ImageIndex);
end;

procedure TSearchFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and ActStart.Enabled then
  begin
    ActStartExecute(nil);
    Key := #0;
  end;
end;

procedure TSearchFrm.ListViewDblClick(Sender: TObject);
begin
  ActPropertiesExecute(nil);
end;

procedure TSearchFrm.edAttrBtnClick(Sender: TObject);
begin
  with TPickAttributesDlg.Create(Self, LdapSchema(Session), cbAttributes.Text) do
  begin
    ShowModal;
    cbAttributes.Text := Attributes;
  end;
end;

end.
