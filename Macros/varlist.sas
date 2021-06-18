/*********************************************************************
MACRO NAME          : varlist

PURPOSE             : return a list of variables in a dataset, with option
                      to store list in a macro variable

PARAMETERS          : dsname - dataset name
                      macvar - name of macro variable to
RETURNS             : list of variables in &dsname.
                      or macro variable &macvar. with list of variable in
                      the dataset &dsname.

EXTERNAL MACROS     : n/a

NOTES               : run %varlist(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : %varlist(help)
                      %varlist(dsname=mylib.dsn1)
                      %varlist(dsname=dsn2,macvar=dsn2vars)
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Jo Ann Colas        17JUN2021   create
*********************************************************************/;

%put MACRO CALLED: varlist;

%macro varlist(help,dsname,macvar=);
    **-----------------------------------------------------------------**
    SET SCORE OF MACRO VARIABLES
    **-----------------------------------------------------------------**;
    %local ER ROR WAR NING data library nobs nvars list;

    %global &macvar.;

    **-----------------------------------------------------------------**
	  SYNTAX HELP IN SAS LOG
    **-----------------------------------------------------------------**;
    %if (%bquote(%upcase(&help.)) eq HELP) %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro VARLIST                                       |;
        %put NOTE: |   return a list of variables in a dataset, with option       |;
        %put NOTE: |   to store list in a macro variable                          |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     dsname....: dataset name (can be library.dataset format) |;
        %put NOTE: |     macvar....: mac var containing list of variables         |;
        %put NOTE: |                                                              |;
        %put NOTE: +--------------------------------------------------------------+;
        %goto endmacro;
    %end;
    %else %if (%bquote(%upcase(&help.)) ne ) %then %do;
        %put &ER.&ROR.: (VARLIST) Your &help. request is not valid. Run varlist(help) for brief syntax help.;
        %goto endmacro;
    %end;

    **-----------------------------------------------------------------**
	  CHECKING FOR REQUIRED PARAMETERS
    **-----------------------------------------------------------------**;
    %if not %length(&dsname.) %then %do;
      %put &ER.&ROR:(VARLIST) Parameter DSNAME required;
      %goto endmacro;
    %end;

    **-----------------------------------------------------------------**
	  CHECK IF LIBNAME IN &DSNAME
    **-----------------------------------------------------------------**;
    %if %sysfunc(find(&dsname.,".")) > 0 %then %do;
        %let library = %upcase(%scan(&dsnname.,1,.));
        %let data = %upcase(%scan(&dsname.,2,.));
    %end;
    %else %do;
        %let library = WORK;
        %let data = %upcase(&dsname.);
    %end;

    **-----------------------------------------------------------------**
	  CHECKING IF LIBNAME EXISTS
    **-----------------------------------------------------------------**;
    proc sql noprint;
    	select *
    	from dictionary.libnames
        where libname = "&library."
    ;quit;

    %if &sqlobs. = 0 %then %do;
        %put &ER.&ROR.: (VARLIST) The library &library. does not exist;
        %goto endmacro;
    %end;

    %*CHECKING THAT &DATA. EXIST IN &LIBRARY.;
    proc sql noprint;
    	select *
    	from dictionary.tables
      where libname = "&library."
          and memname = "&data."
    ;quit;

    %if &sqlobs. = 0 %then %do;
        %put &ER.&ROR.: (VARLIST) The dataset &library..&data. does not exist;
        %goto endmacro;
    %end;


    %*CHECKING THAT &DATA. HAS AT LEAST ONE VARIABLE;
    proc sql noprint;
      select nvar
      into :nvars trimmed
      from dictionary.tables
      where libname = "&library."
          and memname = "&data."
    ;quit;

    %if &nvars. = 0 %then %do;
        %put &WAR.&NING.: (VARLIST) There are no variables in the dataset &library..&data.;
        %goto endmacro;
    %end;

    **-----------------------------------------------------------------**
	  MAKE LIST OF VARIABLES
    **-----------------------------------------------------------------**;
    proc sql noprint;
      select distinct strip(name)
      into :list separated by " "
      from dictionary.columns
      where libname = "&library."
          and memname = "&data."
    ;quit;

    **-----------------------------------------------------------------**
	  PRINT &LIST. AND SAVE &LIST IN &MACVAR. IF EXISTS
    **-----------------------------------------------------------------**;
    %if %length(&macvar.) > 0 %then %do;
        %let &macvar. = &list.;
        %put NOTE: (VARLIST) The list of variables in &library..&data. have been saved in &macvar.;
        %put NOTE: (VARLIST) &macvar. = &list.;
    %end;
    %else %do;
        %put NOTE: (VARLIST) The list of variables in &library..&data. is as follows:;
        %put NOTE: (VARLIST) &list.;
    %end;
%put --------------------EOF varlist.sas--------------------------;
%endmacro:

%mend varlist;
