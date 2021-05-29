/*<pre><b>
/ Program   : globlist
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 August 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return a list of current global macro variable names
/ SubMacros : none
/ Notes     : All global macro variable names will be in uppercase.
/ Usage     : %let glist=%globlist;
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

%macro globlist;

%local dsid rc scope scopenum namenum globflag globlist;
%let globflag=0;


%let dsid=%sysfunc(open(sashelp.vmacro,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (globlist) sashelp.vmacro not opened due to the following reason:;
  %put %sysfunc(sysmsg());
  %goto error;
%end;
%else %do;
  %let scopenum=%sysfunc(varnum(&dsid,scope));
  %let namenum=%sysfunc(varnum(&dsid,name));
%end;

%readloop:
  %let rc=%sysfunc(fetch(&dsid));
  %if &rc %then %goto endoff;
  %let scope=%sysfunc(getvarc(&dsid,&scopenum));
  %if "&scope" NE "GLOBAL" and &globflag %then %goto endoff;
  %else %if "&scope" EQ "GLOBAL" and not &globflag %then %let globflag=1;
  %if &globflag %then %let globlist=&globlist %sysfunc(getvarc(&dsid,&namenum));
%goto readloop;


%endoff:
&globlist
%let rc=%sysfunc(close(&dsid));


%goto skip;
%error:
%put ERROR: (globlist) Leaving globlist macro due to error(s) listed;
%skip:
%mend;
