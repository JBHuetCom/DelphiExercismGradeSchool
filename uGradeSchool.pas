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
      FRoster : TRoster;
      FStudentList : TDictionary<integer, TRoster>;
    end;

    function NewSchool : TSchool;

implementation

  uses
    SysUtils;

  constructor TSchool.Create;
    begin
      inherited;
      self.FRoster := TRoster.Create;
      self.FStudentList := TDictionary<integer, TRoster>.Create;
    end;

  destructor TSchool.Destroy;
    begin
      FStudentList.Free;
      // FRoster.Free;    // Is commented because test already released it. Either refactor test or refactor logic here
      inherited;
    end;

  procedure TSchool.Add(AName : string; AGrade : integer = 1);
    begin
      if self.FStudentList.ContainsKey(AGrade) then
        begin
          self.FStudentList.Items[AGrade].Add(AName);
          self.FStudentList.Items[AGrade].Sort;
        end
      else
        begin
          self.FStudentList.Add(AGrade, TRoster.Create);
          self.FStudentList.Items[AGrade].Add(AName);
        end;
    end;

  function TSchool.Grade(AGrade : integer = 1) : TRoster;
    begin
      Result := TRoster.Create;
      if self.FStudentList.ContainsKey(AGrade) then
        Result := self.FStudentList.Items[AGrade];
   end;

  function TSchool.Roster : TRoster;
    var
     i : integer;
     VKeyList : TArray<integer>;
    begin
      self.FRoster.Clear;
      if 0 < self.FStudentList.Count then
        begin
          SetLength(VKeyList, self.FStudentList.Count);
          VKeyList := self.FStudentList.Keys.ToArray;
          TArray.Sort<integer>(VKeyList);
          for i := 0 to (Length(VKeyList) - 1) do
            self.FRoster.AddRange(self.FStudentList.Items[VKeyList[i]]);
          SetLength(VKeyList,0);
        end;
      Result := self.FRoster;
    end;

  function NewSchool : TSchool;
    begin
      Result := TSchool.Create;
    end;

end.
