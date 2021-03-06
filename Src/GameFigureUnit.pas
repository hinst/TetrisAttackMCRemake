unit GameFigureUnit;

interface

uses
  SysUtils,

  zgl_primitives_2d,
  zgl_math_2d,

  GameConstUnit,
  GameLogUnit,
  GameThingUnit;

type

  { TFigure }

  TFigure = class(TGameThing)
  protected
    FX, FY: Single;
    FW: Single;
    FSpeedY: Single;
    function GetFail: Boolean;
  public
    property X: Single read FX;
    property Y: Single read FY;
    property Fail: Boolean read GetFail;
    constructor Create(const aX, aY, aSpeedY: Single);
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
    function Touches(const aX, aY, aR: Single): Boolean; override;
  end;

implementation

{ TFigure }

function TFigure.GetFail: Boolean;
begin
  result := FY > 600;
end;

constructor TFigure.Create(const aX, aY, aSpeedY: Single);
begin
  inherited Create;
  FX := aX;
  FY := aY;
  FSpeedY := aSpeedY;
  FW := DefaultFigureWidth;
end;

procedure TFigure.Draw;
begin
  pr2d_Rect(FX, FY, FW, FW, DefaultFigureColor);
end;

procedure TFigure.Update(const aTime: Double);
begin
  FY += FSpeedY * aTime / 1000;
  if
    Fail
  then
    FDead := True;
end;

function TFigure.Touches(const aX, aY, aR: Single): Boolean;
var
  distance: Single;
begin
  distance := m_Distance(aX, aY, FX + FW / 2, FY + FW / 2);
  result := distance < FW / 2 + aR;
  //WriteLogMessage(FloatToStr(distance));
end;

end.

