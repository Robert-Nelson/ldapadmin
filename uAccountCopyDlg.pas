unit uAccountCopyDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Config, ImgList;

type
  TAccountCopyDlg = class(TForm)
    Label1:     TLabel;
    NameEd:     TEdit;
    Label2:     TLabel;
    StorageCbx: TComboBox;
    OkBtn:      TBitBtn;
    CancelBtn:  TBitBtn;
    Images:     TImageList;
    procedure   StorageCbxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OkBtnClick(Sender: TObject);
  private
    function    GetStorage: TConfigStorage;
    procedure   SetStorage(const Value: TConfigStorage);
    function GetAccountName: string;
    procedure SetAccountName(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property    Storage: TConfigStorage read GetStorage write SetStorage;
    property    AccountName: string read GetAccountName write SetAccountName;
  end;


implementation
uses Math, Constant;

{$R *.dfm}

{ TAccountCopyDlg }

constructor TAccountCopyDlg.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited;
  for i:=0 to GlobalConfig.StoragesCount-1 do begin
    StorageCbx.Items.Add(GlobalConfig.Storages[i].Name);
  end;
end;

destructor TAccountCopyDlg.Destroy;
begin

  inherited;
end;

function TAccountCopyDlg.GetAccountName: string;
begin
  result:=NameEd.Text;
end;

procedure TAccountCopyDlg.SetAccountName(const Value: string);
begin
  NameEd.Text:=Value;
end;

function TAccountCopyDlg.GetStorage: TConfigStorage;
begin
  if StorageCbx.ItemIndex=-1 then result:=nil
  else result:=GlobalConfig.Storages[StorageCbx.ItemIndex];
end;

procedure TAccountCopyDlg.SetStorage(const Value: TConfigStorage);
var
  i: integer;
begin
  for i:=0 to GlobalConfig.StoragesCount-1 do begin
    if GlobalConfig.Storages[i]=Value then StorageCbx.ItemIndex:=i;
  end;
end;

procedure TAccountCopyDlg.StorageCbxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  StorageCbx.Canvas.FillRect(Rect);
  Images.Draw(StorageCbx.Canvas, Rect.Left, Rect.Top, min(Index, 1));
  Rect.Left:=Images.Width+6;
  DrawText(StorageCbx.Canvas.Handle, pchar(GlobalConfig.Storages[Index].Name), -1, Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

procedure TAccountCopyDlg.OkBtnClick(Sender: TObject);
begin
  ModalResult:=mrNone;
  if NameEd.Text='' then raise Exception.Create(stAccntNameReq);
  if (Storage.AccountByName(NameEd.Text)<>nil) and
    (Application.MessageBox(pchar(stAccntExist), pchar(application.Title), MB_ICONQUESTION or MB_YESNO)<>IDYes) then exit;

  ModalResult:=mrOK;
end;

end.
