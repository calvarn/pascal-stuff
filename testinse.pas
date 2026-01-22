PROGRAM testlist;
USES csp;
VAR
  myList : List;
BEGIN
  randomize;
  Append(myList, 8);
  Append(myList, 10);
  Append(myList, 12);
  Append(myList, 7);
  Insert(myList, 10, 100);
  remove(mylist, 3);
  Printlist(myList);
  writeln(sumlist(myList));
  writeln(avglist(myList));

  WriteLn('Len("Murry") = ', Len('Murry'));  { Output: 5 }
  WriteLn(Concat('hello', 'world'));   { Output: helloworld }
  WriteLn(Concat('e', 'o'));           { Output: eo }
  WriteLn(reverse(Concat('hello', 'world')));
  WriteLn(firstchars(reverse(Concat('hello', 'world'))), 3);
END.
