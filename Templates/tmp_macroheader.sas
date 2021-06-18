/*********************************************************************
MACRO NAME          :

PURPOSE             :

PARAMETERS          :

RETURNS             :

EXTERNAL MACROS     :

SPECIAL REQUIREMENTS:

EXAMPLES            :
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Jo Ann Colas        DDMMMYYYY   create
*********************************************************************/;

%put MACRO CALLED: XXXXX;

%macro XXXXX();
    **-----------------------------------------------------------------**
    SET SCORE OF MACRO VARIABLES
    **-----------------------------------------------------------------**;
    %local ER ROR WAR NING;

    **-----------------------------------------------------------------**
    SYNTAX HELP IN SAS LOG
    **-----------------------------------------------------------------**;
    %if (%bquote(%upcase(&help.)) eq HELP) %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro XXXXX                                         |;
        %put NOTE: |   <PURPOSE>                                                  |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     param1....:                                              |;
        %put NOTE: |     param2....:                                              |;
        %put NOTE: |                                                              |;
        %put NOTE: +--------------------------------------------------------------+;
        %goto endmacro;
    %end;
    %else %if (%bquote(%upcase(&help.)) ne ) %then %do;
        %put &ER.&ROR.: Your &help request is not valid. Run pwd(help) for brief syntax help.;
        %goto endmacro;
    %end;

    **-----------------------------------------------------------------**
    CHECKING FOR REQUIRED PARAMETERS
    **-----------------------------------------------------------------**;
    %if not %length(&XXXX) %then %do;
      %put &ER.&ROR:(MMMM) Parameter XXXX required;
      %goto endmacro;
    %end;

%put --------------------EOF varlist.sas--------------------------;
%endmacro:

%mend XXXXX;
