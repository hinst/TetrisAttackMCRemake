unit GameStateUnit;

interface

uses
  GameConstUnit;

type

  { TGameState }

  TGameState = class
  protected
    FLivesLeft: Integer;
    procedure SetLivesLeft(const aValue: Integer);
  public
    ReloadTimeLeft: Double;
    Lost: Boolean;
    Score: Integer;
    TimeSinceLast: Double;
    EmitTime: Double;
    property LivesLeft: Integer read FLivesLeft write SetLivesLeft;
    constructor Create;
    procedure Update(const aTime: Double);
  end;

implementation

{ TGameState }

procedure TGameState.SetLivesLeft(const aValue: Integer);
begin
  if
    aValue > 0
  then
    FLivesLeft := aValue
  else
    FLivesLeft := 0;
end;

constructor TGameState.Create;
begin
  LivesLeft := DefaultInitialLives;
  ReloadTimeLeft := 0;
  Lost := False;
  Score := 0;
  TimeSinceLast := 0;
  EmitTime := DefaultInitialEmitTime
end;

procedure TGameState.Update(const aTime: Double);
begin
  if
    ReloadTimeLeft > 0
  then
    ReloadTimeLeft -= aTime;
end;

end.

