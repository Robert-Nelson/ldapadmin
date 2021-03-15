  {      LDAPAdmin - Computer.pas
  *      Copyright (C) 2003-2005 Tihomir Karlovic
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

unit Computer;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LDAPClasses, Samba, Posix, RegAccnt, PropertyObject,
  Constant;

type
  TComputerDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    edComputername: TEdit;
    Label1: TLabel;
    edDescription: TEdit;
    Label2: TLabel;
    cbDomain: TComboBox;
    Label3: TLabel;
    procedure edComputernameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    RegAccount: TAccountEntry;
    DomList: TDomainList;
    Entry: TLdapEntry;
    Account: TSamba3Computer;
  public
    constructor Create(AOwner: TComponent; adn: string; ARegAccount: TAccountEntry; ASession: TLDAPSession; AMode: TEditMode); reintroduce;
  end;

var
  ComputerDlg: TComputerDlg;

implementation

uses WinLDAP;

{$R *.DFM}

constructor TComputerDlg.Create(AOwner: TComponent; adn: string; ARegAccount: TAccountEntry; ASession: TLDAPSession; AMode: TEditMode);
var
  i: Integer;
begin
  inherited Create(AOwner);
  RegAccount := ARegAccount;
  Entry := TLdapEntry.Create(ASession, adn);
  if AMode = EM_MODIFY then
  begin
    Entry.Read;
    Account := TSamba3Computer.Create(Entry);
    with Account do
    begin
      if DomainName <> '' then
        cbDomain.Items.Add(DomainName);
      cbDomain.ItemIndex := 0;
      cbDomain.Enabled := false;
      edDescription.text := Description;
    end;
    edComputername.Enabled := False;
    edComputername.Text := GetNameFromDN(adn);
    Caption := Format(cPropertiesOf, [edComputername.Text]);
  end
  else begin
    DomList := TDomainList.Create(ASession);
    with cbDomain do
    begin
      for i := 0 to DomList.Count - 1 do
        Items.Add(DomList.Items[i].DomainName);
      ItemIndex := Items.IndexOf(RegAccount.SambaDomainName);
      if ItemIndex = -1 then
        ItemIndex := 0;
    end;
  end;
end;

procedure TComputerDlg.edComputernameChange(Sender: TObject);
begin
  OKBtn.Enabled := (edComputername.Text <> '') and (cbDomain.ItemIndex <> -1);
end;

procedure TComputerDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  uidnr: Integer;
begin
  if ModalResult = mrOk then
  begin
    if esNew in Entry.State then
    begin
      // Acquire next available uidNumber
      uidnr := Entry.Session.GetFreeUidNumber(RegAccount.posixFirstUID, RegAccount.posixLastUID);
      Account := TSamba3Computer.Create(Entry);
      with Account do
      begin
        New;
        ComputerName := edComputername.Text;
        DomainData := DomList.Items[cbDomain.ItemIndex];
        UidNumber := uidnr;
        GidNumber := COMPUTER_GROUP;
        Entry.dn := 'uid=' + ComputerName + ',' + Entry.dn;
      end;
    end;
    if edDescription.Modified then
      Account.Description := Self.edDescription.Text;
    Entry.Write;
  end;
end;

procedure TComputerDlg.FormDestroy(Sender: TObject);
begin
  Entry.Free;
end;

end.
