unit GameLogUnit;

interface

procedure WriteLogMessage(const s: string);

implementation

procedure WriteLogMessage(const s: string);
begin
  WriteLN(s);
end;

end.

