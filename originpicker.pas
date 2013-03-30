unit OriginPicker;

{$mode objfpc}{$H+}

interface

uses
  Types,PureCodeTypes, Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs;

type

  TOriginPicker = class(TGraphicControl)
  private
    FSelColor: TColor;
    FDisColor: TColor;
    FSelected: TOrigin;
    FOrigins: TOrigins;
    FOnChange: TNotifyEvent;
  protected
    class function GetControlClassDefaultSize: TSize; override;
    procedure SetSelColor(AColor: TColor);
    procedure SetDisColor(AColor: TColor);
    procedure SetSelected(ACorner: TOrigin);
    procedure SetAllowed(AOrigins: TOrigins);
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
  public
    constructor Create(AOwner:TComponent); override;
    procedure AllowAllOrigins;
    procedure AllowHLine;
    procedure AllowVLine;

    class function MoveRect(const R: TRect; const Position: TPoint; AOrigin: TOrigin): TRect;

    function OriginPosition(const Bounds: TRect): TPoint;

  published
    property SelectedColor: TColor read FSelColor write SetSelColor;
    property DisabledColor: TColor read FDisColor write SetDisColor;
    property Align;
    property Color;
    property Anchors;
    property Enabled;
    property Selected: TOrigin read FSelected write SetSelected;
    property Allowed: TOrigins read FOrigins write SetAllowed;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

class function TOriginPicker.GetControlClassDefaultSize: TSize;
begin
  Result.CX := 21;
  Result.CY := 21;
end;

Constructor TOriginPicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption,csOpaque];
  FSelColor:=clBlack;
  FDisColor:=clGray;
  FSelected:=orCenterCenter;
  FOnChange:=nil;
  AllowAllOrigins;
  with GetControlClassDefaultSize do SetInitialBounds(0, 0, CX, CY);
end;

procedure TOriginPicker.SetSelColor(AColor: TColor);
begin
  FSelColor:=AColor;
  Invalidate;
end;

procedure TOriginPicker.SetDisColor(AColor: TColor);
begin
  FDisColor:=AColor;
  Invalidate;
end;

Procedure TOriginPicker.SetSelected(ACorner: TOrigin);
begin
  if ACorner=FSelected then exit;
  FSelected:=ACorner;
  Invalidate
end;

Procedure TOriginPicker.SetAllowed(AOrigins: TOrigins);
begin
  if AOrigins=FOrigins then exit;
  FOrigins:=AOrigins;
  Invalidate
end;

Procedure TOriginPicker.Paint;
var   ssx,ssy: integer;
          i,j: integer;
          r: TRect;
          c: integer;

          DefPen: TColor;
        DefBrush: TColor;

begin
ssx:=Width div 3;
ssy:=Height div 3;

if Enabled then
  begin
   DefPen:=FSelColor;
   DefBrush:=clWhite
  end
   else
    begin
     DefPen:=FDisColor;
     DefBrush:=FDisColor
    end;

with Canvas do
 begin
   Brush.Color:=Color;
   R:=ClientRect;
   InflateRect(R,-ssx div 2,-ssy div 2);
   Rectangle(R);
   c:=0;
   for j:=0 to 2 do
   begin
    R:=Rect(0,0,ssx,ssy);
    OffsetRect(R,0,j*ssy);
    InflateRect(R,-1,-1);
    for i:=0 to 2 do
     begin
      if TOrigin(C) in FOrigins then Pen.Color:=DefPen
                                else Pen.Color:=FDisColor;

      if ord(FSelected)<>c then Brush.Color:=DefBrush
                           else Brush.Color:=FSelColor;
      Rectangle(R);
      OffsetRect(R,ssx,0);
      Inc(c);
    end
   end
 end
end;

procedure TOriginPicker.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
var   ssx,ssy: integer;
          i,j: integer;

          index: TOrigin;
begin
 if not Enabled then exit;
 ssx:=Width div 3;
 ssy:=Height div 3;
 i:=x div ssx;
 j:=y div ssy;

 Index:=TOrigin((j*3)+i);

 if index in Allowed then
   begin
    Selected :=Index;
    if Assigned(FOnChange)  then FOnChange(Self);
   end;
end;

procedure TOriginPicker.AllowAllOrigins;
begin
 Allowed:=[orTopLeft,orTopCenter,orTopRight,
           orCenterLeft,orCenterCenter,orCenterRight,
           orBottomLeft,orBottomCenter,orBottomRight];
end;

procedure TOriginPicker.AllowHLine;
begin
 Allowed:=[orCenterLeft,orCenterCenter,orCenterRight];
end;

procedure TOriginPicker.AllowVLine;
begin
 Allowed:=[orTopCenter,orCenterCenter,orBottomCenter];
end;




class function TOriginPicker.MoveRect(const R: TRect; const Position: TPoint; AOrigin: TOrigin): TRect;
begin

end;

function TOriginPicker.OriginPosition(const Bounds: TRect): TPoint;inline;
begin
 Result:=PureCodeTypes.OriginPosition(Bounds,FSelected);
end;

procedure Register;
begin
  {$I originpicker_icon.lrs}
  RegisterComponents('PureCode',[TOriginPicker]);
end;

end.
