unit GameApplicationUnit;

interface

uses
  zgl_main;

type

  { TGameApplication }

  TGameApplication = class
  public
    constructor Create;
    procedure Run;
    destructor Destroy; override;
  end;

implementation

{ TGameApplication }

constructor TGameApplication.Create;
begin
  inherited Create;
end;

procedure TGameApplication.Run;
begin

end;

destructor TGameApplication.Destroy;
begin
  inherited Destroy;
end;

end.

