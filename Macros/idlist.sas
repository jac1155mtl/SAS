/*********************************************************************
MACRO NAME          : idlist.sas

PURPOSE             : create a macro variable that contains a list 
                      of unique id values (useful to subset a dataset
                      wit IDs from another dataset)

PARAMETERS          : library - library where dataset exist
                      data    - dataset containing the id values
                      idvar   - variable contain the id values
                      macvar  - name of the macro variable that will contain
                               the unique id variables

RETURNS             : a macro variable that contains a list of unique
                      id values

EXTERNAL MACROS     : n/a

NOTES               : run %idlist(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : %idlist(help);
                      %idlist(
                          library = sashelp
                      	  ,data = cars
                    	  ,idvar = make
                    	  ,macvar = carmakes
                      );
                      %put &=carmakes;
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Jo Ann Colas        02JUN2021   create
*********************************************************************/;

%put MACRO CALLED: idlist;

%macro idlist(help,library=work,data=,idvar=,macvar=);
    %local ER ROR nobs;
    %global &macvar.;

    %let ER = ER;
    %let ROR = ROR;

    %*UPCASE PARAMETERS;
    %let help       = %upcase(&help.);
    %let library    = %upcase(&library.);
    %let data       = %upcase(&data.);
    %let idvar      = %upcase(&idvar.);
    %let macvar     = %upcase(&macvar.);

    %*SYNTAX HELP in SAS;
    %if (%bquote(&help.) eq HELP) %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro IDLIST                                        |;
        %put NOTE: |   Macro to create a macro variable that contains a list of   |; 
        %put NOTE: |   unique id values                                           |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     library.: library where dataset exist                    |;
        %put NOTE: |     data....: dataset containing the id values               |;
        %put NOTE: |     idVar...: var in dataset containing the id values        |;
        %put NOTE: |     macVar..: macro var containing the unique id values      |;
        %put NOTE: |                                                              |;
        %put NOTE: +--------------------------------------------------------------+;
        %goto endmacro;
    %end;
    %else %if (%bquote(&help.) ne ) %then %do;
        %put &ER.&ROR.: Your &help request is not valid. Run idlist(help) for brief syntax help.;
        %goto endmacro;
    %end;

    %*CHECKING FOR REQUIRED PARAMETERS;
    %let ER = ER;
    %let ROR = ROR;
	%if %length(&library.) = 0 %then %do;
		%put &ER.&ROR:(IDLIST) Parameter LIBRARY required;
		%goto endmacro;
	%end;
    %else %if %length(&data.) = 0 %then %do;
		%put &ER.&ROR:(IDLIST) Parameter DATA required;
		%goto endmacro;
	%end;
    %else %if %length(&idvar.) = 0 %then %do;
		%put &ER.&ROR:(IDLIST) Parameter IDVAR required;
		%goto endmacro;
	%end;
    %else %if %length(&macvar.) = 0 %then %do;
		%put &ER.&ROR:(IDLIST) Parameter MACVAR required;
		%goto endmacro;
	%end;

    %*CHECKING THAT &LIBRARY EXISTS;
    %if %length(&library) > 0 %then %do;
        proc sql noprint;
        	select *
        	from dictionary.libnames
            where libname = "&library."
        ;quit;

        %if &sqlobs. = 0 %then %do;
            %put &ER.&ROR.: (IDLIST) The library &library. does not exist;
            %goto endmacro;
        %end;
    %end;

    %*CHECKING THAT &DATA EXIST IN &LIBRARY AND HAS DATA;
    %if %length(&data) > 0 %then %do;
        proc sql noprint;
        	select *
        	from dictionary.tables
            where libname = "&library."
                and memname = "&data."
        ;quit;

        %if &sqlobs. = 0 %then %do;
            %put &ER.&ROR.: (IDLIST) The dataset &library..&data. does not exist;
            %goto endmacro;
        %end;
        %else %do;
            proc sql noprint;
            	select nobs
                into :nobs trimmed
            	from dictionary.tables
                where libname = "&library."
                    and memname = "&data."
            ;quit; 

            %if &nobs. = 0 %then %do;
                %put &ER.&ROR.: (IDLIST) There is no data in &library..&data;
                %goto endmacro;
            %end;
        %end;
    %end;

    %*CHECKING THAT &IDVAR EXISTS in &LIBRARY.&DATA AND IT HAS AT LEAST ONE NON-MISSING VALUE;
    %if %length(&idvar) > 0 %then %do;
        proc sql noprint;
        	select *
        	from dictionary.columns
            where libname = "&library."
                and memname = "&data."
                and upcase(name) = "&idvar."
        ;quit;

        %if &sqlobs. = 0 %then %do;
            %put &ER.&ROR.: (IDLIST) The variable &library..&data..&idvar. does not exist;
            %goto endmacro;
        %end;
        %else %do;
            proc sql noprint;
            	select count(*)
                into :nobs trimmed
            	from &library..&data.
                where strip(&idvar.) is not null
            ;quit; 

            %if &nobs. = 0 %then %do;
                %put &ER.&ROR.: (IDLIST) There are no non-missing values in &library..&data..&idvar.;
                %goto endmacro;
            %end;
        %end;
    %end;

    %*CREATE MACRO VARIABLE;
    proc sql noprint;
        select distinct quote(strip(&idvar.))
        into :&macvar. separated by " "
        from &library..&data.
        where strip(&idvar.) is not null
    ;quit; 
%put --------------------EOF idlist.sas--------------------------;
%endmacro:

%mend idlist;
