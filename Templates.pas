  {      LDAPAdmin - Templates.pas
  *      Copyright (C) 2006-2007 Tihomir Karlovic
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

uses ComCtrls, LdapClasses, Classes, Contnrs, Controls, StdCtrls, ExtCtrls, Xml, Windows,
     Forms, Graphics, jpeg, Grids, Messages, Dialogs, Mask;

const
  TEMPLATE_EXT        = 'ltf';
  FMT_DATE_TIME_UNIX  = 'unix';
  FMT_DATE_TIME_GTZ   = 'gtz';

  CT_LEFT_BORDER      = 8;
  CT_RIGHT_BORDER     = 8;
  CT_FIX_TOP          = 8;
  CT_GROUP_SPACING    = 2;
  CT_SPACING          = 8;

type
  TEventType = (etChange, etUpdate);

  TTemplateAttribute = class;
  TTemplateAttributeValue = class;

  TTControl = class of TTemplateControl;

  { Template Controls }

  TTemplateControl = class
  private
    fControl:     TControl;
    fTemplateAttribute: TTemplateAttribute;
    fLdapAttribute: TLdapAttribute;
    fControlIndex: Integer;
    fUseDefaults: Boolean;
    fChangeProc:  TNotifyEvent;
    fExitProc:    TNotifyEvent;
    fParentControl: TTemplateControl;
    fElements:    TObjectList;
    fAutoSize:    Boolean;
    fCaption:     string;
    procedure     OnChangeProc(Sender: TObject);
    procedure     OnExitProc(Sender: TObject);
    procedure     SetParentControl(AControl: TTemplateControl);
  protected
    function      GetParams: TStringList; virtual; abstract;
    procedure     SetOnChange(Event: TNotifyEvent); virtual;
    procedure     SetOnExit(Event: TNotifyEvent); virtual;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); virtual; abstract;
    procedure     LoadProc(XmlNode: TXmlNode); virtual; abstract;
  public
    constructor   Create(Attribute: TTemplateAttribute); virtual;
    destructor    Destroy; override;
    procedure     ArrangeControls; virtual;
    procedure     AdjustSizes;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); virtual; abstract;
    procedure     SetValue(AValue: TTemplateAttributeValue); virtual; abstract;
    procedure     Read; virtual; abstract;
    procedure     Write; virtual; abstract;
    procedure     Load(XmlNode: TXmlNode);
    property      Params: TStringList read GetParams;
    property      UseDefaults: Boolean read fUseDefaults write fUseDefaults;
    property      Control: TControl read fControl;
    property      OnChange: TNotifyEvent write SetOnChange;
    property      OnExit: TNotifyEvent write SetOnExit;
    property      TemplateAttribute: TTemplateAttribute read fTemplateAttribute;
    property      LdapAttribute: TLdapAttribute read fLdapAttribute write SetLdapAttribute;
    property      ParentControl: TTemplateControl read fParentControl write SetParentControl;
    property      Elements: TObjectList read fElements;
    property      AutoSize: Boolean read fAutoSize;
    property      Caption: string read fCaption;
  end;

  TTemplateSVControl = class(TTemplateControl)
    fLdapValue:   TLdapAttributeData;
    fParams:      TStringList;
  protected
    function      GetParams: TStringList; override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    destructor    Destroy; override;
  end;

  TTemplateMVControl = class(TTemplateControl)
    fLdapValue:   TLdapAttributeData;
    fParams:      TStringList;
  protected
    function      GetParams: TStringList; override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    destructor    Destroy; override;
  end;

  TTemplateNoCtrl = class(TTemplateMVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlEdit = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlCombo = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlComboList = class(TTemplateSVControl)
  private
    function      IndexOfValue(Value: string): Integer;
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlImage=class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
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

  TTemplateCtrlGrid = class(TTemplateMVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlPasswordButton = class(TTemplateSVControl)
  private
    procedure     ButtonClick(Sender: TObject);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlTextArea = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlCheckBox =class(TTemplateSVControl)
  private
    fFalse:       string;
    fTrue:        string;
    function      GetCbState(const AState: string): TCheckBoxState;
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlPanel = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  TTemplateCtrlTabSheet = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;
  
  TTemplateCtrlTabbedPanel = class(TTemplateSVControl)
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    destructor    Destroy; override;
    procedure     ArrangeControls; override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
  end;

  { TDateTimePickerFixed - fixes the bug where control looses focus to checkbox
    when time field is changed and up-down spin buttons or keyboard are used
    with ShowCheckbox activated. Also adds custom format property for Delphi5  }

  TDateTimePickerFixed = class(TDateTimePicker)
  private
    fChanging: Boolean;
    {$IFDEF VER130}
    fFormat: string;
    procedure SetFormat(Value: string);
    {$ENDIF}
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    function MsgSetDateTime(Value: TSystemTime): Boolean; override;
  public
    {$IFDEF VER130}
    property Format: string read fFormat write SetFormat;
    {$ENDIF}
  end;

  TTemplateCtrlDate = class(TTemplateSVControl)
  private
    fDateFormat:  string;
    fTimeFormat:  string;
    function      GetDisplayFormat: string;
    procedure     SetDisplayFormat(Value: string);
    function      GetTime(Value: string): TDateTime;
    function      GetTimeString: string;
    procedure     SetTimeString(Value: string);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    property      DisplayFormat: string read GetDisplayFormat write SetDisplayFormat;
    property      DateFormat: string read fDateFormat write fDateFormat;
    property      TimeFormat: string read fTimeFormat write fTimeFormat;
    property      AsString: string read GetTimeString write SetTimeString;
  end;

  TTemplateCtrlTime = class(TTemplateCtrlDate)
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
  end;

  TTemplateCtrlDateTime = class(TTemplateCtrlPanel)
  private
    fDate:        TTemplateCtrlDate;
    fTime:        TTemplateCtrlTime;
    fVertical:    Boolean;
    procedure     MyOnChangeProc(Sender: TObject);
    procedure     MyOnResizeProc(Sender: TObject);
    procedure     SetVertical(Value: Boolean);
  protected
    procedure     LoadProc(XmlNode: TXmlNode); override;
    procedure     SetLdapAttribute(Attribute: TLdapAttribute); override;
  public
    constructor   Create(Attribute: TTemplateAttribute); override;
    procedure     EventProc(Attribute: TLdapAttribute; Event: TEventType); override;
    procedure     SetValue(AValue: TTemplateAttributeValue); override;
    procedure     Read; override;
    procedure     Write; override;
    property      Vertical: Boolean read fVertical write SetVertical;
  end;

  { Template classes }

  TTemplateControlList = class(TObjectList)
  private
    function      GetControl(Index: Integer): TTemplateControl;
  public
    property      Controls[Index: integer]: TTemplateControl read GetControl; default;
  end;

  TTemplateAttributeList = class(TObjectList)
  private
    function      GetAttribute(Index: Integer): TTemplateAttribute;
  public
    property      Attributes[Index: integer]: TTemplateAttribute read GetAttribute; default;
  end;

  TTemplateAttributeValue = class
  private
    FBase64:      Boolean;
    FValue:       string;
    FAttribute:   TTemplateAttribute;
    procedure     SetBase64(const Value: Boolean);
    procedure     SetValue(const Value: string);
    function      GetString: string;
  public
    constructor   Create(AAttribute: TTemplateAttribute);
    procedure     SaveToStream(AStream: TStream);
    property      Base64: Boolean read FBase64 write SetBase64;
    property      Value: string read FValue write SetValue;
    property      AsString: string read GetString;
    property      Attribute: TTemplateAttribute read fAttribute;
  end;

 TTemplateAttribute = class
  private
    FRequired:    Boolean;
    FDescription: string;
    FName:        string;
    FValues:      TObjectList;
    FControls:    TTemplateControlList;
    FDefaultControlClass: TTControl;
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
    property      Controls: TTemplateControlList read fControls;
  end;

 TTemplate = class
  private
    FXmlTree: TXmlTree;
    FDescription: string;
    FName:        string;
    FFileName:    string;
    FRdn:         string;
    FAutoArrange: Boolean;
    FObjectclass: TTemplateAttribute;
    FExtends:     TStringList;
    FIcon:        TBitmap;
    function      GetObjectclasses(Index: Integer): string;
    function      GetObjectclassCount: Integer;
  protected
  public
    constructor   Create(const AFileName: string); reintroduce;
    function      Matches(ObjectClass: TLdapAttribute): Boolean;
    destructor    Destroy; override;
    property      Name: string read FName;
    procedure     Parse(AElements: TObjectList);
    property      Description: string read FDescription;
    property      Objectclasses[Index: Integer]: string read GetObjectclasses;
    property      ObjectclassCount: Integer read GetObjectclassCount;
    property      AutoarrangeControls: Boolean read fAutoarrange;
    property      Extends: TStringlist read fExtends;
    property      Rdn: string read fRdn;
    property      Icon: TBitmap read FIcon;
    property      XmlTree: TxmlTree read fXmlTree;
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
function FormatValue(const AValue: string; Entry: TLdapEntry): string;

var
  TemplateParser: TTemplateParser;

implementation

uses commctrl, base64, SysUtils, Misc, Config, PassDlg, Constant;

const
  CONTROLS_CLASSES: array[0..12] of TTControl = ( TTemplateCtrlEdit,
                                                  TTemplateCtrlCombo,
                                                  TTemplateCtrlComboList,
                                                  TTemplateCtrlImage,
                                                  TTemplateCtrlGrid,
                                                  TTemplateCtrlPasswordButton,
                                                  TTemplateCtrlTextArea,
                                                  TTemplateCtrlCheckBox,
                                                  TTemplateCtrlPanel,
                                                  TTemplateCtrlTabbedPanel,
                                                  TTemplateCtrlDate,
                                                  TTemplateCtrlTime,
                                                  TTemplateCtrlDateTime);
  //DEFAULT_CONTROL_CLASS: TTControl = TTemplateCtrlEdit;

function GetXmlTypeByClass(AClass: TTControl): string;
const
  PREFIX='ttemplatectrl';
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
  PREFIX='ttemplatectrl';
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

function GetDefaultXmlType(XmlNode: TXmlNode): TTControl;
var
  XmlType: string;
begin
  Result := nil;
  if XmlNode.Name = 'objectclass' then Exit;
  XmlType := XmlNode.Attributes.Values['type'];
  if XmlType = '' then
    Result := TTemplateNoCtrl
  else
  if Lowercase(XmlType) = 'text' then
    Result := GetClassByXmlType('edit')
  else
  if Lowercase(XmlType) = 'boolean' then
    Result := GetClassByXmlType('checkbox');
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
      raise Exception.Create(stUnclosedParam);
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
      raise Exception.Create(stUnclosedParam);
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

function CheckStrToInt(Value, Tag: string): Integer;
begin
  try
    Result := StrToInt(Value);
  except
    on E:EConvertError do
      raise Exception.Create(Format('Invalid value %s for <%s>!', [Value, Tag]));
  end;
end;

function CreateControl(ControlTemplate: TXmlNode; Attribute: TTemplateAttribute): TTemplateControl;
var
  AClass: TTControl;
begin
  AClass := nil;

  if Assigned(ControlTemplate) then
    AClass:=GetClassByXmlType(ControlTemplate.Attributes.Values['type']);

  if Assigned(AClass) then
  begin
    Result := AClass.Create(Attribute);
    Result.Load(ControlTemplate);
  end
  else
    Result := nil;
end;


{ TTemplateMVControl }
function TTemplateMVControl.GetParams: TStringList;
var
  p: PChar;
  Param: string;
  i: Integer;
begin
  if not Assigned(fParams) then
  begin
    fParams := TStringList.Create;
    if fUseDefaults then
    begin
      for i := 0 to TemplateAttribute.ValuesCount - 1 do
      begin
        p := PChar(TemplateAttribute.Values[i].AsString);
        Param := GetParameter(p);
        while Param <> '' do begin
          if fParams.IndexOf(Param) = -1 then
            fParams.Add(Param);
          Param := GetParameter(p);
        end;
      end;
    end;
  end;
  Result := fParams;
end;

procedure TTemplateMVControl.SetLdapAttribute(Attribute: TLdapAttribute);
var
  i: Integer;
begin
  fLdapAttribute := Attribute;
  if UseDefaults then
    for i := 0 to TemplateAttribute.ValuesCount - 1 do
    begin
      if i >= fLdapAttribute.ValueCount then
        fLdapAttribute.AddValue;
      if (fLdapAttribute.Values[i].DataSize = 0) and
            not IsParametrized(TemplateAttribute.Values[i].AsString) then
        fLdapAttribute.Values[i].AsString := TemplateAttribute.Values[i].AsString;
    end;
  Read;
end;

destructor TTemplateMVControl.Destroy;
begin
  fParams.Free;
  inherited;
end;

{ TTemplateSVControl }

function TTemplateSVControl.GetParams: TStringList;
var
  p: PChar;
  Param: string;
begin
  if not Assigned(fParams) then
  begin
    fParams := TStringList.Create;
    if fUseDefaults then
    begin
      if fControlIndex < TemplateAttribute.ValuesCount then
      begin
        p := PChar(TemplateAttribute.Values[fControlIndex].AsString);
        Param := GetParameter(p);
        while Param <> '' do begin
          if fParams.IndexOf(Param) = -1 then
            fParams.Add(Param);
          Param := GetParameter(p);
        end;
      end;
    end;
  end;
  Result := fParams;
end;

procedure TTemplateSVControl.SetLdapAttribute(Attribute: TLdapAttribute);
begin
  fLdapAttribute := Attribute;
  if fControlIndex < Attribute.ValueCount then
    fLdapValue := Attribute.Values[fControlIndex]
  else begin
    fLdapValue := Attribute.AddValue;
    if UseDefaults and (fControlIndex < TemplateAttribute.ValuesCount) and
                   not IsParametrized(TemplateAttribute.Values[fControlIndex].AsString) then
       SetValue(TemplateAttribute.Values[fControlIndex]);
  end;
  if fControlIndex >= Attribute.ValueCount then
    raise Exception.Create('Internal error: Control processed out of order!');
  Read;
end;

destructor TTemplateSVControl.Destroy;
begin
  fParams.Free;
  inherited;
end;

{ TTemplateControl }

procedure TTemplateControl.AdjustSizes;
var
  i, j: Integer;
begin
  for i := 0 to Elements.Count - 1 do
    if Elements[i] is TTemplateControl then with TTemplateControl(Elements[i]) do
    begin
      if Assigned(Control) and Assigned(Control.Parent) then
        Control.Width := Control.Parent.ClientWidth - CT_LEFT_BORDER - CT_RIGHT_BORDER;
      AdjustSizes;
    end
    else with TTemplateAttribute(Elements[i]) do
      for j := 0 to Controls.Count - 1 do with Controls[j] do
      begin
        if Assigned(Control) and Assigned(Control.Parent) then
          Control.Width := Control.Parent.ClientWidth - CT_LEFT_BORDER - CT_RIGHT_BORDER;
        AdjustSizes;
      end;
end;

procedure TTemplateControl.OnChangeProc(Sender: TObject);
begin
  Write;
  if Assigned(fChangeProc) then fChangeProc(Self);
end;

procedure TTemplateControl.OnExitProc(Sender: TObject);
begin
  if Assigned(fExitProc) then fExitProc(Self);
end;

procedure TTemplateControl.SetParentControl(AControl: TTemplateControl);
begin

  if Assigned(AControl) then
  begin
    fParentControl := AControl;
    if Assigned(fControl) and (fParentControl.Control is TWinControl) then
      fControl.Parent := TWinControl(fParentControl.Control);
  end
  else
  if Assigned(fParentControl) then
  begin
    fParentControl := nil;
    if Assigned(fControl) then
      fControl.Parent := nil;
  end;
end;

procedure TTemplateControl.Load(XmlNode: TXmlNode);
var
  NotParented: boolean;
  i, j: Integer;
  AAttribute: TTemplateAttribute;
  AControl: TTemplateControl;
begin

  if Assigned(XmlNode) then
  begin
    for i:=0 to XmlNode.Count-1 do with XmlNode[i] do
    begin
      if Name = 'attribute' then
      begin
        AAttribute := TTemplateAttribute.Create(XmlNode[i]);
        fElements.Add(AAttribute);
        for j := 0 to AAttribute.Controls.Count - 1 do
          AAttribute.Controls[j].ParentControl := Self;
      end
      else
      if Name = 'control' then
      begin
        AControl := CreateControl(XmlNode[i], nil);
        if Assigned(AControl) then
        begin
          fElements.Add(AControl);
          AControl.ParentControl := Self;
        end;
      end
      else
      if Name = 'height' then
      begin
        fControl.Height := CheckStrToInt(Content, Name);
        fAutoSize := false;
      end
      else
      if Name = 'caption' then
        fCaption := Content;
     end;

    NotParented:=(fControl.Parent=nil);

    if NotParented then begin
      //If parent is not set and we try to set Items have exception "Control has no parent window" .
      fControl.Visible:=false;
      fControl.Parent:=Application.MainForm;
    end;

    LoadProc(XmlNode);

    if NotParented then begin
      fControl.Parent:=nil;
      fControl.Visible:=true;
    end;
  end;

end;

procedure TTemplateControl.SetOnChange(Event: TNotifyEvent);
begin
  fChangeProc := Event;
end;

procedure TTemplateControl.SetOnExit(Event: TNotifyEvent);
begin
  fExitProc := Event;
end;

procedure TTemplateControl.ArrangeControls;
var
  Element: TObject;
  TemplateControl: TTemplateControl;
  i, j, YPos: Integer;

  procedure PlaceControl;
  var
    L: TLabel;
    cap: string;
  begin
   { Position the control }
    with TemplateControl do
    begin
      cap := '';
      //if not AutoarrangeControls then
      begin
        { Some controls have thier own captions and don't need labels }
        if not ((Control is TCheckbox) or (Control is TButton)) then
        begin
          if Caption <> '' then
            cap := Caption
          else
          if Assigned(TemplateAttribute) then
          begin
            if TemplateAttribute.Description <> '' then
              cap := TemplateAttribute.Description
            else
              cap := TemplateAttribute.Name;
          end;
        end;
        if cap <> '' then
        begin
          cap := cap + ':';
          L := TLabel.Create(Self.Control);
          L.Caption := cap;
          if Control is TWinControl then
            L.FocusControl := TWinControl(Control);
          L.Left := CT_LEFT_BORDER;
          L.Top := yPos;
          L.Parent := Control.Parent;
          inc(yPos, L.Height + CT_GROUP_SPACING);
        end;
        Control.Left := CT_LEFT_BORDER;
        Control.Top := yPos;
        if Control is TImage then
          (Control as TImage).AutoSize := true;
        inc(yPos, Control.Height + CT_SPACING);
      end;
    end;
  end;

begin
  if not Assigned(fControl) then Exit;
  yPos := CT_FIX_TOP;
  for i := 0 to Elements.Count - 1 do
  begin
    Element := Elements[i];
    if Element is TTemplateAttribute then with TTemplateAttribute(Element) do
    begin
      for j := 0 to Controls.Count - 1 do
      begin
        TemplateControl := Controls[j];
        if not(TemplateControl is TTemplateNoCtrl) then
        begin
          TemplateControl.ArrangeControls;
          PlaceControl;
        end;
      end;
    end
    else
    if Element is TTemplateControl then
    begin
      TemplateControl := TTemplateControl(Element);
      if not(TemplateControl is TTemplateNoCtrl) then with TemplateControl do
      begin
        TemplateControl.ArrangeControls;
        if not Assigned(TemplateAttribute) then
          PlaceControl;
      end;
    end;
  end;
  if AutoSize and (yPos > Control.Height) then
    Control.Height := yPos;
end;

constructor TTemplateControl.Create(Attribute: TTemplateAttribute);
begin
  fElements := TObjectList.Create;
  fTemplateAttribute := Attribute;
  fAutoSize := true;
end;

destructor TTemplateControl.Destroy;
begin
  fElements.Free;
  fControl.Free;
  inherited;
end;

{ TTemplateNoCtrl }

procedure TTemplateNoCtrl.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateNoCtrl.Read;
begin

end;

procedure TTemplateNoCtrl.Write;
begin

end;

procedure TTemplateNoCtrl.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateNoCtrl.EventProc(Attribute: TLdapAttribute; Event: TEventType);
var
  i: Integer;
  s: string;
begin
  if (Event = etChange) then with fTemplateAttribute do
    for i := 0 to ValuesCount -  1 do
    begin
      s := FormatValue(Values[i].AsString, Attribute.Entry);
      if not IsParametrized(s) then
        fLdapAttribute.Values[i].AsString := s;
    end;
end;

{ TTemplateCtrlEdit }

procedure TTemplateCtrlEdit.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TMaskEdit).Text := AValue.AsString;
end;

procedure TTemplateCtrlEdit.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TMaskEdit).Text := fLdapValue.AsString;
end;

procedure TTemplateCtrlEdit.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TMaskEdit).Text;
end;

procedure TTemplateCtrlEdit.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  Node:=XmlNode.NodeByName('editmask');
  if Assigned(Node) then TMaskEdit(fControl).EditMask := Node.Content;
end;

procedure TTemplateCtrlEdit.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TMaskEdit), fTemplateAttribute do
  if (Event = etChange) and not Modified and (ValuesCount > 0) then
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
end;

constructor TTemplateCtrlEdit.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TMaskEdit.Create(nil);
  TMaskEdit(fControl).OnChange := OnChangeProc;
  TMaskEdit(fControl).OnExit := OnExitProc;
end;

{ TTemplateCtrlCombo }

procedure TTemplateCtrlCombo.SetValue(AValue: TTemplateAttributeValue);
begin
  with (fControl as TComboBox) do begin
    Text := AValue.AsString;
    OnChange(fControl);
  end;
end;

procedure TTemplateCtrlCombo.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TComboBox).Text := fLdapValue.AsString;
end;

procedure TTemplateCtrlCombo.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TComboBox).Text;
end;

constructor TTemplateCtrlCombo.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TComboBox.Create(nil);
  TComboBox(fControl).OnChange := OnChangeProc;
  TComboBox(fControl).OnExit := OnExitProc;
end;

procedure TTemplateCtrlCombo.LoadProc(XmlNode: TXmlNode);
var
  i: integer;
  ItemsNode: TXmlNode;
begin
  ItemsNode:=XmlNode.NodeByName('items');
  if ItemsNode=nil then exit;
  for i:=0 to ItemsNode.Count-1 do
    if ItemsNode[i].Name='item' then TComboBox(fControl).Items.Add(ItemsNode[i].Content);
end;

procedure TTemplateCtrlCombo.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TComboBox), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
    OnChange(fControl);
    OnExit(fControl);
  end;
end;

{ TTemplateCtrlComboList }

function TTemplateCtrlComboList.IndexOfValue(Value: string): Integer;
var
  p: PChar;
begin
  with TcomboBox(fControl) do
  begin
    p := PChar(Value);
    Result := Items.Count - 1;
    while Result >= 0 do begin
      if AnsiStrComp(p, PChar(Items.Objects[Result])) = 0 then
        break;
      dec(Result);
    end;
  end;
end;

procedure TTemplateCtrlComboList.SetValue(AValue: TTemplateAttributeValue);
begin
  with (fControl as TComboBox) do begin
    ItemIndex := IndexOfValue(fLdapValue.AsString);
    OnChange(fControl);
  end;
end;

procedure TTemplateCtrlComboList.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TComboBox) do
    ItemIndex := IndexOfValue(fLdapValue.AsString);
end;

procedure TTemplateCtrlComboList.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TComboBox) do
    if ItemIndex <> -1 then
      fLdapValue.AsString := PChar(Items.Objects[ItemIndex]);
end;

constructor TTemplateCtrlComboList.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TComboBox.Create(nil);
  with TComboBox(fControl) do begin
    Style := csDropDownList;
    OnChange := OnChangeProc;
    OnExit := OnExitProc;
  end;
end;

procedure TTemplateCtrlComboList.LoadProc(XmlNode: TXmlNode);
var
  i: integer;
  ItemsNode, Node: TXmlNode;
  cap, val: string;
begin
  ItemsNode:=XmlNode.NodeByName('items');
  if ItemsNode=nil then exit;
  for i:=0 to ItemsNode.Count-1 do with ItemsNode[i] do
    if Name='item' then
    begin
      cap := '';
      val := '';
      Node := NodeByName('caption');
      if Assigned(Node) then
        cap := Node.Content;
      Node := NodeByName('value');
      if Assigned(Node) then
        val := Node.Content;
      if cap = '' then cap := val;
      TComboBox(fControl).Items.AddObject(cap, Pointer(StrNew(PChar(val))));
    end;
end;

procedure TTemplateCtrlComboList.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TComboBox), fTemplateAttribute do
  if (Event = etChange) and (ValuesCount > 0) then
  begin
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
    OnChange(fControl);
    OnExit(fControl);
  end;
end;

{ TTemplateCtrlImage }

procedure TTemplateCtrlImage.SetValue(AValue: TTemplateAttributeValue);
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

constructor TTemplateCtrlImage.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TImage.Create(nil);
end;

procedure TTemplateCtrlImage.Read;
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

procedure TTemplateCtrlImage.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (fControl as TImage) do
    if Assigned(Picture.Graphic) then
     StreamCopy(Picture.Graphic.SaveToStream, fLdapValue.LoadFromStream);
end;

procedure TTemplateCtrlImage.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateCtrlImage.EventProc(Attribute: TLdapAttribute; Event: TEventType);
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

{ TTemplateCtrlGrid }

procedure TTemplateCtrlGrid.SetValue(AValue: TTemplateAttributeValue);
begin
  with (Control as TStringGrid) do
  begin
    RowCount := RowCount + 1;
    Cells[0, RowCount - 1] := AValue.AsString;
  end;
end;

procedure TTemplateCtrlGrid.Read;
var
  i: Integer;
begin
  if Assigned(fControl) then with Control as TStringGrid do
  begin
    for i := 0 to RowCount - 1 do Rows[i].Clear;
    if Assigned(fLdapAttribute) then with fLdapAttribute do
    begin
      if RowCount < ValueCount then
        RowCount := ValueCount;
      for i := 0 to ValueCount - 1 do
        Cells[0, i] := Values[i].AsString;
    end;
  end;
end;

procedure TTemplateCtrlGrid.Write;
var
  i: Integer;
begin
  if Assigned(fControl) and Assigned(fLdapAttribute) then with Control as TStringGrid do
  begin
    for i := 0 to RowCount - 1 do
    begin
      if i = fLdapAttribute.ValueCount then
        fLdapAttribute.AddValue;
      fLdapAttribute.Values[i].AsString := Cells[0, i];
    end;
  end;
end;

procedure TTemplateCtrlGrid.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  if not fAutoSize then Exit;
  Node:=XmlNode.NodeByName('rows');
  if Assigned(Node) then with TEditGrid(fControl) do
  begin
    RowCount := CheckStrToInt(Node.Content, Node.Name);
    Height := RowCount * (DefaultRowHeight + GridLineWidth) + DefaultRowHeight div 2;
  end;
end;

procedure TTemplateCtrlGrid.EventProc(Attribute: TLdapAttribute; Event: TEventType);
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
    Write;
  end;
end;

constructor TTemplateCtrlGrid.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TEditGrid.Create(nil);
  TEditGrid(fControl).OnExit := OnExitProc;
  TEditGrid(fControl).OnExit := OnChangeProc;
end;

{ TTemplateCtrlPasswordButton }

procedure TTemplateCtrlPasswordButton.ButtonClick(Sender: TObject);
begin
  with TPasswordDlg.Create(Sender as TControl, fLdapAttribute.Entry, fLdapAttribute.Name) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TTemplateCtrlPasswordButton.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlPasswordButton.Read;
begin

end;

procedure TTemplateCtrlPasswordButton.Write;
begin

end;

procedure TTemplateCtrlPasswordButton.LoadProc(XmlNode: TXmlNode);
begin
  if fCaption <> '' then TButton(fControl).Caption := fCaption;
end;

procedure TTemplateCtrlPasswordButton.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlPasswordButton.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TButton.Create(nil);
  with TButton(fControl) do begin
    OnExit := OnExitProc;
    OnClick := ButtonClick;
    Caption := cSetPassword;
  end;
end;

{ TTemplateCtrlTextArea }

procedure TTemplateCtrlTextArea.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TMemo).Text := AValue.AsString;
end;

procedure TTemplateCtrlTextArea.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (fControl as TMemo).Text := fLdapValue.AsString;
end;

procedure TTemplateCtrlTextArea.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := (fControl as TMemo).Text;
end;

procedure TTemplateCtrlTextArea.LoadProc(XmlNode: TXmlNode);
begin

end;

procedure TTemplateCtrlTextArea.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as Tmemo), fTemplateAttribute do
  if (Event = etChange) and not Modified and (ValuesCount > 0) then
    Text := FormatValue(Values[0].AsString, Attribute.Entry);
end;

constructor TTemplateCtrlTextArea.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TMemo.Create(nil);
  Tmemo(fControl).OnChange := OnChangeProc;
  TMemo(fControl).OnExit := OnExitProc;
end;

{ TTemplateCtrlCheckBox }

function TTemplateCtrlCheckBox.GetCbState(const AState: string): TCheckBoxState;
var
  s: string;
begin
  s := lowercase(AState);
  if s = fTrue then
    Result := cbChecked
  else
  if s = fFalse then
    Result := cbUnChecked
  else
    Result := cbGrayed;
end;

procedure TTemplateCtrlCheckBox.SetValue(AValue: TTemplateAttributeValue);
begin
  (Control as TCheckBox).State := GetCbState(AValue.AsString);
end;

procedure TTemplateCtrlCheckBox.Read;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    (Control as TCheckBox).State := GetCbState(fLdapValue.AsString);
end;

procedure TTemplateCtrlCheckBox.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then with (Control as TCheckBox) do
    case State of
      cbChecked: fLdapValue.AsString := fTrue;
      cbUnchecked: fLdapValue.AsString := fFalse;
  end;
end;

procedure TTemplateCtrlCheckBox.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
begin
  if fCaption <> '' then
    TCheckBox(fControl).Caption := fCaption;
  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do begin
    if Name = 'true' then
      fTrue := lowercase(Content)
    else
    if Name = 'false' then
      fFalse := lowercase(Content);
  end;
end;

procedure TTemplateCtrlCheckBox.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlCheckBox.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TCheckBox.Create(nil);
  with TCheckBox(fControl) do begin
    if Assigned(TemplateAttribute) then
      if TemplateAttribute.Description <> '' then
        Caption := TemplateAttribute.Description
      else
        Caption := TemplateAttribute.Name;
    OnClick := OnChangeProc;
  end;
  fTrue := 'yes';
  fFalse := 'no';
end;

{ TTemplateCtrlPanel }

procedure TTemplateCtrlPanel.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlPanel.Read;
begin

end;

procedure TTemplateCtrlPanel.Write;
begin

end;

procedure TTemplateCtrlPanel.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  Node := XmlNode.NodeByName('bevel');
  if not Assigned(Node) then exit;
  with Node, TPanel(fControl) do
  if Content = 'raised' then
  begin
    BevelInner := bvRaised;
    BevelOuter := bvNone;
  end
  else
  if Content = 'lowered' then
  begin
    BevelInner := bvNone;
    BevelOuter := bvLowered;
  end
  else
  if Content = 'frame' then
  begin
    BevelInner := bvRaised;
    BevelOuter := bvLowered;
  end
  else
  if Content = 'none' then
  begin
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;
end;

procedure TTemplateCtrlPanel.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlPanel.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TPanel.Create(nil);
end;

{ TTemplateCtrlTabSheet }

procedure TTemplateCtrlTabSheet.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlTabSheet.Read;
begin

end;

procedure TTemplateCtrlTabSheet.Write;
begin

end;

procedure TTemplateCtrlTabSheet.LoadProc(XmlNode: TXmlNode);
begin
  TTabSheet(Control).Caption := fCaption;
  fCaption := '';
end;

constructor TTemplateCtrlTabSheet.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TTabSheet.Create(nil);
end;

procedure TTemplateCtrlTabSheet.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

{ TTemplateCtrlTabbedPanel }

procedure TTemplateCtrlTabbedPanel.SetValue(AValue: TTemplateAttributeValue);
begin

end;

procedure TTemplateCtrlTabbedPanel.Read;
begin

end;

procedure TTemplateCtrlTabbedPanel.Write;
begin

end;

procedure TTemplateCtrlTabbedPanel.LoadProc(XmlNode: TXmlNode);
var
  TabSheet: TTemplateCtrlTabSheet;
  i: Integer;
begin
  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do
  begin
    if Name = 'tab' then
    begin
      TabSheet := TTemplateCtrlTabSheet.Create(nil);
      TabSheet.Load(XmlNode[i]);
      TTabSheet(TabSheet.Control).PageControl := TPageControl(fControl);
      TabSheet.ParentControl := Self;
      fElements.Add(TabSheet);
    end;
  end;
  { Reset to first page }
  with TPageControl(fControl) do begin
    ActivePage := nil;
    ActivePageIndex := 0;
  end;
end;

procedure TTemplateCtrlTabbedPanel.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin

end;

constructor TTemplateCtrlTabbedPanel.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TPageControl.Create(nil);
end;

destructor TTemplateCtrlTabbedPanel.Destroy;
begin
  Control.Visible := false;
  Control.Parent := Application.MainForm;
  inherited;
end;

procedure TTemplateCtrlTabbedPanel.ArrangeControls;
var
  i: Integer;
begin
  for i := 0 to Elements.Count - 1 do if Elements[i] is TTemplateControl then
    TTemplateControl(Elements[i]).ArrangeControls;
end;

{ TDateTimePickerFixed }

{$IFDEF VER130}
procedure TDateTimePickerFixed.SetFormat(Value: string);
begin
  fFormat := Value;
  DateTime_SetFormat(Handle, PChar(fFormat));
end;
{$ENDIF}

procedure TDateTimePickerFixed.CNNotify(var Message: TWMNotify);
begin
  if Message.NmHdr^.Code = DTN_DATETIMECHANGE then
  try
    fChanging := true;
    inherited;
  finally
    fChanging := false;
  end;
end;

function TDateTimePickerFixed.MsgSetDateTime(Value: TSystemTime): Boolean;
begin
  Result := true;
  if not fChanging then
  begin
    Result := inherited MsgSetDateTime(Value);
    {$IFDEF VER130}
    if Result and (fFormat <> '') then
      DateTime_SetFormat(Handle, PChar(fFormat));
    {$ENDIF}
  end;
end;


{ TTemplateCtrlDate }

function TTemplateCtrlDate.GetTime(Value: string): TDateTime;
begin
  if Value = '' then
    Result := 0
  else
  if (fDateFormat = FMT_DATE_TIME_UNIX) or (fTimeFormat = FMT_DATE_TIME_UNIX) then
    Result := UnixTimeToDateTime(StrToInt64(Value))
  else
  begin
    if (fDateFormat = FMT_DATE_TIME_GTZ) or (fTimeFormat = FMT_DATE_TIME_GTZ) then
    begin
      if (Length(Value) < 15) or (Uppercase(Value[Length(Value)]) <> 'Z') then
        raise EConvertError.Create('');
      Value[15] := ' ';
      Insert(':', Value, 13);
      Insert(':', Value, 11);
      Insert(' ', Value, 9);
      Insert('-', Value, 7);
      Insert('-', Value, 5);
    end;
    Result := VarToDateTime(Value);
  end;
end;

function TTemplateCtrlDate.GetDisplayFormat: string;
begin
  Result := TDateTimePickerFixed(fControl).Format;
end;

procedure TTemplateCtrlDate.SetDisplayFormat(Value: string);
begin
  TDateTimePickerFixed(fControl).Format := Value;
end;

function TTemplateCtrlDate.GetTimeString: string;
var
  ldapTime: TDateTime;
  t: string;

  function GetDateOrTime(DateTime: TDateTime; DataFormat: string; Kind: TDateTimeKind): string;
  var
    Buffer: array [0..256] of byte;
    flags: ULONG;
    p: PChar;
    st: SystemTime;
  begin
    flags := 0;
    p := nil;
    if DataFormat = '' then
      flags := LOCALE_NOUSEROVERRIDE
    else
      p := PChar(DataFormat);
    DateTimeToSystemTime(DateTime, st);
    case Kind of
      dtkDate: GetDateFormat(LOCALE_SYSTEM_DEFAULT, flags, @st, p, @Buffer, 256);
      dtkTime: GetTimeFormat(LOCALE_SYSTEM_DEFAULT, flags, @st, p, @Buffer, 256);
    end;
    Result := PChar(@Buffer);
  end;

begin
  Result := '';
  with (Control as TDateTimePicker) do
  begin
    try
      ldapTime := GetTime(fLdapValue.AsString);
    except
      ldapTime := 0;
    end;
    if Checked then
    begin
      if (fDateFormat = FMT_DATE_TIME_UNIX) or (fTimeFormat = FMT_DATE_TIME_UNIX) then
      begin
        case Kind of
          dtkDate: Result := IntToStr(DateTimeToUnixTime(Trunc(DateTime)) + DateTimeToUnixTime(Frac(ldapTime)));
          dtkTime: Result := IntToStr(DateTimeToUnixTime(Frac(DateTime)) + DateTimeToUnixTime(Trunc(ldapTime)));
        end;
      end
      else
      if (fDateFormat = FMT_DATE_TIME_GTZ) or (fTimeFormat = FMT_DATE_TIME_GTZ) then
      begin
        case Kind of
          dtkDate: Result := GetDateOrTime(Trunc(DateTime), 'yyyyMMdd', dtkDate) +
                             GetDateOrTime(Frac(ldapTime), 'HHmmssZ', dtkTime);
          dtkTime: Result := GetDateOrTime(Trunc(ldapTime), 'yyyyMMdd', dtkDate) +
                             GetDateOrTime(Frac(DateTime), 'HHmmssZ', dtkTime);
        end;
      end
      else
      begin
        case Kind of
          dtkDate: begin
                     Result := GetDateOrTime(Date, fDateFormat, dtkDate);
                     if Frac(ldapTime) <> 0 then
                     begin
                       if Result <> '' then Result := Result + ' ';
                       Result := Result + GetDateOrTime(ldapTime, fTimeFormat, dtkTime);
                     end;
                   end;
          dtkTime: begin
                     if Trunc(ldapTime) <> 0 then Result := GetDateOrTime(ldapTime, fDateFormat, dtkDate);
                     t := GetDateOrTime(Time, fTimeFormat, dtkTime);
                     if (Result <> '') and (t <> '') then Result := Result + ' ';
                     Result := Result + t;
                   end;
        end;
      end;
    end
    else
      if (fDateFormat = FMT_DATE_TIME_UNIX) or (fTimeFormat = FMT_DATE_TIME_UNIX) then
      begin
        case Kind of
          dtkDate: Result := IntToStr(DateTimeToUnixTime(0) + DateTimeToUnixTime(Frac(ldapTime)));
          dtkTime: Result := IntToStr(DateTimeToUnixTime(Frac(DateTime)) + DateTimeToUnixTime(0));
        end;
      end
      else
      if (fDateFormat = FMT_DATE_TIME_GTZ) or (fTimeFormat = FMT_DATE_TIME_GTZ) then
      begin
        case Kind of
          dtkDate: Result := GetDateOrTime(0, 'yyyyMMdd', dtkDate) +
                             GetDateOrTime(Frac(ldapTime), 'HHmmssZ', dtkTime);
          dtkTime: Result := GetDateOrTime(Trunc(ldapTime), 'yyyyMMdd', dtkDate) +
                             GetDateOrTime(0, 'HHmmssZ', dtkTime);
        end;
      end
      else
      case Kind of
        dtkDate: if Frac(ldapTime) <> 0 then Result := GetDateOrTime(ldapTime, fTimeFormat, dtkTime);
        dtkTime: if Trunc(ldapTime) <> 0 then Result := GetDateOrTime(ldapTime, fDateFormat, dtkDate);
      end;
  end;
end;

procedure TTemplateCtrlDate.SetTimeString(Value: string);

  procedure Err;
  var
    s: string;
  begin
    with (Control as TDateTimePicker) do begin
      case Kind of
        dtkDate: s := 'date format';
        dtkTime: s := 'time format';
      end;
      Checked := false;
    end;
    MessageDlg(Format(stIdentIsnotValid, [Value, s]), mtError, [mbOk], 0);
  end;

begin
  with (Control as TDateTimePicker) do
  if Value = '' then
    Checked := false
  else
  try
    DateTime := GetTime(Value);
      case Kind of
        dtkDate: if Trunc(Date) = 0 then Checked := false;
        dtkTime: if Frac(Time) = 0 then Checked := false;
      end;
    except
      on EConvertError do Err;
      on EVariantError do Err;
      else raise;
    end;
end;

procedure TTemplateCtrlDate.SetValue(AValue: TTemplateAttributeValue);
begin
  AsString := fLdapValue.AsString;
end;

procedure TTemplateCtrlDate.Read;
begin
  if Assigned(fLdapValue) then
    AsString := fLdapValue.AsString;
end;

procedure TTemplateCtrlDate.Write;
begin
  if Assigned(fControl) and Assigned(fLdapValue) then
    fLdapValue.AsString := AsString;
end;

procedure TTemplateCtrlDate.LoadProc(XmlNode: TXmlNode);
var
  i: Integer;
begin
  for i := 0 to XmlNode.Count - 1 do with XmlNode[i] do
    if Name = 'displayformat' then
      DisplayFormat := Content
    else
    if Name = 'dateformat' then
      DateFormat := Content
    else
    if Name = 'timeformat' then
      TimeFormat := Content;
end;

procedure TTemplateCtrlDate.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  with (fControl as TDateTimePicker), fTemplateAttribute do
  if Checked and (Event = etChange) and {***not Modified and} (ValuesCount > 0) then
    AsString := fLdapValue.AsString;
end;

constructor TTemplateCtrlDate.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  fControl := TDateTimePickerFixed.Create(nil);
  with TDateTimePicker(fControl) do begin
    ShowCheckBox := true;
    OnChange := OnChangeProc;
    OnExit := OnExitProc;
  end;
end;

{ TTemplateCtrlTime }

constructor TTemplateCtrlTime.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  TDateTimePicker(fControl).Kind := dtkTime;
end;

{ TTemplateCtrlDateTime }

procedure TTemplateCtrlDateTime.MyOnChangeProc(Sender: TObject);
begin
  if Sender = fDate then
    TDateTimePicker(fTime.Control).Checked := TDateTimePicker(fDate.Control).Checked
  else
    TDateTimePicker(fDate.Control).Checked := TDateTimePicker(fTime.Control).Checked;
  OnChangeProc(Sender);
end;

procedure TTemplateCtrlDateTime.MyOnResizeProc(Sender: TObject);
begin
  if fVertical then
  begin
    fDate.Control.Width := Control.ClientWidth - CT_LEFT_BORDER - CT_RIGHT_BORDER;
    fTime.Control.Width := fDate.Control.Width;
  end
  else begin
    fDate.Control.Width := (Control.ClientWidth  - CT_LEFT_BORDER - CT_RIGHT_BORDER - CT_SPACING) div 2;
    fTime.Control.Left := CT_LEFT_BORDER + fDate.Control.Width + CT_SPACING;
    ftime.Control.Width := fDate.Control.Width;
  end;
end;

procedure TTemplateCtrlDateTime.SetVertical(Value: Boolean);
begin
  fVertical := Value;
  if fVertical then
  begin
    fTime.Control.Left := CT_LEFT_BORDER;
    fTime.Control.Top := fDate.Control.Top + fDate.Control.Height + 4;
  end
  else begin
    fTime.Control.Top := CT_FIX_TOP;
  end;
  fControl.Height := fTime.Control.Top + fTime.Control.Height + CT_SPACING;
end;

procedure TTemplateCtrlDateTime.SetValue(AValue: TTemplateAttributeValue);
begin
  fDate.AsString := AValue.AsString;
  fTime.AsString := AValue.AsString;
end;

procedure TTemplateCtrlDateTime.Read;
begin
  fDate.Read;
  fTime.Read;
end;

procedure TTemplateCtrlDateTime.Write;
begin
  if not (TDateTimePicker(fDate.Control).Checked or TDateTimePicker(fTime.Control).Checked) then
    fLdapValue.AsString := ''
  else begin
    fDate.Write;
    fTime.Write;
  end;
end;

procedure TTemplateCtrlDateTime.LoadProc(XmlNode: TXmlNode);
var
  Node: TXmlNode;
begin
  inherited;
  Node := XmlNode.NodeByName('orientation');
  if Assigned(Node) then
    Vertical := Node.Content = 'vertical';
  fDate.LoadProc(XmlNode);
  fTime.LoadProc(XmlNode);
end;

procedure TTemplateCtrlDateTime.SetLdapAttribute(Attribute: TLdapAttribute);
begin
  inherited;
  fDate.LdapAttribute := Attribute;
  fTime.LdapAttribute := Attribute;
end;

procedure TTemplateCtrlDateTime.EventProc(Attribute: TLdapAttribute; Event: TEventType);
begin
  fDate.EventProc(Attribute, Event);
  ftime.EventProc(Attribute, Event);
end;

constructor TTemplateCtrlDateTime.Create(Attribute: TTemplateAttribute);
begin
  inherited;
  //fControl := TPanel.Create(nil);
  TPanel(fControl).OnResize := MyOnResizeProc;
  TPanel(fControl).BevelInner := bvRaised;
  TPanel(fControl).BevelOuter := bvNone;

  fDate := TTemplateCtrlDate.Create(Attribute);
  fDate.OnChange := MyOnChangeProc;
  fDate.ParentControl := Self;
  fDate.Control.Parent := TPanel(Control);

  fTime := TTemplateCtrltime.Create(Attribute);
  fTime.OnChange := MyOnChangeProc;
  fTime.ParentControl := Self;
  fTime.Control.Parent := TPanel(Control);

  fDate.Control.Left := CT_LEFT_BORDER;
  fDate.Control.Top := CT_FIX_TOP;
  fTime.Control.Top := CT_FIX_TOP;
  fControl.Height := fTime.Control.Top + fTime.Control.Height + CT_SPACING;
end;

{ TTemplateList }

function TTemplateList.GetItem(Index: Integer): TTemplate;
begin
  Result := Items[Index];
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

{ TTemplateAttributeList }

function TTemplateAttributeList.GetAttribute(Index: Integer): TTemplateAttribute;
begin
  Result := TTemplateAttribute(TObjectList(Self)[Index]);
end;

{ TTemplateControlList }

function TTemplateControlList.GetControl(Index: Integer): TTemplateControl;
begin
  Result := TTemplateControl(TObjectList(Self)[Index]);
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
  i: integer;

  procedure LoadIcon(var Icon: TBitmap; Node: TXmlNode);
  var
    Stream: TMemoryStream;
    Buffer: Pointer;
    vLen: Integer;
    FileName, Bitmap, TransColor: string;
    i: Integer;
  begin
    for i := 0 to Node.Count - 1 do with Node[i] do
    if Name = 'bitmap' then
      Bitmap := Content
    else
    if Name = 'filename' then
      FileName := Content
    else
    if Name = 'transparentcolor' then
      TransColor := Content;

    if (Bitmap = '') and (FileName = '') then Exit;

    Icon := TBitmap.Create;
    Icon.Transparent := true;

    if Bitmap <> '' then
    begin
      Stream := TMemoryStream.Create;
      try
        vLen := Length(Bitmap);
        GetMem(Buffer, Base64DecSize(vLen));
        try
          vLen := Base64Decode(Bitmap, Buffer^);
          Stream.WriteBuffer(Buffer^, vLen);
        finally
          FreeMem(Buffer);
        end;
        Stream.Position := 0;
        Icon.LoadFromStream(Stream);
      finally
        Stream.Free;
      end;
    end
    else
      Icon.LoadFromFile(FileName);
    if TransColor <> '' then
      Icon.TransparentColor := $02000000 + CheckStrToInt(TransColor, 'icon/transparentcolor');
  end;

begin
  inherited Create;
  FAutoArrange := true;
  FFileName:=AFileName;
  FExtends := TStringList.Create;
  FXmlTree:=TXmlTree.Create;

  FXmlTree.LoadFromFile(AFileName);
  for i:=0 to FXmlTree.Root.Count-1 do with FXmlTree.Root[i] do begin
    if Name='name' then FName:= Content
    else
    if Name='description' then FDescription:=Content
    else
    if Name='extends' then fExtends.Add(Content)
    else
    if Name='rdn' then fRdn := Content
    else
    if Name='attribute' then
    begin
      with NodeByName('name') do
        if Content = 'objectclass' then
          FObjectClass := TTemplateAttribute.Create(FXmlTree.Root[i]);
    end
    else
    if Name = 'icon' then
      LoadIcon(fIcon, FXmlTree.Root[i]);
  end;
end;

destructor TTemplate.Destroy;
begin
  FXmlTree.Free;
  fObjectclass.Free;
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

procedure TTemplate.Parse(AElements: TObjectList);
var
  Node: TXmlNode;
  i: Integer;
  AAttribute: TTemplateAttribute;

begin
  for i:=0 to FXmlTree.Root.Count-1 do
  begin
    Node := FXmlTree.Root[i];
    if Node.Name = 'attribute' then
    begin
      AAttribute := TTemplateAttribute.Create(Node);
      AElements.Add(AAttribute);
    end
    else
    if Node.Name = 'control' then
      AElements.Add(CreateControl(Node, nil));
  end;
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
  AValue: TTemplateAttributeValue;
  AControl: TTemplateControl;
begin
  inherited Create;
  FControls:=TTemplateControlList.Create;
  FValues:=TObjectList.Create;
  FDefaultControlClass := GetDefaultXmlType(XmlNode);

  for i:=0 to XmlNode.Count-1 do with XmlNode[i] do begin
    if Name='name'  then FName:=Content
    else
    if Name='description' then FDescription := Content
    else
    if Name='control' then
    begin
      AControl := CreateControl(XmlNode[i], Self);
      if Assigned(AControl) then
        AControl.fControlIndex := FControls.Add(AControl)
    end
    else
    if Name='value' then begin
      Avalue:=TTemplateAttributeValue.Create(Self);
      AValue.Base64:=(Attributes.Values['encode']='base64');
      AValue.Value:=Content;
      FValues.Add(AValue)
    end;
  end;

  if (Controls.Count = 0) and Assigned(FDefaultControlClass) then
  begin
    AControl := FDefaultControlClass.Create(Self);
    FControls.Add(AControl);
  end;

end;

destructor TTemplateAttribute.Destroy;
begin
  FControls.Free;
  FValues.Free;
  inherited;
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

constructor TTemplateAttributeValue.Create(AAttribute: TTemplateAttribute);
begin
  fAttribute := AAttribute;
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
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

finalization

  TemplateParser.Free;

end.
