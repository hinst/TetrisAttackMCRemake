unit GameTurretUnit;

interface

uses
  zgl_primitives_2d,
  zgl_mouse,
  zgl_main,
  zgl_math_2d,

  GameConstUnit,
  GameLogUnit;

type

  { TTurret }

  TTurret = class
  protected
    function GetAimStickX: Single;
    function GetAimStickY: Single;
    function GetRotationPointX: Single;
    function GetRotationPointY: Single;
    function GetAimLength: Single;
    property AimStickX: Single read GetAimStickX;
    property AimStickY: Single read GetAimStickY;
    property RotationPointX: Single read GetRotationPointX;
    property RotationPointY: Single read GetRotationPointY;
    property AimLength: Single read GetAimLength;
  public
    procedure Draw;
  end;

implementation

{ TTurret }

function TTurret.GetAimStickX: Single;
begin
  result := 300 - (300 - mouse_X) / AimLength * DefaultTurretRadius;
end;

function TTurret.GetAimStickY: Single;
begin
  result := 600 - (600 - mouse_Y) / AimLength * DefaultTurretRadius;
end;

function TTurret.GetRotationPointX: Single;
begin
  result := 300;
end;

function TTurret.GetRotationPointY: Single;
begin
  result := 600;
end;

function TTurret.GetAimLength: Single;
begin
  result := m_Distance(mouse_X, mouse_Y, RotationPointX, RotationPointY);
end;

procedure TTurret.Draw;
begin
  pr2d_Circle(300, 600, DefaultTurretRadius, DefaultTurretColor, 255 div 3);
  pr2d_Line(300, 600, AimStickX, AimStickY, $FF0000, 255 div 3);
end;

end.

