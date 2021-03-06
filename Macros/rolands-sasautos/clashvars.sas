/*<pre><b>
/ Program   : clashvars
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 16 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To identify where there is a clash of variable characteristics and
/             output diagnostics.
/ SubMacros : none
/ Notes     : Output goes to a flat file. 
/ Usage     : %clashvars(mylib)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ libname           (pos) Libref.
/ file              Name of flat file for output.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro clashvars(libname,file=clashvars.txt);

%if not %length(&libname) %then %let libname=%sysfunc(getoption(user));
%if not %length(&libname) %then %let libname=work;


proc sql noprint;
  create table _clash as 
  select * from dictionary.columns
  where libname="%upcase(&libname)" and memtype='DATA'
  order by name, memname, type, length, format, label;
quit;

proc sort nodupkey data=_clash(keep=name type length format label)
                    out=_clashbad;
  by name type length format label;
run;

data _clashbad;
  set _clashbad;
  by name;
  if last.name and not first.name then output;
  keep name;
run;

data _clash;
  merge _clashbad(in=_bad) _clash;
  by name;
  if _bad;
run;

data _null_;
  file "&file" notitles noprint;
  set _clash;
  put @1 name @20 memname @35 type @40 length @45 format @60 label;
run;

proc datasets nolist;
  delete _clash _clashbad;
run;
quit;

%mend;  