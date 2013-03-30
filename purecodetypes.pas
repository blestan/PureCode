unit PureCodeTypes;

{$mode objfpc}{$H+}

interface

uses Types;

type

  TOrigin=(orTopLeft,orTopCenter,orTopRight,
           orCenterLeft,orCenterCenter,orCenterRight,
           orBottomLeft,orBottomCenter,orBottomRight); // do not change order!!!!

  TOrigins= set of TOrigin;

  TMeasurmentUnits=(muPx,muIN,muPT,muM,muDM,muCM,muMM);



  function OriginPosition(const Bounds: TRect; ACorner: TOrigin): TPoint;

  function PixelsPerUnit(AUnit: TMeasurmentUnits): Single;

var

   ScreenRes: integer = 72; // default screen dpi - please change at runtime!

implementation


function CalcOffsets(const Bounds: TRect; ACorner: TOrigin): TSize;
var x,y,dx,dy: integer;
begin
 y:=ord(ACorner) div 3;
 x:=ord(ACorner) mod 3;

 dx:=Bounds.Right-Bounds.Left;
 dy:=Bounds.Bottom-Bounds.Top;

 case x of
    0: Result.cx := 0;
    1: Result.cx := dx div 2;
    2: Result.cx := dx;
 end;

 case y of
    0: Result.cy:= 0;
    1: Result.cy := dy div 2;
    2: Result.cy := dy;
 end;

end;

function OriginPosition(const Bounds: TRect; ACorner: TOrigin): TPoint;
var Sz: TSize;
begin
 Sz:=CalcOffsets(Bounds,ACorner);
 Result:=Bounds.TopLeft;
 Inc(Result.x,Sz.Cx);
 Inc(Result.y,sz.Cy);
end;

function PixelsPerUnit(AUnit: TMeasurmentUnits): Single;
const m2i=39.3700787;
begin
  if AUnit=muPx then Exit(1);
  Result:=ScreenRes;
  if AUnit=muIN then Exit;
  case AUnit of
    muPt: Result:=  Result/12;
     muM: Result:=  Result*m2i;
    muDM: Result:= (Result*m2i) / 10;
    muCM: Result:= (Result*m2i) / 100;
    muMM: Result:= (Result*m2i) / 1000;
  end;
end;


end.

