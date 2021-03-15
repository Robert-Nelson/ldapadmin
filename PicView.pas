  {      LDAPAdmin - PicView.pas
  *      Copyright (C) 2008 Tihomir Karlovic
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

unit PicView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, ExtCtrls, ComCtrls, ToolWin, ImgList, LdapClasses;

type
  TViewPicFrm = class(TForm)
    Image1: TImage;
    ToolBar1: TToolBar;
    btnFitToPicture: TToolButton;
    btnResize: TToolButton;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    procedure btnFitToPictureClick(Sender: TObject);
    procedure btnResizeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent; AValue: TLdapAttributeData); reintroduce;
  end;

var
  ViewPicFrm: TViewPicFrm;

implementation

uses jpeg, Misc;

{$R *.DFM}

constructor TViewPicFrm.Create(AOwner: TComponent; AValue: TLdapAttributeData);
var
  ji: TJpegImage;
begin
  inherited Create(AOwner);
  ji := TJpegImage.Create;
  StreamCopy(AValue.SaveToStream, ji.LoadFromStream);
  Image1.Picture.Graphic := ji;
  StatusBar1.SimpleText := Format('%dx%d', [Image1.Picture.Width, Image1.Picture.Height]);
  Caption := 'View picture: ' + AValue.Attribute.Name;
end;

procedure TViewPicFrm.btnFitToPictureClick(Sender: TObject);
begin
  LockControl(Self, true);
  try
    Image1.Align := alNone;
    Height := MaxInt;
    Width := MaxInt;
    ClientWidth := Image1.Left + Image1.Width;
    ClientHeight := Image1.Top + Image1.Height + StatusBar1.Height;
  finally
    LockControl(Self, false);
  end;
end;

procedure TViewPicFrm.btnResizeClick(Sender: TObject);
begin
  LockControl(Self, true);
  try
    if btnResize.Down then
    begin
      Image1.Stretch := true;
      Image1.Align := alClient;
    end
    else begin
      Image1.Stretch := false;
      Image1.Align := alNone;
    end;
  finally
    LockControl(Self, false);
  end;
end;

procedure TViewPicFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
