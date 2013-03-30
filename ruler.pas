unit Ruler;

{$mode objfpc}{$H+}

interface

uses
  Types,PureCodeTypes,Classes, SysUtils, LResources, Forms, Controls, Graphics;

type


  TRulerType=(rtTop,rtLeft,rtBottom,rtRight);


  TRuler = class(TGraphicControl)
    private
           FType : TRulerType;
          FUnits : TMeasurmentUnits;
           FZoom : Double;
      FTickColor : TColor;
     FMajorTicks : Double;
            FPPU : Double;

     FZeroOffset : Integer;

     FBusy,FMustExit: Boolean;
    protected
    { Protected declarations }
    class function GetControlClassDefaultSize: TSize; override;
    procedure SetRulerType(AType: TRulerType);
    procedure SetZoom(AZoom: Double);
    procedure SetRulerUnits(AUnits: TMeasurmentUnits);
    procedure SetTickColor(AColor: TColor);
    procedure SetOffset(AnOffset: Integer);
    procedure Paint; override;
    procedure InternalAjust;

   public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    function  Scale(AValue: Double): Integer;
    function  ScreenToUnits(AValue: Integer):Double;
   published
    { Published declarations }
     property RulerType: TRulerType read FType write SetRulerType;
     property RulerUnits: TMeasurmentUnits read FUnits write SetRulerUnits;
     property Zoom: Double read FZoom write SetZoom;
     property TickColor: TColor read FTickColor write SetTickColor;
     Property ZeroOffset: Integer read FZeroOffset write SetOffset;
     property Font;
     property Align;
     property Color;
     property Anchors;
  end;

procedure Register;

implementation

const UnitNames:array[muPx..muMM] of string = ('px','in','pt','m','dm','cm','mm');


constructor TRuler.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption,csOpaque];
  FType:=rtTop;
  FUnits:=muMM;
  FZeroOffset:=0;
  FZoom:=1;
  InternalAjust;
  FBusy:=False;
  FMustExit:=False;
  with GetControlClassDefaultSize do SetInitialBounds(0, 0, CX, CY);
end;

procedure TRuler.SetRulerType(AType: TRulerType);
begin
  if FType=AType then Exit;
  FType:=AType;
  Invalidate;
end;

procedure TRuler.SetRulerUnits(AUnits: TMeasurmentUnits);
begin
  if FUnits=AUnits then Exit;
  FUnits:=AUnits;
  InternalAjust;
  Invalidate;
end;

procedure TRuler.SetZoom(AZoom: Double);
begin
  if AZoom<0.001 then AZoom:=0.001
   else if AZoom>60 then AZoom:=60;
  if FZoom=AZoom then Exit;
  FZoom:=AZoom;
  InternalAjust;
  Invalidate;
end;

procedure TRuler.SetTickColor(AColor: TColor);
begin
  if AColor=FTickColor then exit;
  FTickColor:=AColor;
  ;
end;

procedure TRuler.SetOffset(AnOffset: Integer);
begin
  if AnOffset=FZeroOffset then exit;
  FZeroOffset:=AnOffset;
  Invalidate;
end;

procedure TRuler.InternalAjust;
var I:Integer;
begin
  FPPU:=PixelsPerUnit(FUnits);
  FMajorTicks:=(Screen.PixelsPerInch/FPPU)/FZoom;
  I:=Trunc(FMajorTicks);

  case I of
      0: begin
           FMajorTicks:=Int(FMajorTicks/0.05+0.5)*0.05 ; // to the nearest 5/100
           if FMajorTicks=0 then FMajorTicks:=0.01; //  we are to close to zero
         end;
   1..4: FMajorTicks:=Int(FMajorTicks); // to the nearest int
   5..9: FMajorTicks:=Int(FMajorTicks/5+0.5)*5; // to the nearest 5
   10..MaxInt:  FMajorTicks:=Int(FMajorTicks/10+0.5)*10 // to the nearest 10;
  end
end;

function TRuler.Scale(AValue: Double): Integer;inline;
begin
   Result:=Round(AValue* FZoom * FPPU);
end;

function TRuler.ScreenToUnits(AValue: Integer): Double;
begin
  Result:=(AValue / FPPU) /FZoom;
end;




Procedure TRuler.Paint;
var
  tkMaxLen,DrawBounds: Integer;

procedure SwapInt(var A,B: Integer);inline;
begin
  A:= A xor B;
  B:= A xor B;
  A:= A xor B;
end;

procedure DrawTicks(subDivs: byte; Backward: boolean);
var
  tkCount,tkLen,tkPos,y,x1,y1: Integer;
  tkUnits,tkStep: Single;
begin
tkUnits:=0;
tkStep:=FMajorTicks / SubDivs;
if Backward then tkStep:=-tkStep;
while true  do
  for tkCount:=0 to SubDivs-1 do
  begin
          tkPos:=Scale(tkUnits)+FZeroOffset;

          if ((tkStep>0) and (tkPos>=DrawBounds)) or
             ((tkStep<0) and (tkPos<0)) then exit;

          x1:=tkPos;

          case tkCount of
            0: tkLen:=tkMaxLen;
            5: tkLen:=tkMaxLen div 2;
           else tkLen:= tkMaxLen div 4;
          end;

          y1:=tkMaxLen;

          y:=y1-tkLen;

          if FType in [rtLeft,rtRight] then
            begin
               SwapInt(tkPos,y);
               SwapInt(x1,y1);
            end;

           Canvas.MoveTo(tkPos,y);
           Canvas.LineTo(x1,y1);

          if tkCount=0 then Canvas.TextOut(tkPos+2,y+1,FloatToStr(Round((tkUnits)*100)/100));
           tkUnits:=tkUnits+tkStep;
       end
end;

begin

if FBusy then Exit;

try
  FBusy:=True;
  Canvas.Pen.Color:=FTickColor;
  Canvas.Pen.Width:=1;
  Canvas.Brush.Color:=Color;
  Canvas.Rectangle(ClientRect);

  tkMaxLen:=Height;
  DrawBounds:=Width;

  if FType in [rtLeft,rtRight] then SwapInt(tkMaxLen,DrawBounds);

  DrawTicks(10,false);
  DrawTicks(10,true);
finally
  FBusy:=False;
 end
end;

class function TRuler.GetControlClassDefaultSize: TSize;
begin
  Result.CX := 200;
  Result.CY := 25;
end;

procedure Register;
begin
  {$I ruler_icon.lrs}
  RegisterComponents('PureCode',[TRuler]);
end;

end.
