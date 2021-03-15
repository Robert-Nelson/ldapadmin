  {      LDAPAdmin - Transport.pas
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

unit Transport;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LDAPClasses, Constant;

type
  TTransportDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    cn: TEdit;
    Label1: TLabel;
    transport: TEdit;
    Label2: TLabel;
    procedure cnChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    dn: string;
    ldSession: TLDAPSession;
    EditMode: TEditMode;
  public
    constructor Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  TransportDlg: TTransportDlg;

implementation

{$R *.DFM}

uses WinLDAP;

constructor TTransportDlg.Create(AOwner: TComponent; dn: string; Session: TLDAPSession; Mode: TEditMode);
begin
  inherited Create(AOwner);
  Self.dn := dn;
  ldSession := Session;
  EditMode := Mode;
  if EditMode = EM_MODIFY then
  begin
    cn.Enabled := False;
    cn.text := ldSession.GetNameFromDN(dn);
    //TODO: LookupList: func gets attrs list returns list or array of results
    //cn.text := ldSession.Lookup(dn, sANYCLASS, 'cn', LDAP_SCOPE_BASE);
    transport.text := ldSession.Lookup(dn, sANYCLASS, 'transport', LDAP_SCOPE_BASE);
  end;
end;

procedure TTransportDlg.cnChange(Sender: TObject);
begin
  OKBtn.Enabled := (cn.Text <> '') and (transport.Modified) and (transport.Text <> '');
end;

procedure TTransportDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Entry: TLDAPEntry;
begin
  if ModalResult = mrOk then
  begin
    if EditMode = EM_ADD then
      dn := 'cn=' + cn.Text + ',' + dn;
    Entry := TLDAPEntry.Create(ldSession.pld, dn);
    with Entry do
    try
      if EditMode = EM_ADD then
      begin
        AddAttr('objectclass', 'top', LDAP_MOD_ADD);
        AddAttr('objectclass', 'transportTable', LDAP_MOD_ADD);
        AddAttr('cn', cn.Text, LDAP_MOD_ADD);
        AddAttr('transport', transport.Text, LDAP_MOD_ADD);
        Add;
      end
      else begin
        AddAttr('transport', transport.Text, LDAP_MOD_REPLACE);
        Modify;
      end;
    finally
      Entry.Free;
    end;
  end;
end;

end.
