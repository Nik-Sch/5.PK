unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Spin, ukugel, math;

const
  vZunahme1 = 0.05;
type

  { TSimulation }

  TSimulation = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Reset: TButton;
    Feder1: TShape;
    Feder2: TShape;
    Start2: TButton;
    EnergieverlustEdt: TSpinEdit;
    Start1: TButton;
    Kugel1shp: TShape;
    Kugel2shp: TShape;
    Label1: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Start2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Simulation: TSimulation;
  Kugel1, Kugel2: TKugel;
  Time: Integer;
  Mitte: Integer;//Treffpunkt der beiden Kugeln
  Bewegen: boolean;
  Energieverlust: Integer;
  vZunahme2: double;

implementation

{$R *.lfm}

{ TSimulation }

procedure TSimulation.Timer1Timer(Sender: TObject);
var
  temp: double;
begin//Basketball
  if not Bewegen then //Aufprall
  begin
    temp:= Kugel1.Geschwindigkeit;
    Kugel1.Geschwindigkeit:= Kugel2.Geschwindigkeit * Energieverlust / 100;
    Kugel2.Geschwindigkeit:= temp * Energieverlust / 100;

    Kugel1shp.Left:= Mitte - 72;
    Kugel2shp.Left:= Mitte;
    if (Time = Round(Energieverlust * 0.16)) then
    begin
      inc(Time);
      Timer1.Enabled:= false;
      Kugel1shp.Left:= Mitte - 69;
      Kugel2shp.Left:= Mitte - 3;
      ShowMessage('Finished!');
    end;
    Time:= Time + 1;
  end
  else //bewegen
  begin
    Kugel1shp.Left:= Kugel1shp.Left + Round(Kugel1.Geschwindigkeit);
    Kugel2shp.Left:= Kugel2shp.Left + Round(Kugel2.Geschwindigkeit);

    Kugel1.Geschwindigkeit:= Kugel1.Geschwindigkeit + vZunahme1;
    Kugel2.Geschwindigkeit:= Kugel2.Geschwindigkeit - vZunahme1;
  end;

  if (Kugel1shp.Left + 72 > Kugel2shp.Left) then
  Bewegen:= false
  else
  Bewegen:= true;
end;

procedure TSimulation.Timer2Timer(Sender: TObject);
var
  temp: double;
begin//Federmodell
  if not Bewegen then //Aufprall
  begin
    temp:= Kugel1.Geschwindigkeit;
    Kugel1.Geschwindigkeit:= Kugel2.Geschwindigkeit * Energieverlust / 100;
    Kugel2.Geschwindigkeit:= temp * Energieverlust / 100;
    Kugel1shp.Left:= Mitte - 69;
    Kugel2shp.Left:= Mitte;
    if (Time = Round(Energieverlust * 0.25)) then
    begin
      inc(Time);
      Timer2.Enabled:= false;
      Kugel1shp.Left:= Mitte - 69;
      Kugel2shp.Left:= Mitte - 3;
      ShowMessage('Finished!');
    end;
    Time:= Time + 1;
  end
  else //bewegen
  begin
    Kugel1shp.Left:= Kugel1shp.Left + Round(Kugel1.Geschwindigkeit);
    Kugel2shp.Left:= Kugel2shp.Left + Round(Kugel2.Geschwindigkeit);

    Kugel1.Geschwindigkeit:= Kugel1.Geschwindigkeit + vZunahme2;
    Kugel2.Geschwindigkeit:= Kugel2.Geschwindigkeit - vZunahme2;
    vZunahme2:= sqr((Mitte - Kugel1shp.Left) / (Mitte - 50)) * 0.5;
  end;

  if (Kugel1shp.Left + 69 > Kugel2shp.Left) then
  Bewegen:= false
  else
  Bewegen:= true;

  Feder1.width:= Kugel1shp.Left;
  Feder2.Width:= Kugel1shp.Left + 10;
  Feder2.Left:= Kugel2shp.Left + 65;
end;

procedure TSimulation.FormCreate(Sender: TObject);
begin
  Bewegen:= true;
  Time:= 0;
  Kugel1:= TKugel.create;
  Kugel2:= TKugel.create;

  Kugel1.Geschwindigkeit:= 0;
  Kugel2.Geschwindigkeit:= 0;

  vZunahme2:= 0.2;

  Mitte:= (Kugel1shp.Left + 72 + Kugel2shp.Left) div 2;
end;

procedure TSimulation.Label1Click(Sender: TObject);
begin

end;

procedure TSimulation.ResetClick(Sender: TObject);
begin
  Feder1.Visible:= false;
  Feder2.Visible:= false;
  Kugel1shp.Left:= 50;
  Kugel2shp.Left:= 330;
  Bewegen:= true;
  Time:= 0;
  Kugel1:= TKugel.create;
  Kugel2:= TKugel.create;
  Kugel1.Geschwindigkeit:= 0;
  Kugel2.Geschwindigkeit:= 0;
  vZunahme2:= 0.2;
  Mitte:= (Kugel1shp.Left + 72 + Kugel2shp.Left) div 2;
  Timer1.Enabled:= false;
  Timer2.Enabled:= false;
end;

procedure TSimulation.Start1Click(Sender: TObject);
begin
  ResetClick(Sender);
  Feder1.Visible:= false;
  Feder2.Visible:= false;
  Kugel1shp.Left:= 50;
  Kugel2shp.Left:= 330;
  Energieverlust:= EnergieverlustEdt.Value;
  Timer1.Enabled:= true;
end;

procedure TSimulation.Start2Click(Sender: TObject);
begin
  ResetClick(Sender);
  Feder1.Visible:= true;
  Feder2.Visible:= true;
  Kugel1shp.Left:= 50;
  Kugel2shp.Left:= 330;
  Energieverlust:= EnergieverlustEdt.Value;
  Timer2.Enabled:= true;
end;

end.

