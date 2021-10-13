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
    %else %if &type. ne UPPER and &type. ne LOWER %then %do;
        %put &ER.&ROR.:(CHECKLIMIT) The valid values for the parameter TYPE are UPPER or LOWER;
        %goto endmacro;
    %end;
    %else %if %length(&vars.) ne %length(&limits.) %then %do;
        %put &ER.&ROR.:(CHECKLIMIT) There needs to be the same number of variables in VARS as there are limits in the limits in LIMITS; 
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
        
        %let nmiss = 0;
        %let nBelowLowerlimit = 0;
        %let nAboverUpperLimit = 0;
        
        %let vars_count = %sysfunc(countw(&vars.));
       
        %*MAKE LIST OF VARIABLES THAT ARE UNINTIALIZED; 
        %do i = 1 %to &vars_count.;
            %let var    = %scan(&vars.,&i,%str( )); 
            %let limit  = %scan(&limits.,&i.,%str( ));
            
            %*CHECK IF VARIABLE EXISTS IN &LIB.&DSN.;
            proc sql noprint;
                select upcase(name), upcase(type)
                into :var_check trimmed :var_type trimmed
                from sashelp.vcolumn
                where libname = "&lib."
                    and memname = "&dsn."
                    and upcase(name) = "&var."
            ;quit;
            
            %if %length(&var_check.) = 0 %then %do;
                %put &WAR.&NING.: (CHECKLIMIT) Variable &var. does not exist in &lib..&dsn.;                
            %end;
            %else %if %length(&var_check.) > 0 and &var_type ne N %then %do;
                %put &WAR.&NING.: (CHECKLIMIT) Variable &var. is not numeric;
            %end;
            %else %if %length(&Var_check.) > 0 and &var_type eq N %then %do;
                proc sql noprint;
                    select count(case when &var is null then 1 else 0 end) 
                           ,count(case when . < &var <= &limit. then 1 else 0 end)
                           ,count(case when &limit. < &var. then 1 else 0 end)
                           ,count(*)
                    into :nmiss trimmed
                         ,:nBelowLimit trimmed
                         ,:nAboveLimit trimmed
                         ,:nAll trimmed
                    from &lib..&dsn.
                ;quit;
                    
                data _null_;
                    format count 8. countc $100. status $15. pct 8.2 pctc $100. outtext $100.;
                    do i = 1 to 3;
                        if i = 1 then do;
                            count = &nMiss.;
                            status = "missing";
                        end;
                        else if i = 2 then do;
                            count = &nBelowLimit.;
                            status = "below the limit";
                        end;
                        else if i = 3 then do;
                            count = &nAboveLimit.;
                            status = "above the limit";
                        end;
                        countc = strip(put(count,8.));
                        pct = 100*cnt{i}/&nAll.; 
                        pctc = strip(put(pct,8.2.)); 

                        if i = 1 then putlog "NOTE:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) records with missing value for &VAR. in &LIB..&DSN.";
                        %if &type eq LOWER %then %do;
                            else if i = 2 and &nBelowLimit = 0 then putlog "NOTE:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) non-missing records <= &LIMIT for &VAR. in &LIB..&DSN.";
                            else if i = 2 and &nBelowLimit. > 0 then putlog "&WAR.&NING.:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) non-missing records <= &LIMIT for &VAR. in &LIB..&DSN.";
                            else if i = 3 the putlog "NOTE:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) non-missing records > &LIMIT for &VAR. in &LIB..&DSN.";
                        %end;
                        %else %if %type eq UPPER %then %do;
                            else if i = 2 the putlog "NOTE:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) non-missing records <= &LIMIT for &VAR. in &LIB..&DSN.";
                            else if i = 3 and &nAboveLimit = 0 then putlog "NOTE:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) non-missing records > &LIMIT for &VAR. in &LIB..&DSN.";
                            else if i = 3 and &nAboveLimit. > 0 then putlog "&WAR.&NING.:(CHECKLIMIT) There are " || countc || "(" || pctc || "%) non-missing records > &LIMIT for &VAR. in &LIB..&DSN.";
                        %end;
                    end;
                    drop i;
                          
                run;
            %end;
        %end;
    %end;
    

    %*END OF MACRO;
    %put --------------------EOF CHECKLIMIT.sas--------------------------;
    %endmacro:
%mend;

/*%CHECKLIMIT();*/
/*%CHECKLIMIT(help);*/
/*%CHECKLIMIT(dsn=car);*/
/*%CHECKLIMIT(lib=sashelp,dsn=cars,vars=engineSize cylinders,type=LOWER,limits=1 4);*/

/*data cars;*/
/*    format car $200.;*/
/*    set sashelp.cars;*/
/*run;*/
/*%CHECKLIMIT(lib=work,dsn=cars,vars=car engineSize cylinders,type=LOWER,limits=. 1 4);*/
