  {      LDAPAdmin - Connprop.pas
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

unit ConnProp;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, RegAccnt;

type
  TConnPropDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Name: TEdit;
    Label1: TLabel;
    Server: TEdit;
    Label2: TLabel;
    Port: TEdit;
    Label3: TLabel;
    cbSSL: TCheckBox;
    User: TEdit;
    Label4: TLabel;
    Password: TEdit;
    Label5: TLabel;
    Base: TEdit;
    Label6: TLabel;
    VersionCombo: TComboBox;
    Label7: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbSSLClick(Sender: TObject);
  private
    AccountEntry: TAccountEntry;
  public
    constructor Create(AOwner: TComponent; Account: string); reintroduce;
  end;

var
  ConnPropDlg: TConnPropDlg;

implementation

uses WinLDAP, Constant;

{$R *.DFM}

constructor TConnPropDlg.Create(AOwner: TComponent; Account: string);
begin
  inherited Create(AOwner);
  AccountEntry := TAccountEntry.Create(Account);
  Name.Text := Account;
  Server.Text := AccountEntry.Server;
  Base.Text := AccountEntry.Base;
  User.Text := AccountEntry.User;
  Password.Text := AccountEntry.Password;
  cbSSL.Checked := AccountEntry.UseSSL;
  Port.Text := IntToStr(AccountEntry.Port);
  VersionCombo.ItemIndex := AccountEntry.LdapVersion - 2;
end;

procedure TConnPropDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if Name.Text = '' then
      raise Exception.Create(sAccntNameReq);
    AccountEntry.Name := Name.Text;
    AccountEntry.Server := Server.Text;
    AccountEntry.Base := Base.Text;
    AccountEntry.User := User.Text;
    AccountEntry.Password := Password.Text;
    AccountEntry.Port := StrToInt(Port.Text);
    AccountEntry.UseSSL := cbSSL.Checked;
    AccountEntry.LdapVersion := StrToInt(VersionCombo.Text);
    AccountEntry.Write;
  end;
  Action := caFree;
end;

procedure TConnPropDlg.cbSSLClick(Sender: TObject);
begin
  if cbSSL.Checked then
    Port.Text := IntToStr(LDAP_SSL_PORT)
  else
    Port.Text := IntToStr(LDAP_PORT)
end;

end.
