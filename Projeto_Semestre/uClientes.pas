unit uClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ListView, FMX.Edit, FMX.TabControl;

type
  Tcliente = record
    codigo : Integer;
    nome, endereco : string;

  end;


  Tfrm_Clientes = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    SpeedButton1: TSpeedButton;
    btn_InserirCliente: TSpeedButton;
    Label1: TLabel;
    btn_Atualizar: TSpeedButton;
    edt_Pesquisa: TEdit;
    ListView1: TListView;
    FDConnection1: TFDConnection;
    fdq_Clientes: TFDQuery;
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    tbInserir: TTabItem;
    tbEditar: TTabItem;
    Layout4: TLayout;
    btnVoltar: TSpeedButton;
    Label2: TLabel;
    lbCodigo: TLabel;
    edtCodigo: TEdit;
    lbNome: TLabel;
    edtNome: TEdit;
    lbEndereco: TLabel;
    edtEndereco: TEdit;
    Layout5: TLayout;
    btnSalvar: TSpeedButton;
    procedure btn_AtualizarClick(Sender: TObject);
    procedure atualizaClientesDoBanco();
    procedure insereClienteNaLista(cliente: TCliente);
    procedure btn_InserirClienteClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure insereClienteNoBanco(cliente : Tcliente);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Clientes: Tfrm_Clientes;

implementation

{$R *.fmx}

procedure Tfrm_Clientes.atualizaClientesDoBanco;
var vCliente : Tcliente;
begin
//Efetuar a consulta do banco e trazer todos os clientes

fdq_Clientes.Close;
fdq_Clientes.SQL.Clear;
fdq_Clientes.SQL.Add('select * from clientes');
if edt_Pesquisa.Text <> ''  then
  begin
    fdq_Clientes.SQL.Add(' where nome like :pesquisa');
    fdq_Clientes.ParamByName('pesquisa').AsString := edt_Pesquisa.Text;
  end;


fdq_Clientes.Open();

fdq_Clientes.First;

ListView1.Items.Clear;

while not fdq_Clientes.Eof do
  begin
    vCliente.codigo := fdq_Clientes.FieldByName('codigo').AsInteger;
    vCliente.nome := fdq_Clientes.FieldByName('nome').AsString;
    vCliente.endereco := fdq_Clientes.FieldByName('endereco').AsString;

    insereClienteNaLista(vCliente);

    fdq_Clientes.Next;
  end;

end;

procedure Tfrm_Clientes.btnSalvarClick(Sender: TObject);
var vCliente : TCliente;
begin
  //chamar procedimento para inserir cliente no banco
  vCliente.codigo := StrToInt(edtCodigo.Text);
  vCliente.nome := edtNome.Text;
  vCliente.endereco := edtEndereco.Text;
  insereClienteNoBanco(vCliente);

end;

procedure Tfrm_Clientes.btn_AtualizarClick(Sender: TObject);
begin

// chamar metodo de consulta do banco de dados
atualizaClientesDoBanco;


end;

procedure Tfrm_Clientes.insereClienteNaLista(cliente: TCliente);
begin

// insere cliente na lista

With ListView1.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(cliente.codigo);
    TListItemText(Objects.FindDrawable('txtNome')).Text := cliente.nome;
  end;

end;

procedure Tfrm_Clientes.insereClienteNoBanco(cliente: Tcliente);
begin

  fdq_Clientes.Close;
  fdq_Clientes.SQL.Clear;
  fdq_Clientes.SQL.Add('insert into clientes (codigo, nome, endereco) values(:codigo, :nome, :endereco)');
  fdq_Clientes.ParamByName('codigo').AsInteger := cliente.codigo;
  fdq_Clientes.ParamByName('nome').AsString := cliente.nome;
  fdq_Clientes.ParamByName('endereco').AsString := cliente.endereco;

  fdq_Clientes.ExecSQL;

end;

procedure Tfrm_Clientes.btn_InserirClienteClick(Sender: TObject);
begin

  TabControl1.TabIndex := 1;

end;

procedure Tfrm_Clientes.FormShow(Sender: TObject);
begin

  TabControl1.TabIndex := 0;

end;

end.