unit Member;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView, FMX.TabControl, FMX.Edit,
  FMX.Layouts, FMX.DateTimeCtrls;

  type
  TMemberText = record
        Mitgliedsnummer
      , Vorname
      , Nachname
      , Geburtsdatum
      , Status
      , Rolle
      , Eintrittsdatum
      , Austrittsdatum
      , Alter
      , Stadt
      , Straﬂe
      , plz
      , Nummer
      , Telefon
      , Mobil
      , Mail
      , Anschrift
      , Kontakt
                    :  String;
  end;

  TMemberButtonTask = record Safe, Edit, Discard, Delete : String;
  end;

  TMember = class
    private
    // Variablen
        fMemberNr           : String;
        fName               : String;
        fSurname            : String;
        fBirthday           : TDateTime;
        fAge                : Integer;
        fEntry              : TDateTime;
        fLeaving            : TDateTime;
        fState              : Integer;
        fRole               : Integer;
        fStadt              : String;
        fStraﬂe             : String;
        fStrNummer          : Integer;
        fplz                : String;
        fTelefon            : String;
        fMobil              : String;
        fMail               : String;
    public
    // Zugriff auf die Variablen
        property MemberNr           : String    read fMemberNr  write fMemberNr;
        property Name               : String    read fName      write fName;
        property Surname            : String    read fSurname   write fSurname;
        property Birthday           : TDateTime read fBirthday  write fBirthday;
        property Age                : Integer   read fAge       write fAge;
        property Entry              : TDateTime read fEntry     write fEntry;
        property Leaving            : TDateTime read fLeaving   write fLeaving;
        property State              : Integer   read fState     write fState;
        property Role               : Integer   read fRole      write fRole;
        property Stadt              : String    read fStadt     write fStadt;
        property Straﬂe             : String    read fStraﬂe    write fStraﬂe;
        property Nummer             : Integer   read fStrNummer write fStrNummer;
        property plz                : String    read fplz       write fplz;
        property Telefon            : String    read fTelefon   write fTelefon;
        property Mobil              : String    read fMobil     write fMobil;
        property Mail               : String    read fMail      write fMail;
  end;

  TMemberBtn = class(TButton)

  private
      lMemberButtonTask : String;
      lParameterString0 : String;
      lParameterString1 : String;
      lParameterString2 : String;
      lParameterString3 : String;
      lParameterString4 : String;
      lParameterInt0    : Integer;
      lParameterInt1    : Integer;
      lParameterInt2    : Integer;
      lParameterInt3    : Integer;
      lParameterInt4    : Integer;
      lParameterDate0   : TDate;
      lParameterDate1   : TDate;
      lParameterDate2   : TDate;
      lParameterDate3   : TDate;
      lParameterDate4   : TDate;

  public
      constructor create (AOwner : TComponent); override;
      procedure Click; override;

      property MemberButtonTask  : String   read lMemberButtonTask write lMemberButtonTask;
      property ParameterString0  : String   read lParameterString0 write lParameterString0;
      property ParameterString1  : String   read lParameterString1 write lParameterString1;
      property ParameterString2  : String   read lParameterString2 write lParameterString2;
      property ParameterString3  : String   read lParameterString3 write lParameterString3;
      property ParameterString4  : String   read lParameterString4 write lParameterString4;
      property ParameterInt0     : Integer  read lParameterInt0    write lParameterInt0;
      property ParameterInt1     : Integer  read lParameterInt1    write lParameterInt1;
      property ParameterInt2     : Integer  read lParameterInt2    write lParameterInt2;
      property ParameterInt3     : Integer  read lParameterInt3    write lParameterInt3;
      property ParameterInt4     : Integer  read lParameterInt4    write lParameterInt4;
      property ParameterDate0    : TDate    read lParameterDate0   write lParameterDate0;
      property ParameterDate1    : TDate    read lParameterDate1   write lParameterDate1;
      property ParameterDate2    : TDate    read lParameterDate2   write lParameterDate2;
      property ParameterDate3    : TDate    read lParameterDate3   write lParameterDate3;
      property ParameterDate4    : TDate    read lParameterDate4   write lParameterDate4;
  end;

  TMemberGrid = class(TGridPanelLayout)
  private
      lPanel     : integer;

  public
      constructor create (AOwner : TComponent); override;
      property Panel : integer read lPanel write lPanel;
  end;

  TMemberPanel = class(TPanel)

  private
      lPanel        : integer;
      lMemberNumber : String;
      procedure getMemberInput(Sender :TObject);
  public
      MemberGrid        : TMemberGrid;
      btnMemberSafe     : TMemberBtn;
      btnMemberDiscard  : TMemberBtn;
      btnMemberEdit     : TMemberBtn;
      lblMemberNumber   : TLabel;
      lblMemberName     : TLabel;
      lblMemberSurname  : TLabel;
      lblMemberAge      : TLabel;
      lblMemberAgePlot  : TLabel;
      lblMemberEntry    : TLabel;
      lblMemberExit     : TLabel;
      lblMemberBirthday : TLabel;
      editMemberNumber  : TEdit;
      editMemberName    : TEdit;
      editMemberSurname : TEdit;
      deMemberEntry     : TDateEdit;
      deMemberExit      : TDateEdit;
      deMemberBirthday  : TDateEdit;

      constructor create (AOwner : TComponent); override;

      procedure createObjects(panelNumber : integer);
      property Panel : integer read lPanel write lPanel;
  end;


var
//Variablen
  GMemberPanelNumber : integer;

implementation

 { ****************************************************************************
                         TMemberPanel
 *****************************************************************************}
 constructor TMemberPanel.create(AOwner : TComponent);
 begin

   Inherited create(aowner);

 end;

 procedure TMemberPanel.createObjects(panelNumber: Integer);
 var
    r   : integer;
    LMemberButtonTask : TMemberButtonTask;
    Name : String;
    Surname : String;
    Number : String;
 begin

   LMemberButtonTask.Safe     := 'safe';
   LMemberButtonTask.Edit     := 'edit';
   LMemberButtonTask.Discard  := 'discard';
   LMemberButtonTask.Delete   := 'delete';

   MemberGrid           := TMembergrid.create(self);
   MemberGrid.parent    := self;
   MemberGrid.Align     := MemberGrid.Align.alClient;
   MemberGrid.Name      := TMemberPanel.ClassName + 'Grid' + inttostr(GMemberPanelNumber);
   MemberGrid.Panel     := GMemberPanelNumber;

   MemberGrid.RowCollection.Clear;
   MemberGrid.ColumnCollection.Clear;

   MemberGrid.ColumnCollection.Add;
   MemberGrid.ColumnCollection.Add;
   MemberGrid.ColumnCollection.Add;
   MemberGrid.ColumnCollection.BeginUpdate;
   MemberGrid.ColumnCollection[0].SizeStyle := TGridPanelLayout.TSizeStyle.percent;
   MemberGrid.ColumnCollection[0].Value     := 40;
   MemberGrid.ColumnCollection[1].SizeStyle := TGridPanelLayout.TSizeStyle.percent;
   MemberGrid.ColumnCollection[1].Value     := 40;
   MemberGrid.ColumnCollection[2].SizeStyle := TGridPanelLayout.TSizeStyle.percent;
   MemberGrid.ColumnCollection[2].Value     := 20;
   MemberGrid.ColumnCollection.EndUpdate;

   for r := 0 to 12 do
   begin
   MemberGrid.RowCollection.Add;
   MemberGrid.RowCollection.BeginUpdate;
   MemberGrid.RowCollection[r].SizeStyle := TGridPanelLayout.TSizeStyle.absolute;
   MemberGrid.RowCollection[r].Value := 40;
   MemberGrid.RowCollection.EndUpdate;
   end;

    lblMemberNumber                   := TLabel.Create(self);
    lblMemberNumber.Parent            := MemberGrid;
    lblMemberNumber.Name              := TMemberPanel.ClassName + 'lblMemberNumber'+ inttoStr(GMemberPanelNumber);
    lblMemberNumber.Align             := lblMemberNumber.Align.alClient;
    lblMemberNumber.Margins.Left      := 2;
    lblMemberNumber.Margins.Right     := 2;
    lblMemberNumber.Margins.Top       := 2;
    lblMemberNumber.Margins.Bottom    := 2;


    lblMemberName                     := TLabel.Create(self);
    lblMemberName.Parent              := MemberGrid;
    lblMemberName.Name                := TMemberPanel.ClassName + 'lblMemberName'+ inttoStr(GMemberPanelNumber);
    lblMemberName.Align               := lblMemberName.Align.alClient;
    lblMemberName.Margins.Left        := 2;
    lblMemberName.Margins.Right       := 2;
    lblMemberName.Margins.Top         := 2;
    lblMemberName.Margins.Bottom      := 2;

    lblMemberSurname                  := TLabel.Create(self);
    lblMemberSurname.Parent           := MemberGrid;
    lblMemberSurname.Name             := TMemberPanel.ClassName + 'lblMemberSurname'+ inttoStr(GMemberPanelNumber);
    lblMemberSurname.Align            := lblMemberSurname.Align.alClient;
    lblMemberSurname.Margins.Left     := 2;
    lblMemberSurname.Margins.Right    := 2;
    lblMemberSurname.Margins.Top      := 2;
    lblMemberSurname.Margins.Bottom   := 2;

    lblMemberAge                      := TLabel.Create(self);
    lblMemberAge.Parent               := MemberGrid;
    lblMemberAge.Name                 := TMemberPanel.ClassName + 'lblMemberAge'+ inttoStr(GMemberPanelNumber);
    lblMemberAge.Align                := lblMemberAge.Align.alClient;
    lblMemberAge.Margins.Left         := 2;
    lblMemberAge.Margins.Right        := 2;
    lblMemberAge.Margins.Top          := 2;
    lblMemberAge.Margins.Bottom       := 2;

    lblMemberAgePlot                  := TLabel.Create(self);
    lblMemberAgePlot.Parent           := MemberGrid;
    lblMemberAgePlot.Name             := TMemberPanel.ClassName + 'lblMemberAgePlot'+ inttoStr(GMemberPanelNumber);
    lblMemberAgePlot.Align            := lblMemberAgePlot.Align.alClient;
    lblMemberAgePlot.Margins.Left     := 2;
    lblMemberAgePlot.Margins.Right    := 2;
    lblMemberAgePlot.Margins.Top      := 2;
    lblMemberAgePlot.Margins.Bottom   := 2;

    lblMemberBirthday                 := TLabel.Create(self);
    lblMemberBirthday.Parent          := MemberGrid;
    lblMemberBirthday.Name            := TMemberPanel.ClassName + 'lblMemberBirthday'+ inttoStr(GMemberPanelNumber);
    lblMemberBirthday.Align           := lblMemberBirthday.Align.alClient;
    lblMemberBirthday.Margins.Left    := 2;
    lblMemberBirthday.Margins.Right   := 2;
    lblMemberBirthday.Margins.Top     := 2;
    lblMemberBirthday.Margins.Bottom  := 2;

    lblMemberEntry                    := TLabel.Create(self);
    lblMemberEntry.Parent             := MemberGrid;
    lblMemberEntry.Name               := TMemberPanel.ClassName + 'lblMemberEntry'+ inttoStr(GMemberPanelNumber);
    lblMemberEntry.Align              := lblMemberEntry.Align.alClient;
    lblMemberEntry.Margins.Left       := 2;
    lblMemberEntry.Margins.Right      := 2;
    lblMemberEntry.Margins.Top        := 2;
    lblMemberEntry.Margins.Bottom     := 2;

    lblMemberExit                     := TLabel.Create(self);
    lblMemberExit.Parent              := MemberGrid;
    lblMemberExit.Name                := TMemberPanel.ClassName + 'lblMemberExit'+ inttoStr(GMemberPanelNumber);
    lblMemberExit.Align               := lblMemberExit.Align.alClient;
    lblMemberExit.Margins.Left        := 2;
    lblMemberExit.Margins.Right       := 2;
    lblMemberExit.Margins.Top         := 2;
    lblMemberExit.Margins.Bottom      := 2;

    editMemberNumber                  := TEdit.Create(self);
    editMemberNumber.Parent           := MemberGrid;
    editMemberNumber.Name             := TMemberPanel.ClassName + 'editMemberNumber'+ inttoStr(GMemberPanelNumber);
    editMemberNumber.Align            := editMemberNumber.Align.alClient;
    editMemberNumber.Margins.Left     := 2;
    editMemberNumber.Margins.Right    := 2;
    editMemberNumber.Margins.Top      := 2;
    editMemberNumber.Margins.Bottom   := 2;
    editMemberNumber.TabOrder         := 0;

    editMemberName                    := TEdit.Create(self);
    editMemberName.Parent             := MemberGrid;
    editMemberName.Name               := TMemberPanel.ClassName + 'editMemberName'+ inttoStr(GMemberPanelNumber);
    editMemberName.Align              := editMemberName.Align.alClient;
    editMemberName.Margins.Left       := 2;
    editMemberName.Margins.Right      := 2;
    editMemberName.Margins.Top        := 2;
    editMemberName.Margins.Bottom     := 2;
    editMemberName.TabOrder           := 1;

    editMemberSurname                 := TEdit.Create(self);
    editMemberSurname.Parent          := MemberGrid;
    editMemberSurname.Name            := TMemberPanel.ClassName + 'editMemberSurname'+ inttoStr(GMemberPanelNumber);
    editMemberSurname.Align           := editMemberSurname.Align.alClient;
    editMemberSurname.Margins.Left    := 2;
    editMemberSurname.Margins.Right   := 2;
    editMemberSurname.Margins.Top     := 2;
    editMemberSurname.Margins.Bottom  := 2;
    editMemberSurname.TabOrder        := 2;

    deMemberBirthday                  := TDateEdit.Create(self);
    deMemberBirthday.Parent           := MemberGrid;
    deMemberBirthday.Name             := TMemberPanel.ClassName + 'deMemberBirthday'+ inttoStr(GMemberPanelNumber);
    deMemberBirthday.Align            := deMemberBirthday.Align.alClient;
    deMemberBirthday.Margins.Left     := 2;
    deMemberBirthday.Margins.Right    := 2;
    deMemberBirthday.Margins.Top      := 2;
    deMemberBirthday.Margins.Bottom   := 2;
    deMemberBirthday.Date             := now;
    deMemberBirthday.TabOrder         := 3;

    deMemberEntry                     := TDateEdit.Create(self);
    deMemberEntry.Parent              := MemberGrid;
    deMemberEntry.Name                := TMemberPanel.ClassName + 'deMemberEntry'+ inttoStr(GMemberPanelNumber);
    deMemberEntry.Align               := deMemberEntry.Align.alClient;
    deMemberEntry.Margins.Left        := 2;
    deMemberEntry.Margins.Right       := 2;
    deMemberEntry.Margins.Top         := 2;
    deMemberEntry.Margins.Bottom      := 2;
    deMemberEntry.Date                := now;
    deMemberEntry.TabOrder            := 4;

    deMemberExit                      := TDateEdit.Create(self);
    deMemberExit.Parent               := MemberGrid;
    deMemberExit.Name                 := TMemberPanel.ClassName + 'deMemberExit'+ inttoStr(GMemberPanelNumber);
    deMemberExit.Align                := deMemberExit.Align.alClient;
    deMemberExit.Margins.Left         := 2;
    deMemberExit.Margins.Right        := 2;
    deMemberExit.Margins.Top          := 2;
    deMemberExit.Margins.Bottom       := 2;
    deMemberExit.Date                 := now;
    deMemberExit.TabOrder             := 5;

    btnMemberEdit                      := TMemberBtn.Create(self);
    btnMemberEdit.Parent               := MemberGrid;
    btnMemberEdit.Name                 := TMemberPanel.ClassName + 'btnMemberEdit'+ inttoStr(GMemberPanelNumber);
    btnMemberEdit.Align                := btnMemberEdit.Align.alClient;
    btnMemberEdit.Margins.Left         := 2;
    btnMemberEdit.Margins.Right        := 2;
    btnMemberEdit.Margins.Top          := 2;
    btnMemberEdit.Margins.Bottom       := 2;
    btnMemberEdit.StyleLookup          := 'composetoolbutton';
    btnMemberEdit.MemberButtonTask     := LMemberButtonTask.Edit;
    btnMemberEdit.Taborder             := 6;
    btnMemberEdit.onClick              := getMemberInput;

    btnMemberSafe                      := TMemberBtn.Create(self);
    btnMemberSafe.Parent               := MemberGrid;
    btnMemberSafe.Name                 := TMemberPanel.ClassName + 'btnMemberSafe'+ inttoStr(GMemberPanelNumber);
    btnMemberSafe.Align                := btnMemberSafe.Align.alClient;
    btnMemberSafe.Margins.Left         := 2;
    btnMemberSafe.Margins.Right        := 2;
    btnMemberSafe.Margins.Top          := 2;
    btnMemberSafe.Margins.Bottom       := 2;
    btnMemberSafe.MemberButtonTask     := LMemberButtonTask.Safe;
    btnMemberSafe.TabOrder             := 7;
    btnMemberSafe.onClick              := getMemberInput;

//    btnMemberSafe.StyleLookup          := 'composetoolbutton';

    btnMemberDiscard                   := TMemberBtn.Create(self);
    btnMemberDiscard.Parent            := MemberGrid;
    btnMemberDiscard.Name              := TMemberPanel.ClassName + 'btnMemberDiscard'+ inttoStr(GMemberPanelNumber);
    btnMemberDiscard.Align             := btnMemberDiscard.Align.alClient;
    btnMemberDiscard.Margins.Left      := 2;
    btnMemberDiscard.Margins.Right     := 2;
    btnMemberDiscard.Margins.Top       := 2;
    btnMemberDiscard.Margins.Bottom    := 2;
    btnMemberDiscard.MemberButtonTask  := LMemberButtonTask.Discard;
    btnMemberDiscard.TabOrder          := 8;
    btnMemberDiscard.onClick           := getMemberInput;
//    btnMemberSafe.StyleLookup          := 'composetoolbutton';

   MemberGrid.ControlCollection.BeginUpdate;
   MemberGrid.ControlCollection.Controls[0,0] := btnMemberEdit;
   MemberGrid.ControlCollection.Controls[0,2] := lblMemberNumber;
   MemberGrid.ControlCollection.Controls[1,2] := editMemberNumber;
   MemberGrid.ControlCollection.Controls[0,3] := lblMemberName;
   MemberGrid.ControlCollection.Controls[1,3] := editMemberName;
   MemberGrid.ControlCollection.Controls[0,4] := lblMemberSurname;
   MemberGrid.ControlCollection.Controls[1,4] := editMemberSurname;
   MemberGrid.ControlCollection.Controls[0,5] := lblMemberAge;
   MemberGrid.ControlCollection.Controls[1,5] := lblMemberAgePlot;
   MemberGrid.ControlCollection.Controls[0,6] := lblMemberBirthday;
   MemberGrid.ControlCollection.Controls[1,6] := deMemberBirthday;
   MemberGrid.ControlCollection.Controls[0,7] := lblMemberEntry;
   MemberGrid.ControlCollection.Controls[1,7] := deMemberEntry;
   MemberGrid.ControlCollection.Controls[0,8] := lblMemberExit;
   MemberGrid.ControlCollection.Controls[1,8] := deMemberExit;
   MemberGrid.ControlCollection.Controls[0,10] := btnMemberSafe;
   MemberGrid.ControlCollection.Controls[1,10] := btnMemberDiscard;
   MemberGrid.ControlCollection.EndUpdate;

 end;

  procedure TMemberPanel.getMemberInput(Sender: TObject);
  begin
   btnMemberSafe.ParameterString0 := editMemberNumber.Text;
   btnMemberSafe.ParameterString1 := editMemberName.Text;
   btnMemberSafe.ParameterString2 := editMemberSurname.Text;
   btnMemberEdit.ParameterString0 := editMemberNumber.Text;
   btnMemberEdit.ParameterString1 := editMemberName.Text;
   btnMemberEdit.ParameterString2 := editMemberSurname.Text;
   btnMemberDiscard.ParameterString0 := editMemberNumber.Text;
   btnMemberDiscard.ParameterString1 := editMemberName.Text;
   btnMemberDiscard.ParameterString2 := editMemberSurname.Text;
  end;
  //**************************************************************************

 { ****************************************************************************
                          TMemberGrid
 *****************************************************************************}
 constructor TMemberGrid.Create(AOwner: TComponent);
 var
  GridControl :  TColumnCollection;
 begin
    inherited create(aOwner);

    GridControl := TMemberGrid.TColumnCollection.Create(self);

 end;


 //*****************************************************************************

 { ****************************************************************************
                          TMemberBtn
 *****************************************************************************}
 constructor TMemberBtn.Create(AOwner: TComponent);
 begin

    inherited create(aOwner);

 end;

 procedure TMemberBtn.Click;
 begin
    inherited Click;
    if MemberButtonTask = 'safe'    then showMessage('save: '     + lParameterString0 );
    if MemberButtonTask = 'edit'    then showMessage('edit: '     + lParameterString1 );
    if MemberButtonTask = 'discard' then showMessage('discard: '  + lParameterString2 );
    if MemberButtonTask = 'delete'  then showMessage('delete: '   + lParameterString1 + ' ' + lParameterString2);
 end;

 //*****************************************************************************
end.
