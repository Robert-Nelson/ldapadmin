unit RegAccnt;

interface

const
  // registry strings
  REG_KEY = 'Software\LdapAdmin\';
  REG_ACCOUNT = 'Accounts';

type
  TAccountEntry = class
    Name,
    Server,
    Base,
    User,
    Password: string;
    Port: Integer;
    UseSSL: Boolean;
  public
    constructor Create(AccName: string);
    procedure Read;
    procedure Write;
  end;

implementation

uses Windows, WinLDAP, Registry, SysUtils;

constructor TAccountEntry.Create(AccName: string);
begin
  inherited Create;
  Name := AccName;
  if Name <> '' then
    Read
  else
    Port := LDAP_PORT;
end;

procedure TAccountEntry.Read;
var
  Reg: TRegistry;
  DataSize, Offset: Integer;
  Buffer: PByteArray;
  pint: ^Integer;
  pBool: ^Boolean;

  function ReadStr: string;
  var
    StrLen: Integer;
  begin
    StrLen := Integer(Buffer[Offset]);
    Inc(Offset, SizeOf(Integer));
    SetString(Result,PChar(@Buffer[offset]),StrLen);
    Inc(Offset, StrLen);
  end;

begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, false) then
    begin
      DataSize := Reg.GetDataSize(Name);
      if DataSize > 0 then
      begin
        GetMem(Buffer, DataSize);
        Reg.ReadBinaryData(Name, Buffer^, DataSize);
        Offset := 0;
        Server := ReadStr;
        Base := ReadStr;
        User := ReadStr;
        Password := ReadStr;
        pint := @Buffer[Offset];
        Port := pInt^;
        inc(Offset, SizeOf(Integer));
        pBool := @Buffer[Offset];
        UseSSL := pBool^;
      end
      else begin
        Server := '';
        Base := '';
        User := '';
        Password := '';
        Port := 0;
        UseSSL := false;
      end;
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure TAccountEntry.Write;
var
  Reg: TRegistry;
  DataSize, Offset: Integer;
  Buffer: PByteArray;
  pint: ^Integer;
  pBool: ^Boolean;

  procedure WriteStr(s: string);
  var
    StrLen: Integer;
  begin
    StrLen := Length(s);
    Move(StrLen,Buffer[offset],SizeOf(Integer));
    Inc(Offset, SizeOf(Integer));
    Move(Pointer(s)^,Buffer[offset],StrLen);
    Inc(Offset, StrLen);
  end;

begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, true) then
    begin
      DataSize := Length(Server) +
                  Length(Base) +
                  Length(User) +
                  Length(Password) +
                  6 * SizeOf(Integer) +
                  SizeOf(Boolean);

      GetMem(Buffer, DataSize);
      Offset := 0;
      WriteStr(Server);
      WriteStr(Base);
      WriteStr(User);
      WriteStr(Password);
      pInt := @Buffer[Offset];
      pInt^ := Port;
      inc(Offset,SizeOf(Integer));
      pBool := @Buffer[Offset];
      pBool^ := UseSSL;
      Reg.WriteBinaryData(Name, Buffer^, DataSize);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

end.
 