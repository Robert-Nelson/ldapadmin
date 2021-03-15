  {      LDAPAdmin - Main.pas
  *      Copyright (C) 2006 Tihomir Karlovic
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

unit TemplateCtrl;

interface

uses Classes, Forms, Controls, ComCtrls, StdCtrls, ExtCtrls, Templates, LdapClasses,
     Graphics, Windows, Constant;

const
  CT_LEFT_BORDER     = 8;
  CT_RIGHT_BORDER    = 24;
  CT_FIX_TOP         = 8;
  CT_GROUP_SPACING   = 2;
  CT_SPACING         = 8;

type
  TEventHandler = class
    fEvents: TStringList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetEvent(const AName: string; AControl: TTemplateControl);
    procedure RemoveEvent(const AName: string; AControl: TTemplateControl);
    procedure HandleEvent(Attribute: TLdapAttribute; Event: TEventType);
  end;

  TTemplatePanel = class(TScrollBox)
  private
    fEntry: TLdapEntry;
    fTemplate: TTemplate;
    fEventHandler: TEventHandler;
    fHandlerInstalled: Boolean;
    fLeftBorder, fRightBorder: Integer;
    fFixTop: Integer;
    fSpacing, fGroupSpacing: Integer;
    procedure SetTemplate(Template: TTemplate);
    procedure SetEventHandler(AHandler: TeventHandler);
    procedure SetEntry(AEntry: TLdapEntry);
    procedure OnControlChange(Sender: TObject);
    procedure OnControlExit(Sender: TObject);
  protected
    procedure InstallHandlers;
    procedure RemoveHandlers;
    procedure LoadTemplate; virtual;
    procedure Clear; virtual;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdjustHeight;
    procedure AdjustControls;
    procedure RefreshData;
    property LdapEntry: TLdapEntry read fEntry write SetEntry;
    property EventHandler: TEventHandler read fEventHandler write SetEventHandler;
    property Template: TTemplate read fTemplate write SetTemplate;
    property LeftBorder: Integer read fLeftBorder write fLeftBorder;
    property RightBorder: Integer read fRightBorder write fRightBorder;
  end;

  THeaderPanel = class(TPanel)
  private
    FCaptionHeight: integer;
    FBtnRect:       TRect;
    FRolled:        Boolean;
    fTemplatePanel: TTemplatePanel;
    procedure   SetCaptionHeight(const Value: integer);
    procedure   SetRolled(const Value: Boolean);
    procedure   SetTemplatePanel(APanel: TTemplatePanel);
  protected
    procedure   Resize; override;
    procedure   MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Paint; override;
    procedure   AdjustHeight;
    property    CaptionHeight: integer read FCaptionHeight write SetCaptionHeight;
    property    Rolled: Boolean read FRolled write SetRolled;
    property    TemplatePanel: TTemplatePanel read fTemplatePanel write SetTemplatePanel;
  end;

  TTemplateBox = class(TScrollBox)
  private
    fEventHandler: TEventHandler;
    fTemplateList: TList;
    fTemplateIndex: Integer;
    fTemplateHeaders: Boolean;
    fFlatPanels: Boolean;
    fShowAll: Boolean;
    fEntry: TLdapEntry;
    function  GetTemplate(Index: Integer): TTemplatePanel;
    function  GetTemplateCount: Integer;
    procedure SetTemplateIndex(AValue: Integer);
    procedure SetTemplateHeaders(AValue: Boolean);
    procedure SetFlatPanels(AValue: Boolean);
    procedure SetShowAll(AValue: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Add(ATemplate: TTemplate);
    procedure Insert(ATemplate: TTemplate; Index: Integer);
    procedure Move(FromIndex, ToIndex: Integer);
    procedure Delete(Index: Integer);
    procedure Display; virtual;
    procedure RefreshData;
    property  Templates[Index: Integer]: TTemplatePanel read GetTemplate;
    property  TemplateCount: Integer read GetTemplateCount;
    property  TemplateIndex: Integer read fTemplateIndex write SetTemplateIndex;
    property  TemplateHeaders: Boolean read fTemplateHeaders write SetTemplateHeaders;
    property  FlatPanels: Boolean read fFlatPanels write SetFlatPanels;
    property  ShowAll: Boolean read fShowAll write SetShowAll;
    property  LdapEntry: TLdapEntry read fEntry write fEntry;
  end;

  TTemplateForm = class(TForm)
  private
    fEntry: TLdapEntry;
    fEventHandler: TEventHandler;
    fTemplates: TTemplateList;
    fRdn: string;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  public
    PageControl: TPageControl;
    constructor Create(AOwner: TComponent; adn: string; ASession: TLDAPSession; Mode: TEditMode); reintroduce;
    destructor  Destroy; override;
    procedure   AddTemplate(ATemplate: TTemplate);
    procedure   LoadMatching;
    property    Templates: TTemplateList read fTemplates;
  end;

implementation

uses SysUtils, Misc;

{ TEventHandler }

constructor TEventHandler.Create;
begin
  fEvents := TStringList.Create;
end;

destructor TEventHandler.Destroy;
var
  i: Integer;
begin
  for i := 0 to fEvents.Count - 1 do
    fEvents.Objects[i].Free;
  fEvents.Free;
  inherited;
end;

procedure TEventHandler.SetEvent(const AName: string; AControl: TTemplateControl);
var
  idx: Integer;
begin
  idx := fEvents.IndexOf(AName);
  if idx = -1 then
    idx := fEvents.AddObject(AName, TList.Create);
  TList(fEvents.Objects[idx]).Add(Pointer(AControl));
end;

procedure TEventHandler.RemoveEvent(const AName: string; AControl: TTemplateControl);
var
  i: Integer;

  procedure Remove(idx: Integer);
  var
    si: Integer;
  begin
    with TList(fEvents.Objects[idx]) do
    begin
      si := IndexOf(Pointer(AControl));
      if si <> -1 then
      begin
        Delete(si);
        if Count = 0 then
          fEvents.Delete(idx);
      end;
    end;
  end;

begin
  if AName <> '' then
  begin
    i := fEvents.IndexOf(AName);
    if i <> -1 then
      Remove(i);
  end
  else begin
    for i := fEvents.Count - 1 downto 0 do
      Remove(i);
  end;
end;

procedure TEventHandler.HandleEvent(Attribute: TLdapAttribute; Event: TEventType);
var
  idx, i: Integer;
begin
  idx := fEvents.IndexOf(Attribute.Name);
  if idx <> -1 then with TList(fEvents.Objects[idx]) do
    for i := 0 to Count - 1 do
      TTemplateControl(Items[i]).EventProc(Attribute, Event);
end;

{ TTemplatePanel }

procedure TTemplatePanel.OnControlChange(Sender: TObject);
begin
  if (Sender is TTemplateControl) and Assigned(fEntry) and Assigned(TTemplateControl(Sender).TemplateAttribute) then
    fEventHandler.HandleEvent(fEntry.AttributesByName[TTemplateControl(Sender).TemplateAttribute.Name], etChange);
end;

procedure TTemplatePanel.OnControlExit(Sender: TObject);
begin
  if (Sender is TTemplateControl) and Assigned(fEntry) and Assigned(TTemplateControl(Sender).TemplateAttribute) then
    fEventHandler.HandleEvent(fEntry.AttributesByName[TTemplateControl(Sender).TemplateAttribute.Name], etUpdate);
end;

procedure TTemplatePanel.SetTemplate(Template: TTemplate);
begin
  if fTemplate = Template then Exit;
  LockControl(Self, true);
  try
    Clear;
    fTemplate := Template;
    LoadTemplate;
  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplatePanel.SetEventHandler(AHandler: TeventHandler);
begin
  if fEventHandler = AHandler then Exit;
  RemoveHandlers;
  fEventHandler := AHandler;
  InstallHandlers;
end;

procedure TTemplatePanel.SetEntry(AEntry: TLdapEntry);
begin
  fEntry := AEntry;
  LoadTemplate;
end;

procedure TTemplatePanel.InstallHandlers;
var
  i, j: Integer;

  function ParseParameters(Line: string; Control: TTemplateControl): Boolean;
  var
    p: PChar;
    Param: string;
  begin
    Result := false;
    p := PChar(Line);
    Param := GetParameter(p);
    while Param <> '' do begin
      Result := true;
      fEventHandler.SetEvent(Param, Control);
      Param := GetParameter(p);
    end;
  end;

begin

  if fHandlerInstalled or not (Assigned(fEventHandler) and Assigned(fTemplate)) then Exit;

  for i := 0 to Template.AttributeCount-1 do with Template.Attributes[i] do
  for j := 0 to ControlCount - 1 do with Controls[j] do
  begin
    { Set hooks }
    if Assigned(LdapValue) and (LdapValue.DataSize = 0) and (j < ValuesCount) then
      ParseParameters(Values[j].AsString, Controls[j]);
    { Set event handlers }
    OnChange := OnControlChange;
    OnExit := OnControlExit;
  end;

  fHandlerInstalled := true;

  { Trigger events for all attribute once }
  for i := 0 to fEntry.Attributes.Count - 1 do
  begin
    fEventHandler.HandleEvent(fEntry.Attributes[i], etChange);
    fEventHandler.HandleEvent(fEntry.Attributes[i], etUpdate);
  end;

end;

procedure TTemplatePanel.RemoveHandlers;
var
  i, j: Integer;
begin
  if fHandlerInstalled then
  begin
    for i := 0 to Template.AttributeCount-1 do with Template.Attributes[i] do
    for j := 0 to ControlCount - 1 do
      fEventHandler.RemoveEvent('', Controls[j]);
    fHandlerInstalled := false;
  end;
end;

procedure TTemplatePanel.LoadTemplate;
var
  Attribute: TLdapAttribute;
  L: TLabel;
  i, j, YPos, vCnt: Integer;

begin
  if not (Assigned(fTemplate) and Assigned(fEntry)) then
    Exit;
  yPos := fFixTop;
  for i := 0 to Template.AttributeCount-1 do with Template.Attributes[i] do
  begin
    {if Name = 'objectclass' then
      Continue;}
    Attribute := fEntry.AttributesByName[Name];
    vCnt := Attribute.ValueCount;
    for j := 0 to ControlCount - 1 do with Controls[j] do
    begin
      OnChange := nil; // TODO - InitControl?
      OnExit := nil;

      { Set values }
      if j < vCnt then
        LdapValue := Attribute.Values[j]
      else begin
        LdapValue := Attribute.AddValue;
        if (j < ValuesCount) and not IsParametrized(Values[j].AsString) and (vCnt = 0) then
          SetValue(Values[j])
        else
          LdapValue.Delete;
      end;

      { Position the control }
      if Template.AutoarrangeControls then
      begin
        L := TLabel.Create(Self);
        if Control is TWinControl then
          L.FocusControl := TWinControl(Control);
        if Description <> '' then
          L.Caption := Description
        else
          L.Caption := Name;
        L.Caption := L.Caption + ':';

        L.Left := fLeftBorder;
        L.Top := yPos;
        L.Width := Width - fLeftBorder - fRightBorder;
        inc(yPos, L.Height + fGroupSpacing);
        Control.Left := fLeftBorder;
        Control.Top := yPos;
        if Control is TImage then
          (Control as TImage).AutoSize := true
        else
          Control.Width := L.Width;
        inc(yPos, Control.Height + fSpacing);
        L.Parent := Self;
      end;
      Control.Parent := Self;

    end;
  end;

  InstallHandlers;

end;

procedure TTemplatePanel.Clear;
var
  i: Integer;
begin
  for I := ComponentCount - 1 downto 0 do
    Components[i].Free;
  RemoveHandlers;
  for I := ControlCount - 1 downto 0 do
    Controls[i].Parent := nil;
end;

procedure TTemplatePanel.Resize;
begin
  inherited;
  AdjustControls;
end;

constructor TTemplatePanel.Create(AOwner: TComponent);
begin
  inherited;
  //fEventHandler := TEventHandler.Create;
  fLeftBorder := CT_LEFT_BORDER;
  fRightBorder := CT_RIGHT_BORDER;
  fFixTop := CT_FIX_TOP;
  fGroupSpacing := CT_GROUP_SPACING;
  fSpacing := CT_SPACING;
end;

destructor TTemplatePanel.Destroy;
begin
  Clear;
  //fEventHandler.Free;
  inherited;
end;

procedure TTemplatePanel.AdjustHeight;
begin
  if ControlCount > 0 then with Controls[ControlCount - 1] do
    Self.ClientHeight := Top + Height + fSpacing;
end;

procedure TTemplatePanel.AdjustControls;
var
  i: Integer;
  C: TControl;
begin
  for i := 0 to ControlCount - 1 do
  begin
    C := Controls[i];
    { Adjust width }
    if Template.AutoarrangeControls then
    begin
      C.Left := fLeftBorder;
      C.Width := Width - fLeftBorder - fRightBorder;
    end;
  end;
end;

procedure TTemplatePanel.RefreshData;
var
  i, j: Integer;
begin
  if Assigned(fTemplate) then
  begin
    for i := 0 to Template.AttributeCount-1 do with Template.Attributes[i] do
    for j := 0 to ControlCount - 1 do with Controls[j] do
      Read;
  end;
end;

{ THeaderPanel }

constructor THeaderPanel.Create(AOwner: TComponent);
begin
  inherited;
  FCaptionHeight:=21;
  FRolled:=false;
  {FCaptionFont:=TFont.Create;
  FCaptionFont.Assign(Font);}
  Canvas.Font.Color:=clWhite;
  Canvas.Font.Style:=[fsBold];
  Canvas.Font.Size:=9;
  Canvas.Pen.Color := Canvas.Font.Color;
end;

destructor THeaderPanel.Destroy;
begin
  //FCaptionFont.Free;
  inherited;
end;

procedure THeaderPanel.SetCaptionHeight(const Value: integer);
begin
  FCaptionHeight := Value;
  invalidate;
end;

procedure THeaderPanel.SetRolled(const Value: Boolean);
begin
  FRolled := Value;
  if FRolled then
    Height := FCaptionHeight + 2
  else
    AdjustHeight;
end;

procedure THeaderPanel.SetTemplatePanel(APanel: TTemplatePanel);
begin
  fTemplatePanel := APanel;
  fTemplatePanel.Parent := Self;
  fTemplatePanel.Width := Width;
  AdjustHeight;
end;

procedure THeaderPanel.Paint;
const
  len=3;
var
  TxtRect: TRect;
  p: TPoint;
begin
//  inherited;

  // Calc button rect //////////////////////////////////////////////////////////
  FBtnRect.Top:=1;
  FBtnRect.Bottom:=FCaptionHeight;
  //FBtnRect.Bottom:=Height;
  FBtnRect.Right:=Width;//-fLeftBorder;
  InflateRect(FBtnRect, -3, -3);
  if odd(FBtnRect.Bottom-FBtnRect.Top) then FBtnRect.Top:=FBtnRect.Top-1;
  FBtnRect.Left:=FBtnRect.Right-(FBtnRect.Bottom-FBtnRect.Top);


  //////////////////////////////////////////////////////////////////////////////

  Canvas.Brush.Color:=clAppWorkSpace;
  //Canvas.FillRect(rect(fLeftBorder, 1, Width-fLeftBorder, FCaptionHeight));
  Canvas.FillRect(rect(1, 1, Width, FCaptionHeight));
  //Canvas.FillRect(rect(1, 1, Width, Height));

  //Canvas.Font:=CaptionFont;
  //TxtRect:=rect(fLeftBorder+2, 1, FBtnRect.Left-4, FCaptionHeight);
  TxtRect:=rect(2, 1, FBtnRect.Left-4, FCaptionHeight);
  //TxtRect:=rect(2, 1, FBtnRect.Left-4, Height);
  DrawText(Canvas.Handle, pchar(TemplatePanel.Template.Name), -1, TxtRect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS);

  // Draw button rectangle /////////////////////////////////////////////////////
  //Canvas.Pen.Color:=CaptionFont.Color;
  Canvas.Polyline([point(FBtnRect.Left+1, FBtnRect.Top),point(FBtnRect.Right-1, FBtnRect.Top)]);
  Canvas.Polyline([point(FBtnRect.Right-1, FBtnRect.Top+1),point(FBtnRect.Right-1, FBtnRect.Bottom-1)]);
  Canvas.Polyline([point(FBtnRect.Left+1, FBtnRect.Bottom-1),point(FBtnRect.Right-1, FBtnRect.Bottom-1)]);
  Canvas.Polyline([point(FBtnRect.Left, FBtnRect.Top+1),point(FBtnRect.Left, FBtnRect.Bottom-1)]);

  // Draw button sign //////////////////////////////////////////////////////////
  //p:=CenterPoint(FBtnRect);
  p.x := FBtnRect.Left + (FBtnRect.Right - FBtnRect.Left) div 2;
  p.y := FBtnRect.Top + (FBtnRect.Bottom - FBtnRect.Top) div 2;
  Canvas.Polyline([point(FBtnRect.Left+len, p.Y), point(FBtnRect.Right-len, p.Y)]);
  Canvas.Polyline([point(FBtnRect.Left+len, p.Y-1), point(FBtnRect.Right-len, p.Y-1)]);
  if Rolled then begin
    Canvas.Polyline([point(p.X, FBtnRect.Top+len), point(p.X, FBtnRect.Bottom-len)]);
    Canvas.Polyline([point(p.X-1, FBtnRect.Top+len), point(p.X-1, FBtnRect.Bottom-len)]);
  end;
end;

procedure THeaderPanel.AdjustHeight;
begin
  fTemplatePanel.Top := FCaptionHeight;
  fTemplatePanel.AdjustHeight;
  Height := FCaptionHeight + fTemplatePanel.Height;
end;

procedure THeaderPanel.Resize;
begin
  inherited;
  if Assigned(fTemplatePanel) then
    fTemplatePanel.Width := Width;
end;

procedure THeaderPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
   if (ssDouble in Shift) or (PtInRect(FBtnRect, point(X,Y))) then
      Rolled:=not Rolled;
end;

{ TTemplateBox }

function TTemplateBox.GetTemplate(Index: Integer): TTemplatePanel;
begin
  Result := THeaderPanel(fTemplateList[Index]).TemplatePanel;
end;

function TTemplateBox.GetTemplateCount: Integer;
begin
  Result := fTemplateList.Count;
end;

procedure TTemplateBox.SetTemplateIndex(AValue: Integer);
begin
  fTemplateIndex := AValue;
  Display;
end;

procedure TTemplateBox.SetTemplateHeaders(AValue: Boolean);
begin
  fTemplateHeaders := AValue;
  Display;
end;

procedure TTemplateBox.SetFlatPanels(AValue: Boolean);
begin
  fFlatPanels := AValue;
  Display;
end;

procedure TTemplateBox.SetShowAll(AValue: Boolean);
begin
  fShowAll := AValue;
  Display;
end;

constructor TTemplateBox.Create(AOwner: TComponent);
begin
  inherited;
  fEventHandler := TEventHandler.Create;
  fTemplateList := TTemplateList.Create;
  TemplateIndex := -1;
  fShowAll := true;
  fTemplateHeaders := true;
end;

destructor  TTemplateBox.Destroy;
var
  i: Integer;
begin
  with fTemplateList do begin
    for i := 0 to Count - 1 do
      THeaderPanel(fTemplateList[i]).Free;
    Free;
  end;
  fEventHandler.Free;
  inherited;
end;

procedure TTemplateBox.Add(ATemplate: TTemplate);
var
  pnl: THeaderPanel;
  TemplatePanel: TTemplatePanel;
begin
  LockControl(Self, true);
  try
    TemplatePanel := TTemplatePanel.Create(Self);
    TemplatePanel.LdapEntry := fEntry;
    TemplatePanel.EventHandler := fEventHandler;
    with TemplatePanel do begin
      Template := ATemplate;
      if fFlatPanels then
      begin
        BorderStyle := bsNone;
        RightBorder := LeftBorder;
      end
      else begin
        BorderStyle := bsSingle;
        RightBorder := CT_RIGHT_BORDER;
      end;
    end;

    pnl:=THeaderPanel.Create(self);
    pnl.Parent:=Self;
    pnl.Align := alBottom; // push ut to the end
    pnl.Align := alTop;    // then allign on the top of the last panel
    pnl.TemplatePanel := TemplatePanel;
    TemplatePanel.Anchors := [akLeft, akRight, akTop];

    fTemplateList.Add(pnl);

  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplateBox.Insert(ATemplate: TTemplate; Index: Integer);
var
  TemplatePanel: TTemplatePanel;
begin
  //TODO
  TemplatePanel := TTemplatePanel.Create(Self);
  TemplatePanel.Template := ATemplate;
  fTemplateList.Insert(Index, ATemplate);
end;

procedure TTemplateBox.Move(FromIndex, ToIndex: Integer);
begin
  fTemplateList.Move(FromIndex, ToIndex);
end;

procedure TTemplateBox.Delete(Index: Integer);
begin
  TTemplatePanel(fTemplateList[Index]).Free;
  fTemplateList.Delete(Index);
end;

procedure TTemplateBox.Display;
var
  i: integer;
begin
  try
    LockControl(Self, true);
    for i:=0 to fTemplateList.Count-1 do
      THeaderPanel(fTemplateList[i]).Visible := ((fTemplateIndex = -1) and fShowAll) or (fTemplateIndex=i);
    if fTemplateIndex <> -1 then THeaderPanel(fTemplateList[fTemplateIndex]).Rolled := false;
  finally
    LockControl(Self, false);
  end;
end;

procedure TTemplateBox.RefreshData;
var
  i: Integer;
begin
  for i := 1 to fTemplateList.Count - 1 do
    TTemplatePanel(fTemplateList[i]).Refresh;
end;

{ TTemplateForm }

procedure TTemplateForm.OKBtnClick(Sender: TObject);
var
  i, j: Integer;
  S: TStringList;
  ardn, aval: string;
begin
  if esNew in fEntry.State then
  begin
    S := TStringList.Create;
    try
      for i := 0 to fTemplates.Count - 1 do with fTemplates[i] do
      begin
        { add objectclasses }
        with fEntry.AttributesByName['objectclass'] do
          for j := 0 to ObjectclassCount - 1 do
            AddValue(Objectclasses[j]);
        { designated rdn }
        if Rdn <> '' then
        begin
          aval := fEntry.AttributesByName[Rdn].AsString;
          if aval <> '' then
            S.Add(Rdn + '=' + aval);
        end;
      end;
      if S.Count = 1 then
        ardn := S[0]
      else
        if ComboMessageDlg('Enter rdn:', S.CommaText, ardn) <> mrOk then
          Abort;
      fEntry.Dn := ardn + ',' + fRdn;
    finally
      S.Free;
    end;
  end;
  fEntry.Write;
  CancelBtnClick(nil); // Close form if not modal
end;

procedure TTemplateForm.CancelBtnClick(Sender: TObject);
begin
  if not (fsModal in FormState) then
    Close;
end;

constructor TTemplateForm.Create(AOwner: TComponent; adn: string; ASession: TLDAPSession; Mode: TEditMode);
var
  Panel: TPanel;
  Btn : TButton;
begin
  inherited CreateNew(AOwner);

  fEventHandler := TEventHandler.Create;
  fTemplates := TTemplateList.Create;
  fRdn := adn;
  fEntry := TLdapEntry.Create(ASession, adn);
  if Mode = EM_MODIFY then
  begin
    Caption := Format(cEditEntry, [adn]);
    fEntry.Read;
  end
  else
    Caption := cNewEntry;

  Height := 540;
  Width := 440;
  Position := poOwnerFormCenter;

  Panel := TPanel.Create(Self);
  Panel.Parent := Self;
  Panel.Align := alBottom;
  Panel.Height := 34;

  PageControl := TPageControl.Create(Self);
  PageControl.Parent := Self;
  PageControl.Align := alClient;

  Btn := TButton.Create(Self);
  with Btn do begin
    Parent := Panel;
    Top := 4;
    Left := Panel.Width - Width - 4;
    Anchors := [akTop, akRight];
    ModalResult := mrCancel;
    Caption := '&Cancel';
    Cancel := true;
  end;

  with TButton.Create(Self) do begin
    Parent := Panel;
    Top := 4;
    Left := Btn.Left - Width - 8;
    Anchors := [akTop, akRight];
    TabOrder := 0;
    Default := true;
    ModalResult := mrOk;
    Caption := '&OK';
    OnClick := OkBtnClick;
  end;
end;

destructor TTemplateForm.Destroy;
begin
  fEntry.Free;
  while PageControl.PageCount > 0 do
    PageControl.Pages[0].Free;
  fEventHandler.Free;
  fTemplates.Free;
  inherited;
end;

procedure TTemplateForm.AddTemplate(ATemplate: TTemplate);
var
  Panel: TTemplatePanel;
  TabSheet: TTabSheet;
begin
  Panel := TTemplatePanel.Create(Self);
  Panel.Template := ATemplate;
  Panel.LdapEntry := fEntry;
  Panel.EventHandler := fEventHandler;
  TabSheet := TTabSheet.Create(Self);
  TabSheet.Caption := ATemplate.Name;
  TabSheet.PageControl := PageControl;
  Panel.Parent := TabSheet;
  Panel.Align := alClient;
  fTemplates.Add(ATemplate);
  if TabSheet.TabIndex = 0 then
    ActiveControl := Panel.FindNextControl(nil, true, true, true);
end;

procedure TTemplateForm.LoadMatching;
var
  Oc: TLdapAttribute;
  i: Integer;
  Template: TTemplate;
begin
  if esNew in fEntry.State then Exit;
  Oc := fEntry.AttributesByName['objectclass'];
  for i := 0 to TemplateParser.Count - 1 do
  begin
    Template := TemplateParser.Templates[i];
    if Assigned(Oc) and Template.Matches(Oc) then
      AddTemplate(Template);
  end;
end;

end.
