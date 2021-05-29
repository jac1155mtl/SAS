/*<pre><b>
/ Program   : popfmt
/ Version   : 2.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 05 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To take an existing format for treatment groups and create a new
/             format that shows population totals at the end.
/ SubMacros : %words %varnum
/ Notes     : There are two different ways of using this macro depending on the
/             population dataset you supply. If you supply a value for uniqueid=
/             then it assumes you want to calculate population totals and it will
/             keep the dataset with the calculated totals as "popfmt" with the
/             total population variable named as what you supply to n= .
/             If, however, you do not supply a uniqueid= value then it assumes 
/             that you have already calculated population totals and they will be
/             found in what you supplied to the n= parameter. No "popfmt" dataset
/             will therefore be created since it assumes you already have a
/             dataset with population totals in.
/ Usage     : %popfmt(fmtin=tmt.,fmtout=tmtpop.,dspop=popds,tmtvar=tmt,
/             uniqueid=patient,tmttot=99,split=/)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ fmtin=            Name of input treatment format
/ fmtout=           Name of output format with (N=nnn) population added. This 
/                   default to the fmtin= value with an "n" at the end if not
/                   set. 
/ dspop=            Name of dataset from which to calculate populations
/ tmtvar=           Name of treatment variable
/ uniqueid=         Variable whose value uniquely identifies a population member
/ n=                Name of the variables that holds the population count.
/ tmttot=           Code or value of the treatment variable that is for the total
/                   of all the treatment arms. This should be represented in your 
/                   input format. If this is character then enclose in quotes.
/ split=            Split character to use just before the (N=nnn) (unquoted)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  05nov02         redesigned
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro popfmt(fmtin=,
             fmtout=,
              dspop=,
             tmtvar=,
           uniqueid=,
                  n=,
             tmttot=,
              split=
              );

%local error;
%let error=0;


/*----------------------------------------------*
    Check all required parameters have been set
 *----------------------------------------------*/

%if %length(&fmtin) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (popfmt) fmtin= parameter not set;
%end;

%if %length(&dspop) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (popfmt) dspop= parameter not set;
%end;

%if %length(&tmtvar) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (popfmt) tmtvar= parameter not set;
%end;

%if %words(&tmtvar) GT 1 %then %do;
  %let error=1;
  %put ERROR: (popfmt) tmtvar= parameter must be a single variable;
%end;

%if %length(&n) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (popfmt) n= parameter not set;
%end;

%if %words(&uniqueid) GT 1 %then %do;
  %let error=1;
  %put ERROR: (popfmt) uniqueid= parameter must be a single variable;
%end;

%if &error %then %goto error;


%let fmtin=%sysfunc(compress(&fmtin,.));
%if %length(&fmtout) EQ 0 %then %let fmtout=&fmtin.n;
%else %let fmtout=%sysfunc(compress(&fmtout,.));


%if not %length(&uniqueid) %then %goto resume;


/*==============================================*
 *==============================================*
    PROCESSING FOR CALCULATING POP TOTALS
 *==============================================*
 *==============================================*/



/*----------------------------------------------*
        Create temporary population dataset
 *----------------------------------------------*/

*- create a temporary population dataset -;
data _pop;
  set &dspop;
run;

%if not %varnum(_pop,&tmtvar) %then %do;
  %let error=1;
  %put ERROR: (popfmt) Treatment variable &tmtvar not in population dataset;
%end;

%if not %varnum(_pop,&uniqueid) %then %do;
  %let error=1;
  %put ERROR: (popfmt) Subject identifier &uniqueid not in population dataset;
%end;

%if &error %then %goto error;



/*----------------------------------------------*
          Calculate population totals
 *----------------------------------------------*/

proc sort nodupkey data=_pop(keep=&tmtvar &uniqueid) out=popfmt;
  by &tmtvar &uniqueid;
run;
 
proc summary nway data=popfmt;
  class &tmtvar;
  output out=popfmt(drop=_type_ rename=(_freq_=&n));
run;

%let dspop=popfmt;



/*----------------------------------------------*
         Calculate for all treatment arms
 *----------------------------------------------*/

%if %length(&tmttot) GT 0 %then %do;

  proc sort nodupkey data=_pop(keep=&uniqueid) out=_popall;
    by &uniqueid;
  run;

  proc summary nway data=_popall;
    output out=_popall(drop=_type_ rename=(_freq_=&n));
  run;

  data popfmt;
    set popfmt _popall(in=_all);
    if _all then &tmtvar=&tmttot;
  run; 

  proc sort data=popfmt;
    by &tmtvar;
  run;

  proc datasets nolist;
    delete _popall;
  run;
  quit;

%end;



/*==============================================*
 *==============================================*
    CONTINUE PROCESSING POPULATION DATASET
 *==============================================*
 *==============================================*/

%resume:

/*----------------------------------------------*
               Create output format
 *----------------------------------------------*/

data _pop;
  retain fmtname "&fmtout";
  length label $ 80;
  set &dspop;
  %if %length(&split) EQ 0 %then %do;
    label=trim(put(&tmtvar,&fmtin..))||' (N='||compress(put(&n,11.))||')';
  %end;
  %else %do;
    label=trim(put(&tmtvar,&fmtin..))||"&split(N="||compress(put(&n,11.))||')';
  %end;
  rename &tmtvar=start;
  drop &n;
run;


proc format cntlin=_pop;
run;



/*----------------------------------------------*
                Tidy up and exit
 *----------------------------------------------*/

proc datasets nolist;
  delete _pop;
run;


%goto skip;
%error:
%put ERROR: (popfmt) Leaving popfmt macro due to error(s) listed;
%skip:
%mend;