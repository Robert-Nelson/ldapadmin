  {      LDAPAdmin - Search.pas
  *      Copyright (C) 2003-2012 Tihomir Karlovic
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
  ComCtrls, StdCtrls, LDAPClasses, Menus, ExtCtrls, Sorter, WinLdap, ToolWin,
  ImgList, ActnList, Buttons, Schema, Contnrs, Connection;

const
  MODPANEL_HEIGHT         = 65;
  MODPANEL_LEFT_IND       =  8;
  MODPANEL_LABEL_TOP      =  8;
  MODPANEL_CTRL_TOP       = 24;
  MODPANEL_CTRL_SPACING   =  8;
  MODPANEL_OP_COMBO_WIDTH = 97;

  SAVE_SEARCH_FILTER  = 'Ldif file, Windows format (CR/LF) (*.ldif)|*.ldif|Ldif file, Unix format (LF only) (*.ldif)|*.ldif|CSV (Comma-separated) (*.csv)|*.csv|XML (*.xml)|*.xml';
  SAVE_SEARCH_EXT     = '*.ldif';
  SAVE_MODIFY_FILTER  = 'Text file (*.txt)|*.txt';
  SAVE_MODIFY_EXT     = '*.txt';

type

  TSearchList = class
  private
    FAttributes:  TStringList;
    FEntries:     TLdapEntryList;
    FStatusBar:   TStatusBar;
    procedure     SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
  protected
  public
    constructor   Create(Session: TLdapSession; ABase, AFilter, AAttributes: string; ASearchLevel, ADerefAliases: Integer; AStatusBar: TStatusBar);    destructor    Destroy; override;
    property      Attributes: TStringList read FAttributes;
    property      Entries: TLdapEntryList read FEntries;
  end;

  TModBoxState = (mbxNew, mbxReady, mbxRunning, mbxDone);

  TModifyPanel = class(TPanel)
  public
    Ctrls:        array[0..3] of TControl;
  end;

  TModifyOp = class
    LdapOperation: Integer;
    AttributeName: string;
    Value1:        string;
    Value2:        string;
  end;

  TModifyBox = class(TScrollBox)
  private
    fSchema:      TLdapSchema;
    fSearchList:  TSearchList;
    fOpList:      TObjectList;
    fSbPanel:     TPanel;
    fProgressBar: TProgressBar;
    fMemo:        TRichEdit;
    fCloseButton: TButton;
    fState:       TModBoxState;
    fTimer:       TTimer;
    procedure     DoTimer(Sender: TObject);
    procedure     ButtonClick(Sender: TObject);
    procedure     OpComboChange(Sender: TObject);
    procedure     AddPanel;
  protected
    procedure     Resize; override;
  public
    constructor   Create(AOwner: TComponent; AConnection: TConnection); reintroduce;
    destructor    Destroy; override;
    procedure     New;
    procedure     Run;
    procedure     SaveResults(const Filename: string);
    property      SearchList: TSearchList read fSearchList write fSearchList;
    property      State: TModBoxState read fState;
  end;

  TResultTabSheet=class(TTabSheet)
  private
    FSearchList:  TSearchList;
    FListView:    TListView;
    FSorter:      TListViewSorter;
    procedure     SetSearchList(ASearchList: TSearchList);
    procedure     ListViewSort(SortColumn:  TListColumn; SortAsc: boolean);
    procedure     ListViewData(Sender: TObject; Item: TListItem);
  protected
  public
    constructor   Create(AOwner: TComponent); override;
    destructor    Destroy; override;
    property      SearchList: TSearchList read fSearchList write SetSearchList;
    property      ListView: TListView read FListView;
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
    procedure     RemovePage(Page: TResultTabSheet);
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
    Panel2: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Label5: TLabel;
    cbBasePath: TComboBox;
    PathBtn: TButton;
    Bevel1: TBevel;
    Panel4: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    edName: TEdit;
    edEmail: TEdit;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Memo1: TMemo;
    cbFilters: TComboBox;
    SaveFilterBtn: TButton;
    DeleteFilterBtn: TButton;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbAttributes: TComboBox;
    edAttrBtn: TButton;
    cbSearchLevel: TComboBox;
    cbDerefAliases: TComboBox;
    Panel3: TPanel;
    StartBtn: TBitBtn;
    ToolBar1: TToolBar;
    btnSearch: TToolButton;
    btnModify: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ActClearAll: TAction;
    ClearAllBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure cbFiltersChange(Sender: TObject);
    procedure SaveFilterBtnClick(Sender: TObject);
    procedure DeleteFilterBtnClick(Sender: TObject);
    procedure cbFiltersDropDown(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSearchModifyClick(Sender: TObject);
    procedure ActClearAllExecute(Sender: TObject);
  private
    Connection: TConnection;
    ResultPages: TResultPageControl;
    ModifyBox: TModifyBox;
    fSearchFilter: string;
    procedure Search(const Filter: string);
    procedure Modify(const Filter: string);
  public
    constructor Create(AOwner: TComponent; const dn: string; AConnection: TConnection); reintroduce;
    procedure   SessionDisconnect(Sender: TObject);
    procedure   ShowModify;
  end;

var
  SearchFrm: TSearchFrm;

implementation

uses EditEntry, Constant, Main, Ldif, PickAttr, Xml, Config, Dsml, Params,
     ObjectInfo, Misc;

{$R *.DFM}

{ TSearch }

constructor TSearchList.Create(Session: TLdapSession; ABase, AFilter, AAttributes: string; ASearchLevel, ADerefAliases: Integer; AStatusBar: TStatusBar);
var
  i: integer;
  attrs: array of string;
  CallBackProc: TSearchCallback;
  sdref: Integer;
begin
  FAttributes:=TStringList.Create;
  FAttributes.Sorted := true;
  FAttributes.Duplicates := dupIgnore;
  FAttributes.CommaText := AAttributes;
  FEntries:=TLdapEntryList.Create;

  if Assigned(AStatusBar) then
    CallbackProc := SearchCallback
  else
    CallbackProc := nil;
  sdref := Session.DereferenceAliases;
  Session.DereferenceAliases := ADerefAliases;
  fStatusBar := AStatusBar;
  try
    setlength(attrs, FAttributes.Count+1);
    for i:=0 to FAttributes.Count-1 do
      attrs[i]:=FAttributes[i];
    attrs[FAttributes.Count] := 'objectclass';
    Session.Search(AFilter, ABase, ASearchLevel, attrs, false, FEntries, CallbackProc);
  finally
    Session.DereferenceAliases := sdref;
  end;
  AStatusBar.Panels[1].Text := Format(stCntObjects, [FEntries.Count]);
end;

destructor TSearchList.Destroy;
begin
  FAttributes.Free;
  FEntries.Free;
  inherited;
end;

procedure TSearchList.SearchCallback(Sender: TLdapEntryList; var AbortSearch: Boolean);
begin
  fStatusBar.Panels[1].Text := Format(stRetrieving, [Sender.Count]);
  fStatusBar.Repaint;
  if PeekKey = VK_ESCAPE then
    AbortSearch := true;
end;

{ TModifyBox }

procedure TModifyBox.DoTimer(Sender: TObject);
begin
  if FindDragTarget(Mouse.Cursorpos, false) = fCloseButton then 
    Screen.Cursor := crDefault
  else
    Screen.Cursor := crHourglass;
end;

procedure TModifyBox.ButtonClick(Sender: TObject);
begin
  if fState <> mbxRunning then
    New
  else
    fState := mbxDone;
end;

procedure TModifyBox.OpComboChange(Sender: TObject);
var
  i, l: Integer;

  function NewControl(AControl: TControlClass; ACaption: string): TControl;
  var
    i: Integer;
    p: TWinControl;
  begin
    p := TWinControl(Sender).Parent;
    Result := AControl.Create(p);
    with Result do begin
      Left := l;
      Top := MODPANEL_CTRL_TOP;
      Parent := p;
    end;
    with TLabel.Create(p) do begin
      Left := l;
      Top := MODPANEL_LABEL_TOP;
      Caption := ACaption;
      Parent := p;
    end;
    inc(l, Result.Width + MODPANEL_CTRL_SPACING);

    if AControl = TComboBox then
    begin
      TComboBox(Result).DropDownCount := 16;
      TComboBox(Result).Sorted := true;
      if fSchema.Loaded then
        for i := 0 to fSchema.Attributes.Count - 1 do
          TComboBox(Result).Items.Add(fSchema.Attributes[i].Name[0]);
    end;
  end;

begin
  with (Sender as TComboBox) do
  begin
    if Tag = 0 then
    begin
      AddPanel;
      Tag := 1;
    end;

    { Operation combo und it's label are owned by ScrollBox and therefore not freed }
    for i := Parent.ComponentCount - 1 downto 0 do
      Parent.Components[i].Free;

    l := MODPANEL_LEFT_IND + MODPANEL_OP_COMBO_WIDTH + MODPANEL_CTRL_SPACING;
    with TWinControl(Sender).Parent as TModifyPanel do
    case ItemIndex of
      0: begin
           Ctrls[1] := NewControl(TComboBox, cAttribute);
           Ctrls[2] := NewControl(TEdit, cValue);
         end;
      1: begin
           Ctrls[1] := NewControl(TComboBox, cAttribute);
           Ctrls[2] := TEdit(NewControl(TEdit, cValue));
           TEdit(Ctrls[2]).Text := '*';
         end;
      2: begin
           Ctrls[1] := NewControl(TComboBox, cAttribute);
           Ctrls[2] := NewControl(TEdit, cOldValue);
           Ctrls[3] := NewControl(TEdit, cNewValue);
         end;
    end;
  end;
  fState := mbxReady;
end;

procedure TModifyBox.AddPanel;
var
  Panel: TModifyPanel;
begin
  Panel := TModifyPanel.Create(Self);
  Panel.Parent := Self;
  Panel.Align := alBottom;
  Panel.Align := alTop;
  Panel.Height := MODPANEL_HEIGHT;
  Panel.Ctrls[0] := TComboBox.Create(Self);
  with TComboBox(Panel.Ctrls[0]) do
  begin
    Parent := Panel;
    Style := csDropDownList;
    Items.CommaText := 'Add,Delete,Replace';
    Width := MODPANEL_OP_COMBO_WIDTH;
    Top := MODPANEL_CTRL_TOP;
    Left := MODPANEL_LEFT_IND;
    OnChange := OpComboChange;
  end;
  with TLabel.Create(Self) do
  begin
    Caption := 'Operation:';
    Top := MODPANEL_LABEL_TOP;
    Left := MODPANEL_LEFT_IND;
    Parent := Panel;
  end;
end;

procedure TModifyBox.Resize;
begin
  inherited;
  if Assigned(fMemo) then fMemo.Height := fSbPanel.Height - 32;
end;

procedure TModifyBox.Run;
var
  i: Integer;
  op: TModifyOp;
  StopOnError: Boolean;

  { Left string may contain '*' wildcard }
  function Matches(s1, s2: string): Boolean;
  var
    l1, l2: Integer;
  begin
    if s1 = '*' then
    begin
      Result := true;
      Exit;
    end;
    l1 := Pos('*', s1);
    if l1 = 0 then
    begin
      Result := CompareText(s1, s2) = 0;
      Exit;
    end;
    if StrlIComp(PChar(s1), PChar(s2), l1 - 1) <> 0 then
    begin
      Result := false;
      Exit;
    end;
    l2 := Length(s1) - l1;
    if l2 = 0 then
    begin
      Result := true;
      Exit;
    end;
    if l2 > Length(s2) then
    begin
      Result := false;
      Exit;
    end;
    Result := CompareText(Copy(s1, l1 + 1, MaxInt), Copy(s2, Length(s2) - l2 + 1, MaxInt)) = 0;
  end;

  procedure Add(Entry: TLdapEntry; AName, AValue: string);
  begin
    if AValue <> '' then
      Entry.AttributesByName[AName].AddValue(AValue);
  end;

  procedure Replace(Entry: TLdapEntry; AName, OldValue, NewValue: string);
  var
    i: Integer;
  begin
    if (OldValue = '') or (NewValue = '') then Exit;
    with Entry.AttributesByName[AName] do
    for i := 0 to ValueCount - 1 do
      if Matches(OldValue, Values[i].AsString) then
        Values[i].AsString := NewValue;
  end;

  procedure Delete(Entry: TLdapEntry; AName, AValue: string);
  var
    i: Integer;
  begin
    with Entry.AttributesByName[AName] do
      for i := 0 to ValueCount - 1 do
        if Matches(AValue, Values[i].AsString) then
          Values[i].Delete;
  end;

  procedure DoModify(Entry: TLdapEntry);
  var
    i: Integer;
  begin
    for i := 0 to fOpList.Count - 1 do with TModifyOp(fOpList[i]) do
      if AttributeName <> '' then
        case LdapOperation of
          LdapOpAdd:     Add(Entry, AttributeName, FormatValue(Value1, Entry));
          LdapOpDelete:  Delete(Entry, AttributeName, FormatValue(Value1, Entry));
          LdapOpReplace: Replace(Entry, AttributeName, FormatValue(Value1, Entry), FormatValue(Value2, Entry));
        end;
    if esModified in Entry.State then
    begin
      Entry.Write;
      fMemo.Lines.Add(Entry.dn + ': Ok.');
    end
    else
      fMemo.Lines.Add(Entry.dn + ': Skipped.');
  end;

begin
  if not Assigned(fSearchList) then Exit;

  for i := ControlCount - 1 downto 0 do with (Controls[i] as TModifyPanel) do
  begin
    if (Ctrls[1] as TComboBox).Text <> '' then
    begin
      op := TModifyOp.Create;
      fOpList.Add(op);
      op.LdapOperation := (Ctrls[0] as TComboBox).ItemIndex;
      op.AttributeName := (Ctrls[1] as TComboBox).Text;
      op.Value1 := (Ctrls[2] as TEdit).Text;
      if op.LdapOperation = LdapOpReplace then
        op.Value2 := (Ctrls[3] as TEdit).Text;
    end;
    Free;
  end;

  fProgressBar.Max := SearchList.Entries.Count;
  fSbPanel.Parent := Self; // show the result panel;
  fSbPanel.Repaint;

  StopOnError := true;
  fState := mbxRunning;
  fTimer.Enabled := true;
  for i := 0 to SearchList.Entries.Count - 1 do
  begin
    try
      DoModify(fSearchList.Entries[i]);
      Application.ProcessMessages;
      if fState <> mbxRunning then Break;
    except
      on E: Exception do begin
        fTimer.Enabled := false;
        fMemo.SelAttributes.Color := clRed;
        fMemo.Lines.Add(fSearchList.Entries[i].dn + ': ' + E.Message);
        if StopOnError then
          case MessageDlgEx(Format(stSkipRecord, [E.Message]), mtError, [mbYes, mbNo, mbCancel], ['Skip', 'Skip all', 'Cancel'],[]) of
            mrCancel: break;
            mrNo: StopOnError := false;
          end;
        fTimer.Enabled := true;
      end;
    end;
    fProgressBar.StepIt;
  end;
  fTimer.Enabled := false;
  fState := mbxdone;
  fCloseButton.Caption := '&Ok';
end;

procedure TModifyBox.SaveResults(const Filename: string);
begin
  fMemo.Lines.SaveToFile(FileName);
end;

constructor TModifyBox.Create(AOwner: TComponent; AConnection: TConnection);
var
  L: TLabel;
begin
  inherited Create(AOwner);
  fOpList := TObjectList.Create;
  fSchema := AConnection.Schema;
  fTimer := TTimer.Create(Self);
  fTimer.Enabled := false;
  fTimer.Interval := 50;
  fTimer.OnTimer := DoTimer;
  fSbPanel := TPanel.Create(Self);
  with fSbPanel do begin
    Parent := Self;
    Align := alClient;
  end;
  fProgressBar := TProgressBar.Create(fSbPanel);
  fCloseButton := TButton.Create(fSbPanel);
  with fCloseButton do begin
    Parent := fSbPanel;
    Height := 23;
    Width := 65;
    Top := MODPANEL_LABEL_TOP - 4;
    Left := fSBPanel.Width - Width - MODPANEL_LEFT_IND;
    Caption := 'Cancel';
    Anchors := [akTop, akRight];
    OnClick := ButtonClick;
  end;
  L := TLabel.Create(fSbPanel);
  with L do begin
    Left := MODPANEL_LEFT_IND;
    Top := MODPANEL_LABEL_TOP;
    Caption := cProgress;
    Parent := fSbPanel;
  end;
  with fProgressBar do begin
    Parent := fSbPanel;
    Top := MODPANEL_LABEL_TOP;
    Left := L.Width + 2 * MODPANEL_LEFT_IND;
    Width := fCloseButton.Left - Left - MODPANEL_LEFT_IND;
    Anchors := Anchors + [akRight];
    Step := 1;
  end;
  fMemo := TRichEdit.Create(fSbPanel);
  with fMemo do begin
    Parent := fSbPanel;
    Align := alBottom;
    ScrollBars := ssBoth;
    ReadOnly := true;
  end;
end;

destructor TModifyBox.Destroy;
begin
  fOpList.Free;
  FSearchList.Free;
  inherited;
end;

procedure TModifyBox.New;
begin
  fMemo.Clear;
  fSbPanel.Parent := nil;
  fProgressBar.Position := 0;
  fCloseButton.Caption := 'Can&cel';
  fOpList.Clear;
  FreeAndNil(fSearchList);
  while ControlCount > 0 do Controls[0].Free;
  fState := mbxNew;
  AddPanel;
end;

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
  with (ActivePage as TResultTabSheet) do
    if Assigned(SearchList) then with SearchList do
      fStatusBar.Panels[1].Text := Format(stCntObjects, [FEntries.Count]);
end;

function TResultPageControl.AddPage: TResultTabSheet;
begin
  result:=TResultTabSheet.Create(self);
  result.PageControl:=self;
end;

procedure TResultPageControl.RemovePage(Page: TResultTabSheet);
begin
  Page.PageControl:=nil;
  Page.Free;
end;

procedure TResultPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ssDouble in Shift) then
    RemovePage(ActivePage);
  inherited;
end;

{ TResultsTabSheet }

constructor TResultTabSheet.Create(AOwner: TComponent);
begin
  inherited;

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
  FSearchList.Free;
  FSorter.Free;
  FListView.Free;
  inherited;
end;

procedure TResultTabSheet.ListViewData(Sender: TObject; Item: TListItem);
var
  i: integer;
  Entry: TLdapEntry;
begin
  with SearchList do begin
    Entry := Entries[Item.Index];
    Item.ImageIndex := (Entry.Session as TConnection).GetImageIndex(Entry);
    Item.Caption:=Entry.dn;
    for i:=0 to Attributes.Count-1 do begin
      Item.SubItems.Add(Entry.AttributesByName[Attributes[i]].AsString);
    end;
  end;
end;

procedure TResultTabSheet.ListViewSort(SortColumn: TListColumn; SortAsc: boolean);
begin
  if not Assigned(SearchList) then exit;
  with SearchList do
  if SortColumn.Tag<0 then Entries.Sort([PSEUDOATTR_DN], SortAsc)
  else Entries.Sort([Attributes[SortColumn.Tag]], SortAsc);
  ListView.Repaint;
end;

procedure TResultTabSheet.SetSearchList(ASearchList: TSearchList);
var
  i, w: integer;
begin
  try
    FSearchList := ASearchList;
    FListView.Items.BeginUpdate;
    FListView.Columns.BeginUpdate;
    w := Width;
    if FSearchList.Attributes.Count > 0 then
      w := (w - 400) div FSearchList.Attributes.Count;
    if w < 40 then w := 40;
    for i:=0 to FSearchList.Attributes.Count-1 do begin
      if FSearchList.Attributes[i] <> '*' then
      with FListView.Columns.Add do begin
        Caption:=FSearchList.Attributes[i];
        Width:=w;
        Tag:=i;
      end;
    end;
    FListView.Columns[0].Width := 400;
  finally
    FListView.Columns.EndUpdate;
    FListView.Items.EndUpdate;
  end;
  FListView.Items.Count:=FSearchList.Entries.Count;
end;

{ TSearchForm }

procedure TSearchFrm.Search(const Filter: string);
var
  Page: TResultTabSheet;
begin
  if Assigned(ResultPages.ActivePage) and not Assigned(ResultPages.ActivePage.SearchList) then
    Page := ResultPages.ActivePage
  else
    Page := ResultPages.AddPage;
  ResultPages.ActivePage := Page;
  Screen.Cursor := crHourGlass;
  try
    Page.SearchList := TSearchList.Create(Connection, cbBasePath.Text,                                          Filter, cbAttributes.Text,                                          cbSearchLevel.ItemIndex,                                          cbDerefAliases.ItemIndex, StatusBar);    Page.Caption := Filter;    Page.ListView.PopupMenu := PopupMenu1;
    Page.ListView.OnDblClick := ListViewDblClick;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TSearchFrm.Modify(const Filter: string);
var
  attrs: string;
  i: Integer;

  procedure ExtractParams(var attrs: string; p: PChar);
  var
    s: string;
  begin
    repeat
      s := GetParameter(p);
      if (s <> '') then
      begin
       if attrs <> '' then attrs := attrs + ',';
       attrs := attrs + s;
      end
      else
        Break;
    until false;
  end;

begin
  Screen.Cursor := crHourGlass;
  try
    attrs := '';
    for i := 0 to ModifyBox.ControlCount - 1 do with (ModifyBox.Controls[i] as TModifyPanel) do
    begin
      if TComboBox(Ctrls[1]).Text <> '' then
      begin
        if attrs <> '' then attrs := attrs + ',';
        attrs := attrs + TComboBox(Ctrls[1]).Text;
      end;
      ExtractParams(attrs, PChar(TEdit(Ctrls[2]).Text));
      ExtractParams(attrs, PChar(TEdit(Ctrls[3]).Text));
    end;
    ModifyBox.SearchList.Free;
    ModifyBox.SearchList := TSearchList.Create(Connection, cbBasePath.Text,                                          Filter, attrs,                                          cbSearchLevel.ItemIndex,                                          cbDerefAliases.ItemIndex, StatusBar);    ModifyBox.Run;  finally
    Screen.Cursor := crDefault;
  end;
end;

constructor TSearchFrm.Create(AOwner: TComponent; const dn: string; AConnection: TConnection);
begin
  inherited Create(AOwner);
  Connection := AConnection;
  if dn <> '' then
    cbBasePath.Text := dn
  else
    cbBasePath.Text := Connection.Base;
  ResultPages := TResultPageControl.Create(self);
  ResultPages.Align := alClient;
  ResultPages.Parent := ResultPanel;
  ResultPages.AddPage;
  ResultPages.ActivePage.Caption := cSearchResults;
  fSearchFilter := GlobalConfig.ReadString(rSearchFilter, sDEFSRCH);
  with Connection.Account do begin
    cbBasePath.Items.CommaText := ReadString(rSearchBase, '');
    cbAttributes.Items.CommaText := ReadString(rSearchAttributes, '');
    cbSearchLevel.ItemIndex := ReadInteger(rSearchScope, 2);
    cbDerefAliases.ItemIndex := ReadInteger(rSearchDerefAliases, 0);
  end;
  AConnection.OnDisconnect.Add(SessionDisconnect);
  StatusBar.Panels[0].Text := Format(cServer, [AConnection.Server]);
  StatusBar.Panels[0].Width := StatusBar.Canvas.TextWidth(StatusBar.Panels[0].Text) + 16;
  ToolBar1.DisabledImages := MainFrm.DisabledImages;
end;

procedure TSearchFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Connection.OnDisconnect.Delete(SessionDisconnect);
  Action := caFree;
  with Connection.Account do begin
    WriteString(rSearchBase, cbBasePath.Items.CommaText);
    WriteString(rSearchAttributes, cbAttributes.Items.CommaText);
    WriteInteger(rSearchScope, cbSearchLevel.ItemIndex);
    WriteInteger(rSearchDerefAliases, cbDerefAliases.ItemIndex);
  end;
end;

procedure TSearchFrm.SessionDisconnect(Sender: TObject);
begin
  Close;
end;

procedure TSearchFrm.ShowModify;
begin
  btnModify.Down := true;
  btnSearchModifyClick(nil);
  Show;
end;

procedure TSearchFrm.FormDestroy(Sender: TObject);
begin
  ResultPanel.Free;
  ModifyBox.Free;
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
  if PageControl.ActivePageIndex = 0 then
  begin
    s := '';
    if edName.Text <> '' then
      s := StringReplace(fSearchFilter, '%s', edName.Text, [rfReplaceAll, rfIgnoreCase]);
    if edEmail.Text <> '' then
      s := Format('%s(mail=*%s*)', [s, edEMail.Text]);
    if s = '' then
      s := sANYCLASS
    else
      s := '(&' + s + ')';
  end
  else
    s := Prepare(Memo1.Text);
  if btnSearch.Down then
    Search(s)
  else
    Modify(s);
end;

procedure TSearchFrm.ActGotoExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    MainFrm.LocateEntry(Selected.Caption, true);
end;

procedure TSearchFrm.ActPropertiesExecute(Sender: TObject);
var
  oi: TObjectInfo;
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
  begin
    oi := TObjectInfo.Create(ResultPages.ActivePage.SearchList.Entries[ResultPages.ActiveList.Selected.Index], false);
    try
      MainFrm.EditProperty(Self, oi);
    finally
      oi.Free;
    end;
  end;
end;

procedure TSearchFrm.ActSaveExecute(Sender: TObject);

  procedure ToLdif;
  var
    ldif: TLdifFile;
    i: Integer;
  begin
    ldif := TLDIFFile.Create(SaveDialog.FileName, fmWrite);
    ldif.UnixWrite := SaveDialog.FilterIndex = 2;
    with ResultPages.ActivePage.SearchList do try
      for i := 0 to Entries.Count - 1 do
        ldif.WriteRecord(Entries[i]);
    finally
      ldif.Free;
    end;
  end;

  procedure ToCSV;
  var
    i: Integer;
    csvList: TStringList;
    s: string;
  begin
    csvList := TStringList.Create;
    with ResultPages.ActivePage.ListView do
    try
      for i := 0 to Items.Count - 1 do with Items[i] do
      begin
        s := '"' + Caption + '"';
        if SubItems.Count > 0 then
          s := s + ',' + SubItems.CommaText;
        csvList.Add(s);
      end;
      csvList.SaveToFile(SaveDialog.FileName);
    finally
      csvList.Free;
    end;
  end;

  procedure ToXml;
  var
    DsmlTree: TDsmlTree;
  begin
    DsmlTree := TDsmlTree.Create(ResultPages.ActivePage.SearchList.Entries);
    try
      DsmlTree.SaveToFile(SaveDialog.FileName);
    finally
      DsmlTree.Free;
    end;
  end;

begin
  if btnSearch.Down then
  begin
    with ResultPages, ActivePage do
    if Assigned(ActivePage) and (SearchList.Entries.Count > 0) then
    begin
      SaveDialog.Filter := SAVE_SEARCH_FILTER;
      SaveDialog.DefaultExt := SAVE_SEARCH_EXT;
      if SaveDialog.Execute then
        case SaveDialog.FilterIndex of
          1, 2: ToLdif;
          3:    ToCSV;
          4:    ToXml;
        end;
    end;
  end
  else
  if Assigned(ModifyBox) then
  begin
    SaveDialog.Filter := SAVE_MODIFY_FILTER;
    SaveDialog.DefaultExt := SAVE_MODIFY_EXT;
    if SaveDialog.Execute then
      ModifyBox.SaveResults(SaveDialog.FileName);
  end;
end;

procedure TSearchFrm.ActEditExecute(Sender: TObject);
begin
  with ResultPages, ActiveList do
  if Assigned(ActiveList) and Assigned(Selected) then
    TEditEntryFrm.Create(Self, Selected.Caption, Connection, EM_MODIFY).ShowModal;
end;

procedure TSearchFrm.ActCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TSearchFrm.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Enbl: Boolean;
begin
  ActStart.Enabled := (not (Assigned(ModifyBox) and ModifyBox.Visible) or (ModifyBox.State = mbxReady)) and (PageControl.ActivePageIndex <> 2);
  ActClearAll.Enabled := Assigned(ResultPages.ActivePage) and Assigned(ResultPages.ActivePage.SearchList);
  Enbl := Assigned(ResultPages.ActiveList) and (ResultPages.ActiveList.Items.Count > 0);
  ActSave.Enabled := Enbl or (Assigned(ModifyBox) and ModifyBox.Visible and (ModifyBox.State = mbxDone));
  Enbl := Enbl and ActStart.Enabled and Assigned(ResultPages.ActiveList.Selected);
  ActGoto.Enabled := Enbl;
  ActEdit.Enabled := Enbl;
  if Enbl then
  with TObjectInfo.Create(ResultPages.ActivePage.SearchList.Entries[ResultPages.ActiveList.Selected.Index], false) do begin
    ActProperties.Enabled := Supported;
    Free;
  end
  else
    ActProperties.Enabled := false;
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
  with TPickAttributesDlg.Create(Self, Connection.Schema, cbAttributes.Text) do
  begin
    ShowModal;
    cbAttributes.Text := Attributes;
  end;
end;

procedure TSearchFrm.SaveFilterBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with cbFilters do begin
    if Text = '' then Exit;
    idx := Items.IndexOf(Text);
    if idx = - 1 then
      Items.Add(Text);
    Connection.Account.WriteString(rSearchCustFilters + Text, Memo1.Text);
  end;
end;

procedure TSearchFrm.cbFiltersChange(Sender: TObject);
var
  idx: Integer;
begin
  with cbFilters do begin
    SaveFilterBtn.Enabled := Text <> '';
    DeleteFilterBtn.Enabled := SaveFilterBtn.Enabled;
    idx := Items.IndexOf(Text);
    if idx <> -1 then
      Memo1.Text := Connection.Account.ReadString(rSearchCustFilters + Text);
  end;
end;

procedure TSearchFrm.DeleteFilterBtnClick(Sender: TObject);
var
  idx: Integer;
begin
  with cbFilters do begin
    idx := Items.IndexOf(Text);
    if idx <> -1 then
    begin
      Connection.Account.Delete(rSearchCustFilters + Text);
      Items.Delete(idx);
    end;
  end;
end;

procedure TSearchFrm.cbFiltersDropDown(Sender: TObject);
var
  FilterNames: TStrings;
  i: Integer;
begin
  if cbFilters.Tag = 0 then
  begin
    FilterNames := TStringList.Create;
    try
      Connection.Account.GetValueNames(rSearchCustFilters, FilterNames);
      for i := 0 to FilterNames.Count - 1 do
        cbFilters.Items.Add(FilterNames[i]);
    finally
      FilterNames.Free;
    end;
    cbFilters.Tag := 1;
  end;
end;

procedure TSearchFrm.FormDeactivate(Sender: TObject);
begin
  RevealWindow(Self, False, True);
end;

procedure TSearchFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not (Assigned(ModifyBox) and (ModifyBox.State = mbxRunning));
end;

procedure TSearchFrm.btnSearchModifyClick(Sender: TObject);
begin
  StartBtn.Glyph := nil;
  if btnSearch.Down then
  begin
    if Assigned(ModifyBox) then ModifyBox.Visible := false;
      ResultPanel.Visible := true;
    MainFrm.ImageList.GetBitmap(20, StartBtn.Glyph);
  end
  else begin
    if not Assigned(ModifyBox) then
    begin
      ModifyBox := TModifyBox.Create(Self, Connection);
      ModifyBox.Align := alClient;
      ModifyBox.Parent := Self;
      ModifyBox.New;
    end;
    ResultPanel.Visible := false;
    ModifyBox.Visible := true;
    MainFrm.ImageList.GetBitmap(38, StartBtn.Glyph);
  end;
end;

procedure TSearchFrm.ActClearAllExecute(Sender: TObject);
begin
  LockControl(ResultPages, true);
  with ResultPages do
  try
    while PageCount > 0 do
      RemovePage(ActivePage);
    ResultPages.AddPage;
    ResultPages.ActivePage.Caption := cSearchResults;
  finally
    LockControl(ResultPages, false);
  end;
end;

end.
