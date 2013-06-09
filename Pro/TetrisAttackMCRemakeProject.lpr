program TetrisAttackMCRemakeProject;

// requires ZenGL 3.11

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  GameApplicationUnit, GameLogUnit, GameConstUnit, GameTurretUnit, GameThingUnit
{ you can add units after this };

var
  Application: TGameApplication;
begin
  WriteLogMessage('Entered main routine...');
  Application := TGameApplication.Create;
  Application.Run;
  Application.Free;
  WriteLogMessage('Exiting main routine...');
end.

