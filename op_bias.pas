unit op_bias;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    a1: TEdit;
    a2: TEdit;
    a3: TEdit;
    a4: TEdit;
    a5: TEdit;
    b1: TEdit;
    b2: TEdit;
    b3: TEdit;
    b4: TEdit;
    b5: TEdit;
    Rp: TEdit;
    kOhm: TLabel;
    Label1: TLabel;
    analyse: TButton;
    synthese: TButton;
    ende: TButton;
    Label2: TLabel;
    Ra1: TEdit;
    Ra2: TEdit;
    Ra3: TEdit;
    Ra4: TEdit;
    Ra5: TEdit;
    Rb1: TEdit;
    Rb3: TEdit;
    Rb4: TEdit;
    Rb5: TEdit;
    Rf: TEdit;
    R_ausgleich: TEdit;
    Wert: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Rb2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label28: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Button1: TButton;
    procedure endeClick(Sender: TObject);
    procedure syntheseClick(Sender: TObject);
    procedure analyseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.endeClick(Sender: TObject);
begin
     close;
end;

procedure TForm1.syntheseClick(Sender: TObject);

type float = double;
     kompensationsT = (keine, Ro_plus, Rl_minus);

var summe_a, summe_b, delta: float;
    Rpar, Rfeedback, Ro, Rl: float;
    kompensation: kompensationsT;
    a, b, Ra, Rb: array [1..5] of float;
    Fehlercode, x: integer;
    hilfsstring: string;

    procedure ermittle_kompensationsart (var kompensation: kompensationsT);
    begin
         if delta = 0 then kompensation := keine
         else if delta > 0 then kompensation := Ro_plus
         else if delta < 0 then kompensation := Rl_minus
    end;

    procedure keine_kompensation (var Rfeedback: float; summe_b, delta: float);
    begin
         R_ausgleich.text := 'KEINER!';
         Wert.text := ' ';
         Rfeedback := summe_b * Rpar; {könnte auch summe_a sein, da gleich!}
         Wert.text := '0';

    end;

    procedure berechne_Ro (var Rfeedback: float; summe_b, delta: float);
    var hilfsstring: string;
    begin
         R_ausgleich.text := 'Ro (E+)';
         Rfeedback := summe_b * Rpar;
         Ro := Rfeedback / delta;
         str (Ro/1e3 :6:3, hilfsstring);
         Wert.text := hilfsstring;
    end;

    procedure berechne_Rl (var Rfeedback: float; summe_a, delta: float);
    var hilfsstring: string;
    begin
         R_ausgleich.text := 'Rl (E-)';
         Rfeedback := summe_a * Rpar;
         Rl := - Rfeedback / delta;
         str (Rl/1e3 :6:3, hilfsstring);
         Wert.text := hilfsstring;
    end;


begin
    val (a1.text, a[1], Fehlercode);
    val (a2.text, a[2], Fehlercode);
    val (a3.text, a[3], Fehlercode);
    val (a4.text, a[4], Fehlercode);
    val (a5.text, a[5], Fehlercode);
    summe_a := 0;
    for x := 1 to 5 do summe_a := summe_a + a[x];

    val (b1.text, b[1], Fehlercode);
    val (b2.text, b[2], Fehlercode);
    val (b3.text, b[3], Fehlercode);
    val (b4.text, b[4], Fehlercode);
    val (b5.text, b[5], Fehlercode);

    summe_b:= 0;
    for x := 1 to 5 do summe_b:= summe_b + b[x];
    summe_b := summe_b + 1; {!!!}

    delta := summe_b - summe_a;

    val (Rp.text, Rpar, Fehlercode);
    Rpar := Rpar * 1e3; {Wandlung von Rp und Umrechnung in kOhm!}

    ermittle_kompensationsart (kompensation); {eigenen Prozedur!}
    case kompensation of
         keine:       keine_kompensation (Rfeedback, summe_b, delta);
         Ro_plus:     berechne_Ro (Rfeedback, summe_b, delta);
         Rl_minus:    berechne_Rl (Rfeedback, summe_a, delta);
    end;

    str (Rfeedback/1e3 :6:3, hilfsstring);
    Rf.text := hilfsstring;

    for x := 1 to 5 do begin
        if a[x] <> 0 then
           Ra[x] := Rfeedback / a[x];
    end;

    for x := 1 to 5 do begin
        if b[x] <> 0 then
           Rb[x] := Rfeedback / b[x];
    end;

    if a[1] <> 0 then begin
       str(Ra[1]/1e3 :6:3, hilfsstring);
       Ra1.text := hilfsstring;
    end;
    if a[2] <> 0 then begin
       str(Ra[2]/1e3 :6:3, hilfsstring);
       Ra2.text := hilfsstring;
    end;
    if a[3] <> 0 then begin
       str(Ra[3]/1e3 :6:3, hilfsstring);
       Ra3.text := hilfsstring;
    end;
    if a[4] <> 0 then begin
       str(Ra[4]/1e3 :6:3, hilfsstring);
       Ra4.text := hilfsstring;
    end;
    if a[5] <> 0 then begin
       str(Ra[5]/1e3 :6:3, hilfsstring);
       Ra5.text := hilfsstring;
    end;

    if b[1] <> 0 then begin
       str(Rb[1]/1e3 :6:3, hilfsstring);
       Rb1.text := hilfsstring;
    end;
    if b[2] <> 0 then begin
       str(Rb[2]/1e3 :6:3, hilfsstring);
       Rb2.text := hilfsstring;
    end;
    if b[3] <> 0 then begin
       str(Rb[3]/1e3 :6:3, hilfsstring);
       Rb3.text := hilfsstring;
    end;
    if b[4] <> 0 then begin
       str(Rb[4]/1e3 :6:3, hilfsstring);
       Rb4.text := hilfsstring;
    end;
    if b[5] <> 0 then begin
       str(Rb[5]/1e3 :6:3, hilfsstring);
       Rb5.text := hilfsstring;
    end;

end;

procedure TForm1.analyseClick(Sender: TObject);
type float = real;

     function a_wert (Rai, Leitwerte_a, Rf, Rb_par: float): float;
     var Ra_par: float;
     begin
          Ra_par := 1 / (Leitwerte_a - 1/Rai);
          a_wert := Ra_par/(Rai+Ra_par)*(1+Rf/Rb_par);
     end;

var Rfeedback: float;
    a, b, Ra, Rb: array [1..5] of float;
    Ro, Rl, Ra_par, Rb_par, Leitwerte_a, Leitwerte_b: float;
            {Ra_par wird hier eigentlich nicht gebraucht!}
    Fehlercode, x: integer;
    hilfsstring: string;

begin
     val (Ra1.text, Ra[1], Fehlercode);
     val (Ra2.text, Ra[2], Fehlercode);
     val (Ra3.text, Ra[3], Fehlercode);
     val (Ra4.text, Ra[4], Fehlercode);
     val (Ra5.text, Ra[5], Fehlercode);

     val (Rb1.text, Rb[1], Fehlercode);
     val (Rb2.text, Rb[2], Fehlercode);
     val (Rb3.text, Rb[3], Fehlercode);
     val (Rb4.text, Rb[4], Fehlercode);
     val (Rb5.text, Rb[5], Fehlercode);

     val (Rf.text, Rfeedback, Fehlercode);

     {Leitwerte von Ra berechnen}
     Leitwerte_a := 0;
     for x := 1 to 5 do begin
         if Ra[x] > 0 then
            Leitwerte_a := Leitwerte_a + 1/Ra[x];
     end;
     if R_ausgleich.text = 'Ro (E+)' then begin
        val (Wert.text, Ro, Fehlercode);
        Leitwerte_a := Leitwerte_a + 1/Ro;
     end;
     {Ra_par hier noch nicht berechnen, da ja noch der entsprechende Leitwert
      von dem konkreten a_i-Werte abgezogen werden muß!}

     {Leitwerte von Rb berechnen}
     for x := 1 to 5 do begin
         if Rb[x] > 0 then
            Leitwerte_b := Leitwerte_b + 1/Rb[x];
     end;
     if R_ausgleich.text = 'Rl (E-)' then begin
        val (Wert.text, Rl, Fehlercode);
        Leitwerte_b := Leitwerte_b + 1/Rl;
     end;
     Rb_par := 1/Leitwerte_b;

     {Berechnung der einzelnen Verstärkungs-Faktoren}
     if Ra[1] > 0 then begin
        str ( a_wert(Ra[1],Leitwerte_a,Rfeedback, Rb_par) :6:3, hilfsstring);
        a1.text := hilfsstring;
     end;
     if Ra[2] > 0 then begin
        str ( a_wert(Ra[2],Leitwerte_a,Rfeedback, Rb_par) :6:3, hilfsstring);
        a2.text := hilfsstring;
     end;
     if Ra[3] > 0 then begin
        str ( a_wert(Ra[3],Leitwerte_a,Rfeedback, Rb_par) :6:3, hilfsstring);
        a3.text := hilfsstring;
     end;
     if Ra[4] > 0 then begin
        str ( a_wert(Ra[4],Leitwerte_a,Rfeedback, Rb_par) :6:3, hilfsstring);
        a4.text := hilfsstring;
     end;
     if Ra[5] > 0 then begin
        str ( a_wert(Ra[5],Leitwerte_a,Rfeedback, Rb_par) :6:3, hilfsstring);
        a5.text := hilfsstring;
     end;

     if Rb[1] > 0 then begin
        str (Rfeedback/Rb[1] :6:3, hilfsstring);
        b1.text := hilfsstring;
     end;
     if Rb[2] > 0 then begin
        str (Rfeedback/Rb[2] :6:3, hilfsstring);
        b2.text := hilfsstring;
     end;
     if Rb[3] > 0 then begin
        str (Rfeedback/Rb[3] :6:3, hilfsstring);
        b3.text := hilfsstring;
     end;
     if Rb[4] > 0 then begin
        str (Rfeedback/Rb[4] :6:3, hilfsstring);
        b4.text := hilfsstring;
     end;
     if Rb[5] > 0 then begin
        str (Rfeedback/Rb[5] :6:3, hilfsstring);
        b5.text := hilfsstring;
     end;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Top := (Screen.Height Div 2) - (Height Div 2);
  Left := (Screen.Width Div 2) - (Width Div 2);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     a1.text := 'a1';
     a2.text := 'a2';
     a3.text := 'a3';
     a4.text := 'a4';
     a5.text := 'a5';

     b1.text := 'b1';
     b2.text := 'b2';
     b3.text := 'b3';
     b4.text := 'b4';
     b5.text := 'b5';

     Rf.text := 'Rf';

     Ra1.text := 'Ra1';
     Ra2.text := 'Ra2';
     Ra3.text := 'Ra3';
     Ra4.text := 'Ra4';
     Ra5.text := 'Ra5';

     Rb1.text := 'Rb1';
     Rb2.text := 'Rb2';
     Rb3.text := 'Rb3';
     Rb4.text := 'Rb4';
     Rb5.text := 'Rb5';

     R_ausgleich.text := 'R_ausgleich';
     Wert.text := 'Wert';
end;

end.
