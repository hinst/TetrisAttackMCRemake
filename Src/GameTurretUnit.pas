unit GameTurretUnit;

interface

uses
  zgl_primitives_2d,
  zgl_mouse,

  GameConstUnit,
  GameLogUnit;

type

  { TTurret }

  TTurret = class
  protected
    function GetAimStickX: Single;
    function GetAimStickY: Single;
    property AimStickX: Single read GetAimStickX;
    property AimStickY: Single read GetAimStickY;
  public
    procedure Draw;
  end;

implementation

{ TTurret }

function TTurret.GetAimStickX: Single;
begin
  result := 600 - (600 - mouse_X) / 600 * DefaultTurretRadius;
end;

function TTurret.GetAimStickY: Single;
begin
  result := 300 - (300 - mouse_Y) / 600 * DefaultTurretRadius;
end;

procedure TTurret.Draw;
begin
  pr2d_Circle(300, 600, DefaultTurretRadius, DefaultTurretColor, 255 div 3);
  pr2d_Line(300, 600, mouse_X, mouse_Y, $FF0000, 255 div 3);
end;

end.

