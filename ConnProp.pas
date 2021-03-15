  {      LDAPAdmin - Connprop.pas
  *      Copyright (C) 2003 Tihomir Karlovic
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

unit ConnProp;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, Config;

type
  TConnPropDlg = class(TForm)
    OKBtn:        TButton;
    CancelBtn:    TButton;
    NameEd:       TEdit;
    Label1:       TLabel;
    AccountBox:   TGroupBox;
    Label4:       TLabel;
    UserEd:       TEdit;
    Label5:       TLabel;
    PasswordEd:   TEdit;
    AnonimousCbx: TCheckBox;
    GroupBox3:    TGroupBox;
    Label2:       TLabel;
    ServerEd:     TEdit;
    Label3:       TLabel;
    PortEd:       TEdit;
    cbSSL:        TCheckBox;
    VersionCombo: TComboBox;
    Label7:       TLabel;
    Label6:       TLabel;
    FetchDnBtn:   TBitBtn;
    Panel1:       TPanel;
    Bevel1:       TBevel;
    BaseEd:       TComboBox;
    TestBtn:      TButton;
    procedure     cbSSLClick(Sender: TObject);
    procedure     AnonimousCbxClick(Sender: TObject);
    procedure     FetchDnBtnClick(Sender: TObject);
    procedure     VersionComboChange(Sender: TObject);
    procedure     TestBtnClick(Sender: TObject);
  private
    FUser:        string;
    FPass:        string;
    FPassEnable:  boolean;
    function      GetBase: string;
    procedure     SetBase(const Value: string);
    function      GetLdapVersion: integer;
    procedure     SetLdapVersion(const Value: integer);
    function      GetUser: string;
    procedure     SetUser(const Value: string);
    function      GetPassword: string;
    procedure     SetPassword(const Value: string);
    function      GetPort: integer;
    procedure     SetPort(const Value: integer);
    function      GetServer: string;
    procedure     SetServer(const Value: string);
    function      GetSSL: boolean;
    procedure     SetSSL(const Value: boolean);
    function      GetName: string;
    procedure     SetConnectionName(const Value: string);
    procedure SetPassEnable(const Value: boolean);
  protected
    procedure     DoShow; override;
  public
    constructor   Create(AOwner: TComponent); override;
    property      Name: string read GetName write SetConnectionName;
    property      SSL: boolean read GetSSL write SetSSL;
    property      Port: integer read GetPort write SetPort;
    property      LdapVersion: integer read GetLdapVersion write SetLdapVersion;
    property      User: string read GetUser write SetUser;
    property      Server: string read GetServer write SetServer;
    property      Base: string read GetBase write SetBase;
    property      Password: string read GetPassword write SetPassword;
    property      PasswordEnable: boolean read FPassEnable write SetPassEnable;
  end;

var
  ConnPropDlg: TConnPropDlg;

implementation

uses WinLDAP, Constant, LDAPClasses, Math, Dialogs;

{$R *.DFM}

constructor TConnPropDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Port:=LDAP_PORT;
  LdapVersion:=LDAP_VERSION3;
end;

procedure TConnPropDlg.DoShow;
begin
  AnonimousCbx.Checked:=(UserEd.Text='');
  FetchDnBtn.Enabled:=VersionCombo.Text='3';
  inherited;
end;

function TConnPropDlg.GetName: string;
begin
  result:=NameEd.Text;
end;

procedure TConnPropDlg.SetConnectionName(const Value: string);
begin
  NameEd.Text:=Value;
end;

function TConnPropDlg.GetServer: string;
begin
  result:=ServerEd.Text;
end;

procedure TConnPropDlg.SetServer(const Value: string);
begin
  ServerEd.Text:=Value;
end;

function TConnPropDlg.GetBase: string;
begin
  result:=BaseEd.Text;
end;

procedure TConnPropDlg.SetBase(const Value: string);
begin
  BaseEd.Text:=Value;
end;

function TConnPropDlg.GetUser: string;
begin
  result:=UserEd.Text;
end;

procedure TConnPropDlg.SetUser(const Value: string);
begin
  UserEd.Text:=Value;
end;

function TConnPropDlg.GetPassword: string;
begin
  result:=PasswordEd.Text;
end;

procedure TConnPropDlg.SetPassword(const Value: string);
begin
  PasswordEd.Text:=Value;
end;

function TConnPropDlg.GetLdapVersion: integer;
begin
  result:=StrToInt(VersionCombo.Text);
end;

procedure TConnPropDlg.SetLdapVersion(const Value: integer);
begin
  VersionCombo.ItemIndex := Value - 2;
end;

function TConnPropDlg.GetPort: integer;
begin
  result:=StrToInt(PortEd.Text);
end;

procedure TConnPropDlg.SetPort(const Value: integer);
begin
  PortEd.Text:=IntToStr(Value);
end;

function TConnPropDlg.GetSSL: boolean;
begin
  result:=cbSSL.Checked;
end;

procedure TConnPropDlg.SetSSL(const Value: boolean);
begin
  cbSSL.Checked:=Value;
end;

procedure TConnPropDlg.cbSSLClick(Sender: TObject);
begin
  if cbSSL.Checked then PortEd.Text := IntToStr(LDAP_SSL_PORT)
  else PortEd.Text := IntToStr(LDAP_PORT)
end;

procedure TConnPropDlg.AnonimousCbxClick(Sender: TObject);
begin
  UserEd.Enabled:=not AnonimousCbx.Checked;
  PasswordEd.Enabled:=not AnonimousCbx.Checked;
  Label4.Enabled:=not AnonimousCbx.Checked;
  Label5.Enabled:=not AnonimousCbx.Checked;

  if AnonimousCbx.Checked then begin
    FUser:=UserEd.Text;
    FPass:=PasswordEd.Text;
    UserEd.Text:='';
    PasswordEd.Text:='';
  end
  else begin
    UserEd.Text:=FUser;
    PasswordEd.Text:=FPass;
  end;
end;

procedure TConnPropDlg.FetchDnBtnClick(Sender: TObject);
var
  AList: TLdapEntryList;
  ASession: TLDAPSession;
  i,j: integer;

begin
  ASession:=TLDAPSession.Create;
  AList:=TLdapEntryList.Create;
  BaseEd.Items.Clear;
  Asession.Server:=ServerEd.Text;
  Asession.SSL:=SSl;
  ASession.Port:= Port;
  ASession.Version:=3;

  try
    ASession.Connect;
    ASession.Search('objectClass=*','',LDAP_SCOPE_BASE,['namingContexts'],false,AList);
    for i:=0 to AList.Count-1 do
      for j:=0 to AList[i].AttributesByName['namingContexts'].ValueCount-1 do
        BaseEd.Items.Add(AList[i].AttributesByName['namingContexts'].Values[j].AsString);

    if BaseEd.Items.Count>0 then begin
      BaseEd.Style:=csDropDown;
      BaseEd.DroppedDown:=true;
      if BaseEd.Text='' then BaseEd.ItemIndex:=0;
    end
    else BaseEd.Style:=csSimple;

    ASession.Disconnect;
  finally
    Asession.Free;
    AList.Free;
  end;
end;

procedure TConnPropDlg.VersionComboChange(Sender: TObject);
begin
  FetchDnBtn.Enabled:=VersionCombo.Text='3';
end;

procedure TConnPropDlg.TestBtnClick(Sender: TObject);
var
  Asession: TLDAPSession;
begin
  Asession:=TLDAPSession.Create;
  try
    ASession.Server   := self.Server;
    ASession.Port     := self.Port;
    ASession.Version  := self.LdapVersion;
    ASession.Base     := self.Base;
    ASession.User     := self.User;
    ASession.Password := self.Password;

    Screen.Cursor:=crHourGlass;
    Asession.Connect;
    //if Asession.Connected then
    Application.MessageBox('Connection is successful.', pchar(Application.Title), MB_ICONINFORMATION+ MB_OK);
  finally
    Screen.Cursor:=crDefault;
    Asession.Free;
  end;
end;


procedure TConnPropDlg.SetPassEnable(const Value: boolean);
begin
  FPassEnable := Value;
  PasswordEd.Visible:=Value;
  if Value then Label5.Caption:= 'Password:'
  else Label5.Caption:=stCantStorPass;
end;

end.
