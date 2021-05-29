/*<pre><b>
/ Program   : dslabel
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the dataset label
/ SubMacros : %attrc
/ Notes     : This is a shell macro that calls %attrc
/ Usage     : %let dslabel=%dslabel(dsname);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                Dataset name
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro dslabel(ds);
%attrc(&ds,label)
%mend;
