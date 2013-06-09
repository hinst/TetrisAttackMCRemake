program TetrisAttackMCRemakeProject;

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$REGION ZenGL units}
  zgl_main, GameApplicationUnit
  {$ENDREGION}
  { you can add units after this };

type

var
  Application: TGameApplication;
begin
  Application := TGameApplication.Create;
  Application.Run;
  Application.Free;
end.

