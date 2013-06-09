unit GameApplicationUnit;

interface

uses
  SysUtils,
  {$Region ZenGL units}
  zgl_main,
  zgl_window,
  zgl_screen,
  zgl_primitives_2d,
  {$EndRegion}

  GameConstUnit,
  GameLogUnit,
  GameTurretUnit;

type

  { TGameApplication }

  TGameApplication = class
  protected
    FTurret: TTurret;
    procedure StartupEngine;
    procedure DrawVisualFieldSeparator;
    procedure DrawTurret;
  public
    constructor Create;
    procedure Run;
    procedure Draw;
    procedure Update(const aTime: Double);
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
  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, False, False);
end;

procedure TGameApplication.DrawVisualFieldSeparator;
begin
  pr2d_Line(600, 0, 600, 600, $FFFFFF);
end;

procedure TGameApplication.DrawTurret;
begin
  FTurret.Draw;
end;

constructor TGameApplication.Create;
begin
  inherited Create;
  GlobalGameApplication := self;
  StartupEngine;
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
end;

procedure TGameApplication.Update(const aTime: Double);
begin
end;

destructor TGameApplication.Destroy;
begin
  FTurret.Free;
  inherited Destroy;
end;

end.

