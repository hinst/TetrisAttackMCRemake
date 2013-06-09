unit GameThingUnit;

interface

type

  { TGameThing }

  TGameThing = class
  public
    procedure Draw; virtual;
    procedure Update(const aTime: Double); virtual;
  end;

implementation

{ TGameThing }

procedure TGameThing.Draw;
begin

end;

procedure TGameThing.Update(const aTime: Double);
begin

end;

end.

