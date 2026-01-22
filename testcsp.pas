PROGRAM testcsp;
USES csp;
VAR
  s : STRING;
  myList : List;
  i, count, total : INTEGER;
BEGIN
  count := 0; total := 0;
  Writeln('CSP Testing Program');
  Writeln('Testing List routines');
  Append(myList, 1);
  Append(myList, 2);
  Append(myList, 3);
  IF Length(myList) = 3 THEN count := count + 1;
  total := total + 1;
  IF (myList[1] = 1) AND (myList[2] = 2) AND (myList[3] = 3) THEN
    count := count + 1;
  total := total + 1;
  Insert(myList, 2, 4);
  IF Length(myList) = 4 THEN count := count + 1;
  total := total + 1;
  IF (myList[2] = 4) AND (myList[4] = 3) THEN
    count := count + 1;
  total := total + 1;
  Remove(myList, 3);
  IF (Length(myList) = 3) AND (myList[3] = 3) THEN
    count := count + 1;
  total := total + 1;
  Insert(myList, 8, 10);
  IF (Length(myList) = 4) AND (myList[4] = 10) THEN
    count := count + 1;
  total := total + 1;
  Remove(myList, 9);
  IF Length(myList) = 4 THEN count := count + 1;
  total := total + 1;
  Writeln('Score = ', count, '/', total);
  Writeln('Testing string routines');
  IF Len('Murry') = 5 THEN count := count + 1;
  total := total + 1;
  IF Concat('Mr', 'Murry') = 'MrMurry' THEN count := count + 1;
  total := total + 1;
  IF Reverse('Murry') = 'yrruM' THEN count := count + 1;
  total := total + 1;
  IF Prefix('Murry', 3) = 'Mur' THEN count := count + 1;
  total := total + 1;
  IF Prefix('hello', 10) = 'hello' THEN count := count + 1;
  total := total + 1;
  IF Substring('hello', 2, 3) = 'ell' THEN count := count + 1;
  total := total + 1;
  IF substring('hello', 3, 10) = 'llo' THEN count := count + 1;
  total := total + 1;
  IF substring('hello', 7, 3) = '' THEN count := count + 1;
  total := total + 1;
  Writeln('Score = ', count, '/', total);
  Readln;
END.
