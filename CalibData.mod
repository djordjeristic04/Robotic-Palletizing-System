MODULE CalibData
    !***********************************************************
    ! @file CalibData.mod
    ! @brief Modul sa kalibracionim podacima robotske celije.
    !
    ! @details
    ! U ovom modulu se nalaze podaci koji opisuju geometriju
    ! robotske celije: alat robota, koordinatni sistem postolja,
    ! nominalni koordinatni sistem palete i aktivni koordinatni
    ! sistem palete.
    !
    ! Koordinatni sistem wobjPaletaNominal predstavlja referentni,
    ! rucno nauceni polozaj palete. Koordinatni sistem wobjPaleta
    ! predstavlja aktivni polozaj palete koji se tokom rada azurira
    ! na osnovu rezultata simulirane kamere.
    !***********************************************************
    
    
    !***********************************************************
    ! @brief Definicija vakuumskog zavrsnog uredaja robota.
    !
    ! @details
    ! ToolData promenljiva opisuje TCP vakuumskog gripera koji
    ! se koristi za uzimanje i odlaganje kockica. TCP je definisan
    ! u odnosu na prirubnicu robota. Ovaj alat se koristi u svim
    ! MoveJ i MoveL instrukcijama prilikom pick/place operacija.
    !***********************************************************
    PERS tooldata Vakuum_Griepr:=[TRUE,[[0,-0.2,130.2],[1,0,0,0]],[0.15,[0,0,52.562],[1,0,0,0],0,0,0]];
    
    !***********************************************************
    ! @brief Aktivni koordinatni sistem palete.
    !
    ! @details
    ! Ovaj WorkObject se koristi u putanjama za odlaganje kockica
    ! na paletu. Targeti za svih 9 polja palete definisani su
    ! lokalno u odnosu na ovaj koordinatni sistem.
    !
    ! Tokom svakog ciklusa, vrednost ovog WorkObject-a se azurira
    ! na osnovu ocitanih vrednosti simulirane kamere. Na taj nacin
    ! se sve place pozicije automatski pomeraju zajedno sa paletom.
    !***********************************************************
    PERS wobjdata wobjPaleta:=[FALSE,TRUE,"",[[385,95,203],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
    
    !***********************************************************
    ! @brief Koordinatni sistem postolja.
    !
    ! @details
    ! WorkObject vezan za postolje robotske celije. Njegov
    ! koordinatni pocetak se nalazi u referentnoj tacki postolja,
    ! a ose su uskladene sa geometrijom postolja.
    !
    ! Koristi se kao referentni koordinatni sistem za fiksne
    ! pozicije magacina kockica i za interpretaciju polozaja
    ! palete koji daje kamera.
    !***********************************************************
    PERS wobjdata wobjPostolje:=[FALSE,TRUE,"",[[375,25,200],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
    
    !***********************************************************
    ! @brief Nominalni koordinatni sistem palete.
    !
    ! @details
    ! Predstavlja referentni, rucno nauceni polozaj palete.
    ! Ovaj WorkObject se ne koristi direktno u Move instrukcijama,
    ! vec sluzi kao baza za proracun aktivnog koordinatnog sistema
    ! palete.
    !
    ! Na pocetku svakog ciklusa aktivni WorkObject wobjPaleta se
    ! vraca na vrednost wobjPaletaNominal, a zatim se pomera za
    ! offset koji vrati simulirana kamera.
    !***********************************************************
    PERS wobjdata wobjPaletaNominal:=[FALSE,TRUE,"",[[385,95,203],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
ENDMODULE