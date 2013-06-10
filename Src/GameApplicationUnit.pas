unit GameApplicationUnit;

interface

uses
  SysUtils,
  fgl,
  {$Region ZenGL units}
  zgl_main,
  zgl_render,
  zgl_render_2d,
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
  GameExplosionAnimation,
  GamePresentationUnit,
  GameStateUnit;

type

  { TGameApplication }

  TGameApplication = class
  protected
    FState: TGameState;
    FTurret: TTurret;
    FThings: TGameThingList;
    FEmitter: TGameEmitFigure;
    FPresentation: TPresentation;
    procedure StartupEngine; inline;
    procedure DrawTurret; inline;
    procedure UserShoot; inline;
    procedure UserExplode; inline;
    procedure PerformBulletExplosion(const aX, aY: Single); inline;
    procedure ExplodeThings(const aX, aY, aR: Single);
    procedure DrawThings; inline;
    procedure UpdateThings(const aTime: Double); inline;
    procedure RemoveDeadThings; inline;
    procedure ReleaseThings;
  public
    constructor Create;
    procedure OnEngineStartup; inline;
    procedure Run; inline;
    procedure Draw; inline;
    procedure Update(const aTime: Double); inline;
    destructor Destroy; override;
  end;

var
  GlobalGameApplication: TGameApplication;

implementation

procedure GlobalInit;
begin
  GlobalGameApplication.OnEngineStartup;
end;

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
  zgl_Reg(SYS_LOAD, @GlobalInit);
  zgl_Reg(SYS_DRAW, @GlobalDraw);
  zgl_Reg(SYS_UPDATE, @GlobalUpdate);
  wnd_SetCaption(ApplicationWindowTitle);
  scr_SetOptions(800, 600, REFRESH_MAXIMUM, False, False);
end;

procedure TGameApplication.DrawTurret;
begin
  FTurret.Draw;
  FTurret.DrawAimCursor;
end;

procedure TGameApplication.UserShoot;
var
  bullet: TGameBullet;
begin
  if
    FState.ReloadTimeLeft <= 0
  then
  begin
    WriteLogMessage('Now shooting...');
    bullet := TGameBullet.Create(FTurret);
    FThings.Add(bullet);
    FState.ReloadTimeLeft := DefaultReloadTime;
  end;
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
    PerformBulletExplosion(bullet.X, bullet.Y);
    bullet.Free;
  end;
end;

procedure TGameApplication.PerformBulletExplosion(const aX, aY: Single);
var
  animation: TExplosionAnimation;
begin
  animation := TBulletExplosionAnimation.Create(aX, aY);
  FThings.Add(animation);
  ExplodeThings(aX, aY, animation.R);
end;

procedure TGameApplication.ExplodeThings(const aX, aY, aR: Single);
var
  i: Integer;
  thing: TGameThing;
begin
  for i := FThings.Count - 1 downto 0 do
  begin
    thing := FThings[i];
    if
      thing.Touches(aX, aY, aR)
    then
    begin
      FThings.Delete(i);
    end;
  end;
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

procedure TGameApplication.ReleaseThings;
var
  i: Integer;
begin
  for i := 0 to FThings.Count - 1 do
    FThings[i].Free;
  FThings.Clear;
end;

constructor TGameApplication.Create;
begin
  inherited Create;
  GlobalGameApplication := self;
  StartupEngine;
  FState := TGameState.Create;
  FTurret := TTurret.Create;
  FThings := TGameThingList.Create;
  FEmitter := TGameEmitFigure.Create(FThings);
  FPresentation := TPresentation.Create(FState);
end;

procedure TGameApplication.OnEngineStartup;
begin
  FPresentation.Startup;
end;

procedure TGameApplication.Run;
begin
  zgl_Init;
end;

procedure TGameApplication.Draw;
begin
  batch2d_Begin;
  DrawThings;
  FPresentation.Draw;
  DrawTurret;
  batch2d_End;
end;

procedure TGameApplication.Update(const aTime: Double);
begin
  if
    mouse_Down(M_BLEFT)
  then
    UserShoot;
  if
    mouse_Click(M_BRIGHT)
  then
    UserExplode;
  mouse_ClearState;
  FState.Update(aTime);
  FEmitter.Update(aTime);
  UpdateThings(aTime);
  RemoveDeadThings;
end;

destructor TGameApplication.Destroy;
begin
  FPresentation.Free;
  FEmitter.Free;
  ReleaseThings;
  FThings.Free;
  FTurret.Free;
  FState.Free;
  inherited Destroy;
end;

end.

// лал


