  {      LDAPAdmin - Misc.pas
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

unit Misc;

interface

uses LdapClasses, Classes, SysUtils, Windows, Forms, Dialogs, Controls;

type
  TStreamProcedure = procedure(Stream: TStream) of object;

{ String conversion routines }
function  UTF8ToStringLen(const src: PChar; const Len: Cardinal): widestring;
function  StringToUTF8Len(const src: PChar; const Len: Cardinal): string;
function  StringToWide(const S: string): WideString;
function  CStrToString(cstr: String): String;
{ Time conversion routines }
function  DateTimeToUnixTime(const AValue: TDateTime): Int64;
function  UnixTimeToDateTime(const AValue: Int64): TDateTime;
function  GTZToDateTime(const Value: string): TDateTime;
function  LocalDateTimeToUTC(DateTime: TDateTime): TDateTime;
{ String handling routines }
function  IsNumber(const S: string): Boolean;
procedure Split(Source: string; Result: TStrings; Separator: Char);
function  FormatMemoInput(const Text: string): string;
function  FormatMemoOutput(const Text: string): string;
function  FileReadString(const FileName: TFileName): String;
procedure FileWriteString(const FileName: TFileName; const Value: string);
{ URL handling routines }
procedure ParseURL(const URL: string; var proto, user, password, host, path: string; var port: integer; var auth: TLdapAuthMethod);
{ Some handy dialogs }
function  CheckedMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; CbCaption: string; var CbChecked: Boolean): TModalResult;
function  ComboMessageDlg(const Msg: string; const csItems: string; var Text: string): TModalResult;
function  MessageDlgEx(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Captions: array of string; Events: array of TNotifyEvent): TModalResult;
{ LDAP helper routines }
function  GetUid(Session: TLdapSession): Integer;
function  GetGid(Session: TLdapSession): Integer;
procedure ClassifyLdapEntry(Entry: TLdapEntry; out Container: Boolean; out ImageIndex: Integer);
function  SupportedPropertyObjects(const Index: Integer): Boolean;
{ everything else :-) }
function  HexMem(P: Pointer; Count: Integer; Ellipsis: Boolean): string;
procedure StreamCopy(pf, pt: TStreamProcedure);
procedure LockControl(c: TWinControl; bLock: Boolean);
function  PeekKey: Integer;
procedure RevealWindow(Form: TForm; MoveLeft, MoveTop: Boolean);

const
  mrCustom   = 1000;

implementation

{$I LdapAdmin.inc}

uses StdCtrls, Messages, Constant, Config {$IFDEF VARIANTS} ,variants {$ENDIF};

{ String conversion routines }

{ Note: these functions ignore conversion errors }
function StringToWide(const S: string): WideString;
var
  DestLen: Integer;
begin
  DestLen := MultiByteToWideChar(0, 0, PChar(S), Length(S), nil, 0) + 1;
  SetLength(Result, DestLen);
  MultiByteToWideChar(0, 0, PChar(S), Length(S), PWideChar(Result), DestLen);
  Result[DestLen] := #0;
end;

function UTF8ToStringLen(const src: PChar; const Len: Cardinal): widestring;
var
  l: Integer;
begin
  SetLength(Result, Len);
  if Len > 0 then
  begin
    l := MultiByteToWideChar( CP_UTF8, 0, src, Len, PWChar(Result), Len*SizeOf(WideChar));
    SetLength(Result, l);
  end;
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
    bsiz := WideCharToMultiByte(CP_UTF8, 0, PWideChar(Temp), -1, PChar(Result), bsiz, nil, nil);
    if bsiz > 0 then dec(bsiz);
    SetLength(Result, bsiz);
  end;
end;

function CStrToString(cstr: String): String;
var  lpesc:      Array [0..2] of Byte;
     cbytes:     Integer;
     cesc:       Integer;
     l:          Integer;
     i:          Integer;
begin

  // Set the length of result, this will keep us from having to append. Result could never be longer than input
  SetLength(result, Length(cstr));

  // Set starting defaults
  cbytes:=0;
  l:=Length(cstr)+1;
  i:=1;

  // Iterate the c style string
  while (i < l) do
  begin
     // Check for escape sequence
     if (cstr[i] = '\') then
     begin
        // Get next byte
        Inc(i);
        if (i = l) then break;
        // Set next write pos
        Inc(cbytes);
        case cstr[i] of
           'a'   :  result[cbytes]:=#7;
           'b'   :  result[cbytes]:=#8;
           'f'   :  result[cbytes]:=#12;
           'n'   :  result[cbytes]:=#10;
           'r'   :  result[cbytes]:=#13;
           't'   :  result[cbytes]:=#9;
           'v'   :  result[cbytes]:=#11;
           '\'   :  result[cbytes]:=#92;
           ''''  :  result[cbytes]:=#39;
           '"'   :  result[cbytes]:=#34;
           '?'   :  result[cbytes]:=#63;
        else
           // Going to be either octal or hex
           cesc:=-1;
           // Loop to get the next 3 bytes
           while (i < l) do
           begin
              Inc(cesc);
              case cstr[i] of
                 '0'..'9' :  lpesc[cesc]:=Ord(cstr[i])-48;
                 'A'..'F' :  lpesc[cesc]:=Ord(cstr[i])-55;
                 'X'      :  lpesc[cesc]:=255;
                 'a'..'f' :  lpesc[cesc]:=Ord(cstr[i])-87;
                 'x'      :  lpesc[cesc]:=255;
              else
                 break;
              end;
              if (cesc = 2) then break;
              Inc(i);
           end;
           // Make sure we got 3 bytes
           if (cesc < 2) then
           begin
              // Raise an error if you wish
              Dec(cbytes);
              break;
           end;
           // Check for hex or octal
           if (lpesc[0] = 255) then
              result[cbytes]:=Chr(lpesc[1] * 16 + lpesc[2])
           else
              result[cbytes]:=Chr(lpesc[0] * 64 + lpesc[1] * 8 + lpesc[2]);
        end;
        // Increment the next byte from the input
        Inc(i);
     end
     else
     begin
        // Increment the write buffer pos
        Inc(cbytes);
        result[cbytes]:=cstr[i];
        Inc(i);
     end;
  end;

  // Set the final length on the result
  SetLength(result, cbytes);

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

function GTZToDateTime(const Value: string): TDateTime;
var
  AValue: string;
begin
  if (Length(Value) < 15) or (Uppercase(Value[Length(Value)]) <> 'Z') then
        raise EConvertError.Create(stInvalidTimeFmt);
  AValue := Copy(Value, 1, 14); // not interested in ms
  Insert(':', AValue, 13);
  Insert(':', AValue, 11);
  Insert(' ', AValue, 9);
  Insert('-', AValue, 7);
  Insert('-', AValue, 5);
  Result := VarToDateTime(AValue);
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
    //raise Exception.Create(stInvalidTimeZone);
    Result := DateTime
  else begin
    Bias := tzi.Bias;
    if err = TIME_ZONE_ID_DAYLIGHT then
      inc(Bias, tzi.DayLightBias);
    Result := DateTime + Bias * 60 / 86400;
  end;
end;

{ URL handling routines }

procedure ParseLAURL(const URL: string; var proto, user, password, host, path: string; var port: integer);
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
    if (proto='ldaps') or (proto='ldapsg') then
      port := 636;
  end;

  Delete(AURL,1,n1);

  path:=AURL;
end;

procedure ParseRFCURL(const URL: string; var proto, user, password, host, path: string; var port: integer; var auth: TLdapAuthMethod);
var
  n1, n2: integer;
  AUrl: string;
  p: PChar;
  Extensions: TStringList;

  //{$DEFINE UTF8}
  function UnpackString(const Src: string): string;
  var
    p, p1: PChar;
  {$IFDEF UTF8}
    rg: string;
  {$ENDIF}
  begin
    Result := '';
    p := PChar(Src);
    while p^ <> #0 do begin
      p1 := CharNext(p);
      if (p^ = '%') then
      begin
        p := CharNext(p);
        p1 := CharNext(p);
        p1 := CharNext(p1);
  {$IFDEF UTF8}
        SetString(rg, p, p1 - p);
        Result := Result + Char(StrToInt('$' + rg));
      end
      else
        Result := Result + p^;
  {$ELSE}
        HexToBin(p, p, p1-p);
      end;
      Result := Result + p^;
  {$ENDIF}
      p := p1;
    end;
  end;

  procedure ParseExtensions(const ExtStr: string);
  var
    val: string;
  begin
    if ExtStr = '' then Exit;
    try
      Extensions := TStringList.Create;
      with Extensions do begin
        CommaText := ExtStr;
        user := UnpackString(Values['bindname']);
        password := UnpackString(Values['password']);
        val := Values['auth'];
        if (val='') or (val='simple') then
          auth := AUTH_SIMPLE
        else
        if val = 'gss' then
          auth := AUTH_GSS
        else
        if val = 'sasl' then
        begin
          if proto = 'ldaps' then
            raise Exception.Create(stSaslSSL);
          auth := AUTH_GSS_SASL;
        end
        else
          raise Exception.Create(Format(stUnsupportedAuth, [val]));
      end;
    finally
      Extensions.Free;
    end;
  end;

begin
  //URL format <proto>://[host[:port]]/<dn>?[bindname=[username]][,password=[password]][,auth=[plain|gss|sasl]]

  AUrl:=Url;
  n1:=pos('://',AURL);
  if n1>0 then begin
    proto:=copy(AURL,1,n1-1);
    Delete(AURL,1,n1+2);
  end;

  n1:=pos('/',AURL);
  if n1=0 then
    raise Exception.Create(stInvalidURL);
  n2:=pos(':',copy(AURL,1,n1-1));
  if n2>0 then begin
    host:=copy(AURL,1,n2-1);
    port:=StrToIntDef(copy(AURL,n2+1,n1-n2-1),-1);
  end
  else begin
    if n1=1 then
      host := 'localhost'
    else
      host:=copy(AURL,1,n1-1);
    if proto='ldaps' then
      port := 636;
  end;
  Delete(AURL,1,n1);
  n1:=pos('?',AURL);
  if n1=0 then
    path:=UnpackString(AURL)
  else begin
    path := UnpackString(Copy(AURL,1,n1-1));
    p := StrRScan(@AURL[n1], '?');
    p := CharNext(p);
    ParseExtensions(p);
  end;
end;

procedure ParseURL(const URL: string; var proto, user, password, host, path: string; var port: integer; var auth: TLdapAuthMethod);
begin
  if Pos('@',URL) > 0 then // old LdapAdmin style
    ParseLAURL(URL, proto, user, password, host, path, port)
  else
    ParseRFCURL(URL, proto, user, password, host, path, port, auth);
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

{ String handling routines }

function IsNumber(const S: string): Boolean;
var
  P: PChar;
begin
  P  := PChar(S);
  Result := False;
  while P^ <> #0 do
  begin
    if not (P^ in ['0'..'9']) then Exit;
    Inc(P);
  end;
  Result := True;
end;

procedure Split(Source: string; Result: TStrings; Separator: Char);
var
  p0, p: PChar;
  s: string;
begin
  p0 := PChar(Source);
  p := p0;
  repeat
    while (p^<> #0) and (p^ <> Separator) do
      p := CharNext(p);
    SetString(s, p0, p - p0);
    Result.Add(s);
    if p^ = #0 then
      exit;
    p := CharNext(p);
    p0 := p;
  until false;
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

function FileReadString(const FileName: TFileName): String;
var
  sl: TStringList;
begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(FileName);
      Result := sl.text;
    finally
      sl.Free;
    end;
end;

procedure FileWriteString(const FileName: TFileName; const Value: string);
var
  sl: TStringList;
begin
    sl := TStringList.Create;
    try
      sl.SaveToFile(FileName);
    finally
      sl.Free;
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

function GetUid(Session: TLdapSession): Integer;
var
  IdType: Integer;
begin
  Result := -1;
  idType := AccountConfig.ReadInteger(rPosixIDType, POSIX_ID_RANDOM);
  if idType <> POSIX_ID_NONE then
    Result := Session.GetFreeUidNumber(AccountConfig.ReadInteger(rposixFirstUID, FIRST_UID),
                                       AccountConfig.ReadInteger(rposixLastUID, LAST_UID),
                                       IdType = POSIX_ID_SEQUENTIAL);
end;

function GetGid(Session: TLdapSession): Integer;
var
  IdType: Integer;
begin
  Result := -1;
  idType := AccountConfig.ReadInteger(rPosixIDType, POSIX_ID_RANDOM);
  if idType <> POSIX_ID_NONE then
    Result := Session.GetFreeGidNumber(AccountConfig.ReadInteger(rposixFirstGid, FIRST_GID),
                                       AccountConfig.ReadInteger(rposixLastGID, LAST_GID),
                                       IdType = POSIX_ID_SEQUENTIAL);
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
    else if s = 'sambagroupmapping' then
    begin
      ImageIndex := bmSambaGroup;
      Container := false;
    end
    else if s = 'mailgroup' then
    begin
      ImageIndex := bmMailGroup;
      Container := false;
    end
    else if s = 'posixgroup' then
    begin
      if ImageIndex = bmEntry then // if not yet assigned to Samba group
      begin
        ImageIndex := bmGroup;
        Container := false;
      end;
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
      //Container := false;
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
    bmSambaGroup,
    bmGrOfUnqNames,
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
