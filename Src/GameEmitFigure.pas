unit GameEmitFigure;

interface

uses
  GameThingUnit,
  GameFigureUnit,
  GameConstUnit,
  GameStateUnit,
  GameLogUnit;

type

  { TGameEmitFigure }

  TGameEmitFigure = class
  protected
    FThings: TGameThingList;
    FFallSpeed: Single;
    FState: TGameState;
    FCurrentSpeedModifier: Single;
    procedure Emit;
    procedure Emit(const aX, aY: Integer);
    procedure EmitSquare(const aX: Integer);
    procedure EmitThingie(const aX: Integer);
    procedure EmitSitck(const aX: Integer);
    procedure EmitTriangle(const aX: Integer);
    procedure EmitRThingie(const aX: Integer);
    procedure EmitRThingie2(const aX: Integer);
    procedure EmitRThingie3(const aX: Integer);
    procedure EmitRThingie4(const aX: Integer);
  public
    constructor Create(const aThingList: TGameThingList; const aState: TGameState);
    procedure Update(const aTime: Double);
    procedure EmitHouses;
    destructor Destroy; override;
  end;

implementation

{ TGameEmitFigure }

procedure TGameEmitFigure.Emit;
var
  x: Integer;
begin
  FCurrentSpeedModifier := 1 + 0.5 * (5-random(10)) / 5;
  WriteLogMessage('Now emitting figure...');
  x := random(59);
  case random(6) of
    0
  :
    EmitSquare(x)
  ;
    1
  :
    EmitThingie(x)
  ;
    2
  :
    EmitSitck(x)
  ;
    3
  :
    EmitTriangle(x)
  ;
    4
  :
    EmitRThingie(x)
  ;
    5
  :
    EmitRThingie2(x)
  ;
  end;
end;

procedure TGameEmitFigure.Emit(const aX, aY: Integer);
var
  f: TGameThing;
begin
  f :=
    TFigure.Create(
      aX * DefaultFigureWidth,
      aY * DefaultFigureWidth,
      FFallSpeed * FCurrentSpeedModifier);
  FThings.Add(f);
end;

procedure TGameEmitFigure.EmitSquare(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX, 1);
  Emit(aX + 1, 0);
  Emit(aX + 1, 1);
end;

procedure TGameEmitFigure.EmitThingie(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX, 1);
  Emit(aX + 1, 1);
  Emit(aX + 1, 2);
end;

procedure TGameEmitFigure.EmitSitck(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX, 1);
  Emit(aX, 2);
  Emit(aX, 3);
end;

procedure TGameEmitFigure.EmitTriangle(const aX: Integer);
begin
  Emit(aX + 1, 0);
  Emit(aX, 1);
  Emit(aX + 1, 1);
  Emit(aX + 2, 1);
end;

procedure TGameEmitFigure.EmitRThingie(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX + 1, 0);
  Emit(aX, 1);
  Emit(aX, 2);
end;

procedure TGameEmitFigure.EmitRThingie2(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX + 1, 0);
  Emit(aX + 1, 1);
  Emit(aX + 1, 2);
end;

procedure TGameEmitFigure.EmitRThingie3(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX, 1);
  Emit(aX, 2);
  Emit(aX + 1, 2);
end;

procedure TGameEmitFigure.EmitRThingie4(const aX: Integer);
begin
  Emit(aX, 0);
  Emit(aX, 1);
  Emit(aX, 2);
  Emit(aX + 1, 2);
end;

constructor TGameEmitFigure.Create(const aThingList: TGameThingList; const aState: TGameState);
begin
  inherited Create;
  FThings := aThingList;
  FState := aState;
  FFallSpeed := DefaultInitialFallSpeed;
end;

procedure TGameEmitFigure.Update(const aTime: Double);
begin
  FState.TimeSinceLast += aTime;
  if
    FState.TimeSinceLast >= FState.EmitTime
  then
  begin
    Emit;
    FState.TimeSinceLast := 0;
  end;
end;

procedure TGameEmitFigure.EmitHouses;
  procedure EmitHouse(const aX: Integer);
  begin
    Emit(aX, 59);
    Emit(aX + 1, 59);
    Emit(aX, 58);
    Emit(aX + 1, 58);
    Emit(aX, 57);
    Emit(aX + 1, 57);
  end;

var
  i: Integer;
begin
  for i := 1 to 59 do
  begin
    if (i mod 5 = 0) and (i <> 30) and (i <> 25) and (i <> 35) then
      EmitHouse(i - 1);
  end;
end;

destructor TGameEmitFigure.Destroy;
begin
  inherited Destroy;
end;

end.

