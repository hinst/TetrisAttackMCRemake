unit GameBullletUnit;

interface

uses
  zgl_primitives_2d,
  zgl_math_2d,

  GameThingUnit,
  GameTurretUnit,
  GameConstUnit,
  GameLogUnit;

type

  { TGameBullet }

  TGameBullet = class(TGameThing)
  protected
    FX, FY: Single;
    FSpeedX, FSpeedY: Single;
    FColor: DWord;
  public
    property X: Single read FX;
    property Y: Single read FY;
    constructor Create(const aTurret: TTurret);
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
    function Touches(const aX, aY, aR: Single): Boolean; override;
  end;

  { TGameBulletDelayedExplosion }

  TGameBulletDelayedExplosion = class(TGameThing)
  protected
    FTimeLeft: Double;
    FX, FY: Single;
  public
    property X: Single read FX;
    property Y: Single read FY;
    constructor Create(const aBullet: TGameBullet);
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
  end;


implementation

{ TGameBulletDelayedExplosion }

constructor TGameBulletDelayedExplosion.Create(const aBullet: TGameBullet);
begin
  FX := aBullet.X;
  FY := aBullet.Y;
  FTimeLeft := DefaultDelayedExplosionDelay;
end;

procedure TGameBulletDelayedExplosion.Draw;
begin
  pr2d_Circle(
    FX,
    FY,
    DefaultBulletRadius,
    $FFFF00,
    255
  );
  pr2d_Circle(
    FX,
    FY,
    DefaultBulletRadius,
    $FF0000,
    255 - Trunc(FTimeLeft / DefaultDelayedExplosionDelay * 255)
  );
end;

procedure TGameBulletDelayedExplosion.Update(const aTime: Double);
begin
  FTimeLeft -= aTime;
  if
    FTimeLeft < 0
  then
    FDead := True;
end;

{ TGameBullet }

constructor TGameBullet.Create(const aTurret: TTurret);
begin
  inherited Create;
  FX := aTurret.RotationPointX;
  FY := aTurret.RotationPointY;
  FSpeedX := aTurret.AimVectorX * DefaultBulletSpeedModifier;
  FSpeedY := aTurret.AimVectorY * DefaultBulletSpeedModifier;
  FColor := $FFFF00;
end;

procedure TGameBullet.Draw;
begin
  pr2d_Circle(FX, FY, DefaultBulletRadius, FColor);
end;

procedure TGameBullet.Update(const aTime: Double);
begin
  FX := FX + FSpeedX * aTime / 1000;
  FY := FY + FSpeedY * aTime / 1000;
  if
    FY + DefaultBulletRadius div 2 < 0
  then
    FDead := True;
end;

function TGameBullet.Touches(const aX, aY, aR: Single): Boolean;
begin
  result := m_Distance(aX, aY, FX, FY) < aR + DefaultBulletRadius;
end;

end.

