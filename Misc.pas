unit Misc;

interface

uses Classes;

type
  TStreamProcedure = procedure(Stream: TStream) of object;

function FormatMemoInput(const Text: string): string;
function FormatMemoOutput(const Text: string): string;
procedure StreamCopy(pf, pt: TStreamProcedure);

implementation

uses Windows;

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

end.
