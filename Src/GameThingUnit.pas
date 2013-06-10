unit GameThingUnit;

interface

uses
  fgl;

type

  { TGameThing }

  TGameThing = class
  protected
    FDead: Boolean;
  public
    procedure Draw; virtual;
    procedure Update(const aTime: Double); virtual;
    property Dead: Boolean read FDead;
  end;

  TGameThingList = specialize TFPGList<TGameThing>;

implementation

{ TGameThing }

procedure TGameThing.Draw;
begin

end;

procedure TGameThing.Update(const aTime: Double);
begin

end;

end.

