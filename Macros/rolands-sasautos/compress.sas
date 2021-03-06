/*<pre><b>
/ Program   : compress
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 31 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To compress a macro string 
/ SubMacros : none
/ Notes     : This is a function-style macro.
/ Usage     : %let str2=%compress(&str,1234567890.);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string            (pos) String to compress
/ chars             (pos) Characters to compress out of the string
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro compress(string,chars);
%sysfunc(compress(&string,&chars))
%mend;
  