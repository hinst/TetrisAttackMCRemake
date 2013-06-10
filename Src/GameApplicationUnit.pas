unit GameApplicationUnit;

interface

uses
  SysUtils,
  fgl,
  {$Region ZenGL units}
  zgl_main,
  zgl_window,
  zgl_screen,
  zgl_primitives_2d,
  zgl_mouse,
  {$EndRegion}

  GameConstUnit,
  GameLogUnit,
  GameTurretUnit,
  GameThingUnit,
  GameBullletUnit,
  GameEmitFigure,
  GameExplosionAnimation;

type

  { TGameApplication }

  TGameApplication = class
  protected
    FTurret: TTurret;
    FThings: TGameThingList;
    FEmitter: TGameEmitFigure;
    procedure StartupEngine; inline;
    procedure DrawVisualFieldSeparator; inline;
    procedure DrawTurret; inline;
    procedure UserShoot; inline;
    procedure UserExplode; inline;
    procedure PerformExplosion(const aX, aY: Single); inline;
    procedure DrawThings; inline;
    procedure UpdateThings(const aTime: Double); inline;
    procedure RemoveDeadThings; inline;
  public
    constructor Create;
    procedure Run; inline;
    procedure Draw; inline;
    procedure Update(const aTime: Double); inline;
    destructor Destroy; override;
  end;

var
  GlobalGameApplication: TGameApplication;

implementation

procedure GlobalDraw;
begin
  GlobalGameApplication.Draw;
end;

procedure GlobalUpdate(aTime: Double);
begin
  GlobalGameApplication.Update(aTime);
end;

{ TGameApplication }

procedure TGameApplication.StartupEngine;
begin
  zgl_Reg(SYS_DRAW, @GlobalDraw );
  zgl_Reg(SYS_UPDATE, @GlobalUpdate);
  wnd_SetCaption(ApplicationWindowTitle);
  scr_SetOptions(800, 600, REFRESH_MAXIMUM, False, False);
end;

procedure TGameApplication.DrawVisualFieldSeparator;
begin
  pr2d_Line(600, 0, 600, 600, $FFFFFF);
end;

procedure TGameApplication.DrawTurret;
begin
  FTurret.Draw;
end;

procedure TGameApplication.UserShoot;
var
  bullet: TGameBullet;
begin
  WriteLogMessage('Now shooting...');
  bullet := TGameBullet.Create(FTurret);
  FThings.Add(bullet);
end;

procedure TGameApplication.UserExplode;
var
  i: Integer;
  thing: TGameThing;
  bullet: TGameBullet;
begin
  bullet := nil;
  for i := 0 to FThings.Count - 1 do
  begin
    thing := FThings[i];
    if
      thing is TGameBullet
    then
    begin
      bullet := TGameBullet(thing);
      FThings.Delete(i);
      break;
    end;
  end;
  if
    bullet <> nil
  then
  begin
    PerformExplosion(bullet.X, bullet.Y);
    bullet.Free;
  end;
end;

procedure TGameApplication.PerformExplosion(const aX, aY: Single);
var
  animation: TExplosionAnimation;
begin
  animation := TExplosionAnimation.Create(aX, aY);
  FThings.Add(animation);
end;

procedure TGameApplication.DrawThings;
var
  thing: TGameThing;
begin
  for thing in FThings do
  begin
    thing.Draw;
  end;
end;

procedure TGameApplication.UpdateThings(const aTime: Double);
var
  thing: TGameThing;
begin
  for thing in FThings do
  begin
    thing.Update(aTime);
  end;
end;

procedure TGameApplication.RemoveDeadThings;
var
  i: integer;
  thing: TGameThing;
begin
  for i := FThings.Count - 1 downto 0 do
  begin
    thing := FThings[i];
    if
      thing.Dead
    then
    begin
      FThings.Delete(i);
      thing.Free;
    end;
  end;
end;

constructor TGameApplication.Create;
begin
  inherited Create;
  GlobalGameApplication := self;
  StartupEngine;
  FThings := TGameThingList.Create;
  FEmitter := TGameEmitFigure.Create(FThings);
end;

procedure TGameApplication.Run;
begin
  FTurret := TTurret.Create;
  zgl_Init;
end;

procedure TGameApplication.Draw;
begin
  DrawVisualFieldSeparator;
  DrawTurret;
  DrawThings;
end;

procedure TGameApplication.Update(const aTime: Double);
begin
  if
    mouse_Click(M_BLEFT)
  then
    UserShoot;
  if
    mouse_Click(M_BRIGHT)
  then
    UserExplode;
  mouse_ClearState;
  FEmitter.Update(aTime);
  UpdateThings(aTime);
  RemoveDeadThings;
end;

destructor TGameApplication.Destroy;
begin
  FEmitter.Free;
  FThings.Free;
  FTurret.Free;
  inherited Destroy;
end;

end.

// лалка


