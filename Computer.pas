  {      LDAPAdmin - Computer.pas
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

unit Computer;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LDAPClasses, Samba, Posix, RegAccnt, Constant;

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
  private
    dn: string;
    ldSession: TLDAPSession;
    RegAccount: TAccountEntry;
    DomList: TDomainList;
    EditMode: TEditMode;
    Account: TPosixAccount;
  public
    constructor Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode); reintroduce;
  end;

var
  ComputerDlg: TComputerDlg;

implementation

uses WinLDAP;

{$R *.DFM}

constructor TComputerDlg.Create(AOwner: TComponent; dn: string; RegAccount: TAccountEntry; Session: TLDAPSession; Mode: TEditMode);
var
  i: Integer;
begin
  inherited Create(AOwner);
  Self.dn := dn;
  ldSession := Session;
  Self.RegAccount := RegAccount;
  EditMode := Mode;

  if EditMode = EM_MODIFY then
  begin
    edComputername.Enabled := False;
    edComputername.Text := ldSession.GetNameFromDN(dn);
    Caption := Format(cPropertiesOf, [edComputername.Text]);
    Account := TSamba3Account.Create(ldSession.pld, dn);
    with TSamba3Account(Account) do
    begin
      Account.Read;
      if DomainName <> '' then
        cbDomain.Items.Add(DomainName)
      else
        cbDomain.Items.Add(cSamba2Accnt);
      cbDomain.ItemIndex := 0;
      cbDomain.Enabled := false;
      edDescription.text := Description;
    end;
  end
  else begin
    DomList := TDomainList.Create(ldSession);
    with cbDomain do
    begin
      Items.Add(cSamba2Accnt);
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
  OKBtn.Enabled := edComputername.Text <> '';
end;

procedure TComputerDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  uidnr, gidnr: Integer;
  nbName: string;
  pDom: PDomainRec;
begin
  if ModalResult = mrOk then
  begin
    if EditMode = EM_ADD then
    begin

      // Aquire next available uidNumber and calculate related SAMBA attributes
      uidnr := ldSession.GetFreeUidNumber(RegAccount.posixFirstUID, RegAccount.posixLastUID);
      gidnr := COMPUTER_GROUP;

      nbName := uppercase(edComputername.Text) + '$';

      if cbDomain.ItemIndex = 0 then
      with TSambaAccount(Account) do
        Account := TSambaAccount.Create(ldSession.pld, 'uid=' + nbName + ',' + dn)
      else
        Account := TSamba3Account.Create(ldSession.pld, 'uid=' + nbName + ',' + dn);

      with Account do
      try
        UidNumber := uidnr;
        GidNumber := gidnr;
        Cn := nbName;                        // set cn to be equal to uid
        Uid := nbName;
        LoginShell := '/bin/false';
        HomeDirectory := '/dev/null';

        if Account is TSambaAccount then with TSambaAccount(Account) do
        begin
          rid := 2 * uidnr + 1000;
          PrimaryGroupID := 2 * gidnr + 1001;
          acctFlags := '[W          ]';
          Description := Self.edDescription.Text;
        end
        else with TSamba3Account(Account) do
        begin
          pDom := DomList.Items[cbDomain.ItemIndex - 1];
          DomainName := pDom.DomainName;
          SID := Format('%s-%d', [pDom.SID, pDom.AlgorithmicRIDBase + 2 * UidNumber]);
          GroupSID := Format('%s-%d', [pDom.SID, 2 * gidnr + 1001]);
          acctFlags := '[W          ]';
          Description := Self.edDescription.Text;
        end;
        New;
      finally
        Free;
      end;
    end
    else // Modify
    if edDescription.Modified then
    begin
      with Account do
      try
        Description := Self.edDescription.Text;
        Modify;
      finally
        Free;
      end;
    end;
  end;
end;

end.
