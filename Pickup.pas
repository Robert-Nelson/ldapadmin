  {      LDAPAdmin - Pickup.pas
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

unit Pickup;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, LDAPClasses, ImgList;

const
  bmGroup          =  0;
  bmGroupSel       =  0;
  bmMailGroup      =  1;
  bmMailGroupSel   =  1;
  bmCGroup         =  2;
  bmCGroupSel      =  3;
  bmUser           =  3;
  bmUserSel        =  3;
  bmComputer       =  4;
  bmComputerSel    =  4;

type
  TPickupDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ListView: TListView;
    ImageList: TImageList;
    Label1: TLabel;
    FilterEdit: TEdit;
    tmrChanged: TTimer;
    FullList: TListView;
    procedure ListViewDeletion(Sender: TObject; Item: TListItem);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewClick(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
    procedure tmrChangedTimer(Sender: TObject);
  private
    ColumnToSort: Integer;
    Descending: Boolean;
    procedure CopyListItem(si, di: TListItem);
  public
    procedure Populate(Session: TLDAPSession; Filter: string; var attrs: PCharArray;
      ImgIdx: integer = -1);
    procedure PopulateGroups(Session: TLDAPSession);
    procedure PopulateMailGroups(Session: TLDAPSession);
    procedure PopulateAccounts(Session: TLDAPSession);
    procedure PopulateMailAccounts(Session: TLDAPSession);

    procedure FillFullList;
  end;

var
  PickupDlg: TPickupDlg;

implementation

{$R *.DFM}


uses WinLDAP, Constant;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
var
  n1, n2: Integer;
begin
  n1 := Item1.ImageIndex;
  n2 := Item2.ImageIndex;
  {if ((n1 = bmOu) and (n2 <> bmOu)) then
    Result := -1
  else
  if ((n2 = bmOu) and (n1 <> bmOu))then
    Result := 1}
  if n1 > n2 then
    Result := 1
  else
  if n1 < n2 then
    Result := -1
  else
    Result := AnsiStrIComp(PChar(Item1.Caption), PChar(Item2.Caption));
end;


{ This function takes filter parameter to use on LDAP search and attrs parameter
  which is a NULL terminated array of PChars to attribute names we want to display
  in a list box. The caller can prepare list view columns, if there are not enough
  columns to display results they are automatically added with attribute name
  used as a caption. if there are multiple values per attribute only first returned
  will be displayed }

procedure TPickupDlg.Populate(Session: TLDAPSession; Filter: string; var attrs: PCharArray;
  ImgIdx: integer = -1);
var
  plmSearch, plmEntry: PLDAPMessage;
  ppcVals: PPChar;
  pld: PLDAP;
  I: Integer;
  ListItem: TListItem;
  NewColumn: TListColumn;

function IndexOf(entryName: string): Integer;
var
  I: Integer;
begin
  I := 0;
  while Assigned(attrs[I]) do
  begin
    If (StrIComp(PChar(entryName), attrs[i]) = 0) then
      break;
    Inc(I);
  end;
  Result := I;
end;

begin

  pld := Session.pld;

  for i := ListView.Columns.Count to High(attrs)-1 do
  begin
    NewColumn := ListView.Columns.Add;
    NewColumn.Caption := attrs[i];
  end;

  LdapCheck(ldap_search_s(pld, PChar(Session.Base), LDAP_SCOPE_SUBTREE,
                               PChar(Filter), PChar(attrs), 0, plmSearch));
  try
    // loop thru entries
    plmEntry := ldap_first_entry(pld, plmSearch);
    while Assigned(plmEntry) do
    begin
      //ListItem := ListView.Items.Add;
      i := 0;
      while Assigned(attrs[i]) do
      begin
        ppcVals := ldap_get_values(pld, plmEntry, attrs[i]);
        if Assigned(ppcVals) then
        try
          if I = 0 then
          begin
            ListItem := ListView.Items.Add;
            ListItem.Caption := PCharArray(ppcVals)[0];
            ListItem.Data := StrNew(ldap_get_dn(pld, plmEntry));
            if ImgIdx <> -1 then
              ListItem.ImageIndex := ImgIdx;
            //ListItem.SubItems.Add(PChar(ListItem.Data));
          end
          else
            ListItem.SubItems.Add(PCharArray(ppcVals)[0]);
        finally
          LDAPCheck(ldap_value_free(ppcVals));
        end;
        inc(i);
      end;
      plmEntry := ldap_next_entry(pld, plmEntry);
    end;
  finally
    // free search results
    LDAPCheck(ldap_msgfree(plmSearch));
  end;

  //ListView.AlphaSort;
  ListView.CustomSort(@CustomSortProc, 0);

end;

procedure TPickupDlg.PopulateGroups(Session: TLDAPSession);
var
  attrs: PCharArray;
begin
  // set result fields
  SetLength(attrs, 3);
  attrs[0] := 'cn';
  attrs[1] := 'description';
  attrs[2] := nil;
  ListView.Columns[1].Caption := cDescription;
  Caption := cPickGroups;
  Populate(Session, sGROUPS, attrs, bmGroup);

  FillFullList;
end;

procedure TPickupDlg.PopulateMailGroups(Session: TLDAPSession);
var
  attrs: PCharArray;
begin
  // set result fields
  SetLength(attrs, 3);
  attrs[0] := 'cn';
  attrs[1] := 'description';
  attrs[2] := nil;
  ListView.Columns[1].Caption := cDescription;
  Caption := cPickGroups;
  Populate(Session, sMAILGROUPS, attrs, bmMailGroup);

  FillFullList;
end;

procedure TPickupDlg.PopulateAccounts(Session: TLDAPSession);
var
  attrs: PCharArray;
  i: Integer;
begin
  // set result to Result only
  SetLength(attrs, 2);
  attrs[0] := 'uid';
  attrs[1] := nil;
  Caption := cPickAccounts;
  Populate(Session, sPOSIXACCNT, attrs, bmUser);
  for i := 0 to ListView.Items.Count - 1 do
    with ListView.Items[i] do Subitems.Add(Session.CanonicalName(Session.GetDirFromDN(PChar(Data))));

  FillFullList;
end;


procedure TPickupDlg.PopulateMailAccounts(Session: TLDAPSession);
var
  attrs: PCharArray;
  i: Integer;
begin
  // set result to Result only
  SetLength(attrs, 2);
  attrs[0] := 'uid';
  attrs[1] := nil;
  Caption := cPickAccounts;
  Populate(Session, sMAILACCNT, attrs, bmUser);
  for i := 0 to ListView.Items.Count - 1 do
    with ListView.Items[i] do Subitems.Add(Session.CanonicalName(Session.GetDirFromDN(PChar(Data))));

  FillFullList;
end;

procedure TPickupDlg.ListViewDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    StrDispose(Item.Data);
end;

procedure TPickupDlg.ListViewDblClick(Sender: TObject);
begin
  ModalResult := mrOk
end;

procedure TPickupDlg.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ColumnToSort <> Column.Index then
  begin
    ColumnToSort := Column.Index;
    Descending := false;
  end
  else
    Descending := not Descending;
  //(Sender as TCustomListView).AlphaSort;
  (Sender as TCustomListView).CustomSort(@CustomSortProc, 0);
end;

procedure TPickupDlg.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
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

procedure TPickupDlg.ListViewClick(Sender: TObject);
begin
  OkBtn.Enabled := Assigned(ListView.Selected);
end;

procedure TPickupDlg.FilterEditChange(Sender: TObject);
begin
  tmrChanged.Enabled := false;
  tmrChanged.Enabled := true;
end;

procedure TPickupDlg.CopyListItem(si, di: TListItem);
begin
  if di <> nil then
  with di do
  begin
    Caption := si.Caption;
    Data := StrNew(si.Data);
    ImageIndex := si.ImageIndex;
    Indent := si.Indent;
    OverlayIndex := si.OverlayIndex;
    StateIndex := si.StateIndex;
    SubItems.Assign(si.SubItems);
    Checked := si.Checked;
  end;
end;

procedure TPickupDlg.tmrChangedTimer(Sender: TObject);
var
  i: integer;
  sl: TStringList;
  oldc: TCursor;

  procedure Match(li: TListItem);
  var
    s: string;
    i: integer;
  begin
    s := li.Caption;
    for i:=0 to li.SubItems.Count-1 do
      s := s + '#1' + li.SubItems[i];
    s := UpperCase(s);

    for i:=0 to sl.Count-1 do
      if Pos(sl[i],s) = 0 then exit;

    CopyListItem(li, ListView.Items.Add);
  end;

begin
  tmrChanged.Enabled := false;
  sl := TStringList.Create;
  oldc := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    sl.CommaText := UpperCase(FilterEdit.Text);
    for i:=0 to FullList.Items.Count-1 do
      Match(FullList.Items[i]);
  finally
    Screen.Cursor := oldc;
    ListView.Items.EndUpdate;
    sl.Free;
  end;
end;

procedure TPickupDlg.FillFullList;
var
  i: integer;
begin
  FullList.Items.Clear;

  FullList.Columns.Assign(ListView.Columns);
  for i:=0 to ListView.Items.Count-1 do
    CopyListItem(ListView.Items[i], FullList.Items.Add);
end;

end.
