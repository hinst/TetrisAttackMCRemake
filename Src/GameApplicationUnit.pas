unit GameApplicationUnit;

{$Macro ON}

{$Define inline_ := inline }

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
  zgl_keyboard,
  zgl_math_2d,
  {$EndRegion}

  GameConstUnit,
  GameLogUnit,
  GameTurretUnit,
  GameThingUnit,
  GameBullletUnit,
  GameFigureUnit,
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
    FTargetBullet: TGameBullet;
    FPaused: Boolean;
    procedure StartupEngine;
    procedure DrawTurret;
    procedure UserShoot;
    procedure UserExplode;
    function FindBulletToExplode: TGameBullet;
    procedure PerformBulletExplosion(const aX, aY: Single);
    procedure PerformFigureExplosion(const aX, aY: Single);
    procedure ExplodeThings(const aX, aY, aR: Single);
    procedure ExplodeDirectHits;
    procedure DelayBulletExplosion(const aBullet: TGameBullet);
    procedure DrawThings;
    procedure DrawTargetBulletPointer;
    procedure DrawTargetBulletMarker;
    procedure UpdateThings(const aTime: Double);
    procedure RemoveDeadThings;
    procedure ProcessDeadThing(const aThing: TGameThing);
    procedure ProcessDeadFigure(const aFigure: TFigure);
    procedure ReleaseThings;
    procedure MouseRelease(const aButton: Byte);
  public
    constructor Create;
    procedure OnEngineStartup;
    procedure Run;
    procedure Draw;
    procedure Update(const aTime: Double);
    procedure UpdatePlay(const aTime: Double);
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

procedure GlobalMouseRelease(aButton: Byte);
begin
  GlobalGameApplication.MouseRelease(aButton);
end;

{ TGameApplication }

procedure TGameApplication.StartupEngine;
begin
  zgl_Reg(SYS_LOAD, @GlobalInit);
  zgl_Reg(SYS_DRAW, @GlobalDraw);
  zgl_Reg(SYS_UPDATE, @GlobalUpdate);
  mouse_PRelease := @GlobalMouseRelease;
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
  bullet: TGameBullet;
begin
  bullet := FTargetBullet;
  if
    bullet <> nil
  then
  begin
    FThings.Remove(bullet);
    PerformBulletExplosion(bullet.X, bullet.Y);
    bullet.Free;
  end;
end;

function TGameApplication.FindBulletToExplode: TGameBullet;
var
  i: Integer;
  thing: TGameThing;
  currentBullet: TGameBullet;
  currentDistance, bestDistance: Single;
begin
  result := nil;
  for i := 0 to FThings.Count - 1 do
  begin
    thing := FThings[i];
    if
      thing is TGameBullet
    then
    begin
      currentBullet := TGameBullet(thing);
      currentDistance := m_Distance(currentBullet.X, currentBullet.Y, mouse_X, mouse_Y);
      if
        (currentDistance < bestDistance)
        or
        (result = nil)
      then
      begin
        result := currentBullet;
        bestDistance := currentDistance;
      end;
    end;
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

procedure TGameApplication.PerformFigureExplosion(const aX, aY: Single);
var
  animation: TFigureExplosionAnimation;
begin
  animation := TFigureExplosionAnimation.Create(aX, aY);
  FThings.Add(animation);
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
      thing.Dead
    then
      continue;
    if
      thing.Touches(aX, aY, aR)
    then
    begin
      thing.Dead := true;
      if
        thing is TGameBullet
      then
      begin
        DelayBulletExplosion(TGameBullet(thing));
        if
          FTargetBullet = thing
        then
          FTargetBullet := nil;
      end;
      if
        thing is TFigure
      then
      begin
        WriteLogMessage('Figure exploded');
        PerformFigureExplosion(TFigure(thing).X, TFigure(thing).Y);
        FState.Score += 1;
      end;
    end;
  end;
end;

procedure TGameApplication.ExplodeDirectHits;
var
  i: Integer;
  thing: TGameThing;
  thing2: TGameThing;
  bullet: TGameBullet;
  figure: TFigure;
  explode: boolean;
begin
  for thing in FThings do
  begin
    if
      thing.Dead
    then
      continue;
    if
      thing is TGameBullet
    then
    begin
      bullet := TGameBullet(thing);
      explode := false;
      for thing2 in FThings do
      begin
        if
          thing.Dead
        then
          continue;
        if thing2 is TFigure then
        begin
          figure := TFigure(thing2);
          explode := explode or figure.Touches(bullet.X, bullet.Y, DefaultBulletRadius);
        end;
      end;
      if explode then
      begin
        bullet.Dead := true;
        PerformBulletExplosion(bullet.X, bullet.Y);
      end;
    end;
  end;
end;

procedure TGameApplication.DelayBulletExplosion(const aBullet: TGameBullet);
var
  animation: TGameBulletDelayedExplosion;
begin
  animation := TGameBulletDelayedExplosion.Create(aBullet);
  FThings.Add(animation);
end;

procedure TGameApplication.DrawThings;
var
  thing: TGameThing;
begin
  for thing in FThings do
  begin
    if
      not thing.Dead
    then
      thing.Draw;
  end;
end;

procedure TGameApplication.DrawTargetBulletPointer;
var
  bullet: TGameBullet;
begin
  bullet := FTargetBullet;
  if
    bullet <> nil
  then
  begin
    pr2d_Line(mouse_X, mouse_Y, bullet.X, bullet.Y, $FFFF00, 255 div 2);
  end;
end;

procedure TGameApplication.DrawTargetBulletMarker;
var
  bullet: TGameBullet;
begin
  bullet := FTargetBullet;
  if
    bullet <> nil
  then
  begin
    pr2d_Circle(bullet.X, bullet.Y, DefaultBulletRadius / 3 * 2, $FFFF00, 255 div 2);
  end;
end;

procedure TGameApplication.UpdateThings(const aTime: Double);
var
  thing: TGameThing;
begin
  for thing in FThings do
  begin
    if
      not thing.Dead
    then
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
      ProcessDeadThing(thing);
      thing.Free;
    end;
  end;
end;

procedure TGameApplication.ProcessDeadThing(const aThing: TGameThing);
  procedure PerformDelayedExplosion(const a: TGameBulletDelayedExplosion);
  begin
    PerformBulletExplosion(a.X, a.Y);
  end;
begin
  if
    aThing is TGameBulletDelayedExplosion
  then
    PerformDelayedExplosion(TGameBulletDelayedExplosion(aThing));
  if
    aThing is TFigure
  then
    ProcessDeadFigure(TFigure(aThing));
  if
    FTargetBullet = aThing
  then
  begin
    WriteLogMessage('TargetBulletFlewAway');
    FTargetBullet := nil;
  end;
end;

procedure TGameApplication.ProcessDeadFigure(const aFigure: TFigure);
begin
  if
    aFigure.Fail
  then
  begin
    WriteLogMessage('Figure failed');
    PerformBulletExplosion(aFigure.X, aFigure.Y);
    FState.LivesLeft := FState.LivesLeft - 1;
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

procedure TGameApplication.MouseRelease(const aButton: Byte);
begin
  if
    aButton = M_BRIGHT
  then
    UserExplode;
end;

constructor TGameApplication.Create;
begin
  inherited Create;
  GlobalGameApplication := self;
  StartupEngine;
  FState := TGameState.Create;
  FTurret := TTurret.Create;
  FThings := TGameThingList.Create;
  FEmitter := TGameEmitFigure.Create(FThings, FState);
  FEmitter.EmitHouses;
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
  DrawTurret;
  if mouse_Down(M_BRIGHT) then
    DrawTargetBulletPointer;
  DrawTargetBulletMarker;
  FPresentation.Draw;
  batch2d_End;
end;

procedure TGameApplication.Update(const aTime: Double);
begin
  if
    key_Press(K_SPACE)
  then
  begin
    FPaused := (not FPaused) or FPresentation.DrawHelpEnabled;
  end;
  if
    key_Press(K_F1)
  then
  begin
    FPresentation.DrawHelpEnabled := not FPresentation.DrawHelpEnabled;
    FPaused := FPresentation.DrawHelpEnabled;
  end;
  if
    not FPaused
  then
    UpdatePlay(aTime);
  mouse_ClearState;
  key_ClearState;
end;

procedure TGameApplication.UpdatePlay(const aTime: Double);
begin
  if
    mouse_Down(M_BLEFT)
  then
    UserShoot;
  FState.Update(aTime);
  FEmitter.Update(aTime);
  UpdateThings(aTime);
  ExplodeDirectHits;
  RemoveDeadThings;
  if
    not mouse_Down(M_BRIGHT)
  then
    FTargetBullet := FindBulletToExplode;
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


