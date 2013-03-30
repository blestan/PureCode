{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit PureCode;

interface

uses
  Ruler, OriginPicker, PureCodeTypes, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Ruler', @Ruler.Register);
  RegisterUnit('OriginPicker', @OriginPicker.Register);
end;

initialization
  RegisterPackage('PureCode', @Register);
end.
