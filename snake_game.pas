program SnakeGame;

uses crt, my_crt, snake_module;

const
	DelayDuration = 100;
	GameOverMsg = 'GameOver';

procedure GameInit(var sn: SnakePartPtr; var apl: apple);
var
	i, j: integer;
begin
	SnakeInit(sn);
	AppleCreate(sn, apl);
	for i := 1 to ScreenHeight do begin
		if (i = 1) or (i = ScreenHeight ) then begin
			GoToXY(2, i);
			for j := 2 to ScreenWidth - 1 do
				write('-');
		end else begin
			if i = 2 then
				GoToXY(1, i);
			write('|');
			GoToXY(ScreenWidth, i);
			write('|')
		end
	end;
	GoToXY(1, 1)
end;

function IsGameOver(var sn: SnakePartPtr) : boolean;
begin
	IsGameOver := IsSnakeEatsHimself(sn);
end;

procedure GameOver;
begin
	clrscr;
	WriteXY(ScreenWidth div 2 - length(GameOverMsg) div 2,
		ScreenHeight div 2, GameOverMsg);
	delay(1000);
end;

var
	SnakePtr: SnakePartPtr;
	CurrentDirection, PastDirection: direction;
	apl: apple;
	ch: integer;
begin
	clrscr;
	randomize;
	GameInit(SnakePtr, apl);
	CurrentDirection := stop;
	PastDirection := stop;
	while not IsGameOver(SnakePtr) do begin
		if not KeyPressed then begin
			if CurrentDirection <> stop then
				SnakeMove(SnakePtr, apl, CurrentDirection, PastDirection);
			delay(DelayDuration);
			continue
		end;
		GetKey(ch);
		PastDirection := CurrentDirection;
		case ch of 
			104: CurrentDirection := left;
			106: CurrentDirection := up;
			107: CurrentDirection := down;
			108: CurrentDirection := right;
			27: break
		end
	end;
	if IsGameOver(SnakePtr) then
		GameOver;
	clrscr
end.
