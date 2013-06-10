unit GameBullletUnit;

interface

uses
  zgl_primitives_2d,

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
  public
    property X: Single read FX;
    property Y: Single read FY;
    constructor Create(const aTurret: TTurret);
    procedure Draw; override;
    procedure Update(const aTime: Double); override;
  end;

implementation

{ TGameBullet }

constructor TGameBullet.Create(const aTurret: TTurret);
begin
  inherited Create;
  FX := aTurret.RotationPointX;
  FY := aTurret.RotationPointY;
  FSpeedX := aTurret.AimVectorX * DefaultBulletSpeedModifier;
  FSpeedY := aTurret.AimVectorY * DefaultBulletSpeedModifier;
end;

procedure TGameBullet.Draw;
begin
  pr2d_Circle(FX, FY, DefaultBulletRadius, $FF0000);
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

end.

