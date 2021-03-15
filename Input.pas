unit Input;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TInputDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit: TEdit;
    Prompt: TLabel;
    procedure EditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function InputDlg(ACaption, APrompt: string; var AValue: string): Boolean;

implementation

{$R *.DFM}

function InputDlg(ACaption, APrompt: string; var AValue: string): Boolean;
begin
  Result := false;
  with TInputDlg.Create(Application) do
  begin
    Caption := ACaption;
    Prompt.Caption := APrompt;
    Edit.Text := AValue;
    if ShowModal = mrOk then
    begin
      AValue := Edit.Text;
      Result := true
    end
  end;
end;

procedure TInputDlg.EditChange(Sender: TObject);
begin
  OkBtn.Enabled := Edit.Text <> '';
end;

end.
