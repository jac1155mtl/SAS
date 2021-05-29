/*<pre><b>
/ Program   : lowcase
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return a lower-case version of a macro variable's contents
/ SubMacros : none
/ Notes     : This is a direct replacement for a SI-supplied sasautos member of
/             the same name.
/ Usage     : %let lcase=%lowcase(&string);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string            (pos) String to lower-case
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro lowcase(string);
%if %length(&string) %then %sysfunc(lowcase(&string));
%mend;
