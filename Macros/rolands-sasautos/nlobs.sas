/*<pre><b>
/ Program   : nlobs
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the number of logical observations (i.e. number not
/             marked for deletion) in a dataset. This will either be a positive
/             integer or forced to zero.
/ SubMacros : %attrn
/ Notes     : This is a shell macro that calls %attrn
/ Usage     : %let nlobs=%nlobs(dsname);
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

%macro nlobs(ds);
%local nlobs;
%let nlobs=%attrn(&ds,nlobs);
%if &nlobs LT 0 %then %let nlobs=0;
&nlobs
%mend;
