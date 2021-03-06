unit Database;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Data.DB, MemDS,
  DBAccess, Uni, UniProvider, MySQLUniProvider, FMX.Controls.Presentation,
  FMX.StdCtrls, Declarations,
  System.Generics.Collections, FMX.ListView, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.DateTimeCtrls,
  SQLServerUniProvider ;
  // Model.ProSu.Interfaces, Model.ProSu.Provider,

type
  TDBForm = class(TForm)
    RhinoConnect: TUniConnection;
    MySQLUniProvider1: TMySQLUniProvider;
    Query: TUniQuery;
    UniSP: TUniStoredProc;
    Button1: TButton;
    ListView1: TListView;
    Button2: TButton;
    Label1: TLabel;
    sp: TUniStoredProc;
    DateEdit1: TDateEdit;
    SQLServerUniProvider1: TSQLServerUniProvider;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private-Deklarationen }
    //fProvider   : IProviderInterface;
    fMember     : TMember;
    fMemberList : TObjectList<TMember>;
    fTrainer    : TTrainer;
    fTrainers   : TObjectList<TTrainer>;
  public
    { Public-Deklarationen }
    function getMember  : TObjectList<TMember>;
    function getTrainer : TObjectList<TTrainer>;
    procedure DBConnect;
//    procedure getMemberDetails(id : integer);
    procedure createNewMember(newMember : TMember);
    procedure editNewMember(newMember : TMember);
    procedure deleteMember( Mitgliedernummer  : String
                          ; Nachname          : String
                          ; Vorname           : String
                          );
    //property Provider: IProviderInterface read fProvider;
  end;

var
  Form1: TDBForm;

implementation

//uses Model.ProSu.InterfaceActions;

{$R *.fmx}

procedure TDBForm.Button1Click(Sender: TObject);
var
  Member  : TMember;
begin
  Member := fMemberList.Items[0] as TMember;
  showMessage(  Member.MemberNr
              + ' ' + Member.Name
              + ' ' + Member.Surname
              + ' ' + dateToStr(Member.Birthday)
              + ' ' + intToStr(Member.Age)
              + ' ' + dateToStr(Member.Entry)
              + ' ' + dateToStr(Member.Leaving)
              + ' ' + inttoStr(Member.Role)
              + ' ' + inttostr(Member.State)
              );

end;

procedure TDBForm.deleteMember(Mitgliedernummer: string; Nachname: string; Vorname: string);
begin
    with unisp do
        begin
          Connection      := RhinoConnect;
          StoredProcName  := 'sp_00_Mitglied_Delete' ;
          PrepareSQL;
          ParamByName('paramchr_MemberNr').AsString           := Mitgliedernummer;
          ParamByName('paramchr_MemberName').AsString         := Nachname;
          ParamByName('paramchr_MemberVorname').AsString      := Vorname;
          Execute;
        end;
      if unisp.ParamByName('intError').AsInteger <> 0 then
      begin
        showMessage(unisp.ParamByName('vchError').AsString);
      end
    else
      begin
        showMessage('Eintrag erfolgreich gel�scht');
      end;
end;

procedure TDBForm.createNewMember(newMember: TMember);
begin
// Testaufruf des �bergebenen Members aus der View
{
        showmessage(  'Nummer: '        + newMember.MemberNr
                + ' Name: '         + newMember.Name
                + ' Vorname: '      + newMember.Surname
                + ' Geburtstag: '   + newMember.Birthday
                + ' Alter: '        + inttostr(newMember.Age)
                + ' Eintritt: '     + newMember.Entry
                + ' Austritt: '     + newMember.Leaving
                + ' Status '        + inttostr(newMember.State)
                + ' Rolle '         + inttostr(newMember.Role)
                  )
}
    with unisp do
    begin
      Connection      := RhinoConnect;
      StoredProcName  := 'sp_00_Mitglied_Insert' ;
      PrepareSQL;
      ParamByName('paramchr_MemberNr').AsString           := newMember.MemberNr;
      ParamByName('paramchr_MemberName').AsString         := newMember.Name;
      ParamByName('paramchr_MemberVorname').AsString      := newMember.Surname;
      ParamByName('paramchr_MemberGeburtstag').AsString   := formatDateTime('yyyy-mm-dd',newMember.Birthday);
      ParamByName('paramint_MemberAlter').AsInteger       := newMember.Age;
      ParamByName('paramchr_MemberEintritt').AsString     := formatDateTime('yyyy-mm-dd',newMember.Entry);
      ParamByName('paramchr_MemberAustritt').AsString     := formatDateTime('yyyy-mm-dd',newMember.Leaving);
      ParamByName('paramint_MemberRolle').AsInteger       := newMember.Role;
      ParamByName('paramint_MemberStatus').AsInteger      := newMember.State;
      ParamByName('paramchr_MemberStadt').AsString        := newMember.Stadt;
      ParamByName('paramchr_MemberStrasse').AsString      := newMember.Stra�e;
      ParamByName('paramchr_MemberStrNummer').AsInteger   := newMember.Nummer;
      ParamByName('paramchr_MemberPlz').AsString          := newMember.plz;
      ParamByName('paramchr_MemberTelefon').AsString      := newMember.Telefon;
      ParamByName('paramchr_MemberMobil').AsString        := newMember.Mobil;
      ParamByName('paramchr_MemberMail').AsString         := newMember.Mobil;
      Execute;
    end;

    if unisp.ParamByName('intError').AsInteger <> 0 then
      begin
        showMessage(unisp.ParamByName('vchError').AsString);
      end
    else
      begin
        showMessage('Eintrag erfolgreich angelegt');
      end;
end;

procedure TDBForm.editNewMember(newMember: TMember);
begin
    with unisp do
    begin
      Connection      := RhinoConnect;
      StoredProcName  := 'sp_00_Mitglied_Edit' ;
      PrepareSQL;
      ParamByName('paramchr_MemberNr').AsString           := newMember.MemberNr;
      ParamByName('paramchr_MemberName').AsString         := newMember.Name;
      ParamByName('paramchr_MemberVorname').AsString      := newMember.Surname;
      ParamByName('paramchr_MemberGeburtstag').AsString   := formatDateTime('yyyy-mm-dd',newMember.Birthday);
      ParamByName('paramint_MemberAlter').AsInteger       := newMember.Age;
      ParamByName('paramchr_MemberEintritt').AsString     := formatDateTime('yyyy-mm-dd',newMember.Entry);
      ParamByName('paramchr_MemberAustritt').AsString     := formatDateTime('yyyy-mm-dd',newMember.Leaving);
      ParamByName('paramint_MemberRolle').AsInteger       := newMember.Role;
      ParamByName('paramint_MemberStatus').AsInteger      := newMember.State;
      ParamByName('paramchr_MemberStadt').AsString        := newMember.Stadt;
      ParamByName('paramchr_MemberStrasse').AsString      := newMember.Stra�e;
      ParamByName('paramchr_MemberStrNummer').AsInteger   := newMember.Nummer;
      ParamByName('paramchr_MemberPlz').AsString          := newMember.plz;
      ParamByName('paramchr_MemberTelefon').AsString      := newMember.Telefon;
      ParamByName('paramchr_MemberMobil').AsString        := newMember.Mobil;
      ParamByName('paramchr_MemberMail').AsString         := newMember.Mail;
      Execute;
    end;

    if unisp.ParamByName('intError').AsInteger <> 0 then
      begin
        showMessage(unisp.ParamByName('vchError').AsString);
      end
    else
      begin
        showMessage('beim bearbeiten des Eintrages ist ein Fehler aufgetreten');
      end;
end;
{
procedure TDBForm.getMemberDetails(id : integer);
var
  tmpNotificationClass  : TNotificationClass;
  Member                : TMember;
  I: Integer;
  LItem     : TListViewItem;
  tmpMember : TMember;
  index     : integer;
begin
  getMember;
  Member := fMemberList.Items[id] as TMember;
  tmpNotificationClass := TNotificationClass.Create;
  try
    tmpNotificationClass.Actions            := [actMemberSet];
    tmpNotificationClass.fMemberNummer      :=  Member.MemberNr;
    tmpNotificationClass.fMemberNachname    :=  Member.Name;
    tmpNotificationClass.fMemberVorname     :=  Member.Surname;
    tmpNotificationClass.fMemberGeburtstag  :=  Member.Birthday;
    tmpNotificationClass.fMemberAlter       :=  Member.Age;
    tmpNotificationClass.fMemberEintritt    :=  Member.Entry;
    tmpNotificationClass.fMemberAustritt    :=  Member.Leaving;
    tmpNotificationClass.fMemberRolle       :=  Member.Role;
    tmpNotificationClass.fMemberStatus      :=  Member.State;
    tmpNotificationClass.fMemberStadt       :=  Member.Stadt;
    tmpNotificationClass.fMemberStra�e      :=  Member.Stra�e;
    tmpNotificationClass.fMemberStrNummer   :=  Member.Nummer;
    tmpNotificationClass.fMemberplz         :=  Member.plz;
    tmpNotificationClass.fMemberTelefon     :=  Member.Telefon;
    tmpNotificationClass.fMemberMobil       :=  Member.Mobil;
    tmpNotificationClass.fMemberMail        :=  Member.Mail;
    fProvider.NotifySubscribers(tmpNotificationClass);
  finally
    tmpNotificationClass.free;
  end;

end;
}
function TDBForm.getMember : TObjectList<TMember>;
var
  i: Integer;
  tmpMember : TMember;
begin
// nur f�r Testzwecke getrennt von der Datenbank
  {
  for i := 0 to 10 do
    begin
       tmpMember                := TMember.Create;
       tmpMember.MemberNr       := 'T00000' + inttostr(i);
       tmpMember.Name           := 'TestName ' + inttostr(i);
       tmpMember.Surname        := 'TestSurname ' + inttostr(i);
       tmpMember.Age            := 1;
       tmpMember.State          := 1;
       tmpMember.Role           := 3;
       fMemberList.Add(tmpMember);
    end;
   }
      fMemberList.Clear;
      with unisp do
      begin
      Connection      := RhinoConnect;
      StoredProcName  := 'sp_00_Mitglied_GetAll' ;
      PrepareSQL;
      Execute;
      First;
      while not unisp.eof do
        begin
          tmpMember                := TMember.Create;
          tmpMember.MemberNr       := unisp.FieldByName('Mitgliedernummer').AsString;
          tmpMember.Name           := unisp.FieldByName('Nachname').AsString;
          tmpMember.Surname        := unisp.FieldByName('Vorname').AsString;
          tmpMember.Birthday       := unisp.FieldByName('Geburtsdatum').AsDateTime;
          tmpMember.Age            := unisp.FieldByName('intAlter').AsInteger;
          tmpMember.State          := unisp.FieldByName('intStatus').AsInteger;
          tmpMember.Role           := unisp.FieldByName('intRolle').AsInteger;
          tmpMember.Entry          := unisp.FieldByName('Eintritt').AsDateTime;
          tmpMember.Leaving        := unisp.FieldByName('Austritt').AsDateTime;
          tmpMember.Stadt          := unisp.FieldByName('Stadt').AsString;
          tmpMember.Stra�e         := unisp.FieldByName('Strasse').AsString;
          tmpMember.Nummer         := unisp.FieldByName('Nummer').AsInteger;
          tmpMember.plz            := unisp.FieldByName('plz').AsString;
          tmpMember.Telefon        := unisp.FieldByName('Telefon').AsString;
          tmpMember.Mobil          := unisp.FieldByName('Mobil').AsString;
          tmpMember.Mail           := unisp.FieldByName('Mail').AsString;
          fMemberList.Add(tmpMember);
          unisp.Next;
        end;
      Close;
      end;
    result := fMemberList;
end;

function TDBForm.getTrainer : TObjectList<TTrainer>;
var
  i: Integer;
  tmpTrainer : TTrainer;
begin
// nur f�r Testzwecke getrennt von der Datenbank
  {
  for i := 0 to 10 do
    begin
       tmpMember                := TMember.Create;
       tmpMember.MemberNr       := 'T00000' + inttostr(i);
       tmpMember.Name           := 'TestName ' + inttostr(i);
       tmpMember.Surname        := 'TestSurname ' + inttostr(i);
       tmpMember.Age            := 1;
       tmpMember.State          := 1;
       tmpMember.Role           := 3;
       fMemberList.Add(tmpMember);
    end;
   }
      fTrainers.Clear;
      with unisp do
      begin
      Connection      := RhinoConnect;
      StoredProcName  := 'sp_01_Trainer_GetAll' ;
      PrepareSQL;
      Execute;
      First;
      while not unisp.eof do
        begin
          tmpTrainer                      := TTrainer.Create;
          tmpTrainer.Mitgliedernummer     := unisp.FieldByName('Mitgliedernummer').AsString;
          tmpTrainer.Name                 := unisp.FieldByName('Nachname').AsString;
          tmpTrainer.Vorname              := unisp.FieldByName('Vorname').AsString;
          {
          tmpTrainer.Trainerscheinnummer  := unisp.FieldByName('Trainerscheinnummer').AsString;
          tmpTrainer.Scheinkennung        := unisp.FieldByName('Trainerscheinkennung').AsString;
          tmpTrainer.Ausstellungsdatum    := unisp.FieldByName('Ausstellungsdatum').AsDateTime;
          tmpTrainer.Ablaufdatum          := unisp.FieldByName('Ablaufdatum').AsDateTime;
          tmpTrainer.G�ltigkeit           := unisp.FieldByName('G�ltigkeit').AsInteger;
          tmpTrainer.Beschreibung         := unisp.FieldByName('Beschreibung').AsString;
          }
          fTrainers.Add(tmpTrainer);
          unisp.Next;
        end;
      Close;
      end;
    result := fTrainers;
end;

procedure TDBForm.DBConnect;
begin
     // #CODE connection hardcodieren f�r SQL Server
    //showmessage('es geht los');
end;

procedure TDBForm.FormCreate(Sender: TObject);
begin
     // fProvider := TProSuProvider.Create;
      fMemberList := TObjectList<TMember>.Create;
      fTrainers := TObjectList<TTrainer>.Create;
end;

end.
