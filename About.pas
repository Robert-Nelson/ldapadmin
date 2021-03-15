unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAboutDlg = class(TForm)
    Label1: TLabel;
    BtnClose: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  AboutDlg: TAboutDlg;

implementation

uses Shellapi;

{$R *.DFM}

function GetVersionInfo: string;
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  dummy,
  len: cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  result:='n/a';
  len := GetFileVersionInfoSize(PChar(Application.ExeName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(Application.ExeName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, len){ and (@len <> nil)} then
      result := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;

procedure TAboutDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAboutDlg.Label7Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(label7.Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutDlg.FormCreate(Sender: TObject);
begin
  Label5.Caption:=GetVersionInfo;
end;

end.
