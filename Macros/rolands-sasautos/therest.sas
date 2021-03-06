/*<pre><b>
/ Program   : therest
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To give you everything following any found target string character
/ SubMacros : none
/ Notes     : It does an "indexc" on a string to find the first occurrence of any
/             of the characters in the target string and returns all the string
/             after that. If none of the target characters are found then a null
/             string is returned. The search is case sensitive.
/ Usage     : %let rest=%therest(&str,\/);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string            (pos) String to search
/ target            (pos) Target string
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro therest(string,target);

%local pos;

%if %sysfunc(indexc(&string,&target)) %then %do;
  %let pos=%sysfunc(indexc(&string,&target));
  %if &pos LT %length(&string) %then %qsubstr(&string,&pos+1);
%end;

%mend;  