unit untMain;

interface

uses
  JSON,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, MemDS, VirtualTable;

type
  IEntidade = interface //contrato
    //Encapsulamento
    function GetIdentidade: string;
    procedure SetIdentidade(AValor: String);
    procedure EntidadeToData(AEntidade: IEntidade; ADataSet: TDataSet);
    procedure DataToEntidade(ADataSet: TDataSet; var AEntidade: IEntidade);
  end;

  ITrabalho = interface
    function GetTrabalho: string;
  end;

  TEntidade = class(TInterfacedObject, IEntidade) //superclasse
  private
    FID: Integer;
    FNome: String;
  public
    property ID: Integer read FID write FID;
    property Nome: String read FNome write FNome;
    //Polimorfismo
    function GetIdentidade: string; virtual; abstract;
    procedure SetIdentidade(AValor: String); virtual; abstract;
    procedure EntidadeToData(AEntidade: IEntidade; ADataSet: TDataSet);
    procedure DataToEntidade(ADataSet: TDataSet; var AEntidade: IEntidade);
  end;

  TCliente = class(TEntidade, ITrabalho) //subclasse
  private
    FCPF: String;
    procedure ClienteToData(ADataSet: TDataSet);
  public
    property CPF: String read FCPF write FCPF;
    //Polimorfismo por sobrescrita
    function GetIdentidade: string; override;
    procedure SetIdentidade(AValor: String); override;
    //Polimorfismo por sobrecarga
    function GetID: Integer; overload;
    function GetID(ASoma: Integer): Integer; overload;
    function GetTrabalho: string;
  end;

  TFornecedor = class(TEntidade) //subclasse
  private
    FCNPJ: string;
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    function GetIdentidade: string; override;
    procedure SetIdentidade(AValor: String); override;
  end;

  TForm11 = class(TForm)
    btnInserir: TButton;
    btnConsultar: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    DBGrid1: TDBGrid;
    VirtualTable1: TVirtualTable;
    DataSource1: TDataSource;
    VirtualTable1ID: TIntegerField;
    VirtualTable1Nome: TStringField;
    VirtualTable1Identidade: TStringField;
    VirtualTable1Detalhe: TStringField;
    procedure btnInserirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    procedure ExcluirCliente(AID: Integer);
    function MostrarID(AEntidade: IEntidade): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

function TForm11.MostrarID(AEntidade: IEntidade): string;
begin
  Result := TEntidade(AEntidade).ID.ToString();
end;

procedure TForm11.btnConsultarClick(Sender: TObject);
var
  entidade: IEntidade;
begin
  VirtualTable1.Close();
  VirtualTable1.Filter := 'ID = 1';
  VirtualTable1.Filtered := True;
  VirtualTable1.Open();

  entidade := TCliente.Create();
  entidade.DataToEntidade(VirtualTable1, entidade);

  ShowMessage(TEntidade(entidade).Nome);
  ShowMessage(MostrarID(entidade));
  ShowMessage('Identidade: ' + entidade.GetIdentidade());
end;

procedure TForm11.btnEditarClick(Sender: TObject);
var
  entidade: IEntidade;
begin
  entidade := TCliente.Create();
  entidade.DataToEntidade(VirtualTable1, entidade);

  TEntidade(entidade).Nome := 'Ciclano';

  VirtualTable1.Close();
  VirtualTable1.Open();
  VirtualTable1.Edit();
  entidade.EntidadeToData(entidade, VirtualTable1);
  VirtualTable1.Post();
end;

procedure TForm11.btnExcluirClick(Sender: TObject);
begin
  ExcluirCliente(3);
end;

procedure TForm11.ExcluirCliente(AID: Integer);
begin
  VirtualTable1.First();
  while not VirtualTable1.Eof do
  begin
    if VirtualTable1.FieldByName('ID').AsInteger = AID then
      VirtualTable1.Delete()
    else
      VirtualTable1.Next();
  end;
end;

procedure TForm11.btnInserirClick(Sender: TObject);
var
  cliente: IEntidade;
  fornecedor: IEntidade;
begin
  cliente := TCliente.Create();
  TCliente(cliente).ID := 1;
  TCliente(cliente).Nome := 'Fulano';
  TCliente(cliente).CPF := '123';

  VirtualTable1.Close();
  VirtualTable1.Open();
  VirtualTable1.Append();
//  cliente.EntidadeToData(cliente, VirtualTable1);
  TCliente(cliente).ClienteToData(VirtualTable1);
  VirtualTable1.Post();
  //Não é necessário fazer um cliente.Free, porque o contador de referências de interfaces do Delphi faz isso sozinho

  fornecedor := TFornecedor.Create();
  TFornecedor(fornecedor).ID := 2;
  TFornecedor(fornecedor).Nome := 'Fornecedor';
  TFornecedor(fornecedor).CNPJ := '11759135000151';
  VirtualTable1.Close();
  VirtualTable1.Open();
  VirtualTable1.Append();
  fornecedor.EntidadeToData(fornecedor, VirtualTable1);
  VirtualTable1.Post();
  ShowMessage(fornecedor.GetIdentidade);
end;

{ TCliente }

procedure TCliente.ClienteToData(ADataSet: TDataSet);
begin
  //DRY – Don’t Repeat Yourself
  inherited EntidadeToData(Self, ADataSet);
  ADataSet.FieldByName('Detalhe').AsString := GetTrabalho;
end;

function TCliente.GetID(ASoma: Integer): Integer;
begin
  Result := FID + ASoma;
end;

function TCliente.GetID: Integer;
begin
  Result := FID;
end;

function TCliente.GetIdentidade: string;
begin
  Result := Self.CPF;
end;

function TCliente.GetTrabalho: string;
begin
  Result := 'do lar';
end;

procedure TCliente.SetIdentidade(AValor: String);
begin
  FCPF := AValor;
end;

{ TFornecedor }

function TFornecedor.GetIdentidade: string;
begin
  Result := Self.CNPJ;
end;

procedure TFornecedor.SetIdentidade(AValor: String);
begin
  FCNPJ := AValor;
end;

{ TEntidade }

procedure TEntidade.DataToEntidade(ADataSet: TDataSet;
  var AEntidade: IEntidade);
begin
  TEntidade(AEntidade).ID := ADataSet.FieldByName('ID').AsInteger;
  TEntidade(AEntidade).Nome := ADataSet.FieldByName('Nome').AsString;
  AEntidade.SetIdentidade(ADataSet.FieldByName('Identidade').AsString);
end;

procedure TEntidade.EntidadeToData(AEntidade: IEntidade;
  ADataSet: TDataSet);
begin
  ADataSet.FieldByName('ID').AsInteger := TEntidade(AEntidade).ID;
  ADataSet.FieldByName('Nome').AsString := TEntidade(AEntidade).Nome;
  ADataSet.FieldByName('Identidade').AsString := AEntidade.GetIdentidade;
end;

end.
