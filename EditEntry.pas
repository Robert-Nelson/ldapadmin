  {      LDAPAdmin - EditEntry.pas
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

unit EditEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, WinLDAP, Grids, ToolWin, LDAPClasses, Constant,
  Menus, ImgList, ActnList;

const
  cBinary = Pointer(-1);
  sBinary = '*BINARY**BINARY**BINARY**BINARY**BINARY**BINARY**BINARY**BINARY**BINARY**BINARY**BINARY**BINARY*...';

type
  TEditEntryFrm = class(TForm)
    StringGrid: TStringGrid;
    Panel2: TPanel;
    EditDN: TEdit;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    SaveBtn: TToolButton;
    InsertCellsBtn: TToolButton;
    DeleteCellsBtn: TToolButton;
    ToolButton4: TToolButton;
    ExitBtn: TToolButton;
    ToolButton6: TToolButton;
    MainMenu1: TMainMenu;
    Start1: TMenuItem;
    Bearbeiten1: TMenuItem;
    mbSave: TMenuItem;
    N1: TMenuItem;
    mbExit: TMenuItem;
    mbInsertRow: TMenuItem;
    mbDeleteRow: TMenuItem;
    N2: TMenuItem;
    mbCut: TMenuItem;
    mbRestore: TMenuItem;
    mbCopy: TMenuItem;
    mbPaste: TMenuItem;
    mbDelete: TMenuItem;
    UndoBtn: TToolButton;
    CutBtn: TToolButton;
    CopyBtn: TToolButton;
    PasteBtn: TToolButton;
    DeleteBtn: TToolButton;
    ToolButton8: TToolButton;
    PopupMenu1: TPopupMenu;
    mbInsertRow1: TMenuItem;
    mbDeleteRow1: TMenuItem;
    N4: TMenuItem;
    mbRestore1: TMenuItem;
    mbCut1: TMenuItem;
    mbCopy1: TMenuItem;
    mbPaste1: TMenuItem;
    mbDelete1: TMenuItem;
    N3: TMenuItem;
    mbLoadFromFile: TMenuItem;
    mbSaveToFile: TMenuItem;
    mbViewBinary: TMenuItem;
    N5: TMenuItem;
    OpenFileDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    N8: TMenuItem;
    mbLoadFromFile1: TMenuItem;
    mbSaveToFile1: TMenuItem;
    N9: TMenuItem;
    mbViewBinary1: TMenuItem;
    ActionList1: TActionList;
    ActSave: TAction;
    ActClose: TAction;
    ActInsertRow: TAction;
    ActDeleteRow: TAction;
    ActUndo: TAction;
    ActCut: TAction;
    ActCopy: TAction;
    ActPaste: TAction;
    ActDelete: TAction;
    ActLoadFile: TAction;
    ActSaveFile: TAction;
    ActBinView: TAction;
    procedure StringGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mbSaveClick(Sender: TObject);
    procedure mbExitClick(Sender: TObject);
    procedure mbInsertRowClick(Sender: TObject);
    procedure mbDeleteRowClick(Sender: TObject);
    procedure PushShortCutClick(Sender: TObject);
    procedure ToolBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure mbLoadFromFileClick(Sender: TObject);
    procedure mbSaveToFileClick(Sender: TObject);
    procedure mbViewBinaryClick(Sender: TObject);
    procedure StringGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGridEnter(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
  private
    Entry: TLDAPEntry;
    SaveVal: string;
    procedure SimulateCellClick(ACol, ARow: Integer);
    procedure PushShortCut(Command: TAction);
    procedure AddRow;
    procedure InsertRow(Index: Integer);
    procedure DeleteRow(Index: Integer);
    procedure Load;
    function NewValue(Attr: TLdapAttribute): TLdapAttributeData;
  public
    constructor Create(const AOwner: TComponent; const adn: string;
                       const ASession: TLDAPSession; const Mode: TEditMode); reintroduce; overload;
  end;

var
  EditEntryFrm: TEditEntryFrm;

implementation

uses BinView, Misc, Main;

{$R *.DFM}

function IsString(s: string): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(Length(s));
  Result := (l < Word(-1)) and (StrLen(PChar(s)) = l);
end;

procedure TEditEntryFrm.SimulateCellClick(ACol, ARow: Integer);
var
  Rect: TRect;
  X, Y: Integer;
  DeltaX, DeltaY: Double;
begin
  DeltaX := (65536.0 / Screen.Width);
  DeltaY := (65536.0 / Screen.Height);
  X := Round(Mouse.CursorPos.X * DeltaX);
  Y := Round(Mouse.CursorPos.Y * DeltaY);
  Rect := StringGrid.CellRect(ACol, ARow);
  Rect.BottomRight := StringGrid.ClientToScreen(Rect.BottomRight);
  Rect.BottomRight.x := Round((Rect.BottomRight.x - 1) * DeltaX);
  Rect.BottomRight.y := Round((Rect.BottomRight.y - 1) * DeltaY);
  mouse_event(MOUSEEVENTF_ABSOLUTE + MOUSEEVENTF_MOVE, Rect.Right, Rect.Bottom, 0, 0);
  mouse_event(MOUSEEVENTF_LEFTDOWN + MOUSEEVENTF_ABSOLUTE, Rect.Right, Rect.Bottom, 0, 0);
  mouse_event(MOUSEEVENTF_LEFTUP + MOUSEEVENTF_ABSOLUTE, Rect.Right, Rect.Bottom, 0, 0);
  mouse_event(MOUSEEVENTF_ABSOLUTE + MOUSEEVENTF_MOVE, X, Y, 0, 0);
end;

procedure TEditEntryFrm.PushShortCut(Command: TAction);
var
  vKey, shift: word;
  c: byte;
  ShiftState: TShiftState;
begin
  ShortCutToKey(Command.ShortCut, vKey, ShiftState);
  c := lobyte(vKey);
  if ssCtrl in ShiftState then
    shift := VK_CONTROL
  else
  if ssShift in ShiftState then
      shift := VK_SHIFT
  else
    shift := 0;

  if shift <> 0 then
    keybd_event(shift, 1,0,0);                              // press shift key

  keybd_event(c, MapVirtualKey(c, 0), 0, 0);                // press key
  keybd_event(c, MapVirtualKey(c, 0), KEYEVENTF_KEYUP, 0);  // release key

  if shift <> 0 then
    keybd_event(VK_CONTROL, 1, KEYEVENTF_KEYUP, 0);         // release shift key

  Command.ShortCut := 0;                                    // deaktivate accelerator
  Application.ProcessMessages;
  Command.ShortCut := ShortCut(Word(vKey), ShiftState);     // reaktivate accelerator
end;

procedure TEditEntryFrm.AddRow;
begin
  with StringGrid do RowCount := RowCount + 1;
end;

procedure TEditEntryFrm.InsertRow(Index: Integer);
var
  i: Integer;
begin
  with StringGrid do
  begin
    AddRow;
    Col := 0;
    for i := RowCount downto row + 1 do
      Rows[i] := Rows[i-1];
    Rows[Row].Clear;
    SetFocus;
  end;
end;

procedure TEditEntryFrm.DeleteRow(Index: Integer);
var
  i: Integer;
begin
  with StringGrid do
  begin
    if Assigned(Objects[1, Index]) then
      TLdapAttributeData(Objects[1, Index]).Delete;
    Rows[Index].Clear;
    if RowCount > 2 then
    begin
      for i := Index to RowCount - 2 do
        Rows[i] := Rows[i+1];
      if (Row = Index) and (Index = RowCount - 1) then
        Row := Row - 1;
      Rows[RowCount-1].Clear;
      RowCount := RowCount - 1;
      Col := 0;
    end;
  end;
end;

constructor TEditEntryFrm.Create(const AOwner: TComponent; const adn: string;
                                 const ASession: TLDAPSession; const Mode: TEditMode);
begin
  inherited Create(AOwner);
  Entry := TLDAPEntry.Create(ASession, adn);
  if Mode = EM_MODIFY then
  begin
    Caption := Format(cEditEntry, [adn]);
    EditDN.ReadOnly := true;
    EditDN.Text := adn;
    Load;
  end
  else begin
    Caption := cNewEntry;
    EditDN.Text := ',' + adn;
  end;
  with StringGrid do
  begin
    Cells[0,0] := 'Attribute';
    Cells[1,0] := 'Value';
    SaveVal := Cells[Col, Row];
  end;
end;

procedure TEditEntryFrm.StringGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with StringGrid do
  case Key of
    VK_TAB:    if not (ssShift in Shift) and (Col = ColCount - 1) and (Row = RowCount - 1) then
                 AddRow;
    {VK_INSERT: if (ssCtrl in Shift) then
               begin
                 InsertRow(StringGrid.Row);
                 Key := 0;
               end;
    VK_DELETE: if (ssCtrl in Shift) then
               begin
                 DeleteRow(StringGrid.Row);
                 Key := 0;
               end;}
    VK_ESCAPE: Cells[Col, Row] := SaveVal;
  end;
end;

procedure TEditEntryFrm.Load;
var
  i, j: Integer;
  fItems: TStringList;
  s: string;
begin
  Entry.Read;
  fItems := TStringList.Create;
  for i := 0 to Entry.Attributes.Count - 1 do with Entry.Attributes[i] do
  for j := 0 to ValueCount - 1 do
    fItems.AddObject(Name, Values[j]);
  fItems.Sorted := true;

  with StringGrid do
  begin
    RowCount := 2;
    Rows[1].Clear;
    for I := 0 to fItems.Count - 1 do
    begin
      if I = RowCount - 1 then
        RowCount := RowCount + 1;
      Cells[0, I + 1] := fItems[I];
      s := TLdapAttributeData(fItems.Objects[I]).AsString;
      if IsString(s) then
        Cells[1, I + 1] := s
      else
      begin
        Objects[0, I + 1] := cBinary;
        Cells[1, I + 1] := sBinary;
      end;
      Objects[1, I + 1] := fItems.Objects[I];
    end;
  end;
  fItems.Free;
end;

{ Yet again workaround for to attributes with no equality matching rule }
function TEditEntryFrm.NewValue(Attr: TLdapAttribute): TLdapAttributeData;
begin
  if (Attr.ValueCount = 1) and (Attr.Values[0].ModOp = LdapOpDelete) then
    Result := Attr.Values[0]
  else
    Result := Attr.AddValue;
end;

procedure TEditEntryFrm.StringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  with StringGrid do
  begin
    if (ACol = 1) and (Cells[0, ARow] = '') then
    begin
      CanSelect := false;
      exit;
    end;
    SimulateCellClick(ACol, ARow);
    SaveVal := StringGrid.Cells[ACol, ARow];
    if ((ACol = 0 ) and (Cells[0, ARow] = '')) or ((ACol = 1) and (Objects[0, ARow] <> cBinary)) then
      Options := Options + [goEditing]
    else
      Options := StringGrid.Options - [goEditing];
  end;
end;

procedure TEditEntryFrm.mbSaveClick(Sender: TObject);
begin
  if esNew in Entry.State then
    Entry.Dn := EditDn.Text;
  Entry.Write;
  Close;
  with MainFrm, LdapTree do
  begin
    if Assigned(Selected) and (PChar(Selected.Data) = Entry.dn) then
      LDAPTreeChange(nil, LDAPTree.Selected);
  end;
end;

procedure TEditEntryFrm.mbExitClick(Sender: TObject);
begin
  Close;
end;

procedure TEditEntryFrm.mbInsertRowClick(Sender: TObject);
begin
  InsertRow(StringGrid.Row);
end;

procedure TEditEntryFrm.mbDeleteRowClick(Sender: TObject);
begin
  DeleteRow(StringGrid.Row);
end;

procedure TEditEntryFrm.PushShortCutClick(Sender: TObject);
begin
  PushShortCut(Sender as TAction);
end;

procedure TEditEntryFrm.ToolBtnClick(Sender: TObject);
begin
  if Sender = UndoBtn then
    PushShortcut(ActUndo)
  else
  if Sender = CutBtn then
    PushShortcut(ActCut)
  else
  if Sender = CopyBtn then
    PushShortcut(ActCopy)
  else
  if Sender = PasteBtn then
    PushShortcut(ActPaste)
  else
  if Sender = DeleteBtn then
    PushShortcut(ActDelete)
end;

procedure TEditEntryFrm.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

procedure TEditEntryFrm.StringGridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
begin
  if (ACol = 1) and (Value <> '') then with StringGrid do
  begin
    if not Assigned(Objects[ACol, ARow]) then
    begin
      //Objects[ACol, ARow] := Entry.AttributesByName[Cells[0, ARow]].AddValue;
      Objects[ACol, ARow] := NewValue(Entry.AttributesByName[Cells[0, ARow]]);
      { Object assign invalidates cell causing the inplace editor to select the text.
        Since we have no access to inplace editor to unselect or prevent selecting
        we simulate a mouseclick which will unselect the text automatically }
      SimulateCellClick(ACol, ARow);
    end;
    if Objects[0, ARow] <> cBinary then
      TLdapAttributeData(Objects[ACol, ARow]).AsString := Value;
  end;
end;

procedure TEditEntryFrm.mbLoadFromFileClick(Sender: TObject);
var
  FileStream: TFileStream;
  s: string;
begin
  if not OpenFileDialog.Execute then Exit;
  FileStream := TFileStream.Create(OpenFileDialog.FileName, fmOpenRead);
  with StringGrid do
  try
    if Cells[0, Row] <> '' then
    begin
      if not Assigned(Objects[1, Row]) then
        //Objects[1, Row] := Entry.AttributesByName[Cells[0, Row]].AddValue;
        Objects[1, Row] := NewValue(Entry.AttributesByName[Cells[0, Row]]);
      FileStream.Position := 0;
      TLdapAttributeData(Objects[1, Row]).LoadFromStream(FileStream);
      s := TLdapAttributeData(Objects[1, Row]).AsString;
      if IsString(s) then
        Cells[1, Row] := s
      else begin
        Objects[0, Row] := cBinary;
        Cells[1, Row] := sBinary;
        Col := 0;
      end;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TEditEntryFrm.mbSaveToFileClick(Sender: TObject);
var
  FileStream: TFileStream;
begin
  with SaveFileDialog do
  begin
    if not Execute or (FileExists(FileName) and
       (MessageDlg(Format(stFileOverwrite, [FileName]), mtConfirmation, [mbYes, mbCancel], 0) <> mrYes)) then Exit;
    with StringGrid do
    if Assigned(Objects[1, Row]) then
    begin
      FileStream := TFileStream.Create(FileName, fmCreate);
      with TLdapAttributeData(Objects[1, Row]) do
      try
        SaveToStream(FileStream);
      finally
        FileStream.Free;
      end;
    end;
  end;
end;

procedure TEditEntryFrm.mbViewBinaryClick(Sender: TObject);
begin
  with StringGrid do
  if Assigned(Objects[1, Row]) then
  with THexView.Create(Self) do try
    StreamCopy(TLdapAttributeData(Objects[1, Row]).SaveToStream, LoadFromStream);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TEditEntryFrm.StringGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: Tpoint;
  ACol, ARow: Integer;
begin
  if ssRight in Shift then with StringGrid do
  begin
    MouseToCell(X, Y, ACol, ARow);
    if ((ACol = 0 ) and (Cells[0, ARow] = '')) or ((ACol = 1) and (Objects[0, ARow] <> cBinary)) then
      Options := Options + [goEditing]
    else
      Options := Options - [goEditing];
    if (ARow > 0) and (ARow < RowCount) and (ACol >= 0) and (ACol < ColCount) then
    begin
      try
        OnSelectCell := nil;
        Row := ARow;
        Col := ACol;
      finally
        OnSelectCell := StringGridSelectCell;
      end;
      p.x := 0;
      p.y := 0;
      p := ClientToScreen(p);
      PopupMenu1.Popup(X + p.x, y + p.y);
    end;
  end;
end;

procedure TEditEntryFrm.StringGridEnter(Sender: TObject);
begin
  with StringGrid do
  if (Col = 0) and (Row=1) and (Cells[Col, Row] = '') then
    SimulateCellClick(Col, Row);
end;

procedure TEditEntryFrm.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  Enable: Boolean;
begin
  with StringGrid do Enable := (Col = 1) and (Objects[0, Row] <> cBinary);
  ActUndo.Enabled := Enable;
  ActCut.Enabled := Enable;
  ActCopy.Enabled := Enable;
  ActPaste.Enabled := Enable;
  ActDelete.Enabled := Enable;
end;

end.
