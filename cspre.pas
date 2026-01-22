program cspreview;
const
    size = 20;
type
    list = array[0..size] of integer;
var
    mylist, mylist2 : list;
    i, j, n : integer;
begin
    randomize;
    for i := 1 to size do
        mylist[i] := random(50);
    mylist[0] := size;
    for i := 1 to size do
        writeln('mylist[',i,']', mylist[i]);
    n := 0;
    for i := 1 to size do
        n := n + mylist[i];
end.
