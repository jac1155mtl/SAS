/*<pre><b>
/ Program   : sumtab
/ Version   : 1.1
/ Author    : Roland Rashleigh-Berry
/ Date      : 27 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To produce a table of summary statistics
/ SubMacros : %vartype %varlist %words %quotelst %getvalue %varlen
/ Notes     : This will produce stats like N, Mean, Max etc. for numerics and
/             counts plus percentages of categories for character variables as well
/             as numeric variables mapped to a non-numeric format.
/ Usage     : 
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ dsin=             Input dataset.
/ varlist=          List of variables to obtain summary statistics for. This can
/                   be a mixture of numeric and character variables. 
/ by=               By variable(s) if required.
/ level1=           Grouping variable to go in first column. Must be labeled.
/ width1=20         Width to allow for the first column (report style=1 only)
/ width2=20         Width to allow for the variable label column.
/ label2='Measure'  Column header label for the variable label column.
/ width3=10         Width to allow for the stats-name/category column.
/ label3='Statistic/' 'Category'
/                   Column header label for the stats-name/category column.
/ tmtvar=           Treatment arm variable.
/ tmtlabel=         Label to use for the treatment variable that will be
/                   displayed over the treatment arms columns. Set this to ' ' if
/                   you don't want anything displayed. If left null then the
/                   variable label will be used.
/ tmttot=           Value representing the total for all treatment arms. This
/                   will not be calculated if it is blank. If this is a character
/                   then it must be enclosed in quotes.
/ tmtfmt=           Format to used to decode treatment arm values.
/ fmtin=            This is the base format for creating another format with
/                   (N=nnn) added to the end.
/ fmtout=           This is the format with (n=nnn) endings. If you have set
/                   fmtin= but not this, then by default it adds an "n" at the
/                   end of the format name. If this is created it will override
/                   anything defined to tmtfmt= .
/ tmtall=no         By default, do not display the totals for the treatment arms.
/ tmtpos=left       Position above the column for the treatment arm label.
/ subspace='FE'x    This is a special character you will use to put in a text
/                   field to preserve alignment that you are going to substitute
/                   with a space afterwards. This will be used if you opt to set
/                   tmtpos= to "right" or "center". You can use the %subspace or
/                   %pagexofy macro to reset these to spaces later.
/ dspop=            External population dataset (if required) for use in
/                   creating an output format. Note that if this contains all
/                   variables also specified as by= variables then this dataset
/                   will be subsetted before the output format is made.
/                   At mimimum, this dataset must contain the tmtvar= variable
/                   and the uniqueid= variable. It will be a population dataset,
/                   hence its name.
/ uniqueid=         Variable that uniquely identifies a subject. It is a count of
/                   this that will give us our "(N=nnn)" value for the output
/                   format.
/ addzeros=yes      By default, add zeros where one or more treatment arms are
/                   missing a count for a category where it exists for another
/                   treatment arm.
/ style=            Report style. 1=level1 and level2 in separate columns, 
/                   2=level1 and level2 share a column but with level2 categories
/                   indented. Note that this setting will only have effect if
/                   level1= has been given a value.
/ flatten=no        This is for "flattening" the report so that there is no
/                   blank line between the treatment arm column headings and the
/                   the table.
/ spacing=2         Spaces to leave between the columns.
/ headline=yes      By default, put a dashed line under the column headings.
/ headskip=yes      By default, leave a blank line between the column headings
/                   and the first line of data in the report.
/ split=*           Split character. Must be unquoted.
/ pctfmt=           Format to use for the percent. An internal format will be 
/                   used if this is left blank and the width will be forced to
/                   6 characters. You should ensure that this internal format
/                   suits your purpose if you intend to use it.
/ pctwidth=6        By default, use 6 characters for the formatted percentage.
/ nwidth=4          By default, use 4 characters for the "n" value.
/ indent=3          For style=2 only, indent the level2 categories 3 spaces.
/ stats=            Stats to calculate for non-categorical numeric variables.
/ dpplus1=          Stats to show to an extra decimal point beyond raw data. You
/                   can have entries in this list even though you do not intend
/                   to calculate stats for them.
/ dpplus2=          Stats to show to two extra decimal points beyond raw data.
/                   You can have entries in this list even though you do not
/                   intend to calculate stats for them.
/ missing=no        By default, do not count or alert missing categoricals.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  26jan03         style=2 functionality added for version 1.1
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro sumtab(dsin=,
           varlist=,
                by=,
            level1=,
            width1=20,
            width2=20,
            label2='Measure',
            width3=10,
            label3='Statistic/' 'Category',
            tmtvar=,
          tmtlabel=,
            tmttot=,
            tmtfmt=,
             fmtin=,
            fmtout=,
            tmtall=no,
            tmtpos=left,
          subspace='FE'x,
             dspop=,
          uniqueid=,
          addzeros=yes,
             style=,
           flatten=no,
           spacing=2,
          headline=yes,
          headskip=yes,
             split=*,
            pctfmt=,
          pctwidth=6,
            nwidth=4,
            indent=3,
             stats=n Mean Median Min Max Std,
           dpplus1=mean median,
           dpplus2=std,
           missing=no
            );

/*--------------------------------------------------------* 
      Check we have enough parameters set to proceed
 *--------------------------------------------------------*/

%local i error bypop flatvars byline catlist numlist var 
       typelist flatvars bypop; 
%let error=0;
%let bypop=0;


%if %length(&by) %then %let byline=by &by %str(;);

%if not %length(&dsin) %then %do;
  %let error=1;
  %put ERROR: (sumtab) dsin= parameter not given a value;
%end;

%if not %length(&varlist) %then %do;
  %let error=1;
  %put ERROR: (sumtab) No variables specified to varlist= parameter;
%end;

%if not %length(&width1) %then %let width1=20;
%if not %length(&width2) %then %let width2=20;
%if not %length(&width3) %then %let width3=10;

%if not %length(&tmtvar) %then %do;
  %let error=1;
  %put ERROR: (sumtab) No treatment variable specified to tmtvar= parameter;
%end;
%else %if %words(&tmtvar) GT 1 %then %do;
  %let error=1;
  %put ERROR: (sumtab) Only one variable allowed for tmtvar=;
%end;

%if not %length(&uniqueid) %then %do;
  %let error=1;
  %put ERROR: (sumtab) No subject identifier variable specified to uniqueid= parameter;
%end;
%else %if %words(&uniqueid) GT 1 %then %do;
  %let error=1;
  %put ERROR: (sumtab) Only one variable allowed for uniqueid=;
%end;

%if not %length(&tmtall) %then %let tmtall=no;
%let tmtall=%upcase(%substr(&tmtall,1,1));

%if not %length(&tmtpos) %then %let tmtpos=left;
%let tmtpos=%upcase(%substr(&tmtpos,1,1));
%if %length(%sysfunc(compress(&tmtpos,LRC))) %then %do;
  %let error=1;
  %put ERROR: (sumtab) tmtpos=&tmtpos should be left, right or centre;
%end;
%else %do;
  %if "&tmtpos" EQ "L" %then %let tmtpos=left;
  %else %if "&tmtpos" EQ "R" %then %let tmtpos=right;
  %else %if "&tmtpos" EQ "C" %then %let tmtpos=center;
%end;

%if not %length(&addzeros) %then %let addzeros=yes;
%let addzeros=%upcase(%substr(&addzeros,1,1));

%if not %length(&level1) %then %let style=1;
%if "&style" NE "1" and "&style" NE "2" %then %do;
  %let error=1;
  %put ERROR: (sumtab) style= parameter must be set to 1 or 2;
%end;

%if not %length(&flatten) %then %let flatten=no;
%let flatten=%upcase(%substr(&flatten,1,1));

%if not %length(&spacing) %then %let spacing=2;

%if %length(&headline) EQ 0 %then %let headline=yes;
%let headline=%upcase(%substr(&headline,1,1));
%if "&headline" EQ "Y" %then %let headline=headline;
%else %let headline=;

%if %length(&headskip) EQ 0 %then %let headskip=yes;
%let headskip=%upcase(%substr(&headskip,1,1));
%if "&headskip" EQ "Y" %then %let headskip=headskip;
%else %let headskip=;

%let split=%sysfunc(compress(&split,%str(%'%")));

%if not %length(&missing) %then %let missing=no;
%let missing=%upcase(%substr(&missing,1,1));
%if "&missing" EQ "Y" %then %let missing=missing;
%else %let missing=;

%if %length(&pctwidth) EQ 0 %then %let pctwidth=6;
%if %length(&nwidth) EQ 0 %then %let nwidth=4;
%if %length(&indent) EQ 0 %then %let indent=3;

%if %length(&fmtin) %then %let fmtin=%sysfunc(compress(&fmtin,.)).;
%if %length(&fmtin) and not %length(&fmtout) 
  %then %let fmtout=%sysfunc(compress(&fmtin,.))n.;
%if %length(&fmtout) %then %let fmtout=%sysfunc(compress(&fmtout,.)).;
%if %length(&fmtout) %then %let tmtfmt=&fmtout;

%if %length(&fmtin) and not %length(&dspop) %then %do;
  %let error=1;
  %put ERROR: (sumtab) You have supplied a value for fmtin= but not for dspop=;
%end;

%if &error %then %goto error;



/*--------------------------------------------------------*
                Create required formats
 *--------------------------------------------------------*/

proc format;
  invalue _statno
  %do i=1 %to %words(&stats);
    "%scan(&stats,&i,%str( ))"=&i
  %end;
  ;


%if %length(&pctfmt) EQ 0 %then %do;

  %let pctfmt=pctfmt.;
  %let pctwidth=6;

  picture pctfmt (round)
  0        = '(  0%)' (noedit)
  0<-<1    = '( <1%)' (noedit)
  1-<9.5   = '9%)' (prefix='(  ')
  9.5-99   = '99%)' (prefix='( ')
  99<-<100 = '(>99%)' (noedit)
  100      = '(100%)' (noedit)
  ;

%end;

run;



/*========================================================* 
 *========================================================* 
      Define macro to process the population dataset
 *========================================================* 
 *========================================================*/

%macro dspop;

  data _sumtabp;
    set &dspop;
  run;

  %if not %varnum(_sumtabp,&tmtvar) %then %do;
    %let error=1;
    %put ERROR: (sumtab) Treatment variable "&tmtvar" not in population dataset;
  %end;

  %if not %varnum(_sumtabp,&uniqueid) %then %do;
    %let error=1;
    %put ERROR: (npctcalc) Uniqueid variable "&uniqueid" not in population dataset;
  %end;


  %*- keep only required variables in the population dataset -;
  %*- By default assume the pop dataset has all the by variables -;
  %*- whether any were specified or not -;
  %let bypop=1;
  %*- If there are any "by" variables and the pop dataset is missing  -;
  %*- even one of them then set bypop to false so that we later merge -;
  %*- by treatment arm and not by "by" variables. -;
  %do i=1 %to %words(&by);
    %if not %varnum(_npctpop,%scan(&by,&i,%str( ))) %then %let bypop=0;
  %end;
  *- only keep the "by" variables if they are all present -;
  data _sumtabp;
    set _sumtabp(keep=&tmtvar &uniqueid
    %if &bypop %then %do;
      &by
    %end;
    );
  run;

  %*- add totals for all treatment arms if set -;
  %if %length(&tmttot) and ("&tmtall" EQ "Y") %then %do;
    data _sumtabp;
      set _sumtabp _sumtabp(in=_all);
      if _all then &tmtvar=&tmttot;
    run;
  %end;

  proc summary nway data=_sumtabp;
    class
    %if &bypop %then %do;
      &by
    %end;
      &tmtvar &uniqueid;
    output out=_sumtabp(drop=_type_ _freq_);
   run;

  proc summary nway data=_sumtabp;
    class
    %if &bypop %then %do;
      &by
    %end;
      &tmtvar;
    output out=_sumtabp(drop=_type_ rename=(_freq_=n));
   run;

  %*- Create a "by" dataset -;
  %if %length(&by) and &bypop %then %do;
    proc summary nway data=_sumtab;
      class &by;
      output out=_sumtaby(drop=_type_ _freq_);
    run;

    data _sumtaby;
      set _sumtaby;
      _obs=_n_;
    run;
  %end;
  
%mend;



/*========================================================*
 *========================================================*
        Define macro to process categorical data
 *========================================================*
 *========================================================*/

%macro cat(var,varnum);

  data _sumtabc;
    retain _varnum &varnum;
    length _catstat $ 40 _label $ 40 _var _fmt $ 20 _vtype $ 1;
    set _sumtab(keep=&by &level1 _startcol &tmtvar &var);
    _label=vlabel(&var);
    _var="&var";
    _fmt=vformat(&var);
    _vtype=vtype(&var);
    if _fmt ne ' ' then do;
      if _vtype='C' then do;
        if &var NE ' ' then _catstat=putc(&var,_fmt);
        else _catstat='Missing';
      end;
      else do;
        if &var NE ' ' then _catstat=putn(&var,_fmt);
        else _catstat='Missing';
      end;
    end;
    else _catstat=&var;
  run;

  proc summary nway data=_sumtabc
    %if not %length(&missing) %then %do;
      (where=(_catstat NE 'Missing'))
    %end;
    ;
    class &by &level1 _startcol &tmtvar;
    id _label _var _varnum;
    output out=_sumtabt(drop=_type_ rename=(_freq_=_tot_));
  run;

  proc summary nway &missing data=_sumtabc
    %if not %length(&missing) %then %do;
      (where=(_catstat NE 'Missing'))
    %end;
    ;
    class &by &level1 _startcol &tmtvar _catstat;
    id _label _var _varnum;
    output out=_sumtabc(drop=_type_);
  run;

  data _sumtabc;
    retain _dummy 0;
    length _str $ %eval(&nwidth+&spacing+&pctwidth);
    merge _sumtabt _sumtabc;
    by &by &level1 _startcol &tmtvar;
    _str=put(_freq_,&nwidth..)||'  '||put(100*_freq_/_tot_,&pctfmt);
    %if "&tmtpos" NE "left" %then %do;
      if substr(_str,%eval(&nwidth+&spacing+&pctwidth),1) EQ ' '
      then substr(_str,%eval(&nwidth+&spacing+&pctwidth),1)=&subspace;
    %end;
    if _catstat='Missing' then _statno=9;
    else _statno=5;
    drop _freq_ _tot_;
  run;

  data _sumtabt;
    retain _dummy 0 _statno 0;
    length _catstat $ 40 _str $ %eval(&nwidth+&spacing+&pctwidth);
    set _sumtabt;
    _str=put(_tot_,&nwidth..);
    _catstat='n';
    %if "&tmtpos" NE "left" %then %do;
      substr(_str,%eval(&nwidth+&spacing+&pctwidth),1)=&subspace;
    %end;
    drop _tot_;
  run;


  proc append base=_sumtabx data=_sumtabt;
  run;

  proc append base=_sumtabx data=_sumtabc;
  run;

%mend;



/*========================================================*
 *========================================================*
          Define macro to process numeric data
 *========================================================*
 *========================================================*/

%macro num(var,varnum);
  %local i dpr;

  data _sumtabn _dpr(keep=&var);
    retain _varnum &varnum;
    length _label $ 40 _var $ 20;
    set _sumtab(keep=&by &level1 _startcol &tmtvar &var);
    _label=vlabel(&var);
    _var="&var";
  run;

  *- Find out how many decimal places to the -;
  *- right of the decimal point. -;
  data _dpr;
    length _str $ 20;
    set _dpr;
    _str=put(&var,best20.);
    _dpr=0; 
    if index(_str,'.') then 
      _dpr=length(left(_str))-index(left(_str),'.');
    drop _str;
  run;

  proc summary nway data=_dpr;
    var _dpr;
    output out=_dpr(drop=_type_ _freq_)
    max()=;
  run;

  data _null_;
    set _dpr;
    call symput('dpr',compress(put(_dpr,2.)));
  run;

  proc univariate noprint data=_sumtabn;
    by &by &level1 _startcol &tmtvar _varnum _var _label;
    var &var;
    output out=_sumtabn 
    %do i=1 %to %words(&stats);
      %scan(&stats,&i,%str( ))=%scan(&stats,&i,%str( ))
    %end;
    ;
  run;
 
  proc transpose data=_sumtabn out=_sumtabn(drop=_label_);
    by &by &level1 _startcol &tmtvar _varnum _var _label;
    var &stats;
  run;

  data _sumtabn;
    retain _dummy 0 _dpr &dpr _len %eval(&nwidth+&spacing+&pctwidth);
    length _fmt $ 4 _catstat $ 40 _str $ %eval(&nwidth+&spacing+&pctwidth);
    set _sumtabn;
    _catstat=_name_;
    _fmt=compress(put(_len,2.))||'.';
    if upcase(trim(_name_)) NE 'N' then do;
      if upcase(trim(_name_)) in (%upcase(%quotelst(&dpplus2))) then do;
        _fmt=trim(_fmt)||compress(put(_dpr+2,2.));
      end;
      else if upcase(trim(_name_)) in (%upcase(%quotelst(&dpplus1))) then do;
        _fmt=trim(_fmt)||compress(put(_dpr+1,2.));
      end;
      else _fmt=trim(_fmt)||compress(put(_dpr,2.));
    end;
    _str=putn(col1,_fmt);
    if index(left(reverse(_str)),'.')<5 then do;
      if substr(_str,5-index(left(reverse(_str)),'.'),1) EQ ' '
        then _str=substr(_str,6-index(left(reverse(_str)),'.'));
    end;
    %if "&tmtpos" NE "left" %then %do;
      if substr(_str,%eval(&nwidth+&spacing+&pctwidth),1) EQ ' '
      then substr(_str,%eval(&nwidth+&spacing+&pctwidth),1)=&subspace;
    %end;
    _statno=input(trim(_name_),_statno.);
    drop _name_ col1 _dpr _len _fmt;
  run;

  proc append base=_sumtabx data=_sumtabn;
  run;

%mend;



/*========================================================*
 *========================================================*
             Define macro to flatten the data
 *========================================================*
 *========================================================*/

%macro flatten(ds);

  proc sql noprint;
    select distinct &tmtvar into :flatvars separated by ' TMT'
    from &ds;
  quit;

  %let flatvars=TMT&flatvars;

  proc sort data=&ds;
    by &by &level1 _startcol _varnum _label _statno _catstat &tmtvar;
  run;

  data &ds;
    length idlabel $ 40;
    set &ds;
    idlabel=put(&tmtvar,&tmtfmt);
  run;

  proc transpose data=&ds out=&ds(drop=_name_) prefix=TMT;
    by &by &level1 _startcol _varnum _label _statno _catstat;
    var _str;
    id &tmtvar;
    idlabel idlabel;
  run;

%mend;



/*========================================================*
 *========================================================*
                Define reporting macros
 *========================================================*
 *========================================================*/

%macro flatrep(ds);

  %flatten(&ds)

  %if &style EQ 2 %then %do;
    data &ds;
      length _start $ &indent;
      retain _start ' ';
      set &ds;
    run;

    proc report missing data=&ds &headline &headskip split="&split"
      spacing=&spacing;
      &byline
      columns _start &level1 _startcol _varnum _label _statno _catstat 
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        (&tmtlabel &flatvars)
      %end;
      %else %do;
        &flatvars
      %end;
      ;
      define _start / order width=&indent ' ';
      define &level1 / order noprint;
      define _startcol / order noprint;
      define _varnum / order noprint;
      define _label / order width=&width2 flow left spacing=0
      %if %length(&label2) %then %do;
        &label2
      %end;
      ;
      define _statno / order noprint;
      define _catstat / order left width=&width3
      %if %length(&label3) %then %do;
        &label3
      %end;
      ;
      %do i=1 %to %words(&flatvars);
        define %scan(&flatvars,&i,%str( )) / display &tmtpos
          width=%eval(&nwidth+&spacing+&pctwidth);
      %end;
      break after _varnum / skip;
      compute before _startcol;
        line @_startcol &level1 $char%varlen(&ds,&level1,nodollar).;
      endcompute;
    run;


  %end;
  %else %do;

    proc report missing data=&ds &headline &headskip split="&split"
      spacing=&spacing;
      &byline
      columns &level1 _varnum _label _statno _catstat 
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        (&tmtlabel &flatvars)
      %end;
      %else %do;
        &flatvars
      %end;
      ;
      %if %length(&level1) %then %do;
        define &level1 / order order=internal left flow width=&width1;
      %end;
      define _varnum / order width=2 noprint;
      define _label / order width=&width2 flow left
      %if %length(&label2) %then %do;
        &label2
      %end;
      ;
      define _statno / order width=2 noprint;
      define _catstat / order left width=&width3
      %if %length(&label3) %then %do;
        &label3
      %end;
      ;
      %do i=1 %to %words(&flatvars);
        define %scan(&flatvars,&i,%str( )) / display &tmtpos
          width=%eval(&nwidth+&spacing+&pctwidth);
      %end;
      break after _varnum / skip;
    run;

  %end;

%mend;


%macro rep(ds);

  %if &style EQ 2 %then %do;

    data &ds;
      length _start $ &indent;
      retain _start ' ';
      set &ds;
    run;

    proc report missing data=&ds &headline &headskip split="&split"
      spacing=&spacing;
      &byline
      columns _start &level1 _startcol _varnum _label _statno _catstat &tmtvar,_str _dummy;
      define _start / group width=&indent ' ';
      define &level1 / group noprint;
      define _startcol / group noprint;
      define _varnum / group noprint;
      define _label / group width=&width2 flow left spacing=0
      %if %length(&label2) %then %do;
        &label2
      %end;
      ;
      define _statno / group noprint;
      define _catstat / group left width=&width3
      %if %length(&label3) %then %do;
        &label3
      %end;
      ;
      define &tmtvar / across order=internal
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        &tmtlabel
      %end;
      %if %length(&tmtfmt) %then %do;
        f=&tmtfmt
      %end;
      ;
      define _str / display &tmtpos ' ' width=%eval(&nwidth+&spacing+&pctwidth);
      define _dummy / noprint;
      break after _varnum / skip;
      compute before _startcol;
        line @_startcol &level1 $char%varlen(&ds,&level1,nodollar).;
      endcomp;
    run;

  %end;
  %else %do;

    proc report missing data=&ds &headline &headskip split="&split"
      spacing=&spacing;
      &byline
      columns &level1 _varnum _label _statno _catstat &tmtvar,_str _dummy;
      %if %length(&level1) %then %do;
        define &level1 / group order=internal left flow width=&width1;
      %end;
      define _varnum / group noprint;
      define _label / group width=&width2 flow left
      %if %length(&label2) %then %do;
        &label2
      %end;
      ;
      define _statno / group noprint;
      define _catstat / group left width=&width3
      %if %length(&label3) %then %do;
        &label3
      %end;
      ;
      define &tmtvar / across order=internal
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        &tmtlabel
      %end;
      %if %length(&tmtfmt) %then %do;
        f=&tmtfmt
      %end;
      ;
      define _str / display &tmtpos ' ' width=%eval(&nwidth+&spacing+&pctwidth);
      define _dummy / noprint;
      break after _varnum / skip;
    run;

  %end;

%mend;



/*--------------------------------------------------------*
                Start processing the data
 *--------------------------------------------------------*/

*- keep only the variables we need -;
data _sumtab;
  set &dsin;
  keep &by &level1 &tmtvar &uniqueid &varlist;
run;


%*- process the population dataset if specified -;
%if %length(&dspop) %then %dspop;


%if "&flatten" EQ "Y" %then %do;
  %if not %length(&tmtlabel) %then 
    %let tmtlabel="%varlabel(_sumtab,&tmtvar)";
%end;



%*- If the total for all treatment groups has been specified -;
%*- then duplicate the data and assign the value for all the -;
%*- treatment groups combined -;
%if %length(&tmttot) and ("&tmtall" EQ "Y") %then %do;
  data _sumtab;
    set _sumtab _sumtab(in=_all);
    if _all then &tmtvar=&tmttot;
  run;
%end;

*- get rid of duplicates -;
proc sort nodupkey data=_sumtab;
  by &by &level1 &tmtvar &uniqueid &varlist;
run;

*- find out the number of treatment arm values per by group-;
proc sort nodupkey data=_sumtab out=_sumtabt;
  by &by &tmtvar;
run;
proc summary nway data=_sumtabt;
  by &by;
  output out=_sumtabt(drop=_type_ rename=(_freq_=_ntmt));
run;

*- merge in the number of treatment arm values -;
%if %nobs(_sumtabt) GT 1 %then %do;
  data _sumtab;
    merge _sumtabt _sumtab;
    by &by;
    _startcol=0;
    %if &style EQ 2 %then %do;
      %if %sysfunc(getoption(center)) EQ NOCENTER %then %do;
        _startcol=1;
      %end;
      %else %do;
        _startcol=floor((%sysfunc(getoption(linesize))-
        (&indent+&width2+&spacing+&width3+_ntmt*(&nwidth+2*&spacing+&pctwidth)))/2)+1;
      %end;
    %end;
    drop _ntmt;
  run;
%end;
%else %do;
  data _sumtab;
    %if &style EQ 2 %then %do;
      %if %sysfunc(getoption(center)) EQ NOCENTER %then %do;
        retain _startcol 1;
      %end;
      %else %do;
        retain _startcol %eval(
        ((%sysfunc(getoption(linesize))-
        (&indent+&width2+&spacing+&width3+%getvalue(_sumtabt,_ntmt)*(&nwidth+2*&spacing+&pctwidth)))/2)+1
       );
      %end;
    %end;
    %else %do;
      retain _startcol 0;
    %end;
    set _sumtab;
  run;
%end;


%*- Identify the variable type and write to "typelist".  -;
%*- Note that a numeric variable will be classed as a    -;
%*- categorical variable if it has a non-numeric format. -;
%do i=1 %to %words(&varlist);
  %if ("%vartype(_sumtab,%scan(&varlist,&i,%str( )))" EQ "C")
   or ("%vartype(_sumtab,%scan(&varlist,&i,%str( )))" EQ "N" and 
      ("%substr(%varfmt(_sumtab,%scan(&varlist,&i,%str( )))%str(    ),
        1,4)" NE "BEST" and %length(%sysfunc(compress(%varfmt(_sumtab,
        %scan(&varlist,&i,%str( ))),0123456789.)))))
   %then %let typelist=&typelist C;
   %else %let typelist=&typelist N;
%end;


*- get rid of the append base dataset if it exists -;
proc datasets nolist;
  delete _sumtabx;
run;
quit;


%*- call the macro matching the variable type -;
%do i=1 %to %words(&varlist);
  %let var=%scan(&varlist,&i,%str( ));
  %if "%scan(&typelist,&i,%str( ))" EQ "C" %then %cat(&var,&i);
  %else %num(&var,&i);
%end;

%if %length(&by) and &bypop and %length(&fmtin) %then %do;
  %do i=1 %to %nobs(_sumtaby);
    data _sumtx;
      merge _sumtaby(in=_by where=(_obs=&i)) _sumtabx;
      by &by;
      if _by;
      drop _obs;
    run;
    data _sumtp;
      merge _sumtaby(in=_by where=(_obs=&i)) _sumtabp;
      by &by;
      if _by;
      drop _obs;
    run;
    %popfmt(dspop=_sumtp,fmtin=&fmtin,fmtout=&fmtout,tmtvar=&tmtvar,
            split=&split,n=n);
    %if "&flatten" EQ "Y" %then %flatrep(_sumtx);
    %else %rep(_sumtx);
  %end;
%end;
%else %do;
  %if %length(&fmtin) %then %do;
    %popfmt(dspop=_sumtabp,fmtin=&fmtin,fmtout=&fmtout,tmtvar=&tmtvar,
            split=&split,n=n);
  %end;
  %if "&flatten" EQ "Y" %then %flatrep(_sumtabx);
  %else %rep(_sumtabx);
%end;



/*--------------------------------------------------------*
                   Tidy up and exit
 *--------------------------------------------------------*/

proc datasets nolist;
  delete _sumtabc _sumtabn _dpr _sumtaby _sumtx
         _sumtp _sumtabt _sumtabx;
run;
quit;



%goto skip;
%error:
%put ERROR: (sumtab) Leaving sumtab macro due to error(s) listed. ;
%skip:
%mend;