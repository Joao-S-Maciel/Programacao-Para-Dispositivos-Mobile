unit uPedidos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl, Data.DB, FireDAC.Comp.Client, FMX.Objects, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FMX.DateTimeCtrls;

type
  TPedido= record
    id, id_cliente, id_formapgto : Integer;
    nome_cliente, forma_pgto : string;
    data_pedido : TDate;
    valor_total : Float32;

  end;


  TfrmPedidos = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    imgCliente: TImage;
    FDConnection1: TFDConnection;
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
    edt_Data: TDateEdit;
    FDQuery1: TFDQuery;
    Image4: TImage;
    Layout8: TLayout;
    Text1: TText;
    procedure atualizaPedidosBanco();
    procedure inserePedidoNaLista(pedido : Tpedido);
    procedure btn_AtualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPedidos: TfrmPedidos;

implementation

{$R *.fmx}

procedure TfrmPedidos.atualizaPedidosBanco;
var vPedido : TPedido;
begin

  //Busca os dados no banco
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select pedidos.id,');
  FDQuery1.SQL.Add('    pedidos.data,');
  FDQuery1.SQL.Add('    pedidos.id_Cliente,');
  FDQuery1.SQL.Add('    clientes.nome,');
  FDQuery1.SQL.Add('    pedidos.VALOR_TOTAL,');
  FDQuery1.SQL.Add('    FORMAPGTO.ID as id_formapgto, ');
  FDQuery1.SQL.Add('    FORMAPGTO.DESCRICAO');
  FDQuery1.SQL.Add('from pedidos');
  FDQuery1.SQL.Add('  inner join clientes');
  FDQuery1.SQL.Add('  on clientes.codigo = pedidos.ID_CLIENTE');
  FDQuery1.SQL.Add('  inner join FORMAPGTO');
  FDQuery1.SQL.Add('  on FORMAPGTO.ID = pedidos.ID_FORMAPGTO');
  FDQuery1.SQL.Add('  where pedidos.data = :data');

  FDQuery1.ParamByName('data').AsDate := edt_Data.Date;

  FDQuery1.SQL.Add('  order by pedidos.id');

  FDQuery1.Open();

  ListView1.Items.Clear();

  while not FDQuery1.Eof do
  begin
    vPedido.id := FDQuery1.FieldByName('id').AsInteger;
    vPedido.data_pedido := FDQuery1.FieldByName('data').AsDateTime;
    vPedido.id_cliente := FDQuery1.FieldByName('ID_CLIENTE').AsInteger;
    vPedido.nome_cliente := FDQuery1.FieldByName('nome').AsString;
    vPedido.id_formapgto := FDQuery1.FieldByName('ID_FORMAPGTO').AsInteger;
    vPedido.forma_pgto := FDQuery1.FieldByName('DESCRICAO').AsString;
    vPedido.valor_total := FDQuery1.FieldByName('VALOR_TOTAL').AsFloat;

    //metodo inserir o pedido na lista

    inserePedidoNaLista(vPedido);

    FDQuery1.Next;
  end;

end;

procedure TfrmPedidos.btn_AtualizarClick(Sender: TObject);
begin

  atualizaPedidosBanco;

end;

procedure TfrmPedidos.inserePedidoNaLista(pedido: Tpedido);
begin
// produto cliente na lista

With ListView1.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(pedido.id);
    TListItemText(Objects.FindDrawable('txtNome')).Text := pedido.nome_cliente;
    TListItemText(Objects.FindDrawable('txtData')).Text := DateToStr(pedido.data_pedido);
    TListItemText(Objects.FindDrawable('txtValor')).Text := FloattoStr(pedido.valor_total);
    TListItemImage(Objects.FindDrawable('Image5')).Bitmap := Image4.Bitmap;
  end;

end;

end.
