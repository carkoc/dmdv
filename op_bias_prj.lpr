program op_bias_prj;

{$MODE Delphi}

uses
  Forms, Interfaces,
  op_bias in 'op_bias.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
