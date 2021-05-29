/*<pre><b>
/ Program   : varlen
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 27 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return a variable length. Character variables will have the 
/             length preceded by a "$ " so you can use it in a length statement
/             in a data step. Set the nodollar paremater to anything to suppress
/             the dollar sign.
/ SubMacros : %attrv %vartype
/ Notes     : This is a shell macro that calls %attrv
/ Usage     : %let varlen=%varlen(dsname,varname);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                Dataset name (pos)
/ var               Variable name (pos)
/ nodollar          (pos) If this is set to anything then the dollar shown for 
/                   character length will be suppressed
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  01nov02         Added parameter to suppress the $
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro varlen(ds,var,nodollar);
%local varlen;
%let varlen=%attrv(&ds,&var,varlen);
%if "%vartype(&ds,&var)" EQ "C" and %length(&nodollar) EQ 0 
  %then %let varlen=$ &varlen;
&varlen
%mend;
