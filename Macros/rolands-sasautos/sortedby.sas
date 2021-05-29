/*<pre><b>
/ Program   : sortedby
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the variables a dataset is sorted by or null if not
/ SubMacros : %attrc
/ Notes     : This is a shell macro that calls %attrc
/ Usage     : %let sortedby=%sortedby(dsname);
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

%macro sortedby(ds);
%attrc(&ds,sortedby)
%mend;
