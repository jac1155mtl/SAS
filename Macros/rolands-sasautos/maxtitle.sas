/*<pre><b>
/ Program   : maxtitle
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 09 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To find the highest number title and footnote and output to global
/             macro variables.
/ SubMacros : none
/ Notes     : The global macro variables used to hold the maximum for titles and
/             footnotes will be _maxtitle_ and _maxfoot_ .
/ Usage     : %maxtitles
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ N/A
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro maxtitle;

%global _maxtitle_ _maxfoot_;
%let _maxtitle_=0;
%let _maxfoot_=0;

data _null_;
  retain maxtitle maxfoot 0;
  set sashelp.vtitle end=last;
  if type='T' then maxtitle=number;
  else if type='F' then maxfoot=number;
  if last then do;
    call symput('_maxtitle_',compress(put(maxtitle,2.)));
    call symput('_maxfoot_',compress(put(maxfoot,2.)));
  end;
run;

%mend;
