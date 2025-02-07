unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  System.Rtti, VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer, Data.DB, VCL.TMSFNCCustomComponent, VCL.TMSFNCDataGridDatabaseAdapter,
  VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls, System.TypInfo,
  Utils, VCL.TMSFNCGridCell;

type
  TMainView = class(TForm)
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    pnRodape01: TPanel;
    btnClose: TButton;
    btnOpen: TButton;
    btnRefresh: TButton;
    ckUsarOrdenacao: TCheckBox;
    pnBotoesDireita: TPanel;
    ckPermitirAlteracao: TCheckBox;
    ckPermitirFiltros: TCheckBox;
    pnRodape02: TPanel;
    Label1: TLabel;
    cBoxSelection: TComboBox;
    Button1: TButton;
    btnExportarCSV: TButton;
    btnExportarHTML: TButton;
    ckZebrar: TCheckBox;
    FDQuery1id: TFDAutoIncField;
    FDQuery1nome: TWideStringField;
    FDQuery1profissao: TWideStringField;
    FDQuery1limite: TFloatField;
    FDQuery1porcentagem: TIntegerField;
    FDQuery1ativo: TWideStringField;
    FDQuery1id_cidade: TIntegerField;
    FDQuery1CidadeNome: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure ckUsarOrdenacaoClick(Sender: TObject);
    procedure ckPermitirAlteracaoClick(Sender: TObject);
    procedure ckPermitirFiltrosClick(Sender: TObject);
    procedure cBoxSelectionChange(Sender: TObject);
    procedure btnExportarHTMLClick(Sender: TObject);
    procedure btnExportarCSVClick(Sender: TObject);
    procedure TMSFNCDataGrid1GetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
    procedure ckZebrarClick(Sender: TObject);
    procedure TMSFNCDataGrid1GetCellData(Sender: TObject; ACell: TTMSFNCDataGridCellCoord;
      var AData: TTMSFNCDataGridCellValue);
  private
    procedure ConfComponentesIgualGrid;
    procedure PreencharcBoxSelection;
  public

  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;

  FDConnection1.Params.Database := '../BD/Code4DTeste.db';
  FDQuery1.Open;
  Self.PreencharcBoxSelection;
  Self.ConfComponentesIgualGrid;

  //TMSFNCDataGrid1.AddProgressBar(4, 2, 80);
  //TMSFNCDataGrid1.AddProgressBarColumn(4, 0);
end;

procedure TMainView.PreencharcBoxSelection;
var
  Mode: TTMSFNCDataGridSelectionMode;
begin
  cBoxSelection.Items.BeginUpdate;
  try
    cBoxSelection.Items.Clear;
    for Mode := Low(TTMSFNCDataGridSelectionMode) to High(TTMSFNCDataGridSelectionMode) do
      cBoxSelection.Items.Add(GetEnumName(TypeInfo(TTMSFNCDataGridSelectionMode), Ord(Mode)));
  finally
    cBoxSelection.Items.EndUpdate;
  end;

  cBoxSelection.ItemIndex := Integer(TMSFNCDataGrid1.Options.Selection.Mode);
end;

procedure TMainView.TMSFNCDataGrid1GetCellData(Sender: TObject; ACell: TTMSFNCDataGridCellCoord;
  var AData: TTMSFNCDataGridCellValue);
begin
//  //SE LINHA NAO FIXADA
//  if (ACell.Row >= TMSFNCDataGrid1.FixedRowCount) then
//  begin
//    //SE FOR A COLUNA PORCENTAGEM
//    if ACell.Column = FDQuery1porcentagem.Index then
//    begin
//      LValorColunaPorcentagem := 50; //TMSFNCDataGrid1.Ints[ACell.Column, ACell.Row];
//      TMSFNCDataGrid1.AddProgressBar(ACell.Column, ACell.Row, LValorColunaPorcentagem);
//      //TMSFNCDataGrid1.SetProgressBar(ACell.Column, ACell.Row, LValorColunaPorcentagem);
//    end;
//  end;

    //SE LINHA NAO FIXADA
  if (ACell.Row >= TMSFNCDataGrid1.FixedRowCount) then
  begin
    //SE FOR A COLUNA PORCENTAGEM
    if ACell.Column = FDQuery1porcentagem.Index then
    begin
      TMSFNCDataGrid1.SetProgressBarColumn(ACell.Column, 35);
      //TMSFNCDataGrid1.AddProgressBar(ACell.Column, ACell.Row, LValorColunaPorcentagem);
    end;
  end;


end;

procedure TMainView.TMSFNCDataGrid1GetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
var
  LValorColunaLimite: Double;
begin
  if ckZebrar.Checked then
    if (ACell.Row mod 2) = 0 then
       ACell.Layout.Fill.Color := gcSilver;

  //SE LINHA OU COLUNA FIXADA
  if (ACell.Row < TMSFNCDataGrid1.FixedRowCount) or (ACell.Column < TMSFNCDataGrid1.FixedColumnCount) then
  begin
    ACell.Layout.Font.Color := clHotLight;
    ACell.Layout.Font.Style := [TFontStyle.fsBold];
    Exit;
  end;

  //SE FOR A COLUNA LIMITE
  if ACell.Column = FDQuery1limite.Index then
  begin
    ACell.Layout.Font.Color := clGreen;

    LValorColunaLimite := TMSFNCDataGrid1.Floats[ACell.Column, ACell.Row];
    if LValorColunaLimite < 2000 then
      ACell.Layout.Font.Color := clRed
  end;


//  //SE LINHA NAO FIXADA
//  if (ACell.Row >= TMSFNCDataGrid1.FixedRowCount) then
//  begin
//    //SE FOR A COLUNA PORCENTAGEM
//    if ACell.Column = FDQuery1porcentagem.Index then
//    begin
//      TMSFNCDataGrid1.SetProgressBarColumn(ACell.Column, 35);
//      //TMSFNCDataGrid1.AddProgressBar(ACell.Column, ACell.Row, LValorColunaPorcentagem);
//    end;
//  end;
end;

procedure TMainView.ConfComponentesIgualGrid;
begin
  ckUsarOrdenacao.Checked := TMSFNCDataGrid1.Options.Sorting.Enabled;
  ckPermitirAlteracao.Checked := TMSFNCDataGrid1.Options.Editing.Enabled;
  ckPermitirFiltros.Checked := TMSFNCDataGrid1.Options.Filtering.Enabled;
end;

procedure TMainView.btnCloseClick(Sender: TObject);
begin
  FDQuery1.Close;
end;

procedure TMainView.btnOpenClick(Sender: TObject);
begin
  FDQuery1.Open;
end;

procedure TMainView.btnRefreshClick(Sender: TObject);
begin
  FDQuery1.Refresh;
end;

procedure TMainView.ckUsarOrdenacaoClick(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.Sorting.Enabled := ckUsarOrdenacao.Checked;
end;

procedure TMainView.ckPermitirAlteracaoClick(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.Editing.Enabled := ckPermitirAlteracao.Checked;
end;

procedure TMainView.ckPermitirFiltrosClick(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.Filtering.Enabled := ckPermitirFiltros.Checked;
end;

procedure TMainView.cBoxSelectionChange(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.Selection.Mode := TTMSFNCDataGridSelectionMode(cBoxSelection.ItemIndex);
end;

procedure TMainView.btnExportarCSVClick(Sender: TObject);
var
  LFileName: string;
begin
  LFileName := TUtils.GetNameFileCSV;
  if not LFileName.IsEmpty then
    TMSFNCDataGrid1.SaveToCSVData(LFileName);
end;

procedure TMainView.btnExportarHTMLClick(Sender: TObject);
var
  LFileName: string;
begin
  LFileName := TUtils.GetNameFileHTML;
  if not LFileName.IsEmpty then
    TMSFNCDataGrid1.SaveToHTMLData(LFileName);
end;

procedure TMainView.ckZebrarClick(Sender: TObject);
begin
  btnRefresh.Click;
end;

end.
