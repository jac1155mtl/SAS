/*<pre><b>
/ Program   : equals
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 02 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To compare two numeric values to find if they are equal or very
/             nearly equal.
/ SubMacros : none
/ Notes     : This technique  was copied from the SAS Technical Support site but
/             amended slightly. You use it in a data step. You can get very
/             slight differences in values depending how a value was arrived at
/             but they will be very close. This code will compare them but allow
/             for tiny differences.
/ Usage     : if %equals(val1,7.3) then ...
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ val1              (pos) First value for comparison (can be text or a variable)
/ val2              (pos) Second value for comparison (can be text or a variable)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro equals(val1,val2);
(abs(&val1-&val2) LE 1E-15*max(abs(&val1),abs(&val2)))
%mend;
