/*<pre><b>
/ Program   : chkuniq
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 01 June 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To check for uniqueness in key variables.
/ SubMacros : %eqsuff
/ Notes     : This does not sort a dataset.
/ Usage     : %chkuniq(dsname)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                (pos) Dataset
/ keyvars           (pos) Space-delimited list of key variables 
/ sevind=e          Severity indicator. Use W or E for warning or error.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro chkuniq(ds,keyvars,sevind=e);

%if %upcase(%substr(&sevind,1,1)) EQ E %then %let sevind=ERROR;
%else %if %upcase(%substr(&sevind,1,1)) EQ W %then %let sevind=WARNING;

proc sort data=&ds(keep=&keyvars) out=_chkuniq;
  by &keyvars;
run;

data _null_;
  set _chkuniq;
  by &keyvars;
  if (first.%scan(&keyvars,-1,%str( ))) and not (last.%scan(&keyvars,-1,%str( )))
    then put "&sevind: Dataset &ds is not unique for keys " %eqsuff(&keyvars);
run;

proc datasets nolist;
  delete _chkuniq;
run;
quit;

%mend;


  