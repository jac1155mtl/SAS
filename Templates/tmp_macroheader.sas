/*********************************************************************
MACRO NAME           : 

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
	Checking for required parameters
    **-----------------------------------------------------------------**;
	%local error;
	%let error = 0;
	%if not %length(&XXXX) %then %do;
		%put ERROR:(MMMM) Parameter XXXX required;
		%let error = 1;
	%end;
	%if &error %then %goto endmacro;

%put --------------------EOF XXXXX.sas--------------------------;
%endmacro:

%mend XXXXX;
