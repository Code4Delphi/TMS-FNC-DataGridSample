program FNCDataGridSample;

uses
  Vcl.Forms,
  Main.View in 'Src\Main\Main.View.pas' {MainView},
  Utils in 'Src\Utils\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
