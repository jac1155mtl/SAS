/*<pre><b>
/ Program   : stdfoot
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 09 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To generate a standard footnote that appears after the last defined
/             footnote.
/ SubMacros : %maxtitle
/ Notes     : This is a suggestion only and is here for illustration purposes.
/             This assumes you have run the %jobinfo macro already.
/ Usage     : %stdfoot
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ target='FF'x      Target character to place last in footnote so that the 
/                   %pagexofy macro can place the "Page x of y" label there.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro stdfoot(target='FF'x);
%local ls;
%let ls=%sysfunc(getoption(linesize));
%maxtitle

data _null_;
  length text $ 200;
  text="&_sysin_ &sysdate &systime &_user_";
  substr(text,&ls,1)=&target;
  call execute("footnote%eval(&_maxfoot_+1)"||' "'||substr(text,1,&ls)||'";');
run;

%mend;
  