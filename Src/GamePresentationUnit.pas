unit GamePresentationUnit;

interface

uses
  SysUtils,
  zgl_main,
  zgl_primitives_2d,
  zgl_font,
  zgl_text,
  zgl_textures,
  zgl_textures_png,

  GameConstUnit,
  GameLogUnit,
  GameStateUnit;

type

  { TPresentation }

  TPresentation = class
  protected
    FFont: zglPFont;
    FState: TGameState;
    procedure DrawVisualFieldSeparator; inline;
    procedure DrawRightBlock; inline;
    procedure RT(const aY: Single; const s: string);
  public
    constructor Create(const aState: TGameState);
    procedure Startup;
    procedure Draw;
    destructor Destroy; override;
  end;

implementation

{ TPresentation }

procedure TPresentation.DrawVisualFieldSeparator;
begin
  pr2d_Line(600, 0, 600, 600, $FFFFFF);
end;

procedure TPresentation.DrawRightBlock;
begin
  pr2d_Rect(600, 0, 800, 600, $000000, 200, PR2D_FILL);
end;

procedure TPresentation.RT(const aY: Single; const s: string);
begin
  text_Draw(FFont, 700, aY, s, TEXT_HALIGN_CENTER or TEXT_VALIGN_CENTER);
end;

constructor TPresentation.Create(const aState: TGameState);
begin
  inherited Create;
  FState := aState;
end;

procedure TPresentation.Startup;
begin
  FFont := font_LoadFromFile(DefaultFontName);
end;

procedure TPresentation.Draw;
begin
  DrawRightBlock;
  DrawVisualFieldSeparator;
  RT(25, 'Кадров в секунду: ' + IntToStr(zgl_Get(RENDER_FPS )));
  RT(50, 'Жизней осталось: ' + IntToStr(FState.LivesLeft));
  RT(75, 'Перезарядка:');
  pr2d_Line(600, 85, 600 + abs(200 * FState.ReloadTimeLeft / DefaultReloadTime), 85, $FF0000);
  RT(500, 'СПРАВКА: Ф1');
end;

destructor TPresentation.Destroy;
begin
  inherited Destroy;
end;

end.

