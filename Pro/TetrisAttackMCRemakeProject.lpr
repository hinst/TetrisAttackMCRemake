program TetrisAttackMCRemakeProject;

// requires ZenGL 3.11

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  GameApplicationUnit, GameLogUnit, GameConstUnit, GameTurretUnit,
  GameThingUnit, GameBullletUnit, GameExplosionAnimation, GameEmitFigure,
GameFigureUnit;

var
  Application: TGameApplication;
begin
  WriteLogMessage('Entered main routine...');
  Randomize;
  Application := TGameApplication.Create;
  Application.Run;
  Application.Free;
  WriteLogMessage('Exiting main routine...');
end.

// MEWO

