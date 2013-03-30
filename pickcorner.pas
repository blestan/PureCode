unit pickcorner;

{$mode objfpc}{$H+}

interface

uses
  Types,Classes, SysUtils, LResources, Forms, Controls, Graphics;

type


  TCornerPicker = class(TGraphicControl)
    private
     FSelColor: TColor;
    protected
    { Protected declarations }
    class function GetControlClassDefaultSize: TSize; override;
    procedure SetSelColor(AColor: TColor);
    procedure Paint; override;


   public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
   published
    { Published declarations}
     property TickColor: TColor read FSelColor write SetSelColor;
     property Align;
     property Color;
     property Anchors;
  end;

implementation


class function TCornerPicker.GetControlClassDefaultSize: TSize;
begin
  Result.CX := 21;
  Result.CY := 21;
end;

Constructor TCornerPicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption,csOpaque];
  FSelColor:=clBlack;
  with GetControlClassDefaultSize do SetInitialBounds(0, 0, CX, CY);
end;

procedure TCornerPicker.SetSelColor(AColor: TColor);
begin
  FSelColor:=AColor;
  Invalidate;
end;

Procedure TCornerPicker.Paint;
begin

end;

procedure Register;
begin
  {$I cornerpicker.lrs}
  RegisterComponents('PureCode',[TCornerPicker]);
end;

end.

