/*********************************************************************
MACRO NAME          : checkUninVars

PURPOSE             : Macro for checking for any unintialized variables
                      in a SAS dataset

PARAMETERS          : dsn - SAS dataset

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
Jo Ann Colas        27AUG2021   create
*********************************************************************/;

%put MACRO CALLED: CHECKUNINVARS;

%macro checkUninVars(help,lib=WORK,dsn=,vars=);
    %local nobs sqlobs dsn war ning er ror library data;

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
        %put NOTE: |     lib..........: SAS dataset (default = WORK)              |;
        %put NOTE: |     dsn..........: SAS dataset                               |;
        %put NOTE: |     vars.........: SAS dataset                               |;
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
    %else %do;
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

        %let list =;
        %do i = 1 %to &nvars.;
            %let var=%scan(&vars,&i,%str( )); 

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

        %if %length(&list) = 0 and %length(&vars) = &nvars. %then %do;
            %put NOTE: (CHECKUNINVARS) All the variables in &lib..&dsn. are initialized;
        %end;
        %else %if 0 < %length(&list) = &nvars. %then %do;
            %put &WAR.&NING.: (CHECKUNINVARS) All the variables in &lib..&dsn. are uninitialized;
        %end;
    %end;
    

    %*END OF MACRO;
    %put --------------------EOF CHECKUNINVARS.sas--------------------------;
    %endmacro:
%mend;

%CHECKUNINVARS();
%CHECKUNINVARS(help);
/*%CHECKUNINVARS(dsn=car);*/
%CHECKUNINVARS(lib=sashelp,dsn=cars);
data cars;
    format car $200.;
    set sashelp.cars;
run;
%CHECKUNINVARS(dsn=cars);