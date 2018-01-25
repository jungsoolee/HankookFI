program Send_Sample;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  EditEmailMeassge in 'EditEmailMeassge.pas' {EditMail_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
