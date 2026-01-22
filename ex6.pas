PROGRAM ex6;
TYPE
  StudentRecord = RECORD
  name : STRING;
  age : INTEGER;
  gpa : REAL;
  END;
VAR
  students : ARRAY[1..2] OF StudentRecord;
  i : INTEGER;

PROCEDURE PrintStudent(student : StudentRecord);
BEGIN
  Writeln('Student name : ', student.name);
  Writeln('Student age : ', student.age);
  Writeln('Student gpa : ', student.gpa:1:2);
END;

BEGIN
  FOR i := 1 TO 2 DO
  BEGIN
    WITH students[i] DO
    BEGIN
      Write('Enter name of student: ');
      Readln(name);
      Write('Enter age of student: ');
      Readln(age);
      Write('Enter gpa of student: ');
      Readln(gpa);
    END;
  END;
  PrintStudent(students[1]);
  PrintStudent(students[2]);
  Readln;
END.