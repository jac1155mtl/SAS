/*********************************************************************
MACRO NAME          : pwd

PURPOSE             : Macro for returning random generic password string
                      
PARAMETERS          : pwdLength - length of password generated

RETURNS             : macro variable with random generic password string

EXTERNAL MACROS     : n/a

NOTES               : run %pwd(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : pwd(); 
                      pwd(help);
                      pwd(pwdLength=10);
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Lars Tynelius       18DEC2007   created
*********************************************************************/;

%macro pwd(help, pwdLength=8);
  %local chars i _rc tmp _length uppChars lowChars numChars repChar;

  %if (%bquote(%upcase(&help)) eq HELP) %then %do;
    %put NOTE: +--------------------------------------------------------------+;
    %put NOTE: | Help for macro PWD                                           |;
    %put NOTE: |   Macro for generating random password string containing     |;
    %put NOTE: |   at least one digit or one char.                            |;
    %put NOTE: |                                                              |;
    %put NOTE: |   Parameters                                                 |;
    %put NOTE: |     pwdLength....: Length of the password generated, def 8   |;
    %put NOTE: |                                                              |;
    %put NOTE: +--------------------------------------------------------------+;
    %goto exit;
  %end;
  %else %if (%bquote(%upcase(&help)) ne ) %then %do;
    %put ERROR: Your &help request is not valid. Run [macroname](help) for brief syntax help.;
    %goto exit;
  %end;

  %let _rc = ;

  %let uppChars = ABCDEFGHIJKLMNOPQRSTUVWXYZ;
  %let lowChars = abcdefghijklmnopqrstuvwxyz;
  %let numChars = 0123456789;

  %let chars = &uppChars&lowChars&numChars;
  %let _length = %length(&chars) + 1;

  %do i=1 %to &pwdLength;
    %let _rc =  &_rc%cmpres(%substr(&chars,%sysfunc(floor(%sysfunc(ranuni(0))*(&_length-1)+1)),1));
  %end;

  /* one digit must exists */
  %if (%sysfunc(anydigit(&_rc,1)) eq 0) %then %do;
    %let _length = %length(&numChars) + 1;
    %let repChar = %cmpres(%substr(&numChars,%sysfunc(floor(%sysfunc(ranuni(0))*(&_length-1)+1)),1));

    /* replace one of the chars make it random depending on the length */
    %let replaceInd =  %cmpres(%sysfunc(floor(%sysfunc(ranuni(0))*((&pwdLength+1)-1)+1)));

    %do i=1 %to &pwdLength;
      %if (&i eq &replaceInd) %then %let tmp = %cmpres(&tmp)&repChar;
      %else %let tmp = %cmpres(&tmp)%substr(&_rc,&i,1);
    %end;

    %let _rc = &tmp;
  %end;

  /* one char must exists */
  %if (%sysfunc(notdigit(&_rc,1)) eq 0) %then %do;
    %let _length = %length(&uppChars&lowChars) + 1;
    %let repChar = %cmpres(%substr(&uppChars&lowChars,%sysfunc(floor(%sysfunc(ranuni(0))*(&_length-1)+1)),1));

    /* replace one of the chars make it random depending on the length */
    %let replaceInd =  %cmpres(%sysfunc(floor(%sysfunc(ranuni(0))*((&pwdLength+1)-1)+1)));

    %do i=1 %to &pwdLength;
      %if (&i eq &replaceInd) %then %let tmp = %cmpres(&tmp)&repChar;
      %else %let tmp = %cmpres(&tmp)%substr(&_rc,&i,1);
    %end;

    %let _rc = &tmp;
  %end;

  &_rc

  %exit:
%mend;
/*%put %pwd;*/
/*%put %pwd(pwdLength=10);*/
/*%let pwd = %pwd;*/
/*%pwd(help);*/

