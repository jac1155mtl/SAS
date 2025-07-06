/*********************************************************************
MACRO NAME          : checkDups

PURPOSE             : Macro for checking a SAS dataset for duplicates
                      on one or more variables

PARAMETERS          : dsn - SAS dataset
                      vars - list of variables to check for duplicates

RETURNS             : message in LOG

EXTERNAL MACROS     : n/a

NOTES               : run %checkDups(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : %checkDups();
                      %checkDups(help);
                      %checkDups(dsn=sashelp.cars,vars=make);
                      %checkDups(dsn=sashelp.cars,vars=make model);
                      %checkDups(dsn=sashelp.cars,vars=make model type origin drivetrain);
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Unknown             Unknown     create
                                https://www.skythisweek.info/checkdups.htm
Jo Ann Colas        27AUG2021   add SYNTAX HELP, check for required parameters
*********************************************************************/;

%put MACRO CALLED: CHECKDUPS;

%macro checkDups(help,dsn=,vars=);
    %local nobs dsn vars war ning er ror;

    %let WAR = WAR;
    %let NING = NING;
    %let ER = ER;
    %let ROR = ROR;
    
    %let help = %upcase(&help.);
    %let dsn = %upcase(&dsn.);
    %let vars = %upcase(&vars.);


    %*SYNTAX HELP in SAS;
    %if &help eq HELP %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro CHECKDUPS                                     |;
        %put NOTE: |   Macro for checking a SAS dataset for duplicates on one or  |;
        %put NOTE: |   more variables                                             |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     dsn..........: SAS dataset                               |;
        %put NOTE: |     vars.........: list of variables to check for duplicates |;
        %put NOTE: |                                                              |;
        %put NOTE: +--------------------------------------------------------------+;
        %goto endmacro;
    %end;
    %else %if (%bquote(%upcase(&help.)) ne ) %then %do;
        %put &ER.&ROR.:(CHECKDUPS) Your &help request is not valid. Run checkDups(help) for brief syntax help.;
        %goto endmacro;
    %end;

    %*CHECKING FOR REQUIRED PARAMETERS;
    %if %length(&dsn.) = 0 %then %do;
        %put &ER.&ROR.:(CHECKDUPS) Parameter DSN required;
        %goto endmacro;
    %end;
    %else %if %length(&vars.) = 0 %then %do;
        %put &ER.&ROR.:(CHECKDUPS) Parameter VARS required;
        %goto endmacro;
    %end;

    %*GET DUPLICATES IN &DSN.;
    proc sort data=&dsn. out=_null_ dupout=_dups nodupkey;
        by &vars.;
    run;

    %*GET NUMBER OF OBSERVATIONS OF DUPLICATES;
    proc sql noprint;
        select nobs into :nobs
    from dictionary.tables
    where libname = "WORK"
        and memname = "_DUPS"
    ;quit;

    %*CHECK IF THERE ANY DUPLICATES;
    %if &nobs. = 0 %then %do;
        %put NOTE: No duplicates of (&vars.) in &dsn.;
    %end;
    %else %do;
        %put &WAR.&NING.: Duplicate values of (&vars.) in &dsn.;
    %end;

    %*END OF MACRO;
    %put --------------------EOF CHECKDUPS.sas--------------------------;
    %endmacro:
%mend;
