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
            begin
              FStudentList.Items[ListKey].Free;
              FStudentList.Remove(ListKey);
            end;
          FStudentList.Clear;   // !!! WARNING !!! Clear method do not Free items
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
        Result := FStudentList.Items[AGrade];
   end;

  function TSchool.Roster : TRoster;
    var
      i : integer;
      VKeyList : TArray<integer>;
    begin
      Result := TRoster.Create;
      if 0 < FStudentList.Count then
        begin
          SetLength(VKeyList, FStudentList.Count);
          VKeyList := FStudentList.Keys.ToArray;
          TArray.Sort<integer>(VKeyList);
          for i := 0 to (Length(VKeyList) - 1) do
            Result.AddRange(FStudentList.Items[VKeyList[i]]);
          SetLength(VKeyList,0);
        end;
    end;

  function NewSchool : ISchool;
    begin
      Result := TSchool.Create;
    end;

end.
