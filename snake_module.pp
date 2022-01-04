unit snake_module;

interface

type
	direction = (left, down, up, right, stop);
	SnakePartPtr = ^SnakePart;
	SnakePart = record
		CurX, CurY: integer;
		next: SnakePartPtr;
	end;
	apple = record
		CurX, CurY: integer;
	end;

function SnakeLength(var sn: SnakePartPtr) : integer;
function IsSnakeEatsHimself(var sn: SnakePartPtr) : boolean;
procedure AppleCreate(var sn: SnakePartPtr; var ap: apple);
procedure SnakeInit(var sn: SnakePartPtr);
procedure SnakeMove(var sn: SnakePartPtr; var apl: apple; 
	var CurDir, PastDir: direction);

implementation

uses crt, my_crt;

type
	SnakePartPos = ^SnakePartPtr;

procedure SnakeInit(var sn: SnakePartPtr);
begin
	new(sn);
	sn^.CurX := ScreenWidth div 2;
	sn^.CurY := ScreenHeight div 2;
	sn^.next := nil; 
	WriteXY(sn^.CurX, sn^.CurY, '*')
end;

procedure SnakeTailGet(var sn, part: SnakePartPtr);
var
	pos: SnakePartPos;
begin
	pos := @sn;
	while pos^^.next <> nil do
		pos := @(pos^^.next);
	part := pos^;
	pos^ := nil;
end;

procedure SnakeHeadPut(var sn, part: SnakePartPtr);
begin
	part^.next := sn;
	sn := part;
end;
procedure SnakeAddPart(var sn: SnakePartPtr);
var
	tmp: SnakePartPtr;
begin
	new(tmp);
	tmp^.CurX := sn^.CurX;
	tmp^.CurY := sn^.CurY;
	tmp^.next := sn;
	sn := tmp;
	WriteXY(sn^.CurX, sn^.CurY, 'O')
end;

function SnakeLength(var sn: SnakePartPtr) : integer;
var
	tmp: SnakePartPtr;
begin
	SnakeLength := 0;
	tmp := sn;
	while tmp <> nil do begin
		SnakeLength := SnakeLength + 1;
		tmp := tmp^.next
	end;
end;

function IsSnakeEatsHimself(var sn: SnakePartPtr) : boolean;
var 
	tmp: SnakePartPtr;
	k: integer;
begin
	tmp := sn^.next;
	k := 2;
	while tmp <> nil do begin
		if (sn^.CurX = tmp^.CurX) and (sn^.CurY = tmp^.CurY) and
			(k > 4) then begin
			IsSnakeEatsHimself := true;
			exit
		end;
		k := k + 1;
		tmp := tmp^.next
	end;
	IsSnakeEatsHimself := false
end;

procedure SnakePartMove(var sn, part: SnakePartPtr; dir: direction);
begin
	WriteXY(part^.CurX, part^.CurY, ' ');
	if sn <> nil then begin
		part^.CurX := sn^.CurX;
		part^.CurY := sn^.CurY;
	end;
	case dir of 
		left: part^.CurX := part^.CurX - 1;
		down: part^.CurY := part^.CurY - 1;
		up: part^.CurY := part^.CurY + 1;
		right: part^.CurX := part^.CurX + 1;
	end;
	if part^.CurX = ScreenWidth then
		part^.CurX := 2
	else if part^.CurX = 1 then
		part^.CurX := ScreenWidth - 1;
	if part^.CurY = ScreenHeight then
		part^.CurY := 2
	else if part^.CurY = 1 then
		part^.CurY := ScreenHeight - 1;
	WriteXY(part^.CurX, part^.CurY, '*');
end;

function IsDirectionsOpposite(a, b: direction) : boolean;
begin
	IsDirectionsOpposite :=
		((a = left) and (b = right)) or
		((a = down) and (b = up)) or
		((a = up) and (b = down)) or
		((a = right) and (b = left)); 
end;

function IsSnakeEatsApple(var sn: SnakePartPtr; var apl: apple) : boolean;
var
	tmp: SnakePartPtr;
begin
	tmp := sn;
	while tmp <> nil do begin
		if (tmp^.CurX = apl.CurX) and (tmp^.CurY = apl.CurY) then begin
			IsSnakeEatsApple := true;
			exit
		end;
		tmp := tmp^.next
	end;
	IsSnakeEatsApple := false
end;

procedure AppleCreate(var sn: SnakePartPtr; var ap: apple);
begin
	repeat
		ap.CurX := random(ScreenWidth - 2) + 2;
		ap.CurY := random(ScreenHeight - 2) + 2
	until not IsSnakeEatsApple(sn, ap);
	WriteXY(ap.CurX, ap.CurY, 'A');
end;

procedure SnakeMove(var sn: SnakePartPtr; var apl: apple;
	var CurDir, PastDir: direction);
var
	tmp: SnakePartPtr;
begin
	SnakeTailGet(sn, tmp);
	if (sn <> nil) and IsDirectionsOpposite(CurDir, PastDir) then
		CurDir := PastDir;
	SnakePartMove(sn, tmp, CurDir);
	SnakeHeadPut(sn, tmp);
	if IsSnakeEatsApple(sn, apl) then begin
		SnakeAddPart(sn);
		AppleCreate(sn, apl)
	end
end;

end.
