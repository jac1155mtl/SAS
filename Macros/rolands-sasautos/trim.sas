/*<pre><b>
/ Program   : trim.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 26 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To trim the contents of a macro variable
/ SubMacros : %verifyb
/ Notes     : This is a function-style macro.
/ Usage     : %let macvar=%trim(&macvar);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string            (pos) String to trim
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro trim(string);
%if %length(%sysfunc(compress(&string,%str( ))))
  %then %substr(&string,1,%verifyb(&string,%str( )));
%mend;
