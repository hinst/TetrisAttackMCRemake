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
    function GetAimVectorX: Single;
    function GetAimVectorY: Single;
    function GetAimStickX: Single; inline;
    function GetAimStickY: Single; inline;
    function GetRotationPointX: Single; inline;
    function GetRotationPointY: Single; inline;
    function GetAimLength: Single; inline;
  public
    property AimVectorX: Single read GetAimVectorX;
    property AimVectorY: Single read GetAimVectorY;
    property AimStickX: Single read GetAimStickX;
    property AimStickY: Single read GetAimStickY;
    property RotationPointX: Single read GetRotationPointX;
    property RotationPointY: Single read GetRotationPointY;
    property AimLength: Single read GetAimLength;
    procedure Draw; inline;
    procedure DrawAimCursor;
  end;

implementation

{ TTurret }

function TTurret.GetAimVectorX: Single;
begin
  result := - (300 - mouse_X) / AimLength * DefaultTurretRadius;
end;

function TTurret.GetAimVectorY: Single;
begin
  result := - (600 - mouse_Y) / AimLength * DefaultTurretRadius;
end;

function TTurret.GetAimStickX: Single;
begin
  result := 300 + AimVectorX;
end;

function TTurret.GetAimStickY: Single;
begin
  result := 600 + AimVectorY;
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
  pr2d_Circle(300, 600, DefaultTurretRadius, DefaultTurretColor, 255 div 2);
  pr2d_Line(300, 600, AimStickX, AimStickY, $FF0000, 255 div 3 * 2);
end;

procedure TTurret.DrawAimCursor;
begin
  pr2d_Circle(mouse_X, mouse_Y, DefaultAimCursorRadius, $FF0000, 255 div 3 * 2);
  pr2d_Line(
    mouse_X - DefaultAimCursorRadius div 2,
    mouse_Y,
    mouse_X - DefaultAimCursorRadius div 2 * 3,
    mouse_Y,
    $FF0000, 255 div 2
  );
  pr2d_Line(
    mouse_X + DefaultAimCursorRadius div 2,
    mouse_Y,
    mouse_X + DefaultAimCursorRadius div 2 * 3,
    mouse_Y,
    $FF0000, 255 div 2
  );
  pr2d_Line(
    mouse_X,
    mouse_Y - DefaultAimCursorRadius div 2,
    mouse_X,
    mouse_Y - DefaultAimCursorRadius div 2 * 3,
    $FF0000, 255 div 2
  );
  pr2d_Line(
    mouse_X,
    mouse_Y + DefaultAimCursorRadius div 2,
    mouse_X,
    mouse_Y + DefaultAimCursorRadius div 2 * 3,
    $FF0000, 255 div 2
  );
end;

end.

