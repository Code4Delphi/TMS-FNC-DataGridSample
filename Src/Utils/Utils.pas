unit Utils;

interface

uses
  System.SysUtils,
  System.StrUtils,
  Vcl.Dialogs;

type
  TUtils = class
  private

  public
    class function GetNameFileCSV: string;
    class function GetNameFile(const AExtensao: string): string;
    class function GetNameFileHTML: string;
    class function GetNameFileXLS: string;
  end;

implementation

class function TUtils.GetNameFile(const AExtensao : string): string;
var
  LSaveDialog: TSaveDialog;
begin
  Result := '';
  LSaveDialog := TSaveDialog.Create(nil);
  try
    LSaveDialog.Filter := Format('Arquivos %s (*.%s)|*.%s', [UpperCase(AExtensao), AExtensao, AExtensao]);
    LSaveDialog.DefaultExt := AExtensao;
    LSaveDialog.Title := 'Salvar arquivo ' + AExtensao;

    if LSaveDialog.Execute then
      Result := LSaveDialog.FileName
  finally
    LSaveDialog.Free;
  end;
end;

class function TUtils.GetNameFileCSV: string;
begin
  Result := Self.GetNameFile('csv');
end;

class function TUtils.GetNameFileHTML: string;
begin
  Result := Self.GetNameFile('html');
end;

class function TUtils.GetNameFileXLS: string;
begin
  Result := Self.GetNameFile('xls');
end;

end.
