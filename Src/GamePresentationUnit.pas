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
    FDrawHelpEnabled: Boolean;
    procedure DrawVisualFieldSeparator; inline;
    procedure DrawRightBlock; inline;
    procedure RT(const aY: Single; const s: string);
    procedure CT(const aY: Single; const s: string);
    procedure DrawHelpText;
  public
    property DrawHelpEnabled: Boolean read FDrawHelpEnabled write FDrawHelpEnabled;
    constructor Create(const aState: TGameState);
    procedure Startup;
    procedure Draw;
    procedure DrawHelp;
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

procedure TPresentation.CT(const aY: Single; const s: string);
begin
  text_Draw(FFont, 400, aY, s, TEXT_HALIGN_CENTER or TEXT_VALIGN_CENTER);
end;

procedure TPresentation.DrawHelpText;
begin
  CT(25, 'Х:О  Левая кнопка мыши: выстрелить');
  CT(50, 'Д:О  Зажать левую кнопку: стрелять с максимально возможной скоростью');
  CT(80, 'О:Д  Зажать правую кнопку: зафиксировать ближайший снаряд');
  CT(105, 'О:Х  Отпустить правую кнопку: взорвать зафиксированный снаряд');
  CT(135, 'Ф1  Справка');
  CT(150, 'ПРОБЕЛ  Пауза');
  CT(550, '(Игра приостанавливается на время показа экрана справки)');
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
  RT(105, 'Счёт: ' + IntToStr(FState.Score));
  RT(550, 'СПРАВКА: Ф1');
  if
    DrawHelpEnabled
  then
    DrawHelp; // *OKAY FACE*
end;

procedure TPresentation.DrawHelp;
begin
  pr2d_Rect(0, 0, 800, 600, $000000, 220, PR2D_FILL);
  DrawHelpText;
end;

destructor TPresentation.Destroy;
begin
  inherited Destroy;
end;

end.

