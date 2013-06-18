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
    procedure DrawFailureText;
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
  CT(130, 'Ф1  Справка');
  CT(155, 'ПРОБЕЛ  Пауза');
  CT(550, '(Игра приостанавливается на время показа экрана справки)');
end;

procedure TPresentation.DrawFailureText;
begin
  text_Draw(FFont, 300, 300, 'П О Т Р А Ч Е Н О', TEXT_HALIGN_CENTER or TEXT_VALIGN_CENTER);
end;

constructor TPresentation.Create(const aState: TGameState);
begin
  inherited Create;
  FState := aState;
end;

procedure TPresentation.Startup;
begin
  FFont := font_LoadFromFile(ExtractFilePath(ParamStr(0)) + DefaultFontName);
end;

procedure TPresentation.Draw;
begin
  DrawRightBlock;
  DrawVisualFieldSeparator;
  RT(25, 'Кадров в секунду: ' + IntToStr(zgl_Get(RENDER_FPS )));
  RT(50, 'Жизней осталось: ' + IntToStr(FState.LivesLeft));
  pr2d_Line(600, 60, 600 + abs(200 * FState.LivesLeft / DefaultInitialLives), 60, $00FF00);
  RT(80, 'Перезарядка:');
  pr2d_Line(600, 90, 600 + abs(200 * FState.ReloadTimeLeft / DefaultReloadTime), 90, $FF0000);
  RT(110, 'Счёт: ' + IntToStr(FState.Score));
  RT(135, 'Следующая бомба:');
  pr2d_Line(600, 145, 600 + abs(200 * FState.TimeSinceLast / FState.EmitTime), 145, $FFFF00);
  RT(550, 'СПРАВКА: Ф1');
  if
    DrawHelpEnabled
  then
    DrawHelp; // *OKAY FACE*
  if
    FState.LivesLeft = 0
  then
    DrawFailureText;
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

