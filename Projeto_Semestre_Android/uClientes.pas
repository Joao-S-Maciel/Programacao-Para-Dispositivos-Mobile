unit uClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Objects;

type
  Tcliente = record
    codigo : Integer;
    nome, endereco : string;
    foto : TBitmap;

end;

type
  Tfrm_Clientes = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    imgCliente: TImage;
    FDConnection1: TFDConnection;
    fdq_Clientes: TFDQuery;
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    Layout1: TLayout;
    SpeedButton1: TSpeedButton;
    btn_InserirCliente: TSpeedButton;
    Label1: TLabel;
    Layout2: TLayout;
    btn_Atualizar: TSpeedButton;
    edt_Pesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserir: TTabItem;
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
    tbEditar: TTabItem;
    Layout6: TLayout;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    edtCodigoEdicao: TEdit;
    Label5: TLabel;
    edtNomeEdicao: TEdit;
    Label6: TLabel;
    edtEnderecoEdicao: TEdit;
    Layout7: TLayout;
    btnSalvarEdicao: TSpeedButton;
    btnDeletar: TSpeedButton;
    procedure btn_AtualizarClick(Sender: TObject);
    procedure atualizaClientesDoBanco();
    procedure insereClienteNaLista(cliente: TCliente);
    procedure btn_InserirClienteClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure insereClienteNoBanco(cliente : Tcliente);
    procedure FormShow(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure editaClienteNoBanco(cliente: Tcliente);
    procedure btnSalvarEdicaoClick(Sender: TObject);
    function buscarClienteNoBanco(id_cliente: integer): TCliente;
    procedure deletaCliente(id_cliente: integer);
    procedure btnDeletarClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
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
  foto_stream : TStream;
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
fdq_Clientes.SQL.Add(' order by codigo');

fdq_Clientes.Open();

fdq_Clientes.First;

ListView1.Items.Clear;

while not fdq_Clientes.Eof do
  begin

    if fdq_Clientes.FieldByName('foto').AsString <> '' then
    begin
       foto_stream := fdq_Clientes.CreateBlobStream(fdq_Clientes.FieldByName('foto'), TBlobStreamMode.bmRead);
       vCliente.foto := TBitmap.Create;
       vCliente.foto.LoadFromStream(foto_stream);
       foto_stream.DisposeOf;
    end
    else
      vCliente.foto := nil;


    vCliente.codigo := fdq_Clientes.FieldByName('codigo').AsInteger;
    vCliente.nome := fdq_Clientes.FieldByName('nome').AsString;
    vCliente.endereco := fdq_Clientes.FieldByName('endereco').AsString;


    insereClienteNaLista(vCliente);

    fdq_Clientes.Next;
  end;

end;

procedure Tfrm_Clientes.btnDeletarClick(Sender: TObject);
var id_cliente : integer;
begin

  id_cliente := StrToInt(edtCodigoEdicao.text);
  deletaCliente(id_cliente);
  ShowMessage('Cliente deletado com sucesso');
  TabControl1.TabIndex := 0;
  atualizaClientesDoBanco;

end;

procedure Tfrm_Clientes.btnSalvarClick(Sender: TObject);
var vCliente : TCliente;
begin
  //chamar procedimento para inserir cliente no banco
  vCliente.codigo := StrToInt(edtCodigo.Text);
  vCliente.nome := edtNome.Text;
  vCliente.endereco := edtEndereco.Text;
  insereClienteNoBanco(vCliente);

  TabControl1.TabIndex := 0;
  atualizaClientesDoBanco;

end;

procedure Tfrm_Clientes.btnSalvarEdicaoClick(Sender: TObject);
var vCliente : TCliente;
begin
  vCliente.codigo := StrToInt(edtCodigoEdicao.Text);
  vCliente.nome := edtNomeEdicao.Text;
  vCliente.endereco := edtEnderecoEdicao.Text;

  editaClienteNoBanco(vCliente);

  ShowMessage('Cliente alterado com sucesso.');
  TabControl1.TabIndex := 0;
  atualizaClientesDoBanco;
end;

procedure Tfrm_Clientes.btnVoltarClick(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
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
    TListItemText(Objects.FindDrawable('txtEndereco')).Text := cliente.endereco;

    if cliente.foto <> nil then
    TListItemImage(Objects.FindDrawable('imgCliente')).Bitmap := cliente.foto
    else
      TListItemImage(Objects.FindDrawable('imgCliente')).Bitmap := Image1.Bitmap;

    TListItemImage(Objects.FindDrawable('imgEditar')).Bitmap := Image2.Bitmap;
    TListItemImage(Objects.FindDrawable('imgDeletar')).Bitmap := Image3.Bitmap;
  end;

end;

procedure Tfrm_Clientes.insereClienteNoBanco(cliente: Tcliente);
begin

  fdq_Clientes.Close;
  fdq_Clientes.SQL.Clear;
  fdq_Clientes.SQL.Add('insert into clientes (codigo, nome, endereco, foto)');
  fdq_Clientes.SQL.Add(' values(:codigo, :nome, :endereco, :foto)');
  fdq_Clientes.ParamByName('codigo').AsInteger := cliente.codigo;
  fdq_Clientes.ParamByName('nome').AsString := cliente.nome;
  fdq_Clientes.ParamByName('endereco').AsString := cliente.endereco;
  fdq_Clientes.ParamByName('foto').Assign(imgCliente.Bitmap);
  fdq_Clientes.ExecSQL;

end;

procedure Tfrm_Clientes.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);

var vCliente : TCliente;
    id_cliente : integer;
begin
  //chamar a tela de edição

  if ItemObject.Name = 'imgEditar' then
  begin
    id_cliente := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);
    vCliente := buscarClienteNoBanco(id_cliente);

    edtCodigoEdicao.Text := IntToStr(vCliente.codigo);
    edtNomeEdicao.Text := vCliente.nome;
    edtEnderecoEdicao.Text := vCliente.endereco;

    TabControl1.TabIndex := 2
  end;

  if ItemObject.Name = 'imgDeletar' then
    begin
      ShowMessage('Cliente deletado');
    end;



end;

procedure Tfrm_Clientes.SpeedButton2Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure Tfrm_Clientes.btn_InserirClienteClick(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
end;

function Tfrm_Clientes.buscarClienteNoBanco(id_cliente: integer): TCliente;
  var vCliente : TCliente;

begin

  fdq_Clientes.Close;
  fdq_Clientes.SQL.Clear;
  fdq_Clientes.SQL.Add('select * from clientes');
  fdq_Clientes.SQL.Add(' where codigo = :codigo');
  fdq_Clientes.ParamByName('codigo').AsInteger := id_cliente;

  fdq_Clientes.Open();

  vCliente.codigo := id_cliente;
  vCliente.nome := fdq_Clientes.FieldByName('nome').AsString;
  vCliente.endereco := fdq_Clientes.FieldByName('endereco').AsString;

  Result := vCliente;
  end;

procedure Tfrm_Clientes.deletaCliente(id_cliente: integer);
begin

  fdq_Clientes.Close;
  fdq_Clientes.SQL.Clear;
  fdq_Clientes.SQL.Add('delete from clientes');
  fdq_Clientes.SQL.Add(' where codigo = :codigo');

  fdq_Clientes.ParamByName('codigo').AsInteger := id_cliente;

  fdq_Clientes.ExecSQL;
end;

procedure Tfrm_Clientes.editaClienteNoBanco(cliente: Tcliente);
begin

fdq_Clientes.Close;
fdq_Clientes.SQL.Clear;
fdq_Clientes.SQL.Add('update clientes set');
fdq_Clientes.SQL.Add(' nome = :nome, ');
fdq_Clientes.SQL.Add(' endereco = :endereco, ');
fdq_Clientes.SQL.Add(' foto = :foto ');
fdq_Clientes.SQL.Add(' where codigo = :codigo');

fdq_Clientes.ParamByName('codigo').AsInteger := cliente.codigo;
fdq_Clientes.ParamByName('nome').AsString := cliente.nome;
fdq_Clientes.ParamByName('endereco').AsString := cliente.endereco;
fdq_Clientes.ParamByName('foto').Assign(imgCliente.Bitmap);

fdq_Clientes.ExecSQL;

end;

procedure Tfrm_Clientes.FormShow(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;



end.
