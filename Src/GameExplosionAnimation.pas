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
    FInitialTimeLeft: Single;
    FTimeLeft: Single;
    FColor, FOuterColor: DWord;
    FAlpha, FOuterAlpha: Byte;
    FX, FY: Single;
    FR: Single;
  public
    property R: Single read FR;
    constructor Create(const aX, aY: Single); virtual;
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
  end;

  { TBulletExplosionAnimation }

  TBulletExplosionAnimation = class(TExplosionAnimation)
  public
    constructor Create(const aX, aY: Single); override;
  end;

  { TFigureExplosionAnimation }

  TFigureExplosionAnimation = class(TExplosionAnimation)
  public
    constructor Create(const aX, aY: Single); override;
  end;

implementation

{ TExplosionAnimation }

constructor TExplosionAnimation.Create(const aX, aY: Single);
begin
  inherited Create;
  FX := aX;
  FY := aY;
end;

procedure TExplosionAnimation.Draw;
begin
  pr2d_Circle
  (
    FX,
    FY,
    FR * (1 - FTimeLeft / FInitialTimeLeft),
    FColor,
    FAlpha
  );
  pr2d_Circle
  (
    FX,
    FY,
    FR,
    FOuterColor,
    FOuterAlpha
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

{ TBulletExplosionAnimation }

constructor TBulletExplosionAnimation.Create(const aX, aY: Single);
begin
  inherited Create(aX, aY);
  FInitialTimeLeft := DefaultExplosionAnimationTime;
  FTimeLeft := FInitialTimeLeft;
  FColor := DefaultExplosionAnimationColor;
  FOuterColor := DefaultExplosionAnimationOuterColor;
  FAlpha := DefaultExplosionAnimationAlphaColor;
  FOuterAlpha := DefaultExplosionAnimationOuterAlphaColor;
  FR := DefaultExplosionRadius;
end;

{ TFigureExplosionAnimation }

constructor TFigureExplosionAnimation.Create(const aX, aY: Single);
begin
  inherited Create(aX, aY);
  FInitialTimeLeft := DefaultFigureExplosionAnimationTime;
  FTimeLeft := FInitialTimeLeft;
  FColor := DefaultExplosionAnimationColor;
  FOuterColor := DefaultExplosionAnimationOuterColor;
  FAlpha := DefaultExplosionAnimationAlphaColor;
  FOuterAlpha := DefaultExplosionAnimationOuterAlphaColor;
  FR := DefaultFigureWidth;
end;

end.

