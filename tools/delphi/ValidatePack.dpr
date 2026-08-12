program ValidatePack;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  DextPackValidator in 'DextPackValidator.pas';

procedure PrintUsage;
begin
  Writeln('DEXT AI Coding Pack - Native Delphi Validator');
  Writeln('Usage: ValidatePack.exe [repository-root]');
end;

var
  LRoot: string;
  LValidator: TDextPackValidator;
  LResult: TDextPackValidationResult;
  LError: string;
begin
  try
    if ParamCount > 1 then
    begin
      PrintUsage;
      ExitCode := 2;
      Exit;
    end;

    if ParamCount = 1 then
      LRoot := TPath.GetFullPath(ParamStr(1))
    else
      LRoot := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..'));

    Writeln('Validating: ', LRoot);

    LValidator := TDextPackValidator.Create(LRoot);
    try
      LResult := LValidator.Validate;
    finally
      LValidator.Free;
    end;

    if LResult.IsValid then
    begin
      Writeln('PASS: DEXT AI Coding Pack validation succeeded.');
      ExitCode := 0;
    end
    else
    begin
      Writeln('FAIL: ', Length(LResult.Errors), ' issue(s) found.');
      for LError in LResult.Errors do
        Writeln('  - ', LError);
      ExitCode := 1;
    end;
  except
    on E: Exception do
    begin
      Writeln('ERROR: ', E.ClassName, ': ', E.Message);
      ExitCode := 3;
    end;
  end;
end.
