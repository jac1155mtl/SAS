/*********************************************************************
MACRO NAME          : checkLimit

PURPOSE             : Macro for checking for upper or lower limit of 
                      numerical variables in a SAS dataset

PARAMETERS          : lib    - SAS library where dataset is located 
                               (default = WORK)
                      dsn    - SAS dataset
                      vars   - space-delimited list of numeric 
                               variables to check upper/lower limit
                      type   - UPPER (default) or LOWER
                      limits - space-delimited list of upper/lower 
                               limits for &vars
RETURNS             : message in LOG

EXTERNAL MACROS     : n/a

NOTES               : run %checkLimit(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : %CHECKLIMIT();
                      %CHECKLIMIT(help);
                      %CHECKLIMIT(dsn=car);
                      %CHECKLIMIT(lib=sashelp,dsn=cars,vars=engineSize cylinders,type=LOWER,limits=1 4);
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Jo Ann Colas        27AUG2021   create
*********************************************************************/;

%put MACRO CALLED: CHECKLIMIT;

%macro checkUninVars(help,lib=WORK,dsn=,vars=,type=UPPER,limits=);
    %local nobs sqlobs dsn war ning er ror library data list;

    %let WAR = WAR;
    %let NING = NING;
    %let ER = ER;
    %let ROR = ROR;
    
    %let help   = %upcase(&help.);
    %let lib    = %upcase(&lib.);
    %let dsn    = %upcase(&dsn.);
    %let vars   = %upcase(&vars.);
    %let type   = %upcase(&type.);
    %let limits = %upcase(&limits.);

    %*SYNTAX HELP in SAS;
    %if &help. eq HELP %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro CHECKLIMIT                                    |;
        %put NOTE: |   Macro for checking for upper or lower limit of             |;
        %put NOTE: |   numerical variables in a SAS dataset                       |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     lib..........: SAS library where dataset is located      |;
        %put NOTE: |                    (default = WORK)                          |;
        %put NOTE: |     dsn..........: SAS dataset                               |;
        %put NOTE: |     vars.........: space-delimited list of numeric variables |;
        %put NOTE: |                    to check upper/lower limit                |;
        %put NOTE: |     type.........: UPPER (default) or LOWER                  |;
        %put NOTE: |     limits.......: space-delimited list of limits to check   |; 
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
        %put &ER.&ROR.:(CHECKLIMIT) Parameter DSN required;
        %goto endmacro;
    %end;
    %else %length(&vars.) = 0 %then %do;
        %put &ER.&ROR.:(CHECKLIMIT) Parameter VARS required;
        %goto endmacro;
    %end;
    %else %length(&limits.) = 0 %then %do;
        %put &ER.&ROR.:(CHECKLIMIT) Parameter LIMITS required;
        %goto endmacro;
    %end;
    %else %if &type. ne UPPER and &type. LOWER %then %do;
        %put &ER.&ROR.:(CHECKLIMIT) The valid values for the parameter TYPE are UPPER or LOWER;
        %goto endmacro;
    %end;
    
    %*CHECKING IF LIBRARY EXISTS;
    proc sql noprint;
        select *
        from dictionary.libnames
        where libname = "&lib."
    ;quit;

    %if &sqlobs. = 0 %then %do;
        %put &ER.&ROR.: (CHECKLIMIT) The library &lib. does not exist;
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

    %*CHECK THAT SAME NUMBER OF VARS AND LIMITS;
    %*CHECKING THAT &VARS. EXIST;
    %*CHECKING THAT &VARS. IS NUMERIC;
    
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
