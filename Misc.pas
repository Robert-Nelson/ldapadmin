  {      LDAPAdmin - Misc.pas
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

unit Misc;

interface

uses LdapClasses, Classes, ComCtrls, Windows, Graphics, Forms, Dialogs, Controls;

type
  TStreamProcedure = procedure(Stream: TStream) of object;

  TLVSorterOnSort=procedure(SortColumn:  TListColumn; SortAsc: boolean) of object;

  TListViewSorter=class
  private
    FListView:      TListView;
    FSortColumn:    TListColumn;
    FSortAsc:       boolean;
    FBmp:           TBitmap;
    FOnColumnClick: TLVColumnClickEvent;
    FOnCustomDraw:  TLVCustomDrawEvent;
    FOnSort:        TLVSorterOnSort;
    procedure       SetSortMark; overload;
    procedure       SetSortMark(Column: TListColumn); overload;
    procedure       SetListView(const Value: TListView);
    procedure       DoCustomDraw(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean);
    procedure       DoColumnClick(Sender: TObject; Column: TListColumn);
    procedure       DoCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  public
    constructor     Create; reintroduce;
    destructor      Destroy; override;
    property        ListView: TListView read FListView write SetListView;
    property        SortColumn:  TListColumn read FSortColumn;
    property        SortAsc: boolean read FSortAsc;
    property        OnSort: TLVSorterOnSort read FOnSort write FOnSort;
  end;

{ String conversion routines }
function UTF8ToStringLen(const src: PChar; const Len: Cardinal): widestring;
function StringToUTF8Len(const src: PChar; const Len: Cardinal): string;
{ Time conversion routines }
function  DateTimeToUnixTime(const AValue: TDateTime): Int64;
function  UnixTimeToDateTime(const AValue: Int64): TDateTime;
function  LocalDateTimeToUTC(DateTime: TDateTime): TDateTime;
{ URL handling routines }
procedure ParseURL(const URL: string; var proto, user, password, host, path: string; var port: integer);
{ Some handy dialogs }
function  CheckedMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; CbCaption: string; var CbChecked: Boolean): TModalResult;
function  ComboMessageDlg(const Msg: string; const csItems: string; var Text: string): TModalResult;
function MessageDlgEx(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Captions: array of string; Events: array of TNotifyEvent): TModalResult;
{ everything else :-) }
function  HexMem(P: Pointer; Count: Integer; Ellipsis: Boolean): string;
function  FormatMemoInput(const Text: string): string;
function  FormatMemoOutput(const Text: string): string;
procedure StreamCopy(pf, pt: TStreamProcedure);
procedure LockControl(c: TWinControl; bLock: Boolean);
function  PeekKey: Integer;
procedure ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
function  SupportedPropertyObjects(const Index: Integer): Boolean;
procedure RevealWindow(Form: TForm; MoveLeft, MoveTop: Boolean);

const
  mrCustom   = 1000;

implementation

uses SysUtils, CommCtrl, StdCtrls, Messages, Constant;

{ String conversion routines }

{ Note: these functions ignore conversion errors }
function UTF8ToStringLen(const src: PChar; const Len: Cardinal): widestring;
var
  l: Integer;
begin
  SetLength(Result, Len);
  l := MultiByteToWideChar( CP_UTF8, 0, src, Len, PWChar(Result), Len*SizeOf(WideChar));
  SetLength(Result, l);
end;

function StringToUTF8Len(const src: PChar; const Len: Cardinal): string;
var
  bsiz: Integer;
  Temp: string;
begin
  bsiz := Len * 3;
  SetLength(Temp, bsiz);
  if bsiz > 0 then
  begin
    StringToWideChar(src, PWideChar(Temp), bsiz);
    SetLength(Result, bsiz);
    bsiz := WideCharToMultiByte(CP_UTF8, 0, PWideChar(Temp), Len, PChar(Result), bsiz, nil, nil);
    SetLength(Result, bsiz);
  end;
end;

{ Time conversion routines }

function DateTimeToUnixTime(const AValue: TDateTime): Int64;
begin
  Result := Round((AValue - 25569.0) * 86400)
end;

function UnixTimeToDateTime(const AValue: Int64): TDateTime;
begin
  Result := AValue / 86400 + 25569.0;
end;

function LocalDateTimeToUTC(DateTime: TDateTime): TDateTime;
var
  tzi: TTimeZoneInformation;
  err: DWORD;
  Bias: Integer;
begin
  fillchar(tzi, 0, SizeOf(tzi));
  err := GetTimeZoneInformation(tzi);
  if (err = TIME_ZONE_ID_UNKNOWN) or (err = TIME_ZONE_ID_INVALID) then
    //raise Exception.Create('Invalid time zone!');
    Result := DateTime
  else begin
    Bias := tzi.Bias;
    if err = TIME_ZONE_ID_DAYLIGHT then
      inc(Bias, tzi.DayLightBias);
    Result := DateTime + Bias * 60 / 86400;
  end;
end;

{ URL handling routines }

procedure  ParseURL(const URL: string; var proto, user, password, host, path: string; var port: integer);
var
  n1, n2: integer;
  AUrl: string;
begin
  //URL format <proto>://<user>:<password>@<host>:<port>/<path>
  AUrl:=Url;
  n1:=pos('://',AURL);
  if n1>0 then begin
    proto:=copy(AURL,1,n1-1);
    Delete(AURL,1,n1+2);
  end;

  n1:=pos('@',AURL);
  if n1>0 then begin
    n2:=pos(':',copy(AURL,1,n1-1));
    if n2>0 then begin
      user:=copy(AURL,1,n2-1);
      password:=copy(AURL,n2+1,n1-n2-1);
    end
    else user:=copy(AURL,1,n1-1);
    Delete(AURL,1,n1);
  end;

  n1:=pos('/',AURL);
  if n1=0 then n1:=length(AURL)+1;
  n2:=pos(':',copy(AURL,1,n1-1));
  if n2>0 then begin
    host:=copy(AURL,1,n2-1);
    port:=StrToIntDef(copy(AURL,n2+1,n1-n2-1),-1);
  end
  else begin
    host:=copy(AURL,1,n1-1);
    if proto='ldaps' then
      port := 636;
  end;

  Delete(AURL,1,n1);

  path:=AURL;
end;


function HexMem(P: Pointer; Count: Integer; Ellipsis: Boolean): string;
var
  i, cnt: Integer;
begin
  Result := '';
  if Count > 64 then
    cnt := 64
  else begin
    cnt := Count;
    Ellipsis := false;
  end;
  for i := 0 to cnt - 1 do
    Result := Result + IntToHex(PByteArray(P)[i], 2) + ' ';
  if Ellipsis and (Result <> '') then
    Result := Result + '...';
end;

{ Address fields take $ sign as newline tag so we have to convert this to LF/CR }

function FormatMemoInput(const Text: string): string;
var
  p: PChar;
begin
  Result := '';
  p := PChar(Text);
  while p^ <> #0 do begin
    if p^ = '$' then
      Result := Result + #$D#$A
    else
      Result := Result + p^;
    p := CharNext(p);
  end;
end;

function FormatMemoOutput(const Text: string): string;
var
  p, p1: PChar;
begin
  Result := '';
  p := PChar(Text);
  while p^ <> #0 do begin
    p1 := CharNext(p);
    if (p^ = #$D) and (p1^ = #$A) then
    begin
      Result := Result + '$';
      p1 := CharNext(p1);
    end
    else
      Result := Result + p^;
    p := p1;
  end;
end;

procedure StreamCopy(pf, pt: TStreamProcedure);
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    pf(Stream);
    Stream.Position := 0;
    pt(Stream);
  finally
    Stream.Free;
  end;
end;

procedure LockControl(c: TWinControl; bLock: Boolean);
begin
  if (c = nil) or (c.Parent = nil) or (c.Handle = 0) then Exit;
  if bLock then
    SendMessage(c.Handle, WM_SETREDRAW, 0, 0)
  else
  begin
    SendMessage(c.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(c.Handle, nil, 0,
      RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

function PeekKey: Integer;
var
  msg: TMsg;
begin
  PeekMessage(msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE);
  if msg.Message = WM_KEYDOWN then
    Result := msg.WParam
  else
    Result := 0;
end;

procedure ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
var
  Attr: TLdapAttribute;
  j: integer;
  s: string;

  function IsComputer(const s: string): Boolean;
  var
    i: Integer;
  begin
    i := Pos(',', s);
    Result := (i > 1) and (s[i - 1] = '$');
  end;

begin
  Container := true;
  ImageIndex := bmEntry;
  Attr := Entry.AttributesByName['objectclass'];
  j := Attr.ValueCount - 1;
  while j >= 0 do
  begin
    s := lowercase(Attr.Values[j].AsString);
    if s = 'organizationalunit' then
      ImageIndex := bmOu
    else if s = 'posixaccount' then
    begin
      if ImageIndex = bmEntry then // if not yet assigned to Samba account
      begin
        ImageIndex := bmPosixUser;
        Container := false;
      end;
    end
    else if s = 'sambasamaccount' then
    begin
      if IsComputer(Entry.dn) then             // it's samba computer account
        ImageIndex := bmComputer               // else
      else                                     // it's samba user account
        ImageIndex := bmSamba3User;
      Container := false;
    end
    else if s = 'mailgroup' then
    begin
      ImageIndex := bmMailGroup;
      Container := false;
    end
    else if s = 'posixgroup' then
    begin
      ImageIndex := bmGroup;
      Container := false;
    end
    else if s = 'groupofuniquenames' then
    begin
      ImageIndex := bmGrOfUnqNames;
      Container := false;
    end
    else if s = 'transporttable' then
    begin
      ImageIndex := bmTransport;
      Container := false;
    end
    else if s = 'sudorole' then
    begin
      ImageIndex := bmSudoer;
      Container := false;
    end
    else if s = 'iphost' then
    begin
      ImageIndex := bmHost;
      Container := false;
    end
    else if s = 'locality' then
      ImageIndex := bmLocality
    else if s = 'sambadomain' then
    begin
      ImageIndex := bmSambaDomain;
      Container := false;
    end
    else if s = 'sambaunixidpool' then
    begin
      ImageIndex := bmIdPool;
      Container := false;
    end;
    Dec(j);
  end;
end;

function SupportedPropertyObjects(const Index: Integer): Boolean;
begin
  case Index of
    bmSamba2User,
    bmSamba3User,
    bmPosixUser,
    bmGroup,
    bmMailGroup,
    bmComputer,
    bmTransport,
    bmOu,
    bmLocality,
    bmHost: Result := true;
  else
    Result := false;
  end;
end;

{ TListViewSorter }

constructor TListViewSorter.Create;
begin
  inherited Create;
  FSortColumn:=nil;
  FSortAsc:=true;
  FBmp:=TBitmap.Create;
  FBmp.Width:=9;
  FBmp.Height:=5;
end;

destructor TListViewSorter.Destroy;
begin
  ListView:=nil;
  FBmp.Free;
  inherited;
end;

procedure TListViewSorter.DoColumnClick(Sender: TObject; Column: TListColumn);
begin
  if FSortColumn=Column then FSortAsc:=not FSortAsc
  else FSortAsc:=true;

  FSortColumn:=Column;
  SetSortMark;
  if assigned(FOnSort) then FOnSort(FSortColumn, FSortAsc)
  else FListView.AlphaSort;
  if assigned(FOnColumnClick) then FOnColumnClick(Sender, Column);
end;

procedure TListViewSorter.DoCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare:=0;
  if FSortColumn=nil then exit;
  case FSortColumn.Index of
    0: Compare:=AnsiCompareStr(Item1.Caption,Item2.Caption);
    else begin
          if FSortColumn.Index>Item1.SubItems.Count then exit;
          if FSortColumn.Index>Item2.SubItems.Count then exit;
          Compare:=AnsiCompareStr(
            Item1.SubItems[FSortColumn.Index-1],
            Item2.SubItems[FSortColumn.Index-1]);
         end;
  end;
  if not FSortAsc then Compare:=-Compare;
end;

procedure TListViewSorter.DoCustomDraw(Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean);
begin
  SetSortMark;
  if assigned(FOnCustomDraw) then FOnCustomDraw(Sender,Arect, DefaultDraw);
end;

procedure TListViewSorter.SetListView(const Value: TListView);
begin
  if FListView<>nil then begin
    FListView.OnColumnClick:=FOnColumnClick;
    FListView.OnCustomDraw:=FOnCustomDraw;
  end;

  FListView := Value;

  if FListView=nil then exit;
  FOnColumnClick:=FListView.OnColumnClick;
  FOnCustomDraw:=FListView.OnCustomDraw;
  FListView.OnColumnClick:=DoColumnClick;
  FListView.OnCustomDraw:=DoCustomDraw;
  if not assigned(FListView.OnCompare) then FListView.OnCompare:=DoCompare;
end;

procedure TListViewSorter.SetSortMark;
var
  i: integer;
begin
  if FListView=nil then exit;
  for i:=0 to FListView.Columns.Count-1 do
    SetSortMark(FlistView.Columns[i]);
end;

procedure TListViewSorter.SetSortMark(Column: TListColumn);
var
 Align,hHeader: integer;
 HD: HD_ITEM;
begin
  if FListView=nil then exit;
  hHeader := SendMessage(FListView.Handle, LVM_GETHEADER, 0, 0);
  with HD do
  begin
    case Column.Alignment of
      taLeftJustify:  Align := HDF_LEFT;
      taCenter:       Align := HDF_CENTER;
      taRightJustify: Align := HDF_RIGHT;
    else
      Align := HDF_LEFT;
    end;
    mask := HDI_BITMAP or HDI_FORMAT;

    if Column=FSortColumn then begin
      with FBmp.Canvas do begin
        Brush.Color:=clBtnFace;
        FillRect(rect(0,0,Fbmp.Width,FBmp.Height));
        Brush.Color:=clBtnShadow;
        Pen.Color:=Brush.Color;
        if FSortAsc then Polygon([point(0,4),point(4,0), point(8,4)])
        else Polygon([point(0,0),point(4,4), point(8,0)]);
      end;
      hbm:=FBmp.Handle;
      fmt := HDF_STRING or HDF_BITMAP or HDF_BITMAP_ON_RIGHT;
    end
    else fmt := HDF_STRING or Align;

  end;
  SendMessage(hHeader, HDM_SETITEM, Column.Index, Integer(@HD));
end;

function CheckedMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; CbCaption: string; var CbChecked: Boolean): TModalResult;
var
  Form: TForm;
  i: integer;
  CheckCbx: TCheckBox;
begin
  Form:=CreateMessageDialog(Msg, DlgType, Buttons);
  with Form do
  try
      CheckCbx:=TCheckBox.Create(Form);
      CheckCbx.Parent:=Form;
      CheckCbx.Caption:=Caption;
      CheckCbx.Width:=Width - CheckCbx.Left;
      CheckCbx.Caption := CbCaption;
      CheckCbx.Checked := CbChecked;

      for i:=0 to ComponentCount-1 do begin
        if Components[i] is TLabel then begin
          TLabel(Components[i]).Top:=16;
          CheckCbx.Top:=TLabel(Components[i]).Top+TLabel(Components[i]).Height+16;
          CheckCbx.Left:=TLabel(Components[i]).Left;
        end;
      end;

      for i:=0 to ComponentCount-1 do begin
        if Components[i] is TButton then begin
          TButton(Components[i]).Top:=CheckCbx.Top+CheckCbx.Height+24;
          ClientHeight:=TButton(Components[i]).Top+TButton(Components[i]).Height+16;
        end;
      end;
      Result := ShowModal;
      CbChecked := CheckCbx.Checked;
  finally
    Form.Free;
  end;
end;

function ComboMessageDlg(const Msg: string; const csItems: string; var Text: string): TModalResult;
var
  Form: TForm;
  i: integer;
  Combo: TComboBox;
begin
  Form:=CreateMessageDialog(Msg, mtCustom, mbOkCancel);
  with Form do
  try
    Combo := TComboBox.Create(Form);
    Combo.Parent:=Form;
    Combo.Items.CommaText := csItems;
    Combo.Style := csDropDown;
    for i:=0 to ComponentCount-1 do begin
      if Components[i] is TLabel then begin
        TLabel(Components[i]).Top:=16;
        Width := TLabel(Components[i]).Width + 32;
        Combo.Top:=TLabel(Components[i]).Top+TLabel(Components[i]).Height+4;
        Combo.Left:=TLabel(Components[i]).Left;
      end;
    end;
    if Combo.Width > Width - 32 then
      Width := Combo.Width + 32;

    for i:=0 to ComponentCount-1 do begin
      if Components[i] is TButton then begin
        TButton(Components[i]).Top:=Combo.Top+Combo.Height+24;
        ClientHeight:=TButton(Components[i]).Top+TButton(Components[i]).Height+16;
      end;
    end;
    ActiveControl := Combo;
    Result := ShowModal;
    Text := Combo.Text;
  finally
    Form.Free;
  end;
end;

{ Uses Caption array to replaces captions and Events array to assign OnClick event to buttons}
function MessageDlgEx(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Captions: array of string; Events: array of TNotifyEvent): TModalResult;
var
  Form: TForm;
  i, ci, ce: Integer;
begin
  Form:=CreateMessageDialog(Msg, DlgType, Buttons);
  with Form do
  try
    ci := 0;
    ce := 0;
    for i:=0 to ComponentCount - 1 do
    begin
      if (Components[i] is TButton) then with TButton(Components[i]) do
      begin
        if ci <= High(Captions) then
        begin
          if Captions[ci] <> '' then
            Caption := Captions[ci];
          inc(ci);
        end;
        if ce <= High(Events) then
        begin
          if Assigned(Events[ce]) then
            OnClick := Events[ce];
          inc(ce);
        end;
      end;
    end;
    Result := ShowModal;
  finally
    Form.Free;
  end;
end;

procedure RevealWindow(Form: TForm; MoveLeft, MoveTop: Boolean);
var
  R1, R2: TRect;
  o1, o2: Integer;

  procedure ToLeft;
  begin
    if R2.Left - o1 > 0 then
      Form.Left := R2.Left - o1
    else
      Form.Left := Form.Left + R2.Right - R1.Right + o1;
  end;

  procedure ToRight;
  begin
    if R2.Right + o1 > Screen.Width then
    begin
      Form.Left := R2.Left - o1;
      if Form.Left < 0 then Form.Left := 0;
    end
    else
      Form.Left := Form.Left + R2.Right - R1.Right + o1;
  end;

  procedure ToTop;
  begin
    if R2.Top - o2 > 0 then
      Form.Top := R2.Top - o2
    else
      Form.Top := Form.Top + R2.Bottom - R1.Bottom + o2;
  end;

  procedure ToBottom;
  begin
    if R2.Bottom + o2 > Screen.Height then
    begin
      Form.Top := R2.Top - o2;
      if Form.Top < 0 then Form.Top := 0;
    end
    else
      Form.Top := Form.Top + R2.Bottom - R1.Bottom + o2;
  end;

begin
  if fsShowing in Form.FormState then Exit;
  //if Application.MainForm.WindowState = wsMaximized then Exit;
  o1 := 48 + Random(32);
  o2 := 48 + Random(32);
  GetWindowRect(Form.Handle, R1);
  GetWindowRect(Application.MainForm.Handle, R2);
  if (R1.Top < R2.Top) or (R1.Bottom > R2.Bottom) or
     (R1.Left < R2.Left) or (R1.Right > R2.Right) then Exit;
  if MoveLeft then
    ToLeft
  else
    ToRight;
  if MoveTop then
    ToTop
  else
    ToBottom;
end;

end.
