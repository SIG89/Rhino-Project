use db_rhino
go

if not exists (select * from dbo.sysobjects where id = object_id(N'sp_00_Mitglied_Insert') and objectproperty(id, N'IsProcedure') = 1)
  execute ('create procedure sp_00_Mitglied_Insert as begin return end')
go

-- Protokollausgabe
print 'Anlegen der gespeicherten Prozedur <' + db_name() + '..sp_00_Mitglied_Insert>'
go

/* -- Testaufruf
declare @nError int, @szError nvarchar(200)
exec db_rhino..sp_00_Mitglied_Insert
		   @paramchr_MemberNr               = 'TestMember'				
		,  @paramchr_MemberName             = 'TestNachname'			
		,  @paramchr_MemberVorname          = 'TestVorname'		
		,  @paramchr_MemberGeburtstag	      = getdate()	
		,  @paramint_MemberAlter		      	= 0
		,  @paramchr_MemberEintritt	        = getdate()	
		,  @paramchr_MemberAustritt		      = getdate()
		,  @paramint_MemberRolle	          = 0		
		,  @paramint_MemberStatus           = 1					
    ,  @intError                        = @intError output
    ,  @vchError                        = @vchError output
    ,  @bDebug                          = 1
select [@intError]  = @intError
     , [@szError] = @szError
*/
alter procedure sp_00_Mitglied_Insert
		  @paramchr_MemberNr 			  nvarchar(20)                  -- Mitgliedernummer
		, @paramchr_MemberName 		      nvarchar(25)                  -- Nachname des Mitgliedes
		, @paramchr_MemberVorname 		  nvarchar(25)                  -- Vorname des Mitgliedes
		, @paramchr_MemberGeburtstag	  nvarchar(25)                  -- Geburtsdatum des Mitgliedes
		, @paramint_MemberAlter			  integer                       -- Alter des Mitgliedes
		, @paramchr_MemberEintritt		  nvarchar(25)                  -- Eintrittsdatum in dem Verein
		, @paramchr_MemberAustritt		  nvarchar(25)                  -- Austrittsdatum aus dem Verein
		, @paramint_MemberRolle			  integer                       -- Rolle im Verein
		, @paramint_MemberStatus		  integer                       -- Status ob aktiv oder inaktiv

		, @bNoResultset                 int = 0                       -- <> 0: kein Resultset ausgeben
		, @intError                     int = 0             output    -- Fehlernummer
		, @vchError                     nvarchar(max) = N'' output    -- Fehlerbeschreibung
		, @bDebug                       int = 0                       -- <> 0: Debug-Ausgabe erzeugen
as
/********************************************************************************
  Name     : sp_00_Mitglied_Insert

  Aufgabe  : Prozedur bekommt Parameter übergeben und legt ein neues Vereinsmitglied in der
             Datenbank an
                
  Parameter:      @paramchr_MemberNr 					nvarchar(20)                  -- Mitgliedernummer
		            , @paramchr_MemberName 				nvarchar(25)                  -- Nachname des Mitgliedes
		            , @paramchr_MemberVorname 			nvarchar(25)                  -- Vorname des Mitgliedes
		            , @paramchr_MemberGeburtstag		nvarchar(25)                  -- Geburtsdatum des Mitgliedes
		            , @paramint_MemberAlter			    integer                       -- Alter des Mitgliedes
		            , @paramchr_MemberEintritt			nvarchar(25)                  -- Eintrittsdatum in dem Verein
		            , @paramchr_MemberAustritt			nvarchar(25)                  -- Austrittsdatum aus dem Verein
		            , @paramint_MemberRolle			    integer                       -- Rolle im Verein
		            , @paramint_MemberStatus			integer                       -- Status ob aktiv oder inaktiv

					, @bNoResultset                 int = 0                       -- <> 0: kein Resultset ausgeben
					, @intError                     int = 0             output    -- Fehlernummer
					, @vchError                     nvarchar(max) = N'' output    -- Fehlerbeschreibung
					, @bDebug                       int = 0                       -- <> 0: Debug-Ausgabe erzeugen
    
  Returns  : (...)
             @intError:  0 - Erfolgreich abgeschlossen
             @vchError     - Fehlerbeschreibung

  Hinweise : (...)

    
  Historie :    20180415    Erstellt

********************************************************************************/
begin

  -- Einstellungen
  set rowcount 0
  set nocount on

  -- Name der Prozedur
  declare @szModule sysname
  select @szModule = object_name (@@procid)

/*DEBUG_Ausgabe START*/
if not @bDebug = 0 begin
  declare @dtStartZeit datetime
  set @dtStartZeit = getdate()

  print N'==========================================='
  print N'START ' + @szModule + N': ' + convert(nvarchar(max),getdate(), 121)
  print N''
  print N'[!] Uebergabeparameter von Delphi Tokyo:'
  print N'  @paramchr_MemberNr          = ' + dbo.fn_RhinoDebugPrint(@paramchr_MemberNr)
  print N'  @paramchr_MemberName        = ' + dbo.fn_RhinoDebugPrint(@paramchr_MemberName)
  print N'  @paramchr_MemberVorname     = ' + dbo.fn_RhinoDebugPrint(@paramchr_MemberVorname)
  print N'  @paramchr_MemberGeburtstag  = ' + dbo.fn_RhinoDebugPrint_DateTime(@paramchr_MemberGeburtstag, 20)
  print N'  @paramint_MemberAlter       = ' + dbo.fn_RhinoDebugPrint(@paramint_MemberAlter)
  print N'  @paramchr_MemberEintritt    = ' + dbo.fn_RhinoDebugPrint_DateTime(@paramchr_MemberEintritt, 20)
  print N'  @paramchr_MemberAustritt    = ' + dbo.fn_RhinoDebugPrint_DateTime(@paramchr_MemberAustritt, 20)
  print N'  @paramint_MemberRolle       = ' + dbo.fn_RhinoDebugPrint(@paramint_MemberRolle)
  print N'  @paramint_MemberStatus      = ' + dbo.fn_RhinoDebugPrint(@paramint_MemberStatus)
end
/*DEBUG_Ausgabe ENDE*/

  if @intError <> 0
    return
  set @intError = 0

  /********************************************************************
                       Variablen und Konstanten
  ********************************************************************/
declare		@tblErrorLog table (logTime nvarchar(max), ErrorNr int, Errortext nvarchar(max))
declare				@dt_MemberGeburtstag      date
		      , 	@dt_MemberEintrittsdatum  date
		      , 	@dt_MemberAustrittsdatum  date
  /********************************************************************
                       Transaktionshandling
  ********************************************************************/
  -- kein Transaktionshandling notwendig
  /********************************************************************
            Übergabeparameter abfragen und Fehler abfangen
  ********************************************************************/
  if isnull(@paramchr_MemberNr, N'') = N''
  begin
    select @intError  = 1, @vchError   = N'der Prozedur wurde keine Mitgliedernummer übergeben'
	insert @tblErrorLog values (convert(nvarchar(max),getdate(),121),@intError,@vchError)
  end

  if isnull(@paramchr_MemberName, N'') = N''
  begin
    select @intError  = 2, @vchError   = N'der Prozedur wurde kein Nachname des Mitgliedes übergeben'
	insert @tblErrorLog values (convert(nvarchar(max),getdate(),121),@intError,@vchError)
  end

  if isnull(@paramchr_MemberVorname, N'') = N''
  begin
    select @intError  = 3, @vchError   = N'der Prozedur wurde kein Vorname des Mitgliedes übergeben'
	insert @tblErrorLog values (convert(nvarchar(max),getdate(),121),@intError,@vchError)
  end

  if isnull(@paramchr_MemberGeburtstag, N'') = N''
  begin
    select @intError  = 4, @vchError   = N'der Prozedur wurde kein Geburtsdatum des Mitgliedes übergeben'
	insert @tblErrorLog values (convert(nvarchar(max),getdate(),121),@intError,@vchError)
  end

  if @intError<>0
  begin
	goto sp_error
  end
  /********************************************************************
                       Hauptteil der Prozedur
  ********************************************************************/

	set @dt_MemberGeburtstag 		= convert(date, @paramchr_MemberGeburtstag)
	set @dt_MemberEintrittsdatum	= convert(date, @paramchr_MemberEintritt)
	set @dt_MemberAustrittsdatum	= convert(date, @paramchr_MemberAustritt)

  if not exists(select chr_MitgliederNummer from tblMitglied where chr_MitgliederNummer = @paramchr_MemberNr)
		begin
			insert into tblMitglied 		(
					chr_MitgliederNummer
				,	vch_Vorname
				,	vch_Nachname
				,	dat_Geburtsdatum
				,	int_Alter
				,	dt_Eintrittsdatum
				,	dt_Austrittsdatum
				,	int_Status
				,	int_Rolle
										)
                                                    
			values							(
					@paramchr_MemberNr
				,	@paramchr_MemberVorname
				,	@paramchr_MemberName 			
				,	@dt_MemberGeburtstag		
				,	@paramint_MemberAlter			
				,	@dt_MemberEintrittsdatum		
				,	@dt_MemberAustrittsdatum		
				,	@paramint_MemberStatus
				,	@paramint_MemberRolle					
											)
			set @intError = 0
		end --if not exists(select chr_MitgliederNummer from tblMitglied where chr_MitgliederNummer = @paramchr_MemberNr)
else --if not exists(select chr_MitgliederNummer from tblMitglied where chr_MitgliederNummer = @paramchr_MemberNr)
  begin
        set @intError = 5
        set @vchError = 'Das Mitglied existiert bereits in der Datenbank'
		insert @tblErrorLog values (convert(nvarchar(max),getdate(),121),@intError,@vchError)
		goto sp_error
  end --else --if not exists(select chr_MitgliederNummer from tblMitglied where chr_MitgliederNummer = @paramchr_MemberNr)

  /********************************************************************
                        Ende der Prozedur
  ********************************************************************/
  select @intError  = 0
       , @vchError  = N'Mitglied wurde erfolgreich angelegt'

  /********************************************************************
                        Prozedurabschluss
  ********************************************************************/
  sp_exit:

    -- Resultset bilden
    if @bNoResultset = 0 begin
      select [@intError]  =   isnull(@intError, 0)
           , [@vchError]  =   isnull(@vchError, 0)
    end

/*DEBUG_Ausgabe START*/
if not @bDebug = 0 begin
  print N''
  print N' Einstellungen'
  print N'==========================================='
  print N'  @bDebug                     = ' + dbo.fn_RhinoDebugPrint(@bDebug)
  print N'  @bNoResultset               = ' + dbo.fn_RhinoDebugPrint(@bNoResultset)
  print N'ENDE ' + @szModule + N': ' + convert(nvarchar(max),getdate(), 121)
  print N'==========================================='
end
/*DEBUG_Ausgabe ENDE*/

    return

  sp_error:
  if not @bDebug = 0 begin
  print N'==========================================='
  print N'Ausgabe aus dem ErrorLog'

  declare curErrorLog cursor for select logTime, ErrorNr,Errortext from @tblErrorLog
  declare @logTime nvarchar(max), @ErrorNr int, @Errortext nvarchar(max), @count int = 1

  open curErrorLog
  fetch next from curErrorLog into @logTime, @ErrorNr, @Errortext
  while @@FETCH_STATUS = 0
  begin
		print convert(nvarchar(max), @count) + N'. LogTime: ' + @logTime + ' -- ' 
		+ 'Error Number: ' + convert(nvarchar(max),@ErrorNr) + ' -- '
		+ 'Error Text: ' + @Errortext
		set @count = @count +1
  fetch next from curErrorLog into @logTime, @ErrorNr, @Errortext
  end
  close curErrorLog
  deallocate curErrorLog

    goto sp_exit

	end
end
go
