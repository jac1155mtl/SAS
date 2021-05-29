/*<pre><b>
/ Program   : nvarsn
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the number of numeric variables in a dataset
/ SubMacros : %varlistn %words
/ Notes     : 
/ Usage     : %let nvarsn=%nvarsn(dsname);
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

%macro nvarsn(ds);
%words(%varlistn(&ds))
%mend;
