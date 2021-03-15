  {      LDAPAdmin - uSchemaDlg.pas
  *      Copyright (C) 2005 Alexander Sokoloff
  *
  *      Author: Alexander Sokoloff
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

unit uSchemaDlg;

interface

uses
  Windows, SysUtils, Graphics, Forms, Buttons, Classes, Controls, ComCtrls,
  ExtCtrls, ImgList, Schema, StdCtrls, LDAPClasses, Messages, Menus, Clipbrd;

type
  TChangeType=(ct_Normal,ct_Undo,ct_Redo);

  TSchemaDlg = class(TForm)
    Tree:           TTreeView;
    ImageList1:     TImageList;
    Splitter1:      TSplitter;
    Panel1:         TPanel;
    Label1:         TLabel;
    SearchEdit:     TEdit;
    View:           TTreeView;
    UndoBtn:        TSpeedButton;
    RedoBtn:        TSpeedButton;
    PopupMenu: TPopupMenu;
    pmCopy: TMenuItem;
    StatusBar: TStatusBar;
    procedure       TreeChange(Sender: TObject; Node: TTreeNode);
    procedure       SearchEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure       ViewMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
    procedure       ViewAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure       UndoBtnClick(Sender: TObject);
    procedure       TreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure       RedoBtnClick(Sender: TObject);
    procedure       ViewClick(Sender: TObject);
    procedure       ViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure       FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmCopyClick(Sender: TObject);
    procedure ViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    FUndo:          TList;
    FRedo:          TList;
    FChangeType:    TChangeType;
    FSchema:        TLDAPSchema;
    FLastSerched:   string;
    function        AddValue(const Name: string; Value: string; IsUrl: boolean=false; const Parent: TTreeNode=nil): TTreeNode; overload;
    function        AddValue(const Name: string; Value: integer): TTreeNode; overload;
    function        AddValue(const Name: string; Value: boolean): TTreeNode; overload;
    procedure       Search(const SearchStr: string);
    procedure       ShowObjectClass(const ObjClass: TLDAPSchemaClass);
    procedure       ShowAttribute(const Attribute: TLDAPSchemaAttribute);
    procedure       ShowSyntax(const Syntax: TLDAPSchemaSynax);
    procedure       ShowMatchingRule(const MatchingRule: TLDAPSchemaMatchingRule);
    procedure       ShowMatchingRuleUse(const MatchingRuleUse: TLDAPSchemaMatchingRuleUse);
    procedure       WmGetSysCommand(var Message :TMessage); Message WM_SYSCOMMAND;
  public
    constructor     Create(const ASession: TLDAPSession); reintroduce;
    destructor      Destroy; override;
  end;

implementation

{$R *.dfm}

{ TSchemaDlg }

constructor TSchemaDlg.Create(const ASession: TLDAPSession);
var
  i: integer;
  ParentNode: TTreeNode;
begin
  inherited Create(Application.MainForm);
  FUndo:=TList.Create;
  FRedo:=TList.Create;
  FSchema:=TLDAPSchema.Create(ASession);
  if not FSchema.Loaded then begin
    Application.MessageBox('Can''t load LDAP schema',pchar(application.Title),MB_ICONERROR or MB_OK);
    Free;
  end;

  ParentNode:=Tree.Items.Add(nil,'Object Classes');
  ParentNode.ImageIndex:=1;
  ParentNode.SelectedIndex:=1;
   for i:=0 to FSchema.OBjectClasses.Count-1 do begin
     with Tree.Items.AddChild(ParentNode,FSchema.OBjectClasses.Items[i].Name.CommaText) do begin
       Data:=FSchema.OBjectClasses.Items[i];
     end;
   end;

  ParentNode:=Tree.Items.Add(nil,'Attribute Types');
  ParentNode.ImageIndex:=1;
  ParentNode.SelectedIndex:=1;
  for i:=0 to FSchema.Attributes.Count-1 do begin
    with Tree.Items.AddChild(ParentNode,FSchema.Attributes.Items[i].Name.CommaText) do begin
      Data:=FSchema.Attributes.Items[i];
    end;
  end;

  ParentNode:=Tree.Items.Add(nil,'Syntaxes');
  ParentNode.ImageIndex:=1;
  ParentNode.SelectedIndex:=1;
  for i:=0 to FSchema.Syntaxes.Count-1 do begin
    with Tree.Items.AddChild(ParentNode,FSchema.Syntaxes.Items[i].Oid) do begin
      Data:=FSchema.Syntaxes.Items[i];
    end;
  end;

  ParentNode:=Tree.Items.Add(nil,'Matching Rules');
  ParentNode.ImageIndex:=1;
  ParentNode.SelectedIndex:=1;
  for i:=0 to FSchema.MatchingRules.Count-1 do begin
    with Tree.Items.AddChild(ParentNode,FSchema.MatchingRules.Items[i].Name) do begin
      Data:=FSchema.MatchingRules.Items[i];
    end;
  end;

  ParentNode:=Tree.Items.Add(nil,'Matching Rule Use');
  ParentNode.ImageIndex:=1;
  ParentNode.SelectedIndex:=1;
  for i:=0 to FSchema.MatchingRuleUses.Count-1 do begin
    with Tree.Items.AddChild(ParentNode,FSchema.MatchingRuleUses.Items[i].Name) do begin
      Data:=FSchema.MatchingRuleUses.Items[i];
    end;
  end;

  Tree.AlphaSort;
  Show;
end;

destructor TSchemaDlg.Destroy;
begin
  inherited;
  FUndo.Free;
  FRedo.Free;
  FSchema.Free;
end;

procedure TSchemaDlg.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Tree.Selected=nil then exit;
  View.Items.BeginUpdate;
  View.Items.Clear;
  if (TObject(Tree.Selected.Data) is TLDAPSchemaClass) then ShowObjectClass(TLDAPSchemaClass(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaAttribute) then ShowAttribute(TLDAPSchemaAttribute(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaSynax) then ShowSyntax(TLDAPSchemaSynax(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaMatchingRule) then ShowMatchingRule(TLDAPSchemaMatchingRule(Tree.Selected.Data));
  if (TObject(Tree.Selected.Data) is TLDAPSchemaMatchingRuleUse) then ShowMatchingRuleUse(TLDAPSchemaMatchingRuleUse(Tree.Selected.Data));

  View.FullExpand;
  if View.Items.Count>0 then View.Items[0].Selected:=true;
  View.Items.EndUpdate;

  if Tree.Selected.Parent=nil then begin
    StatusBar.Panels[0].Text:=' '+Tree.Selected.Text;
    StatusBar.Panels[1].Text:=' '+inttostr(Tree.Selected.Count)+ ' items';
  end
  else begin
    StatusBar.Panels[0].Text:=' '+Tree.Selected.Parent.Text;
    StatusBar.Panels[1].Text:=' '+Tree.Selected.Text;
  end;
end;

procedure TSchemaDlg.Search(const SearchStr: string);
  function DoSearch(Start: TTreeNode; Pattern: string): boolean;
  begin
    while Start <> nil do begin
      if pos(Pattern,UpperCase(Start.Text))>0 then begin
        Start.Selected:=true;
        result:=true;
        exit;
      end;
      Start:= Start.GetNext;
    end;
    result:=false;
  end;
var
  s: string;
begin
  s:=Trim(UpperCase(SearchStr));
  if S<>FLastSerched then begin
    DoSearch(Tree.Items.GetFirstNode, s);
    FLastSerched:=s;
  end
  else begin
    if not DoSearch(Tree.Selected.GetNext, s) then
      DoSearch(Tree.Items.GetFirstNode, s);
  end;
end;

procedure TSchemaDlg.SearchEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if KEY=VK_RETURN then Search(SearchEdit.Text);
end;

procedure TSchemaDlg.ViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  Node:=View.GetNodeAt(X,Y);
  if (Node<>nil) and (integer(Node.Data)>0) then View.Cursor:=crHandPoint
  else View.Cursor:=crDefault;
end;

procedure TSchemaDlg.ViewClick(Sender: TObject);
var
  n: integer;
begin
  if (View.Selected<>nil) and (integer(View.Selected.Data)>0) then begin
    n:=pos(': ',View.Selected.Text);
    Search(trim(copy(View.Selected.Text,n+1,length(View.Selected.Text)-n+1)));
  end;
end;

procedure TSchemaDlg.ViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then viewClick(nil);
end;

procedure TSchemaDlg.ViewAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
  if integer(Node.Data)>0 then begin
    if not (cdsFocused in State) then View.Canvas.Font.Color:=clBlue;
    View.Canvas.Font.Style:=[fsUnderline];
  end;
end;

procedure TSchemaDlg.UndoBtnClick(Sender: TObject);
begin
  if FUndo.Count<1 then Exit;
  FChangeType:=ct_Undo;
  TTreeNode(FUndo.Items[FUndo.Count-1]).Selected:=true;
end;

procedure TSchemaDlg.RedoBtnClick(Sender: TObject);
begin
  if FRedo.Count<1 then exit;
  FChangeType:=ct_Redo;
  TTreeNode(FRedo.Items[FRedo.Count-1]).Selected:=true;
end;

procedure TSchemaDlg.TreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  if Tree.Selected<>nil then begin
    case FChangeType of
      ct_Normal:  begin
                    FUndo.Add(Tree.Selected);
                    FRedo.Clear;
                  end;
      ct_Undo:    begin
                    FRedo.Add(Tree.Selected);
                    if FUndo.Count>0 then FUndo.Delete(FUndo.Count-1);
                  end;
      ct_Redo:    begin
                    FUndo.Add(Tree.Selected);
                    if FRedo.Count>0 then FRedo.Delete(FRedo.Count-1);
                  end;
    end;
  end;
  FChangeType:=ct_Normal;
  UndoBtn.Enabled:=FUndo.Count>0;
  RedoBtn.Enabled:=FRedo.Count>0;
end;

function TSchemaDlg.AddValue(const Name: string; Value: string; IsUrl: boolean=false; const Parent: TTreeNode=nil): TTreeNode;
var
  S: string;
begin
  if Name<>'' then S:=': '
  else S:='';

  if IsUrl then result:=View.Items.AddChildObject(Parent, Name+S+Value,pointer(length(Value)))
  else result:=View.Items.AddChild(Parent,Name+S+Value);
  result.ImageIndex:=-1;
  result.SelectedIndex:=-1;
  result.StateIndex:=-1;
end;

function TSchemaDlg.AddValue(const Name: string; Value: integer): TTreeNode;
begin
  result:=AddValue(Name,inttostr(Value));
end;

function TSchemaDlg.AddValue(const Name: string; Value: boolean): TTreeNode;
begin
  if Value then result:=AddValue(Name,'Yes')
  else result:=AddValue(Name,'No');
end;

procedure TSchemaDlg.ShowObjectClass(const ObjClass: TLDAPSchemaClass);
var
  i: integer;
  Node: TTreeNode;
begin
  with ObjClass do begin
    case Name.Count of
      0: AddValue('Name','');
      1: AddValue('Name',Name[0]);
      else begin
        Node:=AddValue('Names','');
        for i:=0 to Name.Count-1 do AddValue('',Name[i],false,Node);
      end;
    end;
    AddValue('Description',Description);
    AddValue('Oid',Oid);

    case Kind of
      lck_Abstract:   AddValue('Kind','Abstract');
      lck_Auxiliary:  AddValue('Kind','Auxiliary');
      lck_Structural: AddValue('Kind','Structural');
    end;

    AddValue('Superior',Sup,true);

    Node:=AddValue('Must','');
    Node.ImageIndex:=1;
    Node.SelectedIndex:=1;
    for i:=0 to Must.Count-1 do begin
      AddValue('',Must[i],true,Node);
    end;

    Node:=AddValue('May','');
    Node.ImageIndex:=1;
    Node.SelectedIndex:=1;
    for i:=0 to May.Count-1 do begin
      AddValue('',May[i],true,Node);
    end;
  end;
end;

procedure TSchemaDlg.ShowAttribute(const Attribute: TLDAPSchemaAttribute);
var
  Node: TTreeNode;
  i: integer;
begin
  with Attribute do begin
   case Name.Count of
      0: AddValue('Name','');
      1: AddValue('Name',Name[0]);
      else begin
        Node:=AddValue('Names','');
        Node.ImageIndex:=1;
        Node.SelectedIndex:=1;
        for i:=0 to Name.Count-1 do AddValue('',Name[i],false,Node);
      end;
   end;
    AddValue('Description',Description);
    AddValue('Oid',Oid);
    AddValue('Single Value',SingleValue);
    AddValue('Syntax',Syntax,true);

    if Attribute.Length>0 then AddValue('Length',Length)
    else AddValue('Length','undefined');

    AddValue('Superior',Superior,true);
    AddValue('Collective',Collective);
    AddValue('Obsolete',Obsolete);
    AddValue('No user modification',NoUserModification);

    case Attribute.Usage of
      au_directoryOperation:   AddValue('Usage','Directory operation');
      au_distributedOperation: AddValue('Usage','Distributed operation');
      au_dSAOperation:         AddValue('Usage','DSA operation');
      au_userApplications:     AddValue('Usage','User applications');
    end;

    AddValue('Ordering', Ordering,true);
    AddValue('Equality', Equality,true);
    AddValue('Substring',Substr,  true);
  end;
end;

procedure TSchemaDlg.ShowSyntax(const Syntax: TLDAPSchemaSynax);
begin
  with Syntax do begin
    AddValue('Oid',Oid);
    AddValue('Description',Description);
  end;
end;

procedure TSchemaDlg.ShowMatchingRule(const MatchingRule: TLDAPSchemaMatchingRule);
begin
  with MatchingRule do begin
    AddValue('Name',Name);
    AddValue('Description',Description);
    AddValue('Oid',Oid);
    AddValue('Obsolete',Obsolete);
    Addvalue('Syntax',Syntax,true);
  end;
end;

procedure TSchemaDlg.ShowMatchingRuleUse(const MatchingRuleUse: TLDAPSchemaMatchingRuleUse);
var
  Node: TTreeNode;
  i: integer;
begin
  with MatchingRuleUse do begin
    AddValue('Name',Name);
    AddValue('Description',Description);
    AddValue('Oid',Oid);
    AddValue('Obsolete',Obsolete);
    Node:=AddValue('Applies OIDs','');
    for i:=0 to Applies.Count-1 do AddValue('',Applies[i],true,Node);
  end;
end;

procedure TSchemaDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TSchemaDlg.WmGetSysCommand(var Message: TMessage);
begin
  if (Message.WParam = SC_MINIMIZE) then Hide
  else inherited; 
end;

procedure TSchemaDlg.pmCopyClick(Sender: TObject);
begin
  if View.Selected<>nil then Clipboard.SetTextBuf(pchar(View.Selected.Text));
end;

procedure TSchemaDlg.ViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  Node: TTreeNode;
begin
  Node:=View.GetNodeAt(MousePos.X,MousePos.Y);
  if Node<>nil then begin
    Node.Selected:=true;
    Node.Focused:=true;
  end;
end;

end.
