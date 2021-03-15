  {      LDAPAdmin - Ldif.pas
  *      Copyright (C) 2004 Tihomir Karlovic
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

unit Ldif;

interface

uses Windows, Classes, SysUtils;

const
  SIZE_CRLF = 2;
  SafeChar:     set of Char = [#$01..#09, #$0B..#$0C, #$0E..#$7F];
  SafeInitChar: set of Char = [#$01..#09, #$0B..#$0C, #$0E..#$1F, #$21..#$39, #$3B, #$3D..#$7F];

type
  TAttrRec = record
    Name: string;
    Value: string;
  end;

  TLdifMode = (fmRead, fmWrite, fmAppend);

{ TLDIF
  Uses ReadRecord to fetch and parse one record and returns the result in Dn and
  Attributes properties. Property RecordLines contains original Ldif lines
  of fetched record (without comments).
  Uses WriteRecord to dump one record to file opened for writing (Dn property
  must be correctly set prior to calling the procedure WriteRecord).
  Descendant classes are responsible for reading and writing of the data by
  overwriting abstract ReadLine and WriteLine procedures. }

type
  TLDIF = class
  private
    fRecord: TStringList;
    fAttributes: TList;
    fdn: string;
    fVersion: Integer;
    fMode: TLdifMode;
    fWrap: Integer;
    fLinesRead: Integer;
    fEof: Boolean;
    function  GetAttribute(Index: Integer): TAttrRec;
    function  GetCount: Integer;
    procedure SetDn(Value: string);
  protected
    procedure ClearResult;
    function  IsSafe(const s: string): Boolean;
    function  StringToUTF8(const src: string): string;
    function  UTF8ToString(const src: string): string;
    function  ReadLine: string; virtual; abstract;
    procedure WriteLine(const Line: string); virtual; abstract;
    procedure PutLine(const attrib, value: string);
    procedure FetchRecord; virtual;
    procedure ParseRecord; virtual;
  public
    procedure ReadRecord; virtual;
    procedure WriteRecord(Items: TStringList); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
    property Version: Integer read fVersion;
    property dn: string read fdn write SetDn;
    property Attributes[Index: Integer]: TAttrRec read GetAttribute;
    property Count: Integer read GetCount;
    property Wrap: Integer read fWrap write fWrap;
    property RecordLines: TStringList read fRecord;
    property EOF: Boolean read fEof;
  end;

  TLDIFFile = class(TLDIF)
  private
    F: Text;
    fNumRead: Integer;
  protected
    function  ReadLine: string; override;
    procedure WriteLine(const Line: string); override;
  public
    constructor Create(const FileName: string; const Mode: TLdifMode); reintroduce; overload;
    destructor Destroy; override;
    property NumRead: Integer read fNumRead;
  end;

  TLDIFStringList = class(TLDIF)
  private
    fLines: TStringList;
    fCurrentLine: Integer;
  protected
    function  ReadLine: string; override;
    procedure WriteLine(const Line: string); override;
  public
    constructor Create(const Lines: TStringList; const Mode: TLdifMode); reintroduce; overload;
    property CurrentLine: Integer read fCurrentLine;
  end;

implementation

uses Constant, Base64;

{ TLDIF }

function TLDIF.GetCount: Integer;
begin
  Result := fAttributes.Count;
end;

function TLDIF.GetAttribute(Index: Integer): TAttrRec;
begin
  Result := TAttrRec(fAttributes[Index]^);
end;

procedure TLDIF.SetDn(Value: string);
begin
  if fMode = fmRead then
    raise Exception.Create(stFileReadOnly);
  fdn := Value;
end;

procedure TLDIF.ClearResult;
var
  i: Integer;
begin
  for i := 0 to fAttributes.Count - 1 do
    Dispose(fAttributes[i]);
  fAttributes.Clear;
end;

constructor TLDIF.Create;
begin
  fRecord := TStringList.Create;
  fAttributes := TList.Create;
  fWrap := 80;
end;

destructor TLDIF.Destroy;
begin
  fRecord.Free;
  ClearResult;
  fAttributes.Free;
  inherited Destroy;
end;

procedure TLDIF.FetchRecord;
var
  Line: string;
begin
  fRecord.Clear;
  while not fEof do
  begin
    Line := ReadLine;
    inc(fLinesRead);
    if Line = '' then
    begin
      if fRecord.Count = 0 then
        continue
      else
        break;
    end
    else
      if Line[1] = '#' then
        Continue;
    fRecord.AddObject(Line, Pointer(fLinesRead - 1));
  end;
end;

procedure TLDIF.ParseRecord;
var
  i, po, vLen: Integer;
  Line, s: string;
  Attr: ^TAttrRec;
  Name, Value: string;

begin
  fdn := '';
  ClearResult;
  i := 0;
  while i < fRecord.Count do
  begin
    { Get line to parse }
    Line := fRecord.Strings[i];
    inc(i);
    while (i < fRecord.Count) and (fRecord.Strings[i][1] = ' ') do
    begin
     Line := Line + Copy(fRecord.Strings[i], 2, MaxInt);
     inc(i);
    end;

    { Parse the line }
    if Line[1] = ' ' then
        raise Exception.Create(Format(stLdifEFold, [Integer(fRecord.Objects[i])]));

    po := Pos(':', Line);
    if po = 0 then
      raise Exception.Create(Format(stLdifENoCol, [Integer(fRecord.Objects[i])]));

    Name := lowercase(TrimRight(Copy(Line, 1, po - 1)));
    if po = Length(Line) - 1 then
      Value := ''
    else
    if Line[po + 1] = ':' then
    begin
      s := TrimLeft(Copy(Line, po + 2, MaxInt));
      vLen := Length(s);
      SetLength(Value, Base64decSize(vLen));
      vLen := Base64Decode(s[1], vLen, Value[1]);
      SetLength(Value, vLen);
      Value := Utf8ToString(Value);
    end
    else
    if Line[po + 1] = '<' then
      //Value := GetUrl(PChar(Line[po + 2]))
      raise Exception.Create('"<" not (yet) supported!')
    else
      Value := TrimLeft(Copy(Line, po + 1, MaxInt));

    if fdn = '' then
    begin
      // it has to be dn or version atribute
      if Name = 'dn' then
        fdn := Value
      else
      if Name = 'version' then
      try
        fVersion := StrToInt(Value)
      except
        on E: Exception do
          raise Exception.Create(Format(stLdifEVer, [Value]));
      end
      else
        raise Exception.Create(Format(stLdifENoDn, [Integer(fRecord.Objects[i]), Name]));
    end
    else begin
      New(Attr);
      Attr^.Name := name;
      Attr^.Value := value;
      fAttributes.Add(Attr);
    end;
  end;
end;

{ Tests whether string contains only safe chars }
function TLDIF.IsSafe(const s: string): Boolean;
var
  p: PChar;
begin
  Result := true;
  p := PChar(s);
  if not (p^ in SafeInitChar) then
  begin
    Result := false;
    exit;
  end;
  while (p^ <> #0) do
  begin
    if not (p^ in SafeChar) then
    begin
      Result := false;
      break;
    end;
    p := CharNext(p);
  end;
end;

function TLDIF.StringToUTF8(const src: string): string;
var
  Dest, UTF8: array [0..1] of WideChar;
  p: PChar;
  c: string;
begin
  Result := '';
  p := PChar(src);
  while (p^ <> #0) do
  begin
    if p^ < #128 then
      Result := Result + p^
    else
    begin
      c := p^;
      StringToWideChar(c, @Dest, SizeOf(Dest));
      WideCharToMultiByte(CP_UTF8, 0, @Dest, 1, LPSTR(@Utf8), SizeOf(UTF8), nil, nil);
      Result := Result + Char(Lo(Integer(UTF8))) + Char(Hi(Integer(UTF8)));
    end;
    p := CharNext(p);
  end;
end;

function TLDIF.UTF8ToString(const src: string): string;
var
  l: Integer;
  dst: string;
  p: PWord;
begin
  Result := '';
  l := Length(src);
  SetLength(Dst, l * SizeOf(WideChar));
  l := MultiByteToWideChar( CP_UTF8, 0, PChar(src), l+1, PWChar(Dst), l*SizeOf(WideChar));
  if l = 0 then
    RaiseLastWin32Error;
  p := PWord(Dst);
  while p^ <> 0 do begin
    Result := Result + Char(p^);
    Inc(p);
  end;
end;

{ If neccessary converts value to base64 coding and dumps the string to file
  wrapping the line so that max length doesn't exceed Wrap count of chars }
procedure TLDIF.PutLine(const attrib, value: string);
var
  p1, len: Integer;
  line, utfstr, s: string;
begin

  line := attrib + ':';

  if value <> '' then
  begin
    // Check if we need to encode to base64
    if IsSafe(value) then
      line := line + ' ' + value
    else
    begin
      utfstr := StringToUTF8(value);
      SetLength(s, Base64encSize(Length(utfstr)*SizeOf(Char)));
      Base64Encode(utfstr[1], Length(utfstr)*SizeOf(Char), s[1]);
      line := line + ': ' + s;
    end;
  end;

  len := Length(line);
  p1 := 1;
  while p1 <= len do
  begin
    if p1 = 1 then
    begin
      WriteLine(System.Copy(line, p1, fWrap));
      inc(p1, wrap);
    end
    else begin
      WriteLine(' ' + System.Copy(line, P1, fWrap - 1));
      inc(p1, wrap - 1);
    end;
  end;
end;

procedure TLDIF.ReadRecord;
begin
  if fEof then
    raise Exception.Create(stLdifEof);
  FetchRecord;
  ParseRecord;
end;

procedure TLDIF.WriteRecord(Items: TStringList);
var
  i: Integer;
begin
  PutLine('dn', fdn);
  for i := 0 to Items.Count - 1 do
    PutLine(Items[i], PChar(Items.Objects[i]));
  WriteLine('');
end;

{ TLDIFFile }

function TLDIFFile.ReadLine: string;
begin
  ReadLn(F, Result);
  fEof := System.eof(F);
  fNumRead := fNumRead + Length(Result) + SIZE_CRLF;
end;

procedure TLDIFFile.WriteLine(const Line: string);
begin
  WriteLn(F, Line);
end;

constructor TLDIFFile.Create(const FileName: string; const Mode: TLdifMode);
begin
  inherited Create;
  fMode := Mode;
  AssignFile(F, FileName);
  try
    if Mode = fmRead then
    begin
      FileMode := 0;
      Reset(F)
    end
    else begin
      FileMode := 1;
      if Mode = fmWrite then
        Rewrite(F)
      else
        Append(F);
    end;
  except
    RaiseLastWin32Error;
  end;
end;

destructor TLDIFFile.Destroy;
begin
  try
    CloseFile(F);
  except end;
  inherited Destroy;
end;

{ TLDIFStringList }

function TLDIFStringList.ReadLine: string;
begin
  Result := fLines[fCurrentLine];
  inc(fCurrentLine);
end;

procedure TLDIFStringList.WriteLine(const Line: string);
begin
  fLines.Add(Line);
end;

constructor TLDIFStringList.Create(const Lines: TStringList; const Mode: TLdifMode);
begin
  fLines := Lines;
  fMode := Mode;
  inherited Create;
end;

end.
