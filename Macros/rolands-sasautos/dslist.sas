/*<pre><b>
/ Program   : dslist
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 02 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To list all the datasets in a libref.
/ SubMacros : none
/ Notes     : This is NOT a function-style macro. See usage notes.
/             You can set an option to prefix the dataset names with the libref.
/             The list of datasets will be written to the global macro variable
/             _dslist_.
/ Usage     : %dslist(work);
/             %let dslist=&_dslist_;
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ libref            (pos) Libref name for which all datasets are to ne listed
/ prefix            (pos) Set this to anything at all and all dataset names will
/                   be prefixed with the libref name.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro dslist(libref,prefix);
%global _dslist_;
%let _dslist_=;
%if not %length(&libref) %then %let libref=%sysfunc(getoption(user));
%if not %length(&libref) %then %let libref=work;
%let libref=%upcase(&libref);

proc sql noprint;
  select distinct memname into :_dslist_ separated by
  %if %length(&prefix) %then %do;
    " &libref.."
  %end;
  %else %do;
    ' '
  %end;
  from dictionary.tables
  where memtype='DATA'
  and libname="&libref";
quit;

%if %length(&prefix) %then %let _dslist_=&libref..&_dslist_;
run;
%mend;
