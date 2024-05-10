unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  Tfrm_Principal = class(TForm)
    btn_Clientes: TButton;
    btn_Produtos: TButton;
    btnPedidos: TButton;
    procedure btn_ClientesClick(Sender: TObject);
    procedure btn_ProdutosClick(Sender: TObject);
    procedure btnPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.fmx}

uses uClientes, uProdutos, uPedidos;

procedure Tfrm_Principal.btnPedidosClick(Sender: TObject);
begin
 frmPedidos.Show;
end;

procedure Tfrm_Principal.btn_ClientesClick(Sender: TObject);
begin

  frm_Clientes.Show;

end;

procedure Tfrm_Principal.btn_ProdutosClick(Sender: TObject);
begin
  frmProdutos.Show;
end;

end.
