/*<pre><b>
/ Program   : hasvarsn
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 01 June 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return true if a dataset has all the numeric variables 
/ SubMacros : %match %varlistn
/ Notes     : Non-matching variables will be returned in the global macro
/             variable _nomatch_ .
/ Usage     : %if not %hasvarsn(dsname,aa bb cc) %then %do ....
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                (pos) Dataset
/ varlist           (pos) Space-delimited list of variables to check
/ casesens=no       By default, case is not important
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro hasvarsn(ds,varlist,casesens=no);
%local varmatch;
%if not %length(&casesens) %then %let casesens=no;
%let casesens=%upcase(%substr(&casesens,1,1));

%let varmatch=%match(%varlistn(&ds),&varlist,casesens=&casesens);

%if not %length(&_nomatch_) %then 1;
%else 0;

%mend;
  