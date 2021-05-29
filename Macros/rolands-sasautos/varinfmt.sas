/*<pre><b>
/ Program   : varinfmt
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return a variable informat
/ SubMacros : %attrv
/ Notes     : This is a shell macro that calls %attrv
/ Usage     : %let varinfmt=%varinfmt(dsname,varname);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                Dataset name (pos)
/ var               Variable name (pos)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro varinfmt(ds,var);
%attrv(&ds,&var,varinfmt)
%mend;
