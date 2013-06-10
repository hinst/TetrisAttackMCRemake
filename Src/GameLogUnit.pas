unit GameLogUnit;

interface

uses
  SysUtils;

procedure WriteLogMessage(const s: string);

implementation

procedure WriteLogMessage(const s: string);
begin
  WriteLN(s);
end;

end.

