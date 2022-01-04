unit my_crt;

interface

procedure WriteXY(x, y: integer; str: string);
procedure GetKey(var code: integer);

implementation

uses crt;

procedure WriteXY(x, y: integer; str: string);
begin
	GoToXY(x, y);
	write(str);
	GoToXY(1, 1);
end;

procedure GetKey(var code: integer);
var
	c: char;
begin
	c := ReadKey;
	if c = #0 then
	begin
		c:= ReadKey;
		code := -ord(c)
	end
	else
		code := ord(c);
end;

end.
