unit uGradeSchool;

interface

  uses
    Generics.Collections;

  type
    TRoster = TList<string>;

    ISchool = interface(IInterface)
      ['{623FFDE3-F742-4236-8733-132ADC2A0D89}']
      procedure Add(AName : string; AGrade : integer = 1);
      function Grade(AGrade : integer = 1) : TRoster;
      function Roster : TRoster;
    end;

    TSchool = class(TInterfacedObject, ISchool)
      constructor Create; overload;
      destructor Destroy; override;
      procedure Add(AName : string; AGrade : integer = 1);
      function Grade(AGrade : integer = 1) : TRoster;
      function Roster : TRoster;
    private
      FStudentList : TDictionary<integer, TRoster>;
    end;

    function NewSchool : ISchool;

implementation

  uses
    SysUtils;

  constructor TSchool.Create;
    begin
      inherited;
      FStudentList := TDictionary<integer, TRoster>.Create;
    end;

  destructor TSchool.Destroy;
    begin
      if Assigned(FStudentList) then
        begin
          for var ListKey in FStudentList.Keys do
            // This loop leaves anyway the last element of Student_names_with_grades_are_displayed_in_the_same_sorted_roster test in memory
            begin
              if Assigned(FStudentList.Items[ListKey]) then
                  FStudentList.Items[ListKey].Free;
              FStudentList.Remove(ListKey);
            end;
          FStudentList.Clear;
        end;
      FStudentList.Free;
      inherited;
    end;

  procedure TSchool.Add(AName : string; AGrade : integer = 1);
    begin
      if FStudentList.ContainsKey(AGrade) then
        begin
          FStudentList.Items[AGrade].Add(AName);
          FStudentList.Items[AGrade].Sort;
        end
      else
        begin
          FStudentList.Add(AGrade, TRoster.Create);
          FStudentList.Items[AGrade].Add(AName);
        end;
    end;

  function TSchool.Grade(AGrade : integer = 1) : TRoster;
    begin
      Result := TRoster.Create;
      if FStudentList.ContainsKey(AGrade) then
        for var i:= 0 to (FStudentList.Items[AGrade].Count - 1) do
          begin
            Result.Add(FStudentList.Items[AGrade][i]);
          end;
   end;

  function TSchool.Roster : TRoster;
    var
      StudentListKeys : TArray<integer>;
    begin
      Result := TRoster.Create;
      if 0 < FStudentList.Count then
        begin
          SetLength(StudentListKeys, FStudentList.Count);
          StudentListKeys := FStudentList.Keys.ToArray;
          TArray.Sort<integer>(StudentListKeys);
          for var i := 0 to (Length(StudentListKeys) - 1) do
            Result.AddRange(FStudentList.Items[StudentListKeys[i]]);
          SetLength(StudentListKeys,0);
        end;
    end;

  function NewSchool : ISchool;
    begin
      Result := TSchool.Create;
    end;

end.
