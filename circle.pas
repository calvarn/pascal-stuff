Program Graphics;
uses Graph, Crt;
var
  Gd, Gm: Integer;
  c: Char;
  x, y: Integer;
begin
  Gd := Detect;
  InitGraph(Gd, Gm, 'C:\DOS\TP7\BGI');
  SetColor(Red);
  x := 0;
  y := 0;
  Repeat
    if KeyPressed then
    begin
      c := ReadKey;
      ClearDevice;
      if c = 'w' then y := y - 5;
      if c = 's' then y := y + 5;
      if c = 'a' then x := x - 5;
      if c = 'd' then x := x + 5;
      Circle(x + 150, y + 150, 50);
    end;
  Until c = 'q';
  CloseGraph;
end.
