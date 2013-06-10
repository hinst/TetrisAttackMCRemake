unit GameExplosionAnimation;

interface

uses
  zgl_primitives_2d,

  GameConstUnit,
  GameThingUnit;

type

  { TExplosionAnimation }

  TExplosionAnimation = class(TGameThing)
  protected
    FTimeLeft: Single;
    FX, FY: Single;
  public
    constructor Create(const aX, aY: Single);
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
  end;

implementation

{ TExplosionAnimation }

constructor TExplosionAnimation.Create(const aX, aY: Single);
begin
  inherited Create;
  FTimeLeft := DefaultExplosionAnimationTime;
  FX := aX;
  FY := aY;
end;

procedure TExplosionAnimation.Draw;
begin
  pr2d_Circle
  (
    FX,
    FY,
    DefaultExplosionRadius,
    DefaultExplosionAnimationColor,
    DefaultExplosionAnimationAlphaColor
  );
  inherited Draw;
end;

procedure TExplosionAnimation.Update(const aTime: Double);
begin
  FTimeLeft -= aTime;
  if
    FTimeLeft <= 0
  then
    FDead := True;
  inherited Update(aTime);
end;

end.

