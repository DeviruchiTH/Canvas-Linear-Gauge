{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit rflinear;

interface

uses
  GraphicLinear, TyphonPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('GraphicLinear', @GraphicLinear.Register);
end;

initialization
  RegisterPackage('rflinear', @Register);
end.
