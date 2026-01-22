PROGRAM ex4;
TYPE
  StudentRecord = RECORD
                    name : STRING;
                    age : INTEGER;
                    gpa : REAL;
                  END;
VAR
  student : StudentRecord;
BEGIN
  student.name := 'Murry';
  student.age := 39;
  student.gpa := 3.3;
  Writeln('Student name : ', student.name);

  Readln;
END.