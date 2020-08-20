unit CricketScorer_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnDot: TButton;
    btnOne: TButton;
    btnSix: TButton;
    btnTwo: TButton;
    btnFour: TButton;
    btnOut: TButton;
    btnWide: TButton;
    btnUndo: TButton;
    pnlSplashScreen: TPanel;
    RichEdit1: TRichEdit;
    lblHeading1: TLabel;
    lblHeading2: TLabel;
    lblCurrentPlayer: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblRunRate: TLabel;
    lblFours: TLabel;
    lblSixes: TLabel;
    Label4: TLabel;
    lblScore: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label5: TLabel;
    lblBallsInOver: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnDotClick(Sender: TObject);
    procedure btnOneClick(Sender: TObject);
    procedure btnTwoClick(Sender: TObject);
    procedure btnFourClick(Sender: TObject);
    procedure btnSixClick(Sender: TObject);
    procedure btnOutClick(Sender: TObject);
    procedure btnWideClick(Sender: TObject);
    procedure SplashScreen(sMessage: string; FontStyle: TFontStyle);
    procedure IncRunsAndBalls(iIncreaseAmount, iBallIncrease: integer);
    procedure CalculateStats();
    procedure EndOfGame();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  iNumOfPlayers, iNumOfOvers, iBallsInOver, iCurrentPlayer: integer;
  aPRuns, aPBalls, aPFours, aPSixes: array [1 .. 10] of integer;
  aPRunRate: array [1 .. 10] of real;
  aPName: array [1 .. 10] of string;

implementation

{$R *.dfm}

procedure TForm1.IncRunsAndBalls(iIncreaseAmount, iBallIncrease: integer);
begin
  inc(iBallsInOver, iBallIncrease);
  if iBallsInOver = 7 then
    iBallsInOver := 0;

  inc(aPRuns[iCurrentPlayer], iIncreaseAmount);
  inc(aPBalls[iCurrentPlayer], iBallIncrease);
end;

procedure TForm1.CalculateStats();
begin
  if aPBalls[iCurrentPlayer] > 0 then
    aPRunRate[iCurrentPlayer] :=
      (aPRuns[iCurrentPlayer] / aPBalls[iCurrentPlayer]);
  lblRunRate.Caption := FloatToStrF(aPRunRate[iCurrentPlayer], ffFixed, 10, 3);
  lblScore.Caption := IntToStr(aPRuns[iCurrentPlayer]);
  lblBallsInOver.Caption := IntToStr(6 - iBallsInOver);
end;

procedure TForm1.SplashScreen(sMessage: string; FontStyle: TFontStyle);
begin
  pnlSplashScreen.Caption := sMessage;
  pnlSplashScreen.Font.Style := [FontStyle];
  pnlSplashScreen.Visible := true;
  pnlSplashScreen.BringToFront;
  Form1.Refresh;
  Sleep(2000);
  pnlSplashScreen.Visible := false;
end;

procedure TForm1.EndOfGame();
begin
  pnlSplashScreen.Caption := 'End of Game';
  pnlSplashScreen.Font.Style := [fsItalic];
  pnlSplashScreen.Visible := true;
  pnlSplashScreen.BringToFront;
  Form1.Refresh;
  Sleep(1500);
  pnlSplashScreen.Visible := false;
end;

procedure TForm1.btnDotClick(Sender: TObject);
begin
  SplashScreen('Dot', Unassigned);
  IncRunsAndBalls(0, 1);
  CalculateStats();
end;

procedure TForm1.btnFourClick(Sender: TObject);
begin
  SplashScreen('Four', Unassigned);
  IncRunsAndBalls(4, 1);
  CalculateStats();

  inc(aPFours[iCurrentPlayer]);
  lblFours.Caption := IntToStr(aPFours[iCurrentPlayer]);
end;

procedure TForm1.btnOneClick(Sender: TObject);
begin
  SplashScreen('One', Unassigned);
  IncRunsAndBalls(1, 1);
  CalculateStats();
end;

procedure TForm1.btnSixClick(Sender: TObject);
begin
  SplashScreen('Six', Unassigned);
  IncRunsAndBalls(6, 1);
  CalculateStats();

  inc(aPSixes[iCurrentPlayer]);
  lblSixes.Caption := IntToStr(aPSixes[iCurrentPlayer]);
end;

procedure TForm1.btnTwoClick(Sender: TObject);
begin
  SplashScreen('Two', Unassigned);
  IncRunsAndBalls(2, 1);
  CalculateStats();
end;

procedure TForm1.btnWideClick(Sender: TObject);
begin
  SplashScreen('W i d e', Unassigned);
  IncRunsAndBalls(1, 0);
  CalculateStats();
end;

procedure TForm1.btnOutClick(Sender: TObject);
begin
  SplashScreen('Howzaat!', fsItalic);
  IncRunsAndBalls(0, 1);
  CalculateStats;

  if iCurrentPlayer < iNumOfPlayers then
    begin
      inc(iCurrentPlayer);
      lblCurrentPlayer.Caption := aPName[iCurrentPlayer];
    end
  else
    EndOfGame;

  lblRunRate.Caption := '0.000';
  lblFours.Caption := IntToStr(aPFours[iCurrentPlayer]);
  lblSixes.Caption := IntToStr(aPSixes[iCurrentPlayer]);
  lblScore.Caption := IntToStr(aPRuns[iCurrentPlayer]);

  RichEdit1.Lines.Add(aPName[iCurrentPlayer - 1] + #9 + IntToStr
      (aPRuns[iCurrentPlayer - 1]) + #9 + #9 + IntToStr
      (aPBalls[iCurrentPlayer - 1]) + #9 + #9 + #9 + FloatToStrF
      (aPRunRate[iCurrentPlayer - 1], ffFixed, 10, 3));
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  I: integer;
  Order: string;
begin
  iCurrentPlayer := 1;
  iBallsInOver := 0;
  iNumOfOvers := 0;

  iNumOfPlayers := StrToInt(InputBox('Number of players',
      'How many players are going to play?', ''));

  if iNumOfPlayers < 1 then
    begin
      ShowMessage('Please enter a number greater than one');
      iNumOfPlayers := StrToInt(InputBox('Number of players',
          'How many players are going to play?', ''));
    end;

  if iNumOfPlayers > 10 then
    begin
      ShowMessage('You can only enter less than ten players');
      iNumOfPlayers := StrToInt(InputBox('Number of players',
          'How many players are going to play?', ''))
    end; ;

  for I := 1 to iNumOfPlayers do
    begin
      case I of
        1:
          Order := 'st';
        2:
          Order := 'nd';
        3:
          Order := 'rd';
        4 .. 10:
          Order := 'th';
      end;

      aPName[I] := InputBox(IntToStr(I) + Order + ' player''s name',
        'What is the name of the ' + IntToStr(I) + Order + ' batsman?', '');
    end;
  RichEdit1.Lines.Add
    ('Name' + #9 + #9 + 'Score' + #9 + #9 + 'Balls faced' + #9 + #9 +
      'Run rate');

  lblCurrentPlayer.Caption := aPName[iCurrentPlayer];
end;

end.
