  {      LDAPAdmin - Copy.pas
  *      Copyright (C) 2005-2012 Tihomir Karlovic
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

unit LdapCopy;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, CommCtrl, LDAPClasses, WinLDAP, LAControls,
  ImgList, Connection;

type

  TExpandNodeProc = procedure (Node: TTreeNode; Session: TLDAPSession) of object;

  TCopyDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    TreeView: TTreeView;
    Label2: TLabel;
    edName: TEdit;
    procedure cbConnectionsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure edNameChange(Sender: TObject);
    procedure cbConnectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TreeViewDeletion(Sender: TObject; Node: TTreeNode);
  private
    cbConnections: TLAComboBox;
    RdnAttribute: string;
    MainConnectionIdx: Integer;
    fExpandNode: TExpandNodeProc;
    fSortProc: TTVCompare;
    ddRoot: TTreeNode;
    procedure cbConnectionsCloseUp(var Index: integer; var CanCloseUp: boolean);
    function  GetTgtDn: string;
    function  GetTgtRdn: string;
    function  GetTgtConnection: TConnection;
  public
    constructor Create(AOwner: TComponent;
                       dn: string;
                       Connection: TConnection;
                       ImageList: TImageList;
                       ExpandNode: TExpandNodeProc;
                       SortProc: TTVCompare); reintroduce;
    property TargetDn: string read GetTgtDn;
    property TargetRdn: string read GetTgtRdn;
    property TargetConnection: TConnection read GetTgtConnection;
  end;

var
  CopyDlg: TCopyDlg;

implementation

{$R *.DFM}

uses Registry, Config, SizeGrip, Constant, ObjectInfo;

{ TCopyDlg }

procedure TCopyDlg.cbConnectionsCloseUp(var Index: integer; var CanCloseUp: boolean);
begin
  if cbConnections.Items.Objects[Index] is TConfigStorage then
  begin
    Beep;
    CanCloseUp := false;
  end;
end;

function TCopyDlg.GetTgtDn: string;
begin
  Result := TObjectInfo(TreeView.Selected.Data).dn;
end;

function TCopyDlg.GetTgtRdn: string;
begin
  Result := RdnAttribute + '=' + edName.Text;
end;

function TCopyDlg.GetTgtConnection: TConnection;
begin
  with cbConnections, Items do
  if (Objects[ItemIndex] is TConnection) then
    Result := TConnection(Objects[ItemIndex])
  else
    Result := nil;
end;

constructor TCopyDlg.Create(AOwner: TComponent;
                            dn: string;
                            Connection: TConnection;
                            ImageList: TImageList;
                            ExpandNode: TExpandNodeProc;
                            SortProc: TTVCompare);
var
  v: string;
  i,j: integer;
begin
  inherited Create(AOwner);
  TSizeGrip.Create(Self);
  OkBtn.Enabled := false;
  cbConnections := TLAComboBox.Create(Self);
  with cbConnections do begin
    Parent := Self;
    Left := 80;
    Top := 8;
    Width := 305;
    Height := 22;
    Style := csOwnerDrawFixed;
    Anchors := [akLeft, akTop, akRight];
    ItemHeight := 16;
    TabOrder := 0;
    OnChange := cbConnectionsChange;
    OnDrawItem := cbConnectionsDrawItem;
    OnCanCloseUp := cbConnectionsCloseUp;
  end;
  for i:=0 to GlobalConfig.StoragesCount-1 do
  begin
    cbConnections.Items.AddObject(GlobalConfig.Storages[i].Name, GlobalConfig.Storages[i]);
    for j:=0 to GlobalConfig.Storages[i].AccountsCount-1 do
      cbConnections.Items.AddObject(GlobalConfig.Storages[i].Accounts[j].Name, GlobalConfig.Storages[i].Accounts[j]);
  end;

  SplitRdn(GetRdnFromDn(dn), RdnAttribute, v);
  edName.Text := v;
  MainConnectionIdx := cbConnections.Items.IndexOf(Connection.Account.Name);
  if MainConnectionIdx = -1 then
    raise Exception.Create('Connection error: could not locate active connection!');
  cbConnections.Items.Objects[MainConnectionIdx] := Connection;
  fExpandNode := ExpandNode;
  fSortProc := SortProc;
  TreeView.Images := ImageList;
  cbConnections.ItemIndex := MainConnectionIdx;
  cbConnectionsChange(nil);
end;

procedure TCopyDlg.cbConnectionsChange(Sender: TObject);
var
  Connection: TConnection;
  Account: TAccount;
begin
  TreeView.Items.Clear;
  TreeView.Repaint;
  OkBtn.Enabled := false;
  Connection := TargetConnection;
  if not Assigned(Connection) then
  begin
    Account := TAccount(cbConnections.Items.Objects[cbConnections.ItemIndex]);
    Connection := TConnection.Create(Account);
    with Connection do
    try
      Screen.Cursor := crHourGlass;
      Server   := Account.Server;
      Base     := Account.Base;
      User     := Account.User;
      Password := Account.Password;
      SSL      := Account.SSL;
      Port     := Account.Port;
      Version  := Account.ldapVersion;
      Connect;
      cbConnections.Items.Objects[cbConnections.ItemIndex] := Connection;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
  ddRoot := TreeView.Items.Add(nil, Format('%s [%s]', [Connection.Base, Connection.Server]));
  ddRoot.Data := TLdapEntry.Create(Connection, Connection.Base);
  fExpandNode(ddRoot, Connection);
  ddRoot.ImageIndex := bmRoot;
  ddRoot.SelectedIndex := bmRoot;
  TreeView.CustomSort(@fSortProc, 0);
  ddRoot.Expand(false);
end;

procedure TCopyDlg.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  with cbConnections.Items do
  for i := 0 to Count - 1 do
    if (i <> MainConnectionIdx) and (Objects[i] is TConnection)then
      Objects[i].Free;
end;

procedure TCopyDlg.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if (Node.Count > 0) and (Integer(Node.Item[0].Data) = ncDummyNode) then
  with (Sender as TTreeView) do
  try
    Items.BeginUpdate;
    Node.Item[0].Delete;
    fExpandNode(Node, TargetConnection);
    CustomSort(@fSortProc, 0);
  finally
    Items.EndUpdate;
  end;
end;

procedure TCopyDlg.edNameChange(Sender: TObject);
begin
  OKBtn.Enabled := (edName.Text <> '') and Assigned(TreeView.Selected);
end;

procedure TCopyDlg.cbConnectionsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: string;
  ImageIndex: Integer;
begin
  with cbConnections do
  begin
    Canvas.FillRect(rect);
    if Items.Objects[Index] is TConfigStorage then
    begin
      if Index = 0 then
        ImageIndex := 32
      else
        ImageIndex := 33;
    end
    else begin
      ImageIndex := bmHost;
      Rect.Left:=Rect.Left+20;
    end;
    Rect.Top:=Rect.Top+1;
    Rect.Bottom:=Rect.Bottom-1;
    Rect.Left:=rect.Left+2;
    TreeView.Images.Draw(Canvas, Rect.Left, Rect.Top, ImageIndex);
    Rect.Left := Rect.Left + 20;
    s := Items[Index];
    DrawText(Canvas.Handle, PChar(s), Length(s), Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  end;
end;

procedure TCopyDlg.TreeViewDeletion(Sender: TObject; Node: TTreeNode);
begin
  if (Node.Data <> nil) and (Integer(Node.Data) <> ncDummyNode) then
    TObjectInfo(Node.Data).Free;
end;

end.
