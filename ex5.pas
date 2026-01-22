PROGRAM ex5;
TYPE
  StudentRecord = RECORD
                    name : STRING;
                    age : INTEGER;
                    gpa : REAL;
                  END;
VAR
  student1, student2 : StudentRecord;
BEGIN
  WITH student1 DO
  BEGIN
  Write('Enter name of student: ');
  Readln(name);
  Write('Enter age of student: ');
  Readln(age);
  Write('Enter gpa of student: ');
  Readln(gpa);
  END;

  WITH student2 DO
  BEGIN
  Write('Enter name of student: ');
  Readln(name);
  Write('Enter age of student: ');
  Readln(age);
  Write('Enter gpa of student: ');
  Readln(gpa);
  END;

  Readln;
END.