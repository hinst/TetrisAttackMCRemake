unit GameStateUnit;

interface

uses
  GameConstUnit;

type

  { TGameState }

  TGameState = class
  public
    LivesLeft: Integer;
    ReloadTimeLeft: Double;
    Lost: Boolean;
    constructor Create;
    procedure Update(const aTime: Double);
  end;

implementation

{ TGameState }

constructor TGameState.Create;
begin
  LivesLeft := DefaultInitialLives;
end;

procedure TGameState.Update(const aTime: Double);
begin
  if
    ReloadTimeLeft > 0
  then
    ReloadTimeLeft -= aTime;
end;

end.

