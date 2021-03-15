  {      LDAPAdmin - Main.pas
  *      Copyright (C) 2006 Tihomir Karlovic
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

unit Templates;

interface

uses LdapClasses, Classes, Contnrs, Controls, StdCtrls, ExtCtrls, Xml, Windows,
     Forms, jpeg, Grids, Messages;

const
  TEMPLATE_EXT   = 'ltf';

type
  TEventType = (etChange, etUpdate);

  TTemplateAttribute = class;
  TTemplateAttributeValue = class;

  { Template Controls }

  TTemplateControl = class
  private
    fControl:     TControl;
    fTemplateAttribute: TTemplateAttribute;
    fLdapValue:   TLdapAttributeData;
    fChangeProc:  TNotifyEvent;
    fExitProc:    TNotifyEvent;
    procedure     OnChangeProc(Sender: TObject);
    procedure     OnExitProc(Sender: TObject);
  protected
    procedure     SetOnChange(Event: TNotifyEvent); virtual;
    procedure     SetOnExit(Event: TNotifyEvent); virtual;
    procedure     SetLdapValue(Value: TLdapAttributeData);
  public
    constructor   Create(Attribute: TTemplateAttribute); virtual;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); virtual; abstract;
    procedure     SetValue(AValue: TTemplateAttributeValue); virtual; abstract;
    procedure     Read; virtual; abstract;
    procedure     Write; virtual; abstract;
    procedure     Load(XmlNode: TXmlNode); virtual; abstract;
    property      Control: TControl read fControl;
    property      OnChange: TNotifyEvent write SetOnChange;
    property      OnExit: TNotifyEvent write SetOnExit;
    property      TemplateAttribute: TTemplateAttribute read fTemplateAttribute;
    property      LdapValue: TLdapAttributeData read fLdapValue write SetLdapValue;
  end;

  TTemplateEdit=class(TTemplateControl)
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    destructor    Destroy; override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    procedure     Load(XmlNode: TXmlNode); override;
  end;

  TTemplateCombo=class(TTemplateControl)
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    destructor    Destroy; override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    procedure     Load(XmlNode: TXmlNode); override;
  end;

  TTemplateImage=class(TTemplateControl)
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    destructor    Destroy; override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    procedure     Load(XmlNode: TXmlNode); override;
  end;

  TEditGrid = class(TStringGrid)
  private
    procedure TabMove;
    procedure SubClassWndProc(var Message: TMessage);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TTemplateGrid=class(TTemplateControl)
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    destructor    Destroy; override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    procedure     Load(XmlNode: TXmlNode); override;
  end;

  { Template classes }

  TTemplateAttributeValue = class
  private
    FBase64:      Boolean;
    FValue:       string;
    procedure     SetBase64(const Value: Boolean);
    procedure     SetValue(const Value: string);
    function      GetString: string;
  public
    procedure     SaveToStream(AStream: TStream);
    property      Base64: Boolean read FBase64 write SetBase64;
    property      Value: string read FValue write SetValue;
    property      AsString: string read GetString;
  end;

 TTemplateAttribute = class
  private
    FRequired:    Boolean;
    FDescription: string;
    FName:        string;
    FValues:      TObjectList;
    FControls:    TObjectList;
    function      GetControls(Index: Integer): TTemplateControl;
    function      GetControlCount: integer;
    function      GetValues(Index: Integer): TTemplateAttributeValue;
    function      GetValuesCount: integer;
  public
    constructor   Create(XmlNode: TXmlNode); reintroduce;
    destructor    Destroy; override;
    property      Name: string read FName;
    property      Description: string read FDescription;
    property      Required: Boolean read FRequired;
    property      Values[Index: Integer]: TTemplateAttributeValue read GetValues;
    property      ValuesCount: integer read GetValuesCount;
    property      Controls[Index: Integer]: TTemplateControl read GetControls;
    property      ControlCount: integer read GetControlCount;
  end;

 TTemplate = class
  private
    FAttributes:  TObjectList;
    FDescription: string;
    FName:        string;
    FFileName:    string;
    FRdn:         string;
    FAutoArrange: Boolean;
    FObjectclass: TTemplateAttribute;
    FExtends:     TStringList;
    FLoaded:      Boolean;
    function      GetObjectclasses(Index: Integer): string;
    function      GetObjectclassCount: Integer;
    function      GetAttributes(Index: Integer): TTemplateAttribute;
    function      GetAttributeCount: integer;
  protected
  public
    constructor   Create(const AFileName: string); reintroduce;
    function      Matches(ObjectClass: TLdapAttribute): Boolean;
    destructor    Destroy; override;
    property      Name: string read FName;
    procedure     Load;
    property      Description: string read FDescription;
    property      Objectclasses[Index: Integer]: string read GetObjectclasses;
    property      ObjectclassCount: Integer read GetObjectclassCount;
    property      Attributes[Index: Integer]: TTemplateAttribute read GetAttributes; default;
    property      AttributeCount: integer read GetAttributeCount;
    property      AutoarrangeControls: Boolean read fAutoarrange;
    property      Extends: TStringlist read fExtends;
    property      Loaded: Boolean read fLoaded;
    property      Rdn: string read fRdn;
  end;

  TTemplateList = class(TList)
  private
    function GetItem(Index: Integer): TTemplate;
  public
    property Templates[Index: Integer]: TTemplate read GetItem; default;
  end;

  TExtensionList = class
  private
    fExtensionList: TStringList;
    function    GetTemplates(Index: string): TTemplateList;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Clear;
    procedure   Add(AValue: string; ATemplate: TTemplate);
    property    Extensions[Index: string]: TTemplateList read GetTemplates; default;
  end;

  TTemplateParser = class
  private
    fTemplateFiles: TStringList;
    fExtensionList: TExtensionList;
    function      GetTemplate(Index: Integer): TTemplate;
    function      GetCount: Integer;
    procedure     SetCommaPaths(Value: string);
  public
    constructor   Create; virtual;
    destructor    Destroy; override;
    procedure     Clear;
    procedure     AddTemplatePath(Path: string);
    property      Templates[Index: Integer]: TTemplate read GetTemplate;
    property      Count: Integer read GetCount;
    property      Extensions: TExtensionList read fExtensionList;
    property      Paths: string write SetCommaPaths;
  end;

function GetParameter(var P: PChar): string;
function IsParametrized(s: string): Boolean;

var
  TemplateParser: TTemplateParser;

implementation

uses base64, SysUtils, Misc, Config;

type TTControl = class of TTemplateControl;

const
  CONTROLS_CLASSES: array[0..3] of TTControl = (TTemplateEdit, TTemplateCombo, TTemplateImage, TTemplateGrid);
  DEFAULT_CONTROL_CLASS: TTControl = TTemplateEdit;

function GetXmlTypeByClass(AClass: TTControl): string;
const
  PREFIX='ttemplate';
  LEN=length(PREFIX);
begin
  result:=LowerCase(AClass.ClassName);
  if pos(PREFIX, result)=1 then begin
    delete(result, 1, LEN);
  end
  else result:='';
end;

function GetClassByXmlType(XmlType: string): TTControl;
const
  PREFIX='ttemplate';
var
  i: integer;
begin
  result:=nil;
  for i:=0 to high(CONTROLS_CLASSES) do begin
    if LowerCase(CONTROLs_CLASSES[i].ClassName)=PREFIX+XmlType then begin
      result:=CONTROLs_CLASSES[i];
      exit;
    end;
  end;
end;

function ScanParam(const p: PChar): PChar;
begin
  Result := p;
  while Result^ <> #0 do
  begin
    case Result^ of
      '\': begin
             inc(Result);
             if not Assigned(Result) then Break;
            end;
      '%': Break;
    end;
    inc(Result);
  end;
end;

function RemoveEsc(const s: string): string;
var
  p, p1, p2: PChar;
begin
  SetLength(Result, Length(s));
  p1 := PChar(s);
  p2 := PChar(Result);
  p := p2;
  while p1^ <> #0 do
  begin
    if p1^ = '\' then
    begin
      inc(p1);
      if p1^ = #0 then
        Break;
    end;
    p2^ := p1^;
    inc(p1);
    inc(p2);
  end;
  SetLength(Result, p2 - p);
end;

function GetParameter(var P: PChar): string;
var
  p1: PChar;
begin
  Result := '';
  P := ScanParam(P);
  if P^ <> #0 then
  begin
    inc(P);
    p1 := ScanParam(P);
    if p1 = #0 then
      raise Exception.Create('Invalid (Unclosed) parameter!');
    if p1 - P > 0 then
      SetString(Result, p, p1 - p);
    P := p1 + 1;
  end;
end;

function IsParametrized(s: string): Boolean;
var
  p: PChar;
begin
  p := pChar(s);
  Result := GetParameter(p) <> '';
end;

function FormatValue(const AValue: string; Entry: TLdapEntry): string;
var
  p0, p1, p2: PChar;
  name, val, s: string;
begin
  Result := '';
  p0 := PChar(AValue);
  p1 := ScanParam(p0);
  while p1^ <> #0 do
  begin
    inc(p1);
    p2 := ScanParam(p1);
    if p2 = #0 then
      raise Exception.Create('Invalid (Unclosed) parameter!');
    if p2 - p1 > 0 then
    begin
      SetString(name, p1, p2 - p1);
      val := Entry.AttributesByName[name].AsString;
      if val = '' then
      begin
        Result := '';
        Exit;
      end;
      SetString(s, p0, p1 - p0 - 1);
      Result := Result + s + val;
      p0 := p2 + 1;
    end;
    p1 := ScanParam(p2 + 1);
  end;
  Result := RemoveEsc(Result + p0);
end;

{ TTemplateControl }

procedure TTemplateControl.OnChangeProc(Sender: TObject);
begin
  Write;
  if Assigned(fChangeProc) then fChangeProc(Self);
end;

procedure TTemplateControl.OnExitProc(Sender: TObject);
begin
  if Assigned(fExitProc) then fExitProc(Self);
end;

procedure TTemplateControl.SetLdapValue(Value: TLdapAttributeData);
begin
  fLdapValue := Value;
  Read;
end;

procedure TTemplateControl.SetOnChange(Event: TNotifyEvent);
begin
  fChangeProc := Event;
end;

procedure TTemplateControl.SetOnExit(Event: TNotifyEvent);
begin
  fExitProc := Event;
end;

constructor TTemplateControl.Create(Attribute: TTemplateAttribute);
begin
  fTemplateAttribute := Attribute;
end;

{ TTemplateEdit }

procedure TTemplateEdit.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TEdit).Text := AValue.AsString;
end;

procedure TTemplateEdit.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TEdit).Text := fLdapValue.AsString;
end;

procedure TTemplateEdit.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TEdit).Text;
end;

procedure TTemplateEdit.Load(XmlNode: TXmlNode);
begin

end;

procedure TTemplateEdit.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TEdit), fTemplateAttribute do
  if (Event = etChange) and not Modified and (ValuesCount > 0) then
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
end;

constructor TTemplateEdit.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TEdit.Create(nil);
  TEdit(fControl).OnChange := OnChangeProc;
  TEdit(fControl).OnExit := OnExitProc;
end;

destructor TTemplateEdit.Destroy;
begin
  fControl.Free;
  inherited;
end;


{ TTemplateCombo }

procedure TTemplateCombo.SetValue(AValue: TTemplateAttributeValue);
begin
  (fControl as TComboBox).Text := AValue.AsString;
end;

procedure TTemplateCombo.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TComboBox).Text := fLdapValue.AsString;
end;

procedure TTemplateCombo.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TComboBox).Text;
end;

constructor TTemplateCombo.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TComboBox.Create(nil);
  TComboBox(fControl).OnChange := OnChangeProc;
  TComboBox(fControl).OnExit := OnExitProc;
end;

destructor TTemplateCombo.Destroy;
begin
  fControl.Free;
  inherited;  
end;

procedure TTemplateCombo.Load(XmlNode: TXmlNode);
var
  i: integer;
  ItemsNode: TXmlNode;
  NotParented: boolean;
begin
  ItemsNode:=XmlNode.NodeByName('items');
  if ItemsNode=nil then exit;

  NotParented:=(fControl.Parent=nil);

  if NotParented then begin
    //If not parent not set and we try to set Items have exception "Control has no parent window" .
    fControl.Visible:=false;
    fControl.Parent:=Application.MainForm;
  end;

  for i:=0 to ItemsNode.Count-1 do
    if ItemsNode[i].Name='item' then TComboBox(fControl).Items.Add(ItemsNode[i].Content);

  if NotParented then begin
    fControl.Parent:=nil;
    fControl.Visible:=true;
  end;
end;

procedure TTemplateCombo.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TComboBox), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
    OnChange(fControl);
    OnExit(fControl);
  end;  
end;

{ TTemplateImage }

procedure TTemplateImage.SetValue(AValue: TTemplateAttributeValue);
var
  ji: TJpegImage;
begin
  with fControl as TImage do begin
   //TODO delete
   ji := Picture.Graphic as TJPEGImage;
   if not Assigned(ji) then
     ji := TJpegImage.Create;
   StreamCopy(AValue.SaveToStream, ji.LoadFromStream);
   Picture.Graphic := ji;
  end;
  Write;
end;

constructor TTemplateImage.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TImage.Create(nil);
end;

destructor TTemplateImage.Destroy;
begin
  fControl.Free;
  inherited;  
end;

procedure TTemplateImage.Read;
var
  ji: TJpegImage;
begin
  if Assigned(fControl) and Assigned(fLdapValue) and (fLdapValue.DataSize > 0) then with (fControl as TImage) do
  begin
   ji := Picture.Graphic as TJPEGImage;
   if not Assigned(ji) then
     ji := TJpegImage.Create;
   StreamCopy(fLdapValue.SaveToStream, ji.LoadFromStream);
   Picture.Graphic := ji;
  end;
end;

procedure TTemplateImage.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TImage) do
    if Assigned(Picture.Graphic) then
     StreamCopy(Picture.Graphic.SaveToStream, fLdapValue.LoadFromStream);
end;

procedure TTemplateImage.Load(XmlNode: TXmlNode);
begin

end;

procedure TTemplateImage.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

{ TEditGrid }

procedure TEditGrid.TabMove;
var
  r, c, d: Integer;
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  if KeyState[VK_SHIFT] and $80 <> 0 then
    d := -1
  else
    d := 1;
  r := Row;
  c := Col;
  c := c + d;
  if c > ColCount - 1 then
  begin
    c := 0;
    r := r + d;
  end
  else
  if c < 0 then
  begin
    c := ColCount - 1;
    r := r + d;
  end;
  if r > RowCount - 1 then
  begin
   if Cells[ColCount - 1, RowCount - 1] <> '' then
      RowCount := r + 1
    else
      r := 0
  end
  else
  if r < 0 then
    r := RowCount - 1;
  Col := c;
  Row := r;
end;

procedure TEditGrid.SubClassWndProc(var Message: TMessage);
begin
  with Message do
  case Msg of
    CM_CHILDKEY:
      if WParam = 13 then
        TabMove;
  else
    WndProc(Message);
  end;
end;

procedure TEditGrid.Resize;
begin
  inherited;
  DefaultColWidth := ClientWidth;
end;

constructor TEditGrid.Create(AOwner: TComponent);
begin
  inherited;
  WindowProc := SubClassWndProc;
  FixedCols := 0;
  FixedRows := 0;
  ColCount := 1;
  RowCount := 5;
  DefaultRowHeight := 18;
  Options := Options + [goEditing, goAlwaysShowEditor];
end;

{ TTemplateGrid }

procedure TTemplateGrid.SetValue(AValue: TTemplateAttributeValue);
begin
  with (Control as TStringGrid) do
  begin
    RowCount := RowCount + 1;
    Cells[0, RowCount - 1] := AValue.AsString;
  end;
end;

procedure TTemplateGrid.Read;
var
  i: Integer;
begin
  if Assigned(fControl) then with Control as TStringGrid do
  begin
    for i := 0 to RowCount - 1 do Rows[i].Clear;
    if Assigned(fLdapValue) then with fLdapValue.Attribute do
    begin
      if RowCount < ValueCount then
        RowCount := ValueCount;
      for i := 0 to ValueCount - 1 do
        Cells[0, i] := Values[i].AsString;
    end;
  end;
end;

procedure TTemplateGrid.Write;
var
  i: Integer;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with Control as TStringGrid do
  begin
    fLdapValue.Attribute.Delete;
    for i := 0 to RowCount - 1 do
      if Cells[0,i] <> '' then fLdapValue.Attribute.AddValue(Cells[0, i]);
  end;
end;

procedure TTemplateGrid.Load(XmlNode: TXmlNode);
begin

end;

procedure TTemplateGrid.EventProc(Attribute: TLdapAttribute; Event: TEventType);
var
  i: Integer;
  s: string;
begin
  with (fControl as TEditGrid), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    if RowCount < ValuesCount then
      RowCount := ValuesCount;
    for i := 0 to ValuesCount -  1 do
    begin
      s := FormatValue(Values[i].AsString, Attribute.Entry);
      if not IsParametrized(s) then
        Cells[0, i] := s;
    end;
  end;
end;

constructor TTemplateGrid.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TEditGrid.Create(nil);
  TEditGrid(fControl).OnExit := OnExitProc;
  TEditGrid(fControl).OnExit := OnChangeProc;
end;

destructor TTemplateGrid.Destroy;
begin
  fControl.Free;
  inherited;
end;

{ TTemplateList }

function TTemplateList.GetItem(Index: Integer): TTemplate;
begin
  Result := Items[Index];
  if not Result.Loaded then
    Result.Load;
end;

{ TExtensionList }

function TExtensionList.GetTemplates(Index: string): TTemplateList;
var
  idx: Integer;
begin
  idx := fExtensionList.IndexOf(Index);
  if idx = -1 then
    Result := nil
  else
    Result := TTemplateList(fExtensionList.Objects[idx]);
end;

constructor TExtensionList.Create;
begin
  fExtensionList := TStringList.Create;
end;

destructor TExtensionList.Destroy;
begin
  Clear;
  fExtensionList.Free;
  inherited;
end;

procedure TExtensionList.Clear;
var
  i: Integer;
begin
  for i := 0 to fExtensionList.Count - 1 do
    fExtensionList.Objects[i].Free;
  fExtensionList.Clear;
end;

procedure TExtensionList.Add(AValue: string; ATemplate: TTemplate);
var
  idx: Integer;
begin
  idx := FExtensionList.IndexOf(AValue);
  if idx = -1 then
    idx := FExtensionList.AddObject(AValue, TTemplateList.Create);
  TTemplateList(FExtensionList.Objects[idx]).Add(ATemplate)
end;

{ TTemplateParser }

constructor TTemplateParser.Create;
begin
  inherited;
  fTemplateFiles := TStringList.Create;
  fExtensionList := TExtensionList.Create;
end;

destructor TTemplateParser.Destroy;
begin
  Clear;
  fTemplateFiles.Free;
  fExtensionList.Free;
  inherited;
end;

procedure TTemplateParser.Clear;
var
  i: Integer;
begin
  with fTemplateFiles do begin
    for i := 0 to Count - 1 do
      TTemplate(Objects[i]).Free;
    Clear;
  end;
  fExtensionList.Clear;
end;

procedure TTemplateParser.AddTemplatePath(Path: string);
var
  sr: TSearchRec;
  Dir: string;

  procedure AddTemplate(name: string);
  var
    Template: TTemplate;
    i: Integer;
  begin
    Template := TTemplate.Create(name);
    fTemplateFiles.AddObject(name, Template);
    for i := 0 to Template.Extends.Count - 1 do
      fExtensionList.Add(Template.Extends[i], Template);
  end;

begin
  if FindFirst(Path, faArchive, sr) = 0 then
  begin
    Dir := ExtractFileDir(Path) + '\';
    with fTemplateFiles do
    begin
      AddTemplate(Dir + sr.Name);
      while FindNext(sr) = 0 do
        AddTemplate(Dir + sr.Name);
      FindClose(sr);
    end;
  end;
end;

function TTemplateParser.GetTemplate(Index: Integer): TTemplate;
begin
  Result := fTemplateFiles.Objects[Index] as TTemplate;
  if not Result.Loaded then
    Result.Load;
end;

function TTemplateParser.GetCount: Integer;
begin
  Result := fTemplateFiles.Count;
end;

procedure TTemplateParser.SetCommaPaths(Value: string);
var
  List: TStringList;
  i: Integer;

begin
  List := TStringList.Create;
  try
    List.CommaText := Value;
    TemplateParser.Clear;
    for i := 0 to List.Count - 1 do
      TemplateParser.AddTemplatePath(List[i] + '\*.' + TEMPLATE_EXT);
  finally
    List.Free;
  end;
end;

{ TTemplate }

constructor TTemplate.Create(const AFileName: string);
var
  XmlTree: TXmlTree;
  i: integer;
begin
  inherited Create;
  FAutoArrange := true;
  FFileName:=AFileName;
  FAttributes:=TObjectList.Create;
  FExtends := TStringList.Create;
  XmlTree:=TXmlTree.Create;
  try
    XmlTree.LoadFromFile(AFileName);
    for i:=0 to XmlTree.Root.Count-1 do with XmlTree.Root[i] do begin
      if Name='name' then FName:= Content
      else
      if Name='description' then FDescription:=Content
      else
      if Name='extends' then fExtends.Add(Content)
      else
      if Name='rdn' then fRdn := Content;
    end;
  finally
    XmlTree.Free;
  end;
end;

destructor TTemplate.Destroy;
begin
  FAttributes.Free;
  FExtends.Free;
  inherited;
end;

function TTemplate.GetObjectclasses(Index: Integer): string;
begin
  if Index < ObjectclassCount then
    Result := fObjectclass.Values[Index].Value
  else
    Result := '';
end;

function TTemplate.GetObjectclassCount: Integer;
begin
  if Assigned(fObjectclass) then
    Result := fObjectclass.ValuesCount
  else
    Result := 0;
end;

function TTemplate.GetAttributes(Index: Integer): TTemplateAttribute;
begin
  result:=TTemplateAttribute(FAttributes[Index]);
end;

function TTemplate.GetAttributeCount: integer;
begin
  result:=FAttributes.Count;
end;

procedure TTemplate.Load;
var
 XmlTree: TXmlTree;
 i: integer;
 AAttribute: TTemplateAttribute;
begin
  if Loaded then
    Exit;
  XmlTree:=TXmlTree.Create;
  try
    XmlTree.LoadFromFile(FFileName);
    for i:=0 to XmlTree.Root.Count-1 do begin
      if XmlTree.Root[i].Name='attribute' then begin
        AAttribute:=TTemplateAttribute.Create(XmlTree.Root[i]);
        FAttributes.Add(AAttribute);
        if AAttribute.Name='objectclass' then
          fObjectclass := AAttribute;
      end;
    end;
  finally
    XmlTree.Free;
  end;
  fLoaded := true;
end;

function TTemplate.Matches(ObjectClass: TLdapAttribute): Boolean;
var
  i: Integer;
begin
  for i := 0 to ObjectclassCount - 1 do
    if ObjectClass.IndexOf(Objectclasses[i]) = -1 then
    begin
      Result := false;
      Exit;
    end;
  Result := true;
end;

{ TTemplateAttribute }

constructor TTemplateAttribute.Create(XmlNode: TXmlNode);
var
  i: integer;
  AClass: TTControl;
  idx: integer;
  AValue: TTemplateAttributeValue;
begin
  inherited Create;
  FControls:=TObjectList.Create;
  FValues:=TObjectList.Create;

  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do begin
    if Name='name'  then FName:=Content
    else
    if Name='description' then FDescription := Content
    else
    if Name='control' then begin
      AClass:=GetClassByXmlType(Attributes.Values['type']);
      if AClass=nil then AClass:=DEFAULT_CONTROL_CLASS;

      idx:=FControls.Add(AClass.Create(Self));
      Controls[idx].Load(XmlNode[i]);
    end
    else
    if Name='value' then begin
      Avalue:=TTemplateAttributeValue.Create;
      AValue.Base64:=(Attributes.Values['encode']='base64');
      AValue.Value:=Content;
      FValues.Add(AValue)
    end;

  end;

  if (ControlCount=0) and (Name <> 'objectclass') then
    FControls.Add(DEFAULT_CONTROL_CLASS.Create(Self));

end;

destructor TTemplateAttribute.Destroy;
begin
  FControls.Free;
  FValues.Free;
  inherited;
end;

function TTemplateAttribute.GetControls(Index: Integer): TTemplateControl;
begin
  Result := FControls[Index] as TTemplateControl;
end;

function TTemplateAttribute.GetControlCount: integer;
begin
  result:=FControls.Count;
end;

function TTemplateAttribute.GetValues(Index: Integer): TTemplateAttributeValue;
begin
  result:=TTemplateAttributeValue(FValues[Index]);
end;

function TTemplateAttribute.GetValuesCount: integer;
begin
  result:=FValues.Count;
end;

{ TTemplateAttributeValue }

procedure TTemplateAttributeValue.SetBase64(const Value: Boolean);
begin
  FBase64 := Value;
end;

procedure TTemplateAttributeValue.SetValue(const Value: string);
begin
  FValue := Value;
end;

function TTemplateAttributeValue.GetString: string;
var
  vLen: Integer;
begin
  if Base64 then
  begin
    vLen := Length(Value);
    SetLength(Result, Base64decSize(vLen));
    vLen := Base64Decode(Value[1], vLen, Result[1]);
    SetLength(Result, vLen);
  end
  else
    Result := Value;
end;

procedure TTemplateAttributeValue.SaveToStream(AStream: TStream);
var
  Buffer: Pointer;
  vLen: Integer;
begin
  if Base64 then
  begin
    vLen := Length(Value);
    GetMem(Buffer, Base64DecSize(vLen));
    try
      vLen := Base64Decode(Value[1], vLen, Buffer^);
      AStream.WriteBuffer(Buffer^, vLen);
    finally
      FreeMem(Buffer);
    end;
  end
  else
    AStream.WriteBuffer(Value[1], Length(Value));
end;

initialization

  TemplateParser := TTemplateParser.Create;
  try
    TemplateParser.Paths := GlobalConfig.ReadString('TemplateDir');
    TemplateParser.AddTemplatePath(ExtractFileDir(application.ExeName) + '\*.' + TEMPLATE_EXT);
  except end;

finalization

  TemplateParser.Free;

end.
