MODULE PickPaths
    !***********************************************************
    ! @file PickPaths.mod
    ! @brief Modul sa putanjama za uzimanje kockica iz magacina.
    !
    ! @details
    ! U ovom modulu se nalaze robtarget tacke i procedure koje
    ! opisuju uzimanje kockica iz fiksnih magacina na postolju.
    !
    ! Za svaku boju kockice definisane su dve tacke:
    ! - approach tacka, koja se nalazi iznad kockice,
    ! - pick tacka, u kojoj vakuumski griper preuzima kockicu.
    !
    ! Magacini kockica se smatraju fiksnim u odnosu na koordinatni
    ! sistem postolja, pa se sve pick putanje izvrsavaju u odnosu
    ! na wobjPostolje.
    !
    ! Pri dohvatanju kockice aktivira se digitalni izlaz AttachCube,
    ! a zatim se ceka 0.5 s kako bi se simuliralo vreme potrebno
    ! za prihvatanje kockice vakuumskim griperom.
    !***********************************************************
    
    
    !***********************************************************
    ! @brief Teach-ovane tacke za uzimanje kockica.
    !
    ! @details
    ! Za svaku boju definisana je approach tacka i pick tacka.
    ! Approach tacka se nalazi iznad kockice i koristi se za
    ! bezbedan prilaz, dok pick tacka predstavlja poziciju u kojoj
    ! vakuumski griper dolazi u kontakt sa kockicom.
    !***********************************************************
    CONST robtarget pGreenBoxPickApproach:=[[75.000418174,-129.999628181,100],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pGreenBoxPick:=[[75.000418174,-129.999628181,50],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pRedBoxPickApproach:=[[-64.999581826,-129.999628181,100],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRedBoxPick:=[[-64.999581826,-129.999628181,50],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pYellowBoxPickApproach:=[[5.000418174,-129.999628181,100],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pYellowBoxPick:=[[5.000418174,-129.999628181,50],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    
    !***********************************************************
    ! @brief Uzimanje zelene kockice iz magacina.
    !
    ! @details
    ! Robot najpre dolazi u approach tacku iznad zelene kockice,
    ! a zatim se linearno spusta do pick pozicije. Kada se alat
    ! nalazi u pick poziciji, aktivira se digitalni izlaz
    ! AttachCube, cime se kockica prihvata vakuumskim griperom.
    !
    ! Nakon cekanja od 0.5 s robot se linearno vraca u approach
    ! tacku, cime se kockica bezbedno podize iz magacina.
    !***********************************************************
    PROC Path_PickGreen()
        MoveJ pGreenBoxPickApproach,v1000,fine,Vakuum_Griepr\WObj:=wobjPostolje;
        MoveL pGreenBoxPick,v100,fine,Vakuum_Griepr\WObj:=wobjPostolje;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 1;
        WaitTime 0.5;
        MoveL pGreenBoxPickApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPostolje;
    ENDPROC
    
    
    !***********************************************************
    ! @brief Uzimanje crvene kockice iz magacina.
    !
    ! @details
    ! Robot dolazi u approach tacku iznad crvene kockice, zatim
    ! se linearno spusta do pick pozicije. U pick poziciji se
    ! aktivira digitalni izlaz AttachCube, cime se simulira
    ! prihvatanje kockice vakuumskim griperom.
    !
    ! Nakon cekanja od 0.5 s robot se vraca u approach tacku,
    ! pri cemu se kockica podize iz magacina.
    !***********************************************************
     PROC Path_PickRed()
        MoveJ pRedBoxPickApproach,v1000,fine,Vakuum_Griepr\WObj:=wobjPostolje;
        MoveL pRedBoxPick,v100,fine,Vakuum_Griepr\WObj:=wobjPostolje;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 1;
        WaitTime 0.5;
        MoveL pRedBoxPickApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPostolje;
    ENDPROC
    
    
    !***********************************************************
    ! @brief Uzimanje zute kockice iz magacina.
    !
    ! @details
    ! Robot najpre dolazi u approach tacku iznad zute kockice,
    ! a zatim se linearno spusta do pick pozicije. U toj poziciji
    ! aktivira se digitalni izlaz AttachCube, sto predstavlja
    ! ukljucivanje vakuumskog gripera.
    !
    ! Nakon cekanja od 0.5 s, potrebnog za stabilno prihvatanje
    ! kockice, robot se linearno vraca u approach tacku.
    !***********************************************************
    PROC Path_PickYellow()
        MoveJ pYellowBoxPickApproach,v1000,fine,Vakuum_Griepr\WObj:=wobjPostolje;
        MoveL pYellowBoxPick,v100,fine,Vakuum_Griepr\WObj:=wobjPostolje;
        WaitTime \InPos, 0.1;
        SetDO AttachCube, 1;
        WaitTime 0.5;
        MoveL pYellowBoxPickApproach,v100,fine,Vakuum_Griepr\WObj:=wobjPostolje;
    ENDPROC
ENDMODULE