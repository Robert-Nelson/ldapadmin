  {      LDAPAdmin - EditEntry.pas
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

unit EditEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, WinLDAP, Grids, ToolWin, LDAPClasses, Constant,
  Menus, ImgList;

const
  cNewRow = Pointer(-1);

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
  private
    Entry: TLDAPEntry;
    fdn: string;
    fSession: TLDAPSession;
    EditMode: TEditMode;
    SaveVal: string;
    procedure PushShortCut(Command: TMenuItem);
    procedure AddRow;
    procedure InsertRow(Index: Integer);
    procedure DeleteRow(Index: Integer);
    procedure Load;
    procedure Modify;
  public
    constructor Create(const AOwner: TComponent; const adn: string;
                       const ASession: TLDAPSession; const Mode: TEditMode); reintroduce; overload;
  end;

var
  EditEntryFrm: TEditEntryFrm;

implementation

{$R *.DFM}

procedure TEditEntryFrm.PushShortCut(Command: TMenuItem);
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
  with StringGrid do begin
    RowCount := RowCount + 1;
    Objects[0,RowCount - 1] := cNewRow;
  end;
end;

procedure TEditEntryFrm.InsertRow(Index: Integer);
var
  i: Integer;
begin
  with StringGrid do
  begin
    AddRow;
    for i := RowCount downto row + 1 do
      Rows[i] := Rows[i-1];
    Rows[Row].Clear;
    Objects[0,Row] := cNewRow;
    Col := 0;
  end;
end;

procedure TEditEntryFrm.DeleteRow(Index: Integer);
var
  i: Integer;
begin
  with StringGrid do
  begin
    Rows[Row].Clear;
    if RowCount > 2 then
    begin
      for i := row to RowCount - 2 do
        Rows[i] := Rows[i+1];
      if Row = RowCount - 1 then
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
  fdn := adn;
  fSession := ASession;
  EditMode := Mode;
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
  I: Integer;
begin
  Entry := TLDAPEntry.Create(fSession, fdn);
  Entry.Read;
  Entry.Items.Sort;
  with StringGrid do
  begin
    RowCount := 2;
    Rows[1].Clear;
    for I := 0 to Entry.Items.Count - 1 do
    begin
      if I = RowCount - 1 then
        RowCount := RowCount + 1;
      Cells[0, I + 1] := Entry.Items[I];
      Cells[1, I + 1] := PChar(Entry.Items.Objects[I]);
      Objects[0, I + 1] := Pointer(I);
    end;
  end;
end;

procedure TEditEntryFrm.Modify;
var
  i, idx: Integer;
begin
  with StringGrid do
  begin
    Entry.ClearAttrs;
    // First pass: handle replaced or deleted attribute/value pairs
    idx := 0;
    for i := 1 to RowCount - 1 do
    begin
      if (Objects[0, i] <> cNewRow) and (Cells[0, i] <> '') then
      begin
        while (Integer(Objects[0, i]) <> idx) and (idx < Entry.Items.Count - 1) do
        begin
          Entry.AddAttr(Entry.Items[idx], PChar(Entry.Items.Objects[idx]), LDAP_MOD_DELETE);
          inc(idx);
          Objects[0, i] := Pointer(idx);
        end;
        if AnsiStrIComp(PChar(Cells[0, i]), PChar(Entry.Items[idx])) <> 0 then
        begin
          Entry.AddAttr(Entry.Items[idx], PChar(Entry.Items.Objects[idx]), LDAP_MOD_DELETE);
          Entry.AddAttr(Cells[0, i], Cells[1, i], LDAP_MOD_ADD);
        end;
        inc(idx)
      end;
    end;
    // Second pass: handle modified attributes
    for i := 1 to RowCount - 1 do
    begin
      if (Objects[0, i] <> cNewRow) and (Cells[0, i] <> '') then
        Entry.AddAttr(Cells[0, i], Cells[1, i], LDAP_MOD_REPLACE)
    end;
    // Third pass: handle added attributes
    for i := 1 to RowCount - 1 do
      if (Objects[0, i] = cNewRow) and (Cells[0, i] <> '') then
        Entry.AddAttr(Cells[0, i], Cells[1, i], LDAP_MOD_ADD);

    Entry.Modify;
  end;

end;


procedure TEditEntryFrm.StringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  SaveVal := StringGrid.Cells[ACol, ARow];
end;

procedure TEditEntryFrm.mbSaveClick(Sender: TObject);
var
  i: Integer;
begin
  if EditMode = EM_ADD then
  begin
    Entry := TLDAPEntry.Create(fSession, EditDN.Text);
    for i := 1 to StringGrid.RowCount - 1 do
      Entry.AddAttr(StringGrid.Cells[0, i], StringGrid.Cells[1, i], LDAP_MOD_ADD);
    Entry.New;
  end
  else
    Modify;
  Close;
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
  PushShortCut(Sender as TMenuItem);
end;

procedure TEditEntryFrm.ToolBtnClick(Sender: TObject);
begin
  if Sender = UndoBtn then
    PushShortcut(mbRestore)
  else
  if Sender = CutBtn then
    PushShortcut(mbCut)
  else
  if Sender = CopyBtn then
    PushShortcut(mbCopy)
  else
  if Sender = PasteBtn then
    PushShortcut(mbPaste)
  else
  if Sender = DeleteBtn then
    PushShortcut(mbDelete)
end;

end.
