unit csp;
interface
const
  size = 255;
type
  list = array[0..size] of integer;

function len(s : string) : integer;
function concat(s1, s2: string) : string;
function reverse(s : string) : string;
function prefix(s : string; n : integer) : string;
function substring(s : string; start, n : integer) : string;

function length(alist: list) : integer;
procedure remove(var alist : list; i : integer);
procedure append(var alist : list; value : integer);
procedure printlist(alist : list);
procedure insert(var alist : list; starti, value : integer);
function sumlist(var alist : list) : integer;
function average(var alist : list) : real;
procedure randomlist(var alist : list; size : integer);
function smallest(alist : list) : integer;
procedure swap(var a,b : integer);
procedure selectionsort(var alist: list);
procedure bubblesort(var alist : list);
function median(alist : list) : integer;
function linearsearch(alist : list; value : integer) : boolean;
function binarysearch(alist : list; value : integer) : boolean;
procedure insertionsort(var alist : list);
implementation
procedure insertionsort(var alist : list);
var
  i, j : integer;
begin
  for i := 2 to length(alist) do
  begin
    for j := 1 downto 2 do
    begin
      if alist[j] < alist[j - 1] then
        swap(alist[j], alist[j - 1])
      else
        break;
    end;
  end;
end;

function substring(s : string; start, n : integer) : string;
var
  i : integer;
begin
  for i := 1 to n do
  begin
    substring[i] := s[start + i];
  end;
end;
procedure selectionsort(var alist: list);
var
  i, j, min : integer;
begin
  for i := 1 to length(alist) - 1 do
  begin
    min := i;
    for j := i + 1 to length(alist) do
    begin
      if alist[j] < alist[min] then min := j;
    end;
    swap(alist[i], alist[min]);
  end;
end;

procedure swap(var a,b : integer);
var
  temp : integer;
begin
  temp := a;
  a := b;
  b := temp;
end;
function binarysearch(alist : list; value : integer) : boolean;
var
  i, l, r, mid, count : integer;
  found : boolean;
begin
  found := false;
  l := 1;
  r := length(alist);
  count := 0;
  repeat
    count := count + 1;
    mid := (l + r) div 2;
    if alist[mid] = value then begin
      found := true;
      break;
    end
    else if alist[mid] < value then l := mid + 1
    else r := mid - 1;
  until l > r;
  writeln('searches: ', count);
  binarysearch := found;
end;
function smallest(alist : list) : integer;
var
  i, knownsmallest : integer;
begin
  knownsmallest := 9999;
  for i := 1 to length(alist) do
  begin
    if knownsmallest > alist[i] then
    begin
      knownsmallest := alist[i];
    end;
  end;
  smallest := knownsmallest;
end;

function linearsearch(alist : list; value : integer) : boolean;
var
  i, count : integer;
  found : boolean;
begin
  found := false;
  count := 0;
  for i := 1 to length(alist) do
  begin
    count := count + 1;
    if alist[i] = value then
    begin
      found := true;
      break;
    end;
  end;
  writeln('searchcount: ', count);
  linearsearch := found;
end;

procedure bubblesort(var alist : list);
var
  i, j, temp : integer;
begin
  for i := 1 to length(alist) - 1 do
  begin
    for j := 1 to length(alist) - i do
    begin
      if alist[j] > alist[j + 1] then
      begin
        swap(alist[j], alist[j + 1]);
      end;
    end;
  end;
end;
function length(alist : LIST) : integer;
begin
  length := aList[0];
end;

function median(alist : list) : integer;

begin
  bubblesort(alist);
  median := alist[alist[0] div 2];
end;
procedure randomlist(var alist : list; size : integer);
var
  i : integer;
begin
  randomize;
  alist[0] := 0;
  for i := 1 to size do
  begin
    append(alist, random(100));
  end;
end;
function prefix(s : string; n : integer) : string;
var
  i : integer;
  pref : string;
begin
  pref := '';
  for i := 1 to n do
    pref := concat(pref, s[i]);
  prefix := pref;
end;

function reverse(s : string) : string;
var
  i : integer;
  rev : string;
begin
  rev := ''; {i hate pascal}
  for i := len(s) downto 1 do
    rev := concat(rev, s[i]);
  reverse := rev;
end;
function concat(s1, s2: string): string;
var
  sz, i: integer;
  tmp: string;
begin
  sz := ord(s1[0]) + ord(s2[0]);
  tmp[0] := chr(sz);

  for i := 1 to ord(s1[0]) do
    tmp[i] := s1[i];

  for i := 1 to ord(s2[0]) do
    tmp[ord(s1[0]) + i] := s2[i];

  concat := tmp;
end;


function sumlist(var alist : list) : integer;
var
  tot, i : integer;
begin
  tot := 0;
  for i := 1 to alist[0] do
  begin
    tot := alist[i] + tot;
  end;
  sumlist := tot;
end;
function len(s : string) : integer;
begin
  len := ord(s[0]);
end;

procedure printlist(alist : list);
var
   i : integer;
begin
  for i := 1 to length(alist) do writeln(alist[i]);
end;

procedure append(var alist : list; value : integer);
var
  templen, targlen : integer;
begin
  alist[0] := alist[0] + 1;
  alist[alist[0]] := value;
end;
procedure insert(var alist : list; starti, value : integer);
var
  i : integer;
begin
if starti > alist[0] then alist[0] := starti;
for i := starti + 2 to alist[0] + 1 do
  begin
    alist[i] := alist[i-1];
  end;
  alist[starti + 1] := value;
end;
procedure remove(var alist : list; i : integer);
var
  int : integer;
begin
  for int := i to alist[0] do
    begin
      alist[int] := alist[int + 1];
    end;
  alist[0] := alist[0] - 1;
end;

function average(var alist : list) : real;
var
  i : integer;
begin
  average := sumlist(alist) / alist[0];
end;



end.
