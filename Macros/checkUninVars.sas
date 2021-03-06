/*********************************************************************
MACRO NAME          : checkUninVars

PURPOSE             : Macro for checking for any unintialized variables
                      in a SAS dataset

PARAMETERS          : lib  - SAS library where dataset is located 
                            (default = WORK)
                      dsn  - SAS dataset
                      vars - list of variables to check if initiated
RETURNS             : message in LOG

EXTERNAL MACROS     : n/a

NOTES               : run %checkDups(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : %CHECKUNINVARS();
                      %CHECKUNINVARS(help);
                      %CHECKUNINVARS(dsn=car);
                      %CHECKUNINVARS(lib=sashelp,dsn=cars);
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Jo Ann Colas        27AUG2021   create
*********************************************************************/;

%put MACRO CALLED: CHECKUNINVARS;

%macro checkUninVars(help,lib=WORK,dsn=,vars=);
    %local nobs sqlobs dsn war ning er ror library data list;

    %let WAR = WAR;
    %let NING = NING;
    %let ER = ER;
    %let ROR = ROR;
    
    %let help   = %upcase(&help.);
    %let lib    = %upcase(&lib.);
    %let dsn    = %upcase(&dsn.);
    %let vars   = %upcase(&vars.);

    %*SYNTAX HELP in SAS;
    %if &help eq HELP %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro CHECKUNINVARS                                 |;
        %put NOTE: |   Macro for checking for any unintialized variables in a SAS |;
        %put NOTE: |   dataset                                                    |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     lib..........: SAS library where dataset is located      |;
        %put NOTE: |                    (default = WORK)                          |;
        %put NOTE: |     dsn..........: SAS dataset                               |;
        %put NOTE: |     vars.........: space delimited list of variables to      |;
        %put NOTE: |                    check if initiated (if blank, will check  |;
        %put NOTE: |                    all variables in dataset)                 |;
        %put NOTE: |                                                              |;
        %put NOTE: +--------------------------------------------------------------+;
        %goto endmacro;
    %end;
    %else %if (%bquote(%upcase(&help.)) ne ) %then %do;
        %put &ER.&ROR.:(CHECKUNINVARS) Your &help request is not valid. Run checkDups(help) for brief syntax help.;
        %goto endmacro;
    %end;

    %*CHECKING FOR REQUIRED PARAMETERS;
    %if %length(&dsn.) = 0 %then %do;
        %put &ER.&ROR.:(CHECKUNINVARS) Parameter DSN required;
        %goto endmacro;
    %end;

    %*CHECKING IF LIBRARY EXISTS;
    proc sql noprint;
        select *
        from dictionary.libnames
        where libname = "&lib."
    ;quit;

    %if &sqlobs. = 0 %then %do;
        %put &ER.&ROR.: (CHECKUNINVARS) The library &lib. does not exist;
        %goto endmacro;
    %end;

    %*CHECKING THAT &DATA. EXIST IN &LIBRARY.;
    proc sql noprint;
        select *
        from dictionary.tables
      where libname = "&lib."
          and memname = "&dsn."
    ;quit;

    %if &sqlobs. = 0 %then %do;
        %put &ER.&ROR.: (CHECKUNINVARS) The dataset &lib..&dsn. does not exist;
        %goto endmacro;
    %end;

    %*CHECKING THAT &DATA. HAS AT LEAST ONE VARIABLE;
    proc sql noprint;
      select nvar
      into :nvars trimmed
      from dictionary.tables
      where libname = "&lib."
          and memname = "&dsn."
    ;quit;

    %if &nvars. = 0 %then %do;
        %put &WAR.&NING.: (CHECKUNINVARS) There are no variables in the dataset &library..&data.;
        %goto endmacro;
    %end;

    %*MAKE LIST OF UNINTIALIZED VARIABLES;
    %else %if &nvars. > 0 %then %do;
    
        %*IF NO VARIABLES SPECIFIED, UPDATE &VARS. TO INCLUDE ALL VARIABLES IN &DSN.;
        %if %length(&vars) = 0 %then %do;
            proc sql noprint;
                select upcase(name)
                into :vars separated by " "
                from sashelp.vcolumn
                where libname = "&lib."
                    and memname = "&dsn."
            ;quit;
            %put &=vars;
        %end;

        %*MAKE LIST OF VARIABLES THAT ARE UNINTIALIZED;
        %let list =;
        %let vars_count = %sysfunc(countw(&vars.));
        %do i = 1 %to &vars_count.;
            %let var=%scan(&vars,&i,%str( )); 
            
            %*CHECK IF VARIABLE EXISTS IN &LIB.&DSN.;
            proc sql noprint;
                select upcase(name)
                into :var_check trimmed
                from sashelp.vcolumn
                where libname = "&lib."
                    and memname = "&dsn."
                    and upcase(name) = "&var."
            ;quit;
            
            %if %length(&var_check.) = 0 %then %do;
                %put &WAR.&NING.: (CHECKUNINVARS) Variable &var. does not exist in &lib..&dsn.;                
            %end;
            %else %if %length(&var_check.) > 0 %then %do;
                %*CHECK IF AT LEAST ONE ROW WITH NON-MISSING VALUE FOR &VAR.;
                proc sql noprint;
                    select count(*) into :nobs
                    from &lib..&dsn.
                    where &var. is not null
                ;quit;

                %if &nobs. = 0 %then %do;
                    %put &WAR.&NING.: (CHECKUNINVARS) Variable &var. is uninitialized in &lib..&dsn.;
                    data _null_;
                        newlist = catx(" ","&list.","&var.");
                        call symput("list",newlist);
                    run;

                    %let list = %trim(&list.);
                %end; 
             %end;
        %end;

        %*OUTPUT NOTE IF ALL VARIABLES ARE INITIALIZED;
        %if %length(&list) = 0 and %length(&vars) = &nvars. %then %do;
            %put NOTE: (CHECKUNINVARS) All the variables in &lib..&dsn. are initialized;
        %end;
        %else %if %length(&list) = 0 and %length(&vars) < &nvars. %then %do;
            %put NOTE: (CHECKUNINVARS) The variables &vars. in &lib..&dsn. are initialized;
        %end;
    %end;
    

    %*END OF MACRO;
    %put --------------------EOF CHECKUNINVARS.sas--------------------------;
    %endmacro:
%mend;

/*%CHECKUNINVARS();*/
/*%CHECKUNINVARS(help);*/
/*%CHECKUNINVARS(dsn=car);*/
/*%CHECKUNINVARS(lib=sashelp,dsn=cars);*/

/*data cars;*/
/*    format car $200.;*/
/*    set sashelp.cars;*/
/*run;*/
/*%CHECKUNINVARS(dsn=cars);*/
