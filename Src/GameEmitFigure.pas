unit GameEmitFigure;

interface

uses
  GameThingUnit,
  GameFigureUnit,
  GameConstUnit,
  GameLogUnit;

type

  { TGameEmitFigure }

  TGameEmitFigure = class
  protected
    FThings: TGameThingList;
    FTimeSinceLast: Double;
    FEmitTime: Double;
    FFallSpeed: Single;
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
    constructor Create(const aThingList: TGameThingList);
    procedure Update(const aTime: Double);
    destructor Destroy; override;
  end;

implementation

{ TGameEmitFigure }

procedure TGameEmitFigure.Emit;
var
  x: Integer;
begin
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
  f := TFigure.Create(aX * DefaultFigureWidth, aY * DefaultFigureWidth, FFallSpeed);
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

constructor TGameEmitFigure.Create(const aThingList: TGameThingList);
begin
  inherited Create;
  FThings := aThingList;
  FTimeSinceLast := 0;
  FEmitTime := DefaultInitialEmitTime;
  FFallSpeed := DefaultInitialFallSpeed;
end;

procedure TGameEmitFigure.Update(const aTime: Double);
begin
  FTimeSinceLast += aTime;
  if
    FTimeSinceLast >= FEmitTime
  then
  begin
    Emit;
    FTimeSinceLast := 0;
  end;
end;

destructor TGameEmitFigure.Destroy;
begin
  inherited Destroy;
end;

end.

