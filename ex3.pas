PROGRAM ex3;
VAR
  name : ARRAY[1..2] OF STRING;
  age : ARRAY[1..2] OF INTEGER;
  gpa : ARRAY[1..2] OF REAL;
  i : INTEGER;
BEGIN
  FOR i := 1 TO 2 DO
  BEGIN
    Write('Enter name of student: ');
    Readln(name[i]);
    Write('Enter age of student: ');
    Readln(age[i]);
    Write('Enter gpa of student: ');
    Readln(gpa[i]);
  END;

  Readln;
END.