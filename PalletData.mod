MODULE PalletData
    !***********************************************************
    ! @file PalletData.mod
    ! @brief Modul sa procesnim i HMI promenljivama za paletiranje.
    !
    ! @details
    ! U ovom modulu se nalaze globalne PERS promenljive koje sluze
    ! za komunikaciju izmedu ScreenMaker HMI-ja i RAPID programa.
    !
    ! HMI preko ovih promenljivih salje izabranu boju kockice,
    ! izabranu poziciju na paleti, kao i komande za dodavanje,
    ! resetovanje i potvrdu rasporeda. RAPID program zatim obraduje
    ! ove zahteve u proceduri HMI_Handler().
    !
    ! Modul takode sadrzi niz cellColor koji predstavlja trenutni
    ! raspored kockica na paleti u okviru jednog ciklusa.
    !***********************************************************
        
    
    !***********************************************************
    ! @brief Izabrana boja kockice sa HMI-ja.
    !
    ! @details
    ! Promenljiva se popunjava preko NumEditor kontrole na
    ! ScreenMaker ekranu.
    !
    ! Vrednosti:
    ! - 0: nije izabrana boja
    ! - 1: crvena kockica
    ! - 2: zuta kockica
    ! - 3: zelena kockica
    !**********************************************************
    PERS num hmiColor := 2;
    
    !***********************************************************
    ! @brief Izabrana pozicija na paleti sa HMI-ja.
    !
    ! @details
    ! Promenljiva se popunjava preko NumEditor kontrole na
    ! ScreenMaker ekranu. Vrednost predstavlja indeks polja
    ! na paleti dimenzija 3x3.
    !
    ! Dozvoljene vrednosti su od 1 do 9.
    !***********************************************************
    PERS num hmiCell := 3;
    
    !***********************************************************
    ! @brief Zahtev za dodavanje izabrane kockice u raspored.
    !
    ! @details
    ! Promenljiva se postavlja preko HMI Switch kontrole DODAJ.
    ! Kada RAPID program detektuje zahtev, poziva proceduru
    ! AddCell() i pokusava da upise izabranu boju na izabranu
    ! poziciju palete.
    !***********************************************************
    PERS bool hmiAddReq := TRUE;


    !***********************************************************
    ! @brief Zahtev za resetovanje trenutnog rasporeda palete.
    !
    ! @details
    ! Promenljiva se postavlja preko HMI Switch kontrole RESET.
    ! Kada RAPID program detektuje zahtev, poziva proceduru
    ! ResetPattern(), kojom se brise trenutni raspored palete
    ! i resetuju pomocne HMI promenljive.
    !***********************************************************
    PERS bool hmiResetReq := FALSE;


    !***********************************************************
    ! @brief Zahtev za potvrdu unetog rasporeda palete.
    !
    ! @details
    ! Promenljiva se postavlja preko HMI Switch kontrole POTVRDI.
    ! Nakon potvrde, RAPID program proverava da li je raspored
    ! validan. Raspored je validan ako se svaka boja nalazi na
    ! barem jednoj poziciji na paleti.
    !***********************************************************
    PERS bool hmiStartReq := TRUE;

    !***********************************************************
    ! @brief Zahtev za zamenu trenutno oznacenu celiju
    !
    ! @details
    ! Promenljiva se postavlja preko HMI Switch kontrole ZAMENI.
    ! Nakon potvrde, RAPID program zamenjuje trenutnu kockicku 
    ! na toj poziciji, sa trenutno podesenom kockicom u hmiColor
    ! i hmiCell.
    !
    !***********************************************************
    PERS bool hmiReplaceReq := FALSE;
    
    !***********************************************************
    ! @brief Niz koji opisuje raspored kockica na paleti.
    !
    ! @details
    ! Niz ima 9 elemenata, po jedan za svako polje palete 3x3.
    ! Indeks niza odgovara indeksu pozicije na paleti.
    !
    ! Vrednosti elemenata:
    ! - 0: prazno polje
    ! - 1: crvena kockica
    ! - 2: zuta kockica
    ! - 3: zelena kockica
    !
    ! Primer:
    ! cellColor{1} = 2 znaci da se na poziciji 1 nalazi zuta
    ! kockica.
    !***********************************************************
    PERS num cellColor{9} := [1,3,2,0,0,0,0,0,0];
    

    !***********************************************************
    ! @brief Latch promenljiva za DODAJ Switch kontrolu.
    !
    ! @details
    ! Posto se na ScreenMaker ekranu koristi Switch kontrola
    ! umesto klasicnog Button-a, ova promenljiva sprecava da se
    ! jedan isti zahtev za dodavanje obradi vise puta dok je
    ! Switch ukljucen.
    !***********************************************************
    PERS bool addSwitchLatch := TRUE;


    !***********************************************************
    ! @brief Latch promenljiva za RESET Switch kontrolu.
    !
    ! @details
    ! Sprecava visestruku obradu istog reset zahteva dok je
    ! RESET Switch kontrola ukljucena.
    !***********************************************************
    PERS bool resetSwitchLatch := FALSE;

    !***********************************************************
    ! @brief Latch promenljiva za ZAMENI Switch kontrolu.
    !
    ! @details
    ! Sprecava visestruku obradu zahteva da zamenimo kocku na datom
    ! oznacenoj celiji palete zahteva dok je
    ! ZAMENI Switch kontrola ukljucena.
    !***********************************************************
    PERS bool replaceSwitchLatch := FALSE; 
        
    !***********************************************************
    ! @brief Statusna poruka za prikaz na HMI ekranu.
    !
    ! @details
    ! Promenljiva se prikazuje na ScreenMaker ekranu preko
    ! DataEditor ili slicne kontrole. Koristi se za ispis
    ! trenutnog stanja procesa, gresaka pri unosu i informacija
    ! o toku paletiranja.
    !
    ! Primeri poruka:
    ! - "Dodato: zuta na poziciju 1."
    ! - "Greska: pozicija 1 je vec zauzeta."
    ! - "Cekam dozvolu operatora: StartProces."
    !***********************************************************
    PERS string hmiStatus := "Paletiranje zavrseno.";
ENDMODULE