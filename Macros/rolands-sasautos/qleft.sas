/*<pre><b>
/ Program   : qleft.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 31 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To left-align the contents of a macro variable and return the
/             result quoted.
/ SubMacros : %verify %qcompress
/ Notes     : This is a function-style macro.
/ Usage     : %let macvar=%qleft(&macvar);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string	    (pos) String to left-align
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro qleft(string);
%if %length(%qcompress(&string,%str( )))
  %then %qsubstr(&string,%verify(&string,%str( )));
%mend;
