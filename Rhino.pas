unit Rhino;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView, FMX.TabControl,
  declarations, FMX.Layouts, FMX.Platform, System.Generics.Collections, Member,
  FMX.Edit;

type
  TForm1 = class(TForm)
    pTop: TPanel;
    expanderBtn: TExpander;
    lvRhino: TListView;
    splitter: TSplitter;
    tcRhino: TTabControl;
    btnMitglied: TButton;
    expanderpanel: TPanel;
    btnTrainer: TButton;
    btnPlayer: TButton;
    btnContact: TButton;
    btnSponsor: TButton;
    btnAddress: TButton;
    btnAdd: TButton;
    Button1: TButton;
    procedure btnMitgliedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTrainerClick(Sender: TObject);
    procedure btnPlayerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private-Deklarationen }

    // Funktionen

    // Listen
    Members :  TObjectList<TMember>;

    // Objekte
    FTestPanel    : TMemberPanel;
    Mitglied      : TTabItem;
    btnMember     : TButton;
    // Prozeduren
    procedure FillListView;
    procedure ClearListView;
    procedure ClearTabControl;
    procedure ShowScreenSize;

  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation


{$R *.fmx}

procedure TForm1.btnAddClick(Sender: TObject);
var
   i              : integer;
   index          : integer;
   tmpNewMember   : TMember;
   LItem          : TListViewItem;
begin

    // Mitglied erzeugen;
      tmpNewMember         := TMember.Create;
      tmpNewMember.Name    := 'Neues';
      tmpNewMember.Surname := 'Mitglied';
      Members.add(tmpNewMember);

    // TabControl Mitgliedelement einf�gen
    tcRhino.BeginUpdate;
      if tcRhino.TabCount > 0 then clearTabControl;
      Mitglied             :=  TTabItemClass.Create(self);
      Mitglied.Parent      :=  tcRhino;
      Mitglied.Name        := 'Mitglied' + intToStr(tcRhino.TabCount);
      Mitglied.Text        := 'Mitglied' + intToStr(tcRhino.TabCount);
      GMemberPanelNumber   := tcRhino.TabCount;
      FTestPanel           := TMemberPanel.create(self);
      FTestPanel.Parent    := Mitglied;
      FTestPanel.Name      := 'Panel' + intToStr(tcRhino.TabCount);
      FTestPanel.Align     := FTestPanel.Align.alClient;
      FTestPanel.Panel     := GMemberPanelNumber;
      FTestPanel.createObjects(GMemberPanelNumber);
    tcRhino.EndUpdate;

    ClearListView;
    FillListView;
end;

procedure TForm1.FillListView;
var
  I           : Integer;
  LItem       : TListViewItem;
  tmpMember   : TMember;
  tmpTrainer  : TTrainer;
  index       : integer;
begin
  try
  index := Members.Count;
  index := index - 1 ;
      lvRhino.BeginUpdate;
        for i := 0 to index do
      begin
        tmpMember     := (Members.Items[i]) as TMember;
        LItem         := lvRhino.Items.Add;
        LItem.Text    := tmpMember.Name + ', ' + tmpMember.Surname;
        LItem.Detail  := inttostr(Members.IndexOf(tmpMember));
      end;
      lvRhino.EndUpdate;
  except
      showMessage('klappt nicht');
  end;
end;

procedure TForm1.ClearListView;
begin
  lvRhino.BeginUpdate;
        lvRhino.Items.Clear;
  lvRhino.EndUpdate
end;

procedure TForm1.ClearTabControl;
var
    I : integer;
begin
  tcRhino.BeginUpdate;
        for I := 0 to tcrhino.TabCount-1 do
        begin
           tcrhino.Tabs[0].Free;
        end;
  tcRhino.EndUpdate;
end;

procedure TForm1.btnMitgliedClick(Sender: TObject);

begin
      // Code noch einf�gen
      showmessage('Code noch einf�gen');
end;

procedure TForm1.btnPlayerClick(Sender: TObject);
var
    Player : TTabItem;
begin
    tcRhino.BeginUpdate;
    Player:=  TTabItemClass.Create(tcRhino);
    Player.Parent     :=  tcRhino;
    Player.Text       := 'Spieler ' + intToStr(tcRhino.TabCount);
    tcRhino.EndUpdate;
end;

procedure TForm1.btnTrainerClick(Sender: TObject);
var
    Trainer : TTabItem;
begin
    tcRhino.BeginUpdate;
    Trainer:=  TTabItemClass.Create(tcRhino);
    Trainer.Parent     :=  tcRhino;
    Trainer.Text       := 'Trainer ' + intToStr(tcRhino.TabCount);
    tcRhino.EndUpdate;
end;

procedure TForm1.ShowScreenSize;
var
   clientScreenScale   : Single;
   clientScreenSize    : TSize;
   clientScreenService : IFMXScreenService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(clientScreenService)) then
  begin
    clientScreenScale   := clientScreenService.GetScreenScale;
  end
  else clientScreenScale   := 1;
  clientScreenSize.CX   := Round(clientScreenService.GetScreenSize.X*clientScreenScale);
  clientScreenSize.CY   := Round(clientScreenService.GetScreenSize.Y*clientScreenScale);
  //showmessage(inttostr(clientScreenSize.CX) + ' ' +inttostr(clientScreenSize.CY));
  Form1.Width  := clientScreenSize.CX;
  Form1.Height := clientScreenSize.CY;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Test : TMember;
begin
      //ShowScreenSize;
      expanderBtn.IsExpanded := false;
      Members                := TObjectList<TMember>.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTestPanel);
end;

end.
