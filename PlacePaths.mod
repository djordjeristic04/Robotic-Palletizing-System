MODULE PlacePaths
    !***********************************************************
    ! @file PlacePaths.mod
    ! @brief Modul sa putanjama za odlaganje kockica na paletu.
    !
    ! @details
    ! U ovom modulu se nalaze robtarget tacke i procedure koje
    ! opisuju odlaganje kockica na pojedinacna polja palete 3x3.
    !
    ! Za svako polje palete definisane su dve tacke:
    ! - approach tacka, koja se nalazi iznad odgovarajuceg polja,
    ! - place tacka, u kojoj se kockica odlaze na paletu.
    !
    ! Sve tacke za odlaganje definisane su lokalno u odnosu na
    ! aktivni koordinatni sistem palete, wobjPaleta. Ovaj
    ! WorkObject se tokom rada azurira na osnovu rezultata
    ! simulirane kamere, tako da se sva polja palete automatski
    ! pomeraju zajedno sa paletom.
    !
    ! Pri odlaganju kockice robot najpre dolazi u approach tacku,
    ! zatim se linearno spusta do place tacke, deaktivira digitalni
    ! izlaz AttachCube i time otpusta kockicu sa vakuumskog
    ! gripera. Nakon kratkog cekanja robot se vraca u approach
    ! tacku i odlazi u bezbednu tacku iznad palete.
    !***********************************************************
    
    
    !***********************************************************
    ! @brief Teach-ovane tacke za odlaganje kockica na paletu.
    !
    ! @details
    ! Za svako od devet polja palete definisane su approach i
    ! place tacke. Approach tacka se nalazi iznad odgovarajuceg
    ! polja i koristi se za bezbedan prilaz paleti, dok place
    ! tacka predstavlja poziciju u kojoj se kockica fizicki
    ! odlaze na paletu.
    !
    ! Tacke su definisane u lokalnom koordinatnom sistemu palete.
    ! U MoveJ i MoveL instrukcijama koristi se aktivni WorkObject
    ! wobjPaleta, koji se azurira na osnovu ocitavanja kamere.
    !
    ! Tacka pPalSafe predstavlja bezbednu poziciju iznad palete
    ! u koju robot odlazi nakon odlaganja kockice, kako bi se
    ! obezbedio siguran prelaz ka sledecoj pick/place operaciji.
    !***********************************************************
    CONST robtarget pPalletCell01PlaceApproach:=[[69.999581826,69.999628181,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell01Place:=[[69.999581826,69.999628181,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletSafe:=[[-0.000418174,-0.000371819,150],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell02PlaceApproach:=[[69.999581826,-0.000371819,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell02Place:=[[69.999581826,-0.000371819,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell03PlaceApproach:=[[69.999581826,-70.000371819,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell03Place:=[[69.999581826,-70.000371819,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell04PlaceApproach:=[[-0.000418174,69.999628181,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell04Place:=[[-0.000418174,69.999628181,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell05PlaceApproach:=[[-0.000418174,-0.000371819,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell05Place:=[[-0.000418174,-0.000371819,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell06PlaceApproach:=[[-0.000418174,-70.000371819,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell06Place:=[[-0.000418174,-70.000371819,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell07PlaceApproach:=[[-70.000418174,69.999628181,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell07Place:=[[-70.000418174,69.999628181,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell08PlaceApproach:=[[-70.000418174,-0.000371819,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell08Place:=[[-70.000418174,-0.000371819,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pPalletCell09PlaceApproach:=[[-70.000418174,-70.000371819,100],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPalletCell09Place:=[[-70.000418174,-70.000371819,50],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 01 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 01, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************
    PROC Path_PlaceCell01()
        MoveJ pPalletCell01PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell01Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell01PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 02 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 02, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************
    PROC Path_PlaceCell02()
        MoveL pPalletCell02PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell02Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;        
        MoveL pPalletCell02PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 03 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 03, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************
    PROC Path_PlaceCell03()
        MoveJ pPalletCell03PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell03Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell03PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 04 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 04, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************
    PROC Path_PlaceCell04()
        MoveJ pPalletCell04PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell04Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell04PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 05 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 05, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************   
    PROC Path_PlaceCell05()
        MoveJ pPalletCell05PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell05Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell05PlaceApproach,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 06 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 06, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************    
    PROC Path_PlaceCell06()
        MoveJ pPalletCell06PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell06Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell06PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 07 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 07, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************    
    PROC Path_PlaceCell07()
        MoveJ pPalletCell07PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell07Place,v150,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell07PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 08 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 08, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************    
    PROC Path_PlaceCell08()
        MoveJ pPalletCell08PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell08Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;        
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell08PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
    
    !***********************************************************
    ! @brief Odlaganje kockice na polje 09 palete
    !
    ! @details
    ! Robot dolazi u approach poziciju iznad polja 01, zatim se
    ! linearno spusta do place pozicije. Na mestu odlaganja se
    ! deaktivira digitalni izlaz AttachCube, cime se kockica
    ! otpusta sa vakuumskog gripera. Nakon kratkog cekanja robot
    ! se vraca u approach poziciju, a zatim odlazi u bezbednu
    ! tacku pPalletSafe iznad sredine palete.
    !***********************************************************    
    PROC Path_PlaceCell09()
        MoveJ pPalletCell09PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveL pPalletCell09Place,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 0;
        WaitTime 0.5;
        MoveL pPalletCell09PlaceApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPaleta;
        MoveJ pPalletSafe,v1000,fine,Vakuum_Griepr\WObj:=wobjPaleta;
    ENDPROC
ENDMODULE