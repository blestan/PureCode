unit PureCodeTypes;

{$mode objfpc}{$H+}

interface

type

  TOrigin=(cTopLeft,cTopCenter,cTopRight,
               cCenterLeft,cCenterCenter,cCenterRight,
               cBottomLeft,cBottomCenter,cBottomRight); // do not change order!!!!

  TOrigins= set of TOrigin;


  TMeasurmentUnits=(muPx,muIN,muPT,muM,muDM,muCM,muMM);

  function PixelsPerUnit(AUnit: TMeasurmentUnits): Single;

var

   ScreenRes: integer = 72; // default screen dpi - please change at runtime!

implementation

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

