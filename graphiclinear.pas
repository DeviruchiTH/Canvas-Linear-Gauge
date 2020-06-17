(*
	Developed by deviruchi (Kritch)
	Version 1.0.0
	Armtronics Thailand
	Library : example
*)

unit GraphicLinear;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, LResources, Controls, Graphics, Dialogs, BGRABitmap, BGRABitmapTypes, ExtCtrls;

type
  TGraphicLinear = class(TGraphicControl)

  private
    till : integer;
    SwitchAlert : Boolean;
    FFontMargin,CharWidth:   integer;
    Fleft,Ftop : integer;
    FMaxValue : Extended;
    FMinValue : Extended;
    FPosition : Extended;
    FWarning : Extended;
    FDecimalPlaces : Integer;
    FParent : TWinControl;
    FFixScale: integer;
    FBackgroundColor : TColor;
    FBorderColor : TColor;
    FSubScaleColor : TColor;
    FBorderStyle : TPenStyle;
    FScaleColor : TColor;
    FWarningColor : TColor;
    FWarningLinearColor1 : TColor;
    FWarningLinearColor2 : TColor;
    FBrushLinearColor : TColor;
    FStyleLinear : Byte;

    FRealMarker : Extended;
    FMarkerTill : integer;
    FINC : integer;
    procedure SetFontMargin(Value: integer);
    procedure SetLeft(Value: integer);
    procedure SetTop(Value: integer);
    procedure SetupParent(Value: TWinControl);
    procedure SetMaxValue(Value: Extended);
    procedure SetMinValue(Value: Extended);
    procedure SetPosition(Value: Extended);
    procedure SetWarning(Value: Extended);
    procedure SetWarningColor(Value : TColor);
    procedure SetWarningLinearColor1(Value: TColor);
    procedure SetWarningLinearColor2(Value: TColor);
    procedure SetDecimalplaces(Value: integer);
    procedure SetFixScale(Value: integer);
    procedure SetBackgroundColor(Value: TColor);
    procedure SetBorderColor(Value: TColor);
    procedure SetBorderStyle(Value: TPenStyle);
    procedure SetSubScaleColor(Value: TColor);
    procedure SetScaleColor(Value: TColor);

    procedure SetBrushLinearColor(Value : TColor);
    procedure SetStyleLinear(Value : byte);
  protected
    procedure Paint; override;
    procedure DoOnResize; override;
    procedure EventWarning;
    procedure ForcePosition(const AValue: Real); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Color : TColor read FBrushLinearColor write SetBrushLinearColor;
    property Enabled;
    property Font;
    property Height;
    property PopupMenu;
    property Visible;
    property Width;
    property Left;
    property Top;
    property Parent: TWinControl read FParent write SetupParent;
    property FontMargin: integer read FFontMargin write SetFontMargin;
    property Maxvalue : Extended read FMaxValue write SetMaxValue;
    property Minvalue : Extended read FMinValue write SetMinValue;
    property Position : Extended read FPosition write SetPosition;
    property Warning : Extended read FWarning write SetWarning;
    property WarningColor : TColor read FWarningColor write SetWarningColor;
    property WarningLinearColor1 : TColor read FWarningLinearColor1 write SetWarningLinearColor1;
    property WarningLinearColor2 : TColor read FWarningLinearColor2 write SetWarningLinearColor2;
    property DecPlaces : integer read FDecimalPlaces write SetDecimalplaces;
    property FixScale : integer read FFixScale write SetFixScale;
    property BackgroundColor : TColor read FBackgroundColor write SetBackgroundColor;
    property BorderColor : TColor read FBorderColor write SetBorderColor;
    property BorderStyle : TPenStyle read FBorderStyle write SetBorderStyle;
    property ScaleColor : TColor read FScaleColor write SetScaleColor;
    property SubScaleColor : TColor read FSubScaleColor write SetSubScaleColor;
    property StyleLinear : byte read FStyleLinear write SetStyleLinear;
    property OnResize;
    property OnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Armtronics',[TGraphicLinear]);
end;

constructor TGraphicLinear.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alNone;
  Color := clBtnFace;
  Enabled := true;
  Visible := true;
  Font.Name := 'Arial';
  Font.Size := 8;
  Font.Style:= [fsBold];
  FFontMargin := 5;
  CharWidth := 8;
  FMaxValue:= 10000;
  FMinValue:= 0;
  FDecimalPlaces := 1000;
  FFixScale := 10;
  FWarning := 5000;
  FPosition := 10;
  FWarningColor:= clRed;
  FWarningLinearColor1 := RGBToColor(255,89,0);
  FWarningLinearColor2 := RGBToColor(255,188,53);
  FBackgroundColor:= RGBToColor(4,62,108);
  FScaleColor:=RGBToColor(166,168,174);
  FSubScaleColor:= RGBToColor(166,168,174);
  FBorderColor := RGBToColor(0,0,0);
  FBorderStyle := psSolid;
  Width:= 510;
  Height:= 45;
  Parent := TWinControl(AOwner);
end;

destructor TGraphicLinear.Destroy;
begin
  inherited Destroy;
end;

procedure TGraphicLinear.Paint;
var
 p, i: integer;
 StepScale : Extended;
 ScaleLinear : Extended;
 StepLine : Integer;
 StepSubLine : Integer;
begin
  p := 0;
  ScaleLinear:= Minvalue;
  StepLine := round((Width / FixScale)-1);
  StepSubLine := round(((Width / 5) / FixScale)) -5;
  till := round((Width / (FMaxValue - FMinValue)) * (FPosition - FMinValue));
  if ( FMinValue < 0) then
  begin
     StepScale := (FMaxValue + abs(FMinValue)) / FixScale;
  end
  else
  begin
     StepScale := (FMaxValue-FMinValue) / FixScale;
  end;
  Self.Canvas.Brush.Color := FBackgroundColor;
  Self.Canvas.Pen.Color :=  FBorderColor;
  Self.Canvas.Pen.Style := FBorderStyle;
  Self.Canvas.Rectangle(0,0,Width, Height);
  for i := 0 to Width do
  begin
    if (StepSubLine * i) <= (Width)-10 then
    begin
      Self.Canvas.Pen.Color := FSubScaleColor;
      Self.Canvas.Pen.Width := 1;
      Self.Canvas.Line(StepSubLine * i,0,StepSubLine * i,5);
    end;
  end;
  case FStyleLinear of
    0 :
      begin
        if (FPosition >= FMinValue) then
        begin
          self.Canvas.Brush.Color := FBrushLinearColor;
          self.Canvas.Pen.Style := TPenStyle.psClear;
          self.Canvas.Rectangle(0,11,till,Height-3);
          self.Canvas.Brush.Color := RGBToColor(25,140,25);
          self.Canvas.Pen.Style := TPenStyle.psClear;
          self.Canvas.Rectangle(0,7,till,12);
        end;
        if (FPosition >= FWarning) then
        begin
          EventWarning;
        end;
      end;
    1 :
      begin
        if (FPosition >= FMinValue) then
        begin
          self.Canvas.Brush.Color := FBrushLinearColor;
          self.Canvas.Pen.Style := TPenStyle.psClear;
          self.Canvas.Rectangle(0,5,till,Height-3);
        end;
        if (FPosition >= FWarning) then
        begin
          EventWarning;
        end;
      end;
  end;
  if (FPosition > FRealMarker) then
  begin
    FMarkerTill := till;
    FRealMarker := FPosition;
    FINC := 0;
  end
  else
  begin
    if FINC >= 30 then
    begin
      FRealMarker := FMinValue;
    end;
    inc(FINC);
  end;

     self.Canvas.Pen.Color := clRed;
     self.Canvas.Pen.Width := 3;
     self.Canvas.Pen.Style := TPenStyle.psSolid;
     self.Canvas.Line(FMarkerTill,Height,FMarkerTill,0);

     Self.Canvas.Pen.Color:= FScaleColor;
     Self.Canvas.Pen.Style:= psSolid;
     Self.Canvas.Pen.Width:= 3;
     Self.Canvas.Pen.JoinStyle:=pjsBevel;
     repeat
       if (p MOD StepLine) = 0 then
       begin
          Self.Canvas.Line(p,0,p,8);
          if ScaleLinear <> FWarning then
          begin
            self.Canvas.Font.Name:= Font.Name;
            Self.Canvas.Font.Style:= Font.Style;
            Self.Canvas.Font.Size:= Font.Size;
            Self.Canvas.Font.Color := Font.Color;
          end
          else
          begin
            self.Canvas.Font.Name:= Font.Name;
            Self.Canvas.Font.Style:= Font.Style;
            Self.Canvas.Font.Size:= Font.Size;
            Self.Canvas.Font.Color := FWarningColor;
          end;
          if (ScaleLinear <= FMaxValue) and (ScaleLinear > FMinValue) then
          begin
            Self.Canvas.TextRect(Self.Canvas.ClipRect, p-FFontMargin, 10, FloatToStr(ScaleLinear/FDecimalPlaces));
          end;
          ScaleLinear := ScaleLinear + StepScale;
       end;
       inc(p);
     until p >= Width;
end;

procedure TGraphicLinear.EventWarning;
begin
  case FStyleLinear of
       0 :
         begin
            if FPosition >= FWarning then
            begin
               if not SwitchAlert then
               begin
                 self.Canvas.Brush.Color:= FWarningLinearColor1;
                 self.Canvas.Pen.Style:= TPenStyle.psClear;
                 SwitchAlert := True;
                 self.Canvas.Rectangle(0,7,till,12);
               end
               else
               begin
                 self.Canvas.Brush.Color:= FWarningLinearColor2;
                 self.Canvas.Pen.Style:= TPenStyle.psClear;
                 SwitchAlert := False;
                 self.Canvas.Rectangle(0,7,till,12);
               end;
            end;
         end;
       1 :
         begin
            if not SwitchAlert then
            begin
              self.Canvas.Brush.Color:= FWarningLinearColor1;
              self.Canvas.Pen.Style:= TPenStyle.psClear;
              SwitchAlert := True;
              self.Canvas.Rectangle(0,5,till,Height-3);
            end
            else
            begin
              self.Canvas.Brush.Color:= FWarningLinearColor2;
              self.Canvas.Pen.Style:= TPenStyle.psClear;
              SwitchAlert := False;
              self.Canvas.Rectangle(0,5,till,Height-3);
            end;
         end;
  end;
end;

procedure TGraphicLinear.SetFontMargin(Value: integer);
begin
  FFontMargin := Value + 3;
  Invalidate;
end;

procedure TGraphicLinear.SetLeft(Value: integer);
begin
  FLeft := Value;
  inherited SetBounds(Left, Top, Width, Height);
end;

procedure TGraphicLinear.SetTop(Value: integer);
begin
  FTop := Value;
  inherited SetBounds(Left, Top, Width, Height);
end;

procedure TGraphicLinear.SetMaxValue(Value: Extended);
begin
  FMaxValue := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetMinValue(Value: Extended);
begin
  FMinValue := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetFixScale(Value: integer);
begin
  FFixScale := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetPosition(Value: Extended);
begin
  if ([csLoading,csDestroying]*ComponentState<>[]) or
     (csCreating in FControlState) then Exit;
  if FPosition = value then Exit;
  FPosition := value;
  ForcePosition(FPosition);
  Invalidate;
end;

procedure TGraphicLinear.ForcePosition(const AValue: Real);
begin
  if FPosition < FMinValue then FPosition := FMinValue
  else if FPosition > FMaxValue then Exit
  else FPosition := AValue;
end;

procedure TGraphicLinear.SetDecimalplaces(Value: integer);
begin
  FDecimalPlaces := Value;
  if FDecimalPlaces = 0 then
  begin
       FDecimalPlaces := 1;
       Invalidate;
  end;
  Invalidate;
end;

procedure TGraphicLinear.SetWarning(Value: Extended);
begin
  FWarning := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetWarningColor(Value: TColor);
begin
  FWarningColor := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetWarningLinearColor1(Value: TColor);
begin
  FWarningLinearColor1 := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetWarningLinearColor2(Value: TColor);
begin
  FWarningLinearColor2 := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetBackgroundColor(Value: TColor);
begin
  FBackgroundColor := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetBorderColor(Value: TColor);
begin
  FBorderColor:= Value;
  Invalidate;
end;

procedure TGraphicLinear.SetBorderStyle(Value: TPenStyle);
begin
  FBorderStyle:= Value;
  Invalidate;
end;

procedure TGraphicLinear.SetScaleColor(Value: TColor);
begin
  FScaleColor := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetSubScaleColor(Value: TColor);
begin
  FSubScaleColor := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetBrushLinearColor(Value : TColor);
begin
  FBrushLinearColor := Value;
  Invalidate;
end;

procedure TGraphicLinear.SetStyleLinear(Value : byte);
begin
  if Value > 1 then Value := 1;
  FStyleLinear := Value;
  Invalidate;
end;

procedure TGraphicLinear.DoOnResize;
begin
  if Width <= 341 then Width := 341;
  SetBounds(Left,Top,Width,Height);
  Invalidate;
  inherited DoOnResize;
end;

procedure TGraphicLinear.SetupParent(Value: TWinControl);
begin
  FParent := Value;
  inherited SetParent(FParent);
end;

end.
