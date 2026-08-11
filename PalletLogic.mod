MODULE PalletLogic
    !***********************************************************
    ! @file PalletLogic.mod
    ! @brief Modul sa glavnom logikom procesa paletiranja.
    !
    ! @details
    ! Ovaj modul sadrzi procedure i funkcije koje obradjuju
    ! korisnicki unos sa ScreenMaker HMI-ja, proveravaju ispravnost
    ! rasporeda kockica na paleti i biraju odgovarajuce pick/place
    ! putanje.
    !
    ! HMI ne pokrece direktno putanje robota, vec samo postavlja
    ! zahtevne promenljive kao sto su hmiAddReq, hmiResetReq i
    ! hmiStartReq. RAPID program zatim u proceduri HMI_Handler()
    ! obradjuje te zahteve i menja raspored palete.
    !
    ! Raspored palete se cuva u nizu cellColor, gde svaki element
    ! predstavlja jedno polje palete 3x3.
    !**********************************************************       
    
    
    !***********************************************************
    ! @brief Vraca tekstualni naziv boje na osnovu numericke oznake.
    !
    ! @details
    ! Funkcija prevodi numericku vrednost boje u tekst koji se
    ! koristi za ispis statusnih poruka na ScreenMaker HMI-ju i
    ! FlexPendant-u.
    !
    ! Vrednosti:
    ! - 1: crvena
    ! - 2: zuta
    ! - 3: zelena
    !
    ! @param color Numericka oznaka boje.
    ! @return Tekstualni naziv boje.
    !***********************************************************
    FUNC string ColorToStr(num color)
        TEST color
        CASE 1:
            RETURN "crvena";
        CASE 2:
            RETURN "zuta";
        CASE 3:
            RETURN "zelena";
        DEFAULT:
            RETURN "nepoznata";
        ENDTEST

    ENDFUNC


    !***********************************************************
    ! @brief Dodaje jednu kockicu u raspored palete.
    !
    ! @details
    ! Procedura se poziva kada korisnik na HMI ekranu izabere
    ! boju i poziciju, a zatim aktivira DODAJ zahtev.
    !
    ! Najpre se proverava da li je pozicija u opsegu 1-9, zatim
    ! da li je boja u opsegu 1-3. Nakon toga se proverava da li
    ! je izabrana pozicija vec zauzeta. Ako je pozicija prazna,
    ! u niz cellColor se upisuje izabrana boja.
    !
    ! Na ovaj nacin se obezbedjuje da u okviru jednog ciklusa
    ! na isto polje palete ne mogu biti unete dve razlicite boje.
    !
    ! @param color Izabrana boja kockice.
    ! @param cell Izabrana pozicija na paleti.
    !***********************************************************
     PROC AddCell(num color, num cell)
        IF cell < 1 OR cell > 9 THEN
            SetStatus "Greska: pozicija mora biti 1-9.";
            RETURN;
        ENDIF
    
        IF color < 1 OR color > 3 THEN
            SetStatus "Greska: boja mora biti 1-crvena, 2-zuta ili 3-zelena.";
            RETURN;
        ENDIF        
    
        IF cellColor{cell} <> 0 THEN
            SetStatus "Greska: pozicija " + NumToStr(cell,0) + " je vec zauzeta.";
            RETURN;
        ENDIF
    
        cellColor{cell} := color;
        SetStatus "Dodato: " + ColorToStr(color) + " na poziciju " + NumToStr(cell,0) + ".";
    
    ENDPROC


    !***********************************************************
    ! @brief Resetuje raspored palete i HMI zahteve.
    !
    ! @details
    ! Procedura postavlja sve elemente niza cellColor na nulu,
    ! cime se sva polja palete oznacavaju kao prazna. Takodje
    ! resetuje pomocne HMI promenljive i zahteve koji dolaze sa
    ! ScreenMaker ekrana.
    !
    ! Poziva se na pocetku svakog novog ciklusa i kada korisnik
    ! aktivira RESET zahtev.
    !***********************************************************
    PROC ResetPattern()
        VAR num i;
    
        FOR i FROM 1 TO 9 DO
            cellColor{i} := 0;
        ENDFOR
    
        hmiColor := 0;
        hmiCell := 0;
    
        hmiAddReq := FALSE;
        hmiResetReq := FALSE;
        hmiStartReq := FALSE;
        hmiReplaceReq := FALSE;
       
        addSwitchLatch := FALSE;
        resetSwitchLatch := FALSE;
        replaceSwitchLatch := FALSE;
        
        SetStatus "RESET: sva polja su obrisana.";
    ENDPROC


    !***********************************************************
    ! @brief Proverava da li je uneti raspored validan.
    !
    ! @details
    ! Funkcija proverava uslov zadatka da se svaka boja mora
    ! pojaviti na paleti barem jednom. Raspored je validan samo
    ! ako postoji najmanje jedna crvena, jedna zuta i jedna zelena
    ! kockica.
    !
    ! @return TRUE ako je raspored validan, u suprotnom FALSE.
    !***********************************************************
    FUNC bool IsPatternValid()
        VAR num i;
        VAR bool hasRed := FALSE;
        VAR bool hasYellow := FALSE;
        VAR bool hasGreen := FALSE;

        FOR i FROM 1 TO 9 DO
            IF cellColor{i} = 1 THEN
                hasRed := TRUE;
            ENDIF

            IF cellColor{i} = 2 THEN
                hasYellow := TRUE;
            ENDIF

            IF cellColor{i} = 3 THEN
                hasGreen := TRUE;
            ENDIF
        ENDFOR

        RETURN hasRed AND hasYellow AND hasGreen;
    ENDFUNC


    !***********************************************************
    ! @brief Obradjuje zahteve koji dolaze sa HMI ekrana.
    !
    ! @details
    ! Procedura proverava stanje HMI zahtevnih promenljivih:
    ! hmiAddReq i hmiResetReq. Posto se na ScreenMaker ekranu
    ! koriste Switch kontrole, uvedene su latch promenljive koje
    ! sprecavaju da se isti zahtev obradi vise puta dok je Switch
    ! ukljucen.
    !
    ! Kada se detektuje zahtev za dodavanje, poziva se AddCell().
    ! Kada se detektuje zahtev za reset, poziva se ResetPattern().
    !
    ! Ova procedura se periodicno poziva dok program ceka da
    ! korisnik zavrsi unos rasporeda.
    !***********************************************************
    PROC HMI_Handler()
        ! RESET switch - obradi samo jednom dok je switch ukljucen
        IF hmiResetReq AND (NOT resetSwitchLatch) THEN
            resetSwitchLatch := TRUE;
            ResetPattern;
        ENDIF
    
        IF NOT hmiResetReq THEN
            resetSwitchLatch := FALSE;
        ENDIF
    
        ! DODAJ switch - obradi samo jednom dok je switch ukljucen
        IF hmiAddReq AND (NOT addSwitchLatch) THEN
            addSwitchLatch := TRUE;
            AddCell hmiColor, hmiCell;
        ENDIF
    
        IF NOT hmiAddReq THEN
            addSwitchLatch := FALSE;
        ENDIF
        
        ! ZAMENI swith - obradi samo jednom dok je switch ukljucen
        IF hmiReplaceReq AND (NOT replaceSwitchLatch) THEN
            replaceSwitchLatch := TRUE;
            ReplaceCell hmiColor, hmiCell;
        ENDIF
        
        IF NOT hmiReplaceReq THEN
            replaceSwitchLatch := FALSE;
        ENDIF
    ENDPROC

    !***********************************************************
    ! @brief Bira odgovarajucu pick putanju na osnovu boje.
    !
    ! @details
    ! U zavisnosti od numericke oznake boje, procedura poziva
    ! odgovarajucu putanju za uzimanje kockice iz odgovarajuceg
    ! magacina.
    !
    ! Vrednosti:
    ! - 1: Path_PickRed
    ! - 2: Path_PickYellow
    ! - 3: Path_PickGreen
    !
    ! @param color Boja kockice koju robot treba da uzme.
    !***********************************************************
    PROC PickCube(num color)
        TEST color
        CASE 1:
            Path_PickRed;

        CASE 2:
            Path_PickYellow;

        CASE 3:
            Path_PickGreen;

        DEFAULT:
            SetStatus "Greska: nepoznata boja u PickCube.";
        ENDTEST
    ENDPROC


    !***********************************************************
    ! @brief Bira odgovarajucu place putanju na osnovu pozicije.
    !
    ! @details
    ! U zavisnosti od indeksa polja palete, procedura poziva
    ! odgovarajucu putanju za odlaganje kockice na paletu.
    !
    ! Pozicije su numerisane od 1 do 9 i odgovaraju poljima
    ! palete dimenzija 3x3.
    !
    ! @param cell Pozicija na paleti na koju treba odloziti kockicu.
    !***********************************************************
    PROC PlaceCube(num cell)
        TEST cell
        CASE 1:
            Path_PlaceCell01;

        CASE 2:
            Path_PlaceCell02;

        CASE 3:
            Path_PlaceCell03;

        CASE 4:
            Path_PlaceCell04;

        CASE 5:
            Path_PlaceCell05;

        CASE 6:
            Path_PlaceCell06;

        CASE 7:
            Path_PlaceCell07;

        CASE 8:
            Path_PlaceCell08;

        CASE 9:
            Path_PlaceCell09;

        DEFAULT:
            SetStatus "Greska: nepoznata pozicija u PlaceCube.";
        ENDTEST

    ENDPROC
   
    PROC ReplaceCell(num color, num cell)
        IF cell < 1 OR cell > 9 THEN
            SetStatus "Greska: pozicija mora biti 1-9.";
            RETURN;
        ENDIF
    
        IF color < 1 OR color > 3 THEN
            SetStatus "Greska: boja mora biti 1-crvena, 2-zuta ili 3-zelena.";
            RETURN;
        ENDIF
    
        IF cellColor{cell} = 0 THEN
            cellColor{cell} := color;
            SetStatus "Polje je bilo prazno. Dodato: " + ColorToStr(color) + " na poziciju " + NumToStr(cell,0) + ".";
        ELSE
            cellColor{cell} := color;
            SetStatus "Zamenjeno: " + ColorToStr(color) + " na poziciji " + NumToStr(cell,0) + ".";
        ENDIF
    ENDPROC
    
    !***********************************************************
    ! @brief Izvrsava kompletan proces paletiranja.
    !
    ! @details
    ! Procedura prolazi kroz svih 9 pozicija palete. Ako je
    ! odredjeno polje popunjeno, najpre se poziva PickCube()
    ! za odgovarajucu boju, a zatim PlaceCube() za odgovarajucu
    ! poziciju.
    !
    ! Na ovaj nacin se raspored koji je korisnik uneo preko HMI-ja
    ! pretvara u niz robotskih pick/place operacija.
    !***********************************************************
    PROC Palletize()
        VAR num i;

        FOR i FROM 1 TO 9 DO

            IF cellColor{i} <> 0 THEN
                SetStatus "Paletiranje: " + ColorToStr(cellColor{i}) + " na poziciju " + NumToStr(i,0) + ".";

                PickCube cellColor{i};
                PlaceCube i;
                
                ! Kratko zadrzavanje u bezbednoj tacki iznad palete 
                ! pre odlaska na sledecu pick operaciju. 
                WaitTime \InPos, 0.5;
            ENDIF

        ENDFOR

        SetStatus "Paletiranje zavrseno.";

    ENDPROC
    
    !***********************************************************
    ! @brief Postavlja statusnu poruku procesa.
    !
    ! @details
    ! Procedura upisuje prosledjenu poruku u promenljivu hmiStatus,
    ! koja se prikazuje na ScreenMaker HMI ekranu. Ista poruka se
    ! dodatno ispisuje pomocu TPWrite instrukcije na FlexPendant-u,
    ! sto olaksava pracenje toka programa i debugovanje.
    !
    ! @param msg Tekst statusne poruke.
    !***********************************************************
    PROC SetStatus(string msg)
        hmiStatus := msg;
        TPWrite msg;
    ENDPROC
ENDMODULE