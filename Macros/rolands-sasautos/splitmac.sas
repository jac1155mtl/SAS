/*<pre><b>
/ Program   : splitmac
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 05 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To insert split characters in a macro expression
/ SubMacros : none
/ Notes     : This is the sister macro to %splitvar except it works on macro
/             values instead of SAS variables. It is a function-style macro.
/
/             A split character will normally be placed in a blank space. If
/             there is no suitable space then it will be inserted after a hyphen.
/             But if there is no suitable space and no hyphen then it will be
/             inserted at the end. 
/
/             This macro will only look back the floor of half the column width
/             to find a place to insert the split character.
/
/             If the input string has one or more equals signs in it then enclose
/             the string in %str(). If it has one or more commas in it then
/             enclose it in %quote().
/
/ Usage     : %let str=The quick brown fox jumped over the lazy dog;
/             %let splitstr=%splitmac(&str,10);
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ str               (pos) Macro string to split.
/ cols              (pos) Maximum number of columns allowed.
/ split=*           Split character. Must be a single character, unquoted.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro splitmac(str,cols,split=*);

%local error _cols tempstr res;
%let error=0;

%if not %length(&str) %then %do;
  %let error=1;
  %put ERROR: (splitvar) No string supplied as first positional parameter;
%end;

%if not %length(&cols) %then %do;
  %let error=1;
  %put ERROR: (splitvar) No column width supplied as second positional parameter;
%end;
%else %if %sysfunc(verify(&cols,1234567890)) %then %do;
  %let error=1;
  %put ERROR: (splitvar) Cols parameter "&cols" not a valid number of columns;
%end;

%if not %length(&split) %then %let split=*;

%if %length(&split) GT 1 %then %do;
  %let error=1;
  %put ERROR: (splitvar) Split character &split is not a single unquoted character;
%end;

%if &error %then %goto error;
%let tempstr=&str;


%do %while(%length(&tempstr) GT &cols);
  %do _cols=(&cols+1) %to %eval(&cols/2) %by -1;
    %if "%qsubstr(%quote(&tempstr),&_cols,1)" EQ " " %then %do;
      %let res=&res%qsubstr(%quote(&tempstr),1,%eval(&_cols - 1))&split;
      %let tempstr=%qsubstr(%quote(&tempstr),%eval(&_cols+1));
      %let _cols=1;
    %end;
  %end;
  %*- if space character not found look for a hyphen -;
  %if &_cols GT 1 %then %do;
    %do _cols=&cols %to %eval(&cols/2) %by -1;
      %if "%qsubstr(%quote(&tempstr),&_cols,1)" EQ "-" %then %do;
        %let res=&res%qsubstr(%quote(&tempstr),1,&_cols)&split;
        %let tempstr=%qsubstr(%quote(&tempstr),%eval(&_cols+1));
        %let _cols=1;
      %end;
    %end;
  %end;
  %*- if no hyphen found then split at end -;
  %if &_cols GT 1 %then %do;
    %let res=&res%qsubstr(%quote(&tempstr),1,&cols)&split;
    %let tempstr=%qsubstr(%quote(&tempstr),&cols+1);
  %end;
%end;

&res&tempstr

%goto skip;
%error:
%put ERROR: (splitmac) Leaving splitmac macro due to error(s) listed;
%skip:
%mend;