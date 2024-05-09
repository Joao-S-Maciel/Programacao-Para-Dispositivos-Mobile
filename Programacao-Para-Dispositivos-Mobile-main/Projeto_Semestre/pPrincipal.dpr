program pPrincipal;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {frm_Principal},
  uClientes in 'uClientes.pas' {frm_Clientes},
  uProdutos in 'uProdutos.pas' {frmProdutos},
  uPedidos in 'uPedidos.pas' {frmPedidos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(Tfrm_Clientes, frm_Clientes);
  Application.CreateForm(TfrmProdutos, frmProdutos);
  Application.CreateForm(TfrmPedidos, frmPedidos);
  Application.Run;
end.
