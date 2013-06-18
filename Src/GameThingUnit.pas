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
    property Dead: Boolean read FDead write FDead;
    procedure Draw; virtual;
    procedure Update(const aTime: Double); virtual;
    function Touches(const aX, aY, aR: Single): Boolean; virtual;
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

function TGameThing.Touches(const aX, aY, aR: Single): Boolean;
begin
  result := False;
end;

end.

