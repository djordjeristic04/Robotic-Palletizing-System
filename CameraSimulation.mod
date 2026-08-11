MODULE CameraSimulation
    !***********************************************************
    ! @file CameraSimulation.mod
    ! @brief Modul za simulaciju rada kamere.
    !
    ! @details
    ! U ovom modulu se nalazi jednostavna simulacija kamere koja
    ! detektuje polozaj i orijentaciju palete na postolju.
    !
    ! Umesto prave kamere, funkcija SimulateCameraReading() generise
    ! pseudo-random vrednosti za X, Y i Rz u zadatim opsezima.
    ! Dobijene vrednosti predstavljaju pomeraj i rotaciju palete u
    ! odnosu na referentni/nominalni polozaj.
    !
    ! Kamera ne detektuje boju kockica. Boje i pozicije zadaje
    ! korisnik preko HMI-ja, dok kamera sluzi za korekciju polozaja
    ! palete pre pocetka paletiranja.
    !***********************************************************
    
    
    
    
    !***********************************************************
    ! @brief Struktura koja opisuje rezultat ocitavanja kamere.
    !
    ! @details
    ! Record sadrzi tri vrednosti koje kamera vraca:
    ! - x  : pomeraj palete po X osi [mm]
    ! - y  : pomeraj palete po Y osi [mm]
    ! - rz : rotacija palete oko Z ose [deg]
    !
    ! Ove vrednosti se kasnije koriste za azuriranje aktivnog
    ! WorkObject-a palete, odnosno promenljive wobjPaleta.
    !***********************************************************
    RECORD camerapos
        num x;
        num y;
        num rz;
    ENDRECORD


    !***********************************************************
    ! @brief Seme pseudo-random generatora.
    !
    ! @details
    ! Vrednost randSeed se menja pri svakom pozivu funkcije
    ! NextRandom(). Na taj nacin se dobijaju razlicite vrednosti
    ! za simulaciju polozaja palete.
    !***********************************************************
    PERS num randSeed := 2.72119;


    !***********************************************************
    ! @brief Generisanje pseudo-random broja u opsegu [0, 1).
    !
    ! @details
    ! Funkcija koristi sinusnu funkciju i trenutno seme randSeed
    ! kako bi generisala realan broj u opsegu od 0 do 1.
    !
    ! Nakon generisanja broja, seme se pomera kako bi sledeci
    ! poziv dao drugu vrednost. Funkcija je realizovana tako da
    ! radi samo sa realnim brojevima i ne koristi velike celobrojne
    ! vrednosti, cime se izbegavaju problemi sa prekoracenjem.
    !
    ! @return Pseudo-random broj u opsegu [0, 1).
    !***********************************************************
    FUNC num NextRandom()
        VAR num x;

        x := Sin(randSeed * 12.9898) * 43758.5453;
        x := Abs(x - Trunc(x));

        randSeed := randSeed + x + 0.6180339887;

        IF randSeed > 1000 THEN
            randSeed := randSeed - Trunc(randSeed);
        ENDIF

        RETURN x;
    ENDFUNC


    !***********************************************************
    ! @brief Inicijalizacija semena pseudo-random generatora.
    !
    ! @details
    ! Procedura se poziva jednom na pocetku programa. Kratkim
    ! merenjem vremena pomocu clock promenljive formira se nova
    ! pocetna vrednost randSeed, kako bi generisane vrednosti bile
    ! razlicite pri razlicitim pokretanjima programa.
    !***********************************************************
    PROC InitRandomSeed()
        VAR clock myClock;
        VAR num t;

        ClkReset myClock;
        ClkStart myClock;
        WaitTime 0.01;
        ClkStop myClock;

        t := ClkRead(myClock);

        randSeed := Abs(t - Trunc(t)) + 0.01;
    ENDPROC
    

    !***********************************************************
    ! @brief Simulacija ocitavanja kamere.
    !
    ! @details
    ! Funkcija generise pseudo-random vrednosti za X, Y i Rz
    ! u opsezima koje korisnik prosledi kao argumente.
    !
    ! Dobijene vrednosti predstavljaju informaciju koju bi u
    ! realnom sistemu dala kamera postavljena iznad postolja.
    ! Na osnovu tih vrednosti azurira se aktivni koordinatni
    ! sistem palete.
    !
    ! @param xMin Minimalna vrednost pomeraja po X osi [mm].
    ! @param xMax Maksimalna vrednost pomeraja po X osi [mm].
    ! @param yMin Minimalna vrednost pomeraja po Y osi [mm].
    ! @param yMax Maksimalna vrednost pomeraja po Y osi [mm].
    ! @param rzMin Minimalna rotacija oko Z ose [deg].
    ! @param rzMax Maksimalna rotacija oko Z ose [deg].
    !
    ! @return Struktura tipa camerapos sa vrednostima x, y i rz.
    !***********************************************************
    FUNC camerapos SimulateCameraReading(num xMin, num xMax,
                                         num yMin, num yMax,
                                         num rzMin, num rzMax)
        VAR camerapos result;

        result.x  := xMin  + NextRandom() * (xMax - xMin);
        result.y  := yMin  + NextRandom() * (yMax - yMin);
        result.rz := rzMin + NextRandom() * (rzMax - rzMin);

        RETURN result;
    ENDFUNC
ENDMODULE