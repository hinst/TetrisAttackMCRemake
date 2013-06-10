unit GameFigureUnit;

interface

uses
  zgl_primitives_2d,
  GameConstUnit,
  GameThingUnit;

type

  { TFigure }

  TFigure = class(TGameThing)
  protected
    FX, FY: Single;
    FSpeedY: Single;
  public
    constructor Create(const aX, aY, aSpeedY: Single);
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
  end;

implementation

{ TFigure }

constructor TFigure.Create(const aX, aY, aSpeedY: Single);
begin
  inherited Create;
  FX := aX;
  FY := aY;
  FSpeedY := aSpeedY;
end;

procedure TFigure.Draw;
begin
  pr2d_Rect(FX, FY, DefaultFigureWidth, DefaultFigureWidth, DefaultFigureColor);
end;

procedure TFigure.Update(const aTime: Double);
begin
  FY += FSpeedY * aTime / 1000;
end;

end.

