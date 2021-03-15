  {      LDAPAdmin - Search.pas
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

unit Search;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, LDAPClasses;

type
  TSearchFrm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    SBCombo: TComboBox;
    SearchBtn: TButton;
    edName: TEdit;
    edEmail: TEdit;
    StartBtn: TButton;
    CloseBtn: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListView: TListView;
    Label4: TLabel;
    StatusBar: TStatusBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
  private
    Session: TLDAPSession;
    dn: string;
    ColumnToSort: Integer;
    Descending: Boolean;
    procedure Search(const Filter: string);
  public
    constructor Create(AOwner: TComponent; const dn: string; const Session: TLDAPSession); reintroduce;
  end;

var
  SearchFrm: TSearchFrm;

implementation

uses WinLDAP, Constant;

{$R *.DFM}

procedure TSearchFrm.Search(const Filter: string);
var
  ListItem: TListItem;
  plmSearch, plmEntry: PLDAPMessage;
  attrs: PCharArray;
  pszdn: PChar;
  pld: PLDAP;
  cnt: Integer;

begin
  pld := Session.pld;

  // set result to objectclass only
  SetLength(attrs, 2);
  attrs[0] := 'objectclass';
  attrs[1] := nil;
  LdapCheck(ldap_search_s(pld, PChar(dn), LDAP_SCOPE_SUBTREE, PChar(Filter), PChar(attrs), 0, plmSearch));

  try

    cnt := 0;
    plmEntry := ldap_first_entry(pld, plmSearch);

    while Assigned(plmEntry) do
    begin

      pszdn := ldap_get_dn(pld, plmEntry);

      if Assigned(pszdn) then
      try
        ListItem := ListView.Items.Add;
        ListItem.Caption := pszdn;
        {ListItem.Caption := Session.GetNameFromDN(pszdn);
        ListItem.SubItems.Add(Session.CanonicalNAme(pszdn));}

      finally
        ldap_memfree(pszdn);
      end;

      inc(cnt);
      plmEntry := ldap_next_entry(pld, plmEntry);

    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;
  StatusBar.SimpleText := Format(stCntObjects, [cnt]);
end;

constructor TSearchFrm.Create(AOwner: TComponent; const dn: string; const Session: TLDAPSession);
begin
  inherited Create(AOwner);
  Self.dn := dn;
  Self.Session := Session;
  if dn <> '' then
    SBCombo.Text := dn
  else
    SBCombo.Text := Session.Base;
end;

procedure TSearchFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSearchFrm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSearchFrm.StartBtnClick(Sender: TObject);
var
  s: string;
begin
  ListView.Items.Clear;
  if PageControl1.ActivePage = TabSheet1 then
  begin
    s := '';
    if edName.Text <> '' then
      s := Format('(|(uid=*%s*)(displayName=*%s*))', [edName.Text, edName.Text]);
    if edEmail.Text <> '' then
      //s := s + '(mail=' + edEmail.Text + ')';
      s := Format('%s(mail=*%s*)', [s, edEMail.Text]);
    if s = '' then
      s := sANYCLASS
    else
      s := '(&' + s + ')';
    Search(s);
  end
  else
    Search(Memo1.Text);
end;

procedure TSearchFrm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  begin
    Compare := -1;
    ix := ColumnToSort - 1;
    if Item1.SubItems.Count > ix then
    begin
      Compare := 1;
      if Item2.SubItems.Count > ix then
        Compare := AnsiCompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
    end;
  end;
  if Descending then
    Compare := - Compare;
end;

procedure TSearchFrm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ColumnToSort <> Column.Index then
  begin
    ColumnToSort := Column.Index;
    Descending := false;
  end
  else
    Descending := not Descending;
  (Sender as TCustomListView).AlphaSort;
end;

end.
