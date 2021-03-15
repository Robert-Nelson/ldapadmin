  {      LDAPAdmin - Copy.pas
  *      Copyright (C) 2005 Tihomir Karlovic
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
  Buttons, ExtCtrls, ComCtrls, CommCtrl, LDAPClasses, WinLDAP;

type
  TExpandNodeProc = procedure (Node: TTreeNode; Session: TLDAPSession) of object;
  TCopyDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    cbConnections: TComboBox;
    Label1: TLabel;
    TreeView: TTreeView;
    Label2: TLabel;
    edName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cbConnectionsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure edNameChange(Sender: TObject);
    procedure cbConnectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    RdnAttribute: string;
    MainSessionIdx: Integer;
    fExpandNode: TExpandNodeProc;
    fSortProc: TTVCompare;
    ddRoot: TTreeNode;
    function GetTgtDn: string;
    function GetTgtRdn: string;
    function GetTgtSession: TLDAPSession;
  public
    constructor Create(AOwner: TComponent;
                       dn, AccountName: string;
                       Session: TLDAPSession;
                       ImageList: TImageList;
                       ExpandNode: TExpandNodeProc;
                       SortProc: TTVCompare); reintroduce;
    property TargetDn: string read GetTgtDn;
    property TargetRdn: string read GetTgtRdn;
    property TargetSession: TLDAPSession read GetTgtSession;
  end;

var
  CopyDlg: TCopyDlg;

implementation

{$R *.DFM}

uses Registry, RegAccnt, Constant;

function TCopyDlg.GetTgtDn: string;
begin
  Result := PChar(TreeView.Selected.Data);
end;

function TCopyDlg.GetTgtRdn: string;
begin
  Result := RdnAttribute + '=' + edName.Text;
end;

function TCopyDlg.GetTgtSession: TLDAPSession;
begin
  Result := TLDAPSession(cbConnections.Items.Objects[cbConnections.ItemIndex]);
end;

constructor TCopyDlg.Create(AOwner: TComponent;
                            dn, AccountName: string;
                            Session: TLDAPSession;
                            ImageList: TImageList;
                            ExpandNode: TExpandNodeProc;
                            SortProc: TTVCompare);
var
  v: string;
begin
  inherited Create(AOwner);
  SplitRdn(GetRdnFromDn(dn), RdnAttribute, v);
  edName.Text := v;
  MainSessionIdx := cbConnections.Items.IndexOf(AccountName);
  if MainSessionIdx = -1 then
    raise Exception.Create('Error!');
  cbConnections.Items.Objects[MainSessionIdx] := Session;
  fExpandNode := ExpandNode;
  fSortProc := SortProc;
  TreeView.Images := ImageList;
  cbConnections.ItemIndex := MainSessionIdx;
  cbConnectionsChange(nil);
end;


procedure TCopyDlg.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
  I: Integer;
  KeyList: TStringList;
begin
  OkBtn.Enabled := false;
  cbConnections.Items.Clear;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
    if Reg.OpenKey(REG_KEY + REG_ACCOUNT, false) then
    begin
      KeyList := TStringList.Create;
      try
        Reg.GetValueNames(KeyList);
        Reg.CloseKey;
        for I := 0 to KeyList.Count - 1 do
          cbConnections.Items.Add(KeyList[I]);
      finally
        KeyList.Free;
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TCopyDlg.cbConnectionsChange(Sender: TObject);
var
  Session: TLDAPSession;
  regAccount: TAccountEntry;
begin
  TreeView.Items.Clear;
  TreeView.Repaint;
  OkBtn.Enabled := false;
  Session := TLDAPSession(cbConnections.Items.Objects[cbConnections.ItemIndex]);
  if not Assigned(Session) then
  begin
    Session := TLDAPSession.Create;
    regAccount := TAccountEntry.Create(cbConnections.Items[cbConnections.ItemIndex]);
    with Session do
    try
      Screen.Cursor := crHourGlass;
      Server := regAccount.ldapServer;
      Base := regAccount.ldapBase;
      User := regAccount.ldapUser;
      Password := regAccount.ldapPassword;
      SSL := regAccount.ldapUseSSL;
      Port := regAccount.ldapPort;
      Version := regAccount.ldapVersion;
      Connect;
      cbConnections.Items.Objects[cbConnections.ItemIndex] := Session;
    finally
      Screen.Cursor := crDefault;
      regAccount.Free;
    end;
  end;
  ddRoot := TreeView.Items.Add(nil, Format('%s [%s]', [Session.Base, Session.Server]));
  ddRoot.Data := Pointer(StrNew(PChar(Session.Base)));
  fExpandNode(ddRoot, Session);
  ddRoot.ImageIndex := bmRoot;
  ddRoot.SelectedIndex := bmRoot;
  TreeView.CustomSort(@fSortProc, 0);
  ddRoot.Expand(false);
end;

procedure TCopyDlg.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to cbConnections.Items.Count - 1 do
    if i <> MainSessionIdx then
      (cbConnections.Items.Objects[i] as TLDAPSession).Free;
end;

procedure TCopyDlg.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if (Node.Count > 0) and (Integer(Node.Item[0].Data) = ncDummyNode) then
  with (Sender as TTreeView) do
  try
    Items.BeginUpdate;
    Node.Item[0].Delete;
    fExpandNode(Node, TLDAPSession(cbConnections.Items.Objects[cbConnections.ItemIndex]));
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
begin
  with cbConnections do
  begin
    Canvas.FillRect(rect);
    Rect.Top:=Rect.Top+1;
    Rect.Bottom:=Rect.Bottom-1;
    Rect.Left:=rect.Left+2;
    TreeView.Images.Draw(Canvas, Rect.Left, Rect.Top, bmHost);
    Rect.Left := Rect.Left + 20;
    s := Items[Index];
    DrawText(Canvas.Handle, PChar(s), Length(s), Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  end;
end;

end.
