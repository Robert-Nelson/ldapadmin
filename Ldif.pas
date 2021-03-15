  {      LDAPAdmin - Ldif.pas
  *      Copyright (C) 2004-2005 Tihomir Karlovic
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

uses LdapClasses, Windows, Classes, SysUtils;

const
  SIZE_CRLF = 2;
  SafeChar:     set of Char = [#$01..#09, #$0B..#$0C, #$0E..#$7F];
  SafeInitChar: set of Char = [#$01..#09, #$0B..#$0C, #$0E..#$1F, #$21..#$39, #$3B, #$3D..#$7F];

type
  TLdifMode = (fmRead, fmWrite, fmAppend);

{ TLDIF
  Uses ReadRecord to fetch and parse one record. Property RecordLines contains
  original Ldif lines of fetched record (without comments).
  Uses WriteRecord to dump one record to file opened for writing.
  Descendant classes are responsible for reading and writing of the data by
  overwriting abstract ReadLine and WriteLine procedures. }

type
  TLDIF = class
  private
    fRecord: TStringList;
    fVersion: Integer;
    fMode: TLdifMode;
    fWrap: Integer;
    fLinesRead: Integer;
    fEof: Boolean;
  protected
    function  IsSafe(const Buffer: PBytes; DataSize: Cardinal): Boolean;
    function  ReadLine: string; virtual; abstract;
    procedure WriteLine(const Line: string); virtual; abstract;
    procedure PutLine(const attrib: string; const Buffer: PBytes; const DataSize: Cardinal);
    procedure FetchRecord; virtual;
    procedure ParseRecord(Entry: TLdapEntry); virtual;
    procedure ReadFromURL(url: string; Value: TLdapAttributeData);
  public
    procedure ReadRecord(Entry: TLdapEntry = nil); virtual;
    procedure WriteRecord(Entry: TLdapEntry); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
    property Version: Integer read fVersion;
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

constructor TLDIF.Create;
begin
  fRecord := TStringList.Create;
  fWrap := 80;
end;

destructor TLDIF.Destroy;
begin
  fRecord.Free;
  inherited Destroy;
end;

procedure TLDIF.FetchRecord;
var
  Line: string;
begin
  if fEof then
    raise Exception.Create(stLdifEof);
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

procedure TLDIF.ParseRecord(Entry: TLdapEntry);
var
  i, po, vLen: Integer;
  Line, s: string;
  Name, Value: string;
  Attr: TLdapAttribute;
begin
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
    Attr := Entry.AttributesByName[name];
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
    end
    else
    if Line[po + 1] = '<' then
      ReadFromUrl(TrimLeft(Copy(Line, po + 2, MaxInt)), Attr.AddValue)
    else
      Value := TrimLeft(Copy(Line, po + 1, MaxInt));

    if Entry.dn = '' then
    begin
      // it has to be dn or version atribute
      if Name = 'dn' then
        Entry.dn := Value
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
    else
      Attr.AddValue(Pointer(@Value[1]), Length(Value));
  end;
end;

procedure TLDIF.ReadFromURL(url: string; Value: TLdapAttributeData);
var
  i: Integer;
  fs: TFileStream;
begin
  i := Pos('://', url);
  if i = 0 then
    raise Exception.Create(stLdifInvalidUrl);
  if AnsiStrLIComp(PChar(url), 'file', i - 1) <> 0 then
    raise Exception.Create(stLdifUrlNotSupp);
  fs := TFileStream.Create(Copy(url, i + 3, MaxInt), fmOpenRead);
  try
    Value.LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

{ Tests whether data contains only safe chars }
function TLDIF.IsSafe(const Buffer: PBytes; DataSize: Cardinal): Boolean;
var
  p: PChar;
  EndBuf: PChar;
begin
  Result := true;
  p := PChar(Buffer);
  if not (p^ in SafeInitChar) then
  begin
    Result := false;
    exit;
  end;
  EndBuf := PChar(Cardinal(Buffer) + DataSize);
  while (p <> EndBuf) do
  begin
    if not (p^ in SafeChar) then
    begin
      Result := false;
      break;
    end;
    Inc(p);
  end;
end;

{ If neccessary encodes data to base64 coding and dumps the string to file
  wrapping the line so that max length doesn't exceed Wrap count of chars }
procedure TLDIF.PutLine(const attrib: string; const Buffer: PBytes; const DataSize: Cardinal);
var
  p1, len: Integer;
  line, s: string;
begin

  line := attrib + ':';

  if DataSize > 0 then
  begin
    // Check if we need to encode to base64
    if IsSafe(Buffer, DataSize) then
    begin
      SetString(s, PChar(Buffer), DataSize);
      line := line + ' ' + s
    end
    else
    begin
      SetLength(s, Base64encSize(DataSize));
      Base64Encode(Pointer(Buffer)^, DataSize, s[1]);
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

procedure TLDIF.ReadRecord(Entry: TLdapEntry = nil);
begin
  FetchRecord;
  if Assigned(Entry) then
  begin
    Entry.dn := '';
    Entry.Attributes.Clear;
    ParseRecord(Entry);
  end;
end;

procedure TLDIF.WriteRecord(Entry: TLdapEntry);
var
  i, j: Integer;
begin
  PutLine('dn', @Entry.dn[1], Length(Entry.dn));
  for i := 0 to Entry.Attributes.Count - 1 do with Entry.Attributes[i] do
    for j := 0 to ValueCount - 1 do with Values[j] do
      PutLine(Name, Data, DataSize);
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
