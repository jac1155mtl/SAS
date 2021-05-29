/*<pre><b>
/ Program   : varnum
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the variable position in a dataset or 0 if not there
/ SubMacros : none
/ Notes     : Since only 0 or a positive integer is returned you can use this
/             like a truth statement such as %if %varnum(dsname,varnam) %then..
/ Usage     : %let varnum=%varnum(dsname,varname);
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

%macro varnum(ds,var);

%local dsid rc varnum;
%let varnum=0;

%let dsid=%sysfunc(open(&ds,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (varnum) Dataset &ds not opened due to the following reason:;
  %put %sysfunc(sysmsg());
%end;
%else %do;
  %let varnum=%sysfunc(varnum(&dsid,&var));
  %let rc=%sysfunc(close(&dsid));
%end;
&varnum
%mend;