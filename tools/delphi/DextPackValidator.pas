unit DextPackValidator;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Generics.Collections;

type
  TDextPackValidationResult = record
  private
    FErrors: TArray<string>;
  public
    class function Success: TDextPackValidationResult; static;
    procedure AddError(const AMessage: string);
    function IsValid: Boolean;
    property Errors: TArray<string> read FErrors;
  end;

  TDextPackValidator = class
  strict private
    FRootPath: string;
    FErrors: TList<string>;
    procedure RequireFile(const ARelativePath: string);
    procedure RequireText(const ARelativePath, AText: string);
    procedure ValidateCoreFiles;
    procedure ValidateSkills;
    procedure ValidatePrompts;
    procedure ValidateFullArtifacts;
    procedure ValidateReleaseIdentity;
    procedure ValidateBehaviorGuards;
  public
    constructor Create(const ARootPath: string);
    destructor Destroy; override;
    function Validate: TDextPackValidationResult;
  end;

implementation

{ TDextPackValidationResult }

class function TDextPackValidationResult.Success: TDextPackValidationResult;
begin
  Result.FErrors := [];
end;

procedure TDextPackValidationResult.AddError(const AMessage: string);
var
  LLength: Integer;
begin
  LLength := Length(FErrors);
  SetLength(FErrors, LLength + 1);
  FErrors[LLength] := AMessage;
end;

function TDextPackValidationResult.IsValid: Boolean;
begin
  Result := Length(FErrors) = 0;
end;

{ TDextPackValidator }

constructor TDextPackValidator.Create(const ARootPath: string);
begin
  inherited Create;
  FRootPath := TPath.GetFullPath(ARootPath);
  FErrors := TList<string>.Create;
end;

destructor TDextPackValidator.Destroy;
begin
  FErrors.Free;
  inherited;
end;

procedure TDextPackValidator.RequireFile(const ARelativePath: string);
var
  LPath: string;
begin
  LPath := TPath.Combine(FRootPath, ARelativePath);
  if not TFile.Exists(LPath) then
    FErrors.Add('Missing required file: ' + ARelativePath);
end;

procedure TDextPackValidator.RequireText(const ARelativePath, AText: string);
var
  LPath: string;
  LContent: string;
begin
  LPath := TPath.Combine(FRootPath, ARelativePath);
  if not TFile.Exists(LPath) then
  begin
    FErrors.Add('Missing required file: ' + ARelativePath);
    Exit;
  end;

  LContent := TFile.ReadAllText(LPath, TEncoding.UTF8);
  if not LContent.Contains(AText) then
    FErrors.Add(Format('Required text "%s" missing from %s', [AText, ARelativePath]));
end;

procedure TDextPackValidator.ValidateCoreFiles;
const
  CoreFiles: array[0..9] of string = (
    'README.md',
    'CHANGELOG.md',
    'DEXT_AI_MEMORY_ENRICHED.md',
    'DEXT_API_SYMBOL_INDEX.md',
    'DEXT_DECISION_TREE.md',
    'DEXT_ANTI_PATTERNS.md',
    'DEXT_CODE_RECIPES.md',
    'snapshots' + PathDelim + 'DEXT_VERSION_SNAPSHOT.md',
    'versioning' + PathDelim + 'RELEASE_MANIFEST.md',
    'quality' + PathDelim + 'RELEASE_GATE.md'
  );
var
  LFile: string;
begin
  for LFile in CoreFiles do
    RequireFile(LFile);
end;

procedure TDextPackValidator.ValidateSkills;
const
  Skills: array[0..6] of string = (
    'dext-web',
    'dext-orm',
    'dext-financial',
    'dext-fastpath',
    'dext-realtime',
    'dext-testing',
    'dext-mcp'
  );
var
  LSkill: string;
begin
  for LSkill in Skills do
    RequireFile(TPath.Combine(TPath.Combine('skills', LSkill), 'SKILL.md'));
end;

procedure TDextPackValidator.ValidatePrompts;
const
  Prompts: array[0..7] of string = (
    'create-crud-api.md',
    'create-financial-module.md',
    'create-fast-endpoint.md',
    'create-realtime-feature.md',
    'create-mcp-server.md',
    'migrate-dmvc-to-dext.md',
    'review-dext-code.md',
    'create-test-suite.md'
  );
var
  LPrompt: string;
begin
  for LPrompt in Prompts do
    RequireFile(TPath.Combine('prompts', LPrompt));
end;

procedure TDextPackValidator.ValidateFullArtifacts;
var
  I: Integer;
begin
  for I := 1 to 9 do
    RequireFile(Format('full%sDEXT_AI_MEMORY_ENRICHED_PART_%.2d.md', [PathDelim, I]));

  for I := 1 to 4 do
    RequireFile(Format('full%sDEXT_API_SYMBOL_INDEX_PART_%.2d.md', [PathDelim, I]));
end;

procedure TDextPackValidator.ValidateReleaseIdentity;
begin
  RequireText('README.md', 'cesarliws/dext@');
  RequireText(TPath.Combine('versioning', 'RELEASE_MANIFEST.md'), 'Upstream full SHA:');
  RequireText(TPath.Combine('snapshots', 'DEXT_VERSION_SNAPSHOT.md'), 'Audited HEAD:');
end;

procedure TDextPackValidator.ValidateBehaviorGuards;
const
  Guards: array[0..6] of string = (
    '{id}',
    '[MaxLength',
    'IList<T>',
    'AcquireScoped',
    'Mock<T>',
    'TBcd',
    'MapFast'
  );
var
  LGuard: string;
  LAntiPatterns: string;
  LBehaviorGate: string;
  LCombined: string;
begin
  LAntiPatterns := TFile.ReadAllText(TPath.Combine(FRootPath, 'DEXT_ANTI_PATTERNS.md'), TEncoding.UTF8);
  LBehaviorGate := TFile.ReadAllText(TPath.Combine(FRootPath, TPath.Combine('quality', 'AGENT_BEHAVIOR_GATE.md')), TEncoding.UTF8);
  LCombined := LAntiPatterns + sLineBreak + LBehaviorGate;

  for LGuard in Guards do
    if not LCombined.Contains(LGuard) then
      FErrors.Add('Missing required behavior guard: ' + LGuard);
end;

function TDextPackValidator.Validate: TDextPackValidationResult;
var
  LError: string;
begin
  FErrors.Clear;

  ValidateCoreFiles;
  ValidateSkills;
  ValidatePrompts;
  ValidateFullArtifacts;
  ValidateReleaseIdentity;

  if FErrors.Count = 0 then
    ValidateBehaviorGuards;

  Result := TDextPackValidationResult.Success;
  for LError in FErrors do
    Result.AddError(LError);
end;

end.
