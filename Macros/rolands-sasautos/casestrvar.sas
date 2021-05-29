/*<pre><b>
/ Program   : casestrvar
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 09 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To force mixed case forms of a string into the string itself.
/ SubMacros : none
/ Notes     : This must be used in a data step as shown in the usage notes.
/             The macro version of this macro is %casestrmac. This is NOT a 
/             function-style macro.
/ Usage     : data test2;
/              set test;
/              %casestrvar(text,'Roland');
/             run;
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ var               (pos) Text variable.
/ str               (pos) String (quoted) to enforce case.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro casestrvar(var,str);
_casepos=1;
do while(index(upcase(substr(&var,_casepos)),upcase(&str)));
  _casepos=_casepos-1+index(upcase(substr(&var,_casepos)),upcase(&str));
  if substr(&var,_casepos,length(&str)) NE trim(&str) 
    then substr(&var,_casepos,length(&str))=trim(&str);
  _casepos=_casepos+length(&str);
end;
drop _casepos;
%mend;