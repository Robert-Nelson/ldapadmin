  {      LDAPAdmin - SizeGrip.pas
  *      Copyright (C) 2012 Tihomir Karlovic
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

unit SizeGrip;

interface

uses ComCtrls, Controls, Classes, CommCtrl;

type
  TSizeGrip = class(TStatusBar)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

procedure TSizeGrip.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style or SBARS_SIZEGRIP;
end;

constructor TSizeGrip.Create(AOwner: TComponent);
begin
  inherited;
  Align := alNone;
  if AOwner is TWinControl then
  begin
    Parent := TWinControl(AOwner);
    Width:=Height;
    Left := Parent.ClientWidth - Width;
    Top := Parent.ClientHeight - Height;
  end;
  Panels.Add.Bevel := pbNone;
  Anchors := [akRight,akBottom];
  SendToBack;
end;

end.
