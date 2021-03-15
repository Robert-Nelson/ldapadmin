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

unit ConnList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, ImgList, LDAPClasses;

type
  TConnListFrm = class(TForm)
    OkBtn: TButton;
    CancelBtn: TButton;
    ListView: TListView;
    PopupMenu: TPopupMenu;
    pbNew: TMenuItem;
    pbProperties: TMenuItem;
    pbDelete: TMenuItem;
    N1: TMenuItem;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure pbNewClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure pbPropertiesClick(Sender: TObject);
    procedure pbDeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
  private
    Session: TLDAPSession;
    procedure GetAccounts;
  public
    constructor Create(AOwner: TComponent; lSession: TLDAPSession); reintroduce;
  end;

var
  ConnListFrm: TConnListFrm;

implementation

uses Registry, ConnProp,RegAccnt;

{$R *.DFM}

constructor TConnListFrm.Create(AOwner: TComponent; lSession: TLDAPSession);
begin
  inherited Create(AOwner);
  Session := lSession;
end;

procedure TConnListFrm.GetAccounts;
var
  Reg: TRegistry;
  I: Integer;
  KeyList: TStringList;
  ListItem: TListItem;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, false) then
    try
      KeyList := TStringList.Create;
      Reg.GetValueNames(KeyList);
      Reg.CloseKey;
      ListView.Items.Clear;
      for I := 0 to KeyList.Count - 1 do
      begin
        ListItem := ListView.Items.Add;
        ListItem.Caption := KeyList[I];
        ListItem.ImageIndex := 0;
        //if Reg.OpenKey(KeyList[I], false) then
      end;
    finally
      KeyList.Free;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TConnListFrm.FormCreate(Sender: TObject);
begin
  GetAccounts;
end;

procedure TConnListFrm.pbNewClick(Sender: TObject);
begin
  TConnPropDlg.Create(Self, '').ShowModal;
  GetAccounts;
end;

procedure TConnListFrm.PopupMenuPopup(Sender: TObject);
var
  Enable: Boolean;
begin
  Enable := ListView.Selected <> nil;
  pbDelete.enabled := Enable;
  pbProperties.Enabled := Enable;
end;

procedure TConnListFrm.pbPropertiesClick(Sender: TObject);
begin
  TConnPropDlg.Create(Self, ListView.Selected.Caption).ShowModal;
end;

procedure TConnListFrm.pbDeleteClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, false) then
    try
      Reg.DeleteValue(ListView.Selected.Caption);
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  GetAccounts;
end;

procedure TConnListFrm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  AccountEntry: TAccountEntry;
begin
  if ModalResult = mrOk then
  begin
    AccountEntry := TAccountEntry.Create(ListView.Selected.Caption);
    with Session do begin
      Server := AccountEntry.Server;
      Base := AccountEntry.Base;
      User := AccountEntry.User;
      Password := AccountEntry.Password;
      SSL := AccountEntry.UseSSL;
      Port := AccountEntry.Port;
      Version := AccountEntry.LdapVersion;
    end;
    AccountEntry.Destroy;
  end;
end;

procedure TConnListFrm.ListViewDblClick(Sender: TObject);
begin
  if Assigned(ListView.Selected) then
    ModalResult := mrOk;
end;

procedure TConnListFrm.ListViewClick(Sender: TObject);
begin
  OkBtn.Enabled := Assigned(ListView.Selected);
end;

end.
