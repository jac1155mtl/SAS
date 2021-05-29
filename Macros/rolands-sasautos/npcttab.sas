/*<pre><b>
/ Program   : npcttab
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 16 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To create a table with "n" and "pct" values
/ SubMacros : %npctcalc %popfmt %varnum %varlabel %words %nobs
/ Notes     : This is the macro that handles formatting the output dataset from
/             the %npctcalc macro into a table. You are recommended not to call 
/             this macro directly but rather set up shell macros to call it with
/             as many parameters as you can defaulted. Suffix the shell macro
/             name with the style of the report, 1=two columns, 2=indented
/             level2, 3=only level2.
/ Usage     : Set up shell macros to call this macro.
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ level1=           Higher level grouping variable. Must be character and six
/                   bytes minimum. Must have a label defined.
/ level2=           Lower level grouping variable. Must be character and six
/                   bytes minimum. Must have a label defined.
/ width1=20         Width to allow for the level1 column (report style=1 only).
/ width2=20         Width to allow for the level2 column.
/ lvl1tot=' TOTAL'  The label for the total of all level1 items. This should
/                   start with a blank for sorting purposes. Must be quoted.
/                   A format named $left. will be created that will align the
/                   formatted value one character from the left. This macro
/                   requires this parameter to be set. If you do not want the
/                   observations it creates then use the lvl1all= parameter to
/                   reject them.
/ lvl1all=yes       By default, show the values for the total of all level1
/                   categories.
/ lvl2tot=' TOTAL'  The label for the total of all items grouped by the level1
/                   value. This should start with a blank for sorting purposes.
/                   Must be quoted. This macro creates a format named $left.
/                   that will align the formatted value one character from the
/                   left. This macro requires this parameter to be set. If you do
/                   not want the observations it creates using it then you can
/                   always reject them from the output dataset.
/ lvl2all=yes       By default show the totals for all the level2 categories.
/ dsin=             Input dataset for analysis.
/ by=               "by" variable(s) if required. Should be unquoted. Separate
/                   with spaces if more than one.
/ tmtvar=           Treatment arm identifier variable. One variable only.
/ tmtlabel=         Label to use for the treatment variable that will be
/                   displayed over the treatment arms columns. Set this to ' ' if
/                   you don't want anything displayed. If left null then the
/                   treatment variable label will be used.
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
/ dspop=            External population dataset (if required) for use in
/                   calculating percentages. Note that if this contains all
/                   variables also specified as by= variables then this dataset
/                   will be subsetted before the percentage calculation is made.
/                   At mimimum, this dataset must contain the tmtvar= variable
/                   and the uniqueid= variable. It will be a population dataset,
/                   hence its name.
/ uniqueid=         Variable that uniquely identifies a subject. It is a count of
/                   this that will give us our "n" value.
/ addzeros=yes      By default, add zeros where one or more treatment arms are
/                   missing a count for a category where it exists for another
/                   treatment arm.
/ pctcalc=T         Percentage calculation style (unquoted). This is also
/                   affected by the presence or otherwise of the dspop= dataset. 
/                   If there is a dspop= dataset then the percentage shown for 
/                   the overall total is always a percentage of the population
/                   no matter what you specify. Otherwise "T" gives the
/                   percentage of the total. "L" gives the percentage of the 
/                   level1 category total but the level1 total is shown as a
/                   percentage of the overall total. "P" gives the percentage
/                   based on the population total.
/ nsort=            You set this to a treatment arm code (can also be the total
/                   for all treatment arms as supplied to the tmttot= parameter)
/                   to merge in the n value for that treatment arm with the 
/                   observations in other treatment arms. This can be useful for
/                   sorting into order. The variables created will be called
/                   "sort1" and "sort2", corresponding with level1 and level2
/                   values. If this is a character value then enclose in quotes.
/                   Note that the value will be NEGATIVE as it will be 0-n for
/                   that treatment arm.
/ style=            Report style. 1=level1 and level2 in separate columns, 
/                   2=level1 and level2 share a column but with level2 categories
/                   indented, 3=only show level2 categories.
/ flatten=no        This is for "flattening" the report so that "n" and "pct"
/                   column headers are not shown and do not take up a line. If
/                   set to "yes" then it will combine "n" and "pct" into a string
/                   and create a transposed character variable to hold it. This
/                   can be used where space is at a premium.
/ spacing=2         Spaces to leave between the columns.
/ headline=yes      By default, put a dashed line under the column headings.
/ headskip=yes      By default, leave a blank line between the column headings
/                   and the first line of data in the report.
/ split=/           Split character. Must be unquoted.
/ pctfmt=           Format to use for the percent. An internal format will be 
/                   used if this is left blank and the width will be forced to
/                   6 characters. You should ensure that this internal format
/                   suits your purpose if you intend to use it.
/ pctwidth=6        By default, use 6 characters for the formatted percentage.
/ pctlabel='pct'    Label for the "pct" column. Will not be shown if flatten=yes.
/ nwidth=4          By default, use 4 characters for the "n" value.
/ nlabel='n'        Label for the "n" column. Will not be shown if flatten=yes.
/ indent=3          For style=2 only, indent the level2 categories 3 spaces.
/ order=LL          By default, order the report alphabetically using level1 and
/                   level1 values. Change to "NN" to order using the sort1 and
/                   sort2 variables (see nsort= parameter) or use a combination
/                   of "L" and "N" to suit.
/ n=n               By default, the variable with the unique subject count is
/                   called "n".
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/


%macro npcttab(level1=,
               level2=,
               width1=20,
               width2=20,
              lvl1tot=' TOTAL',
              lvl1all=yes,
              lvl2tot=' TOTAL',
              lvl2all=yes,
                 dsin=,
                   by=,
               tmtvar=,
             tmtlabel=,
               tmttot=,
               tmtfmt=,
                fmtin=,
               fmtout=,
               tmtall=no,
                dspop=,
             uniqueid=,
             addzeros=yes,
              pctcalc=T,
                nsort=,
                style=1,
              flatten=no,
              spacing=2,
             headline=yes,
             headskip=yes,
                split=/,
               pctfmt=,
             pctwidth=6,
             pctlabel='pct',
                    n=n,
               nwidth=4,
               nlabel='n',
               indent=3,
                order=LL
               );

/*--------------------------------------------------------*
     Check we have enough parameters set to proceed
 *--------------------------------------------------------*/

%local i error bypop flatvars byline macro;
%let error=0;
%let bypop=0;
%if %length(&by) %then %let byline=by &by%str(;);

%if %length(&style) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npcttab) style=&style parameter must be set to either 1, 2 or 3;
%end;
%else %if (%length(&style) NE 1) or 
     (%length(%sysfunc(compress(&style,123))) GT 0) %then %do;
  %let error=1;
  %put ERROR: (npcttab) style=&style parameter must be set to either 1, 2 or 3;
%end;

%if %length(&dsin) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npcttab) dsin= parameter not set;
%end;

%if %length(&order) EQ 0 %then %let order=ll;
%if %length(&order) EQ 1 %then %let order=&order.&order;
%let order=%upcase(&order);
%if %length(&order) NE 2 %then %do;
  %let error=1;
  %put ERROR: (npcttab) order=&order must be two characters;
%end;
%else %if %length(%sysfunc(compress(&order,NL))) %then %do;
  %let error=1;
  %put ERROR: (npcttab) order=&order must be "N" or "L" combination;
%end;


%if &error %then %goto error;


%if %length(&width1) EQ 0 %then %let width1=20;
%if %length(&width2) EQ 0 %then %let width2=20;
%if %length(&lvl1all) EQ 0 %then %let lvl1all=yes;
%let lvl1all=%upcase(%substr(&lvl1all,1,1));
%if %length(&lvl2all) EQ 0 %then %let lvl2all=yes;
%let lvl2all=%upcase(%substr(&lvl2all,1,1));
%if %length(&tmtall) EQ 0 %then %let tmtall=no;
%let tmtall=%upcase(%substr(&tmtall,1,1));
%if %length(&flatten) EQ 0 %then %let flatten=no;
%let flatten=%upcase(%substr(&flatten,1,1));
%if %length(&spacing) EQ 0 %then %let spacing=2;

%if %length(&headline) EQ 0 %then %let headline=yes;
%let headline=%upcase(%substr(&headline,1,1));
%if "&headline" EQ "Y" %then %let headline=headline;
%else %let headline=;

%if %length(&headskip) EQ 0 %then %let headskip=yes;
%let headskip=%upcase(%substr(&headskip,1,1));
%if "&headskip" EQ "Y" %then %let headskip=headskip;
%else %let headskip=;

%if %length(&pctwidth) EQ 0 %then %let pctwidth=6;
%if %length(&nwidth) EQ 0 %then %let nwidth=4;
%if %length(&indent) EQ 0 %then %let indent=3;

%if %length(&fmtin) %then %let fmtin=%sysfunc(compress(&fmtin,.)).;
%if %length(&fmtin) and not %length(&fmtout) 
  %then %let fmtout=%sysfunc(compress(&fmtin,.))n.;
%if %length(&fmtout) %then %let fmtout=%sysfunc(compress(&fmtout,.)).;
%if %length(&fmtout) %then %let tmtfmt=&fmtout;

%let split=%sysfunc(compress(&split,%str(%'%")));



/*--------------------------------------------------------*
        Neutralise level1 values for style 3 report
 *--------------------------------------------------------*/

%if &style EQ 3 %then %do;
  data _npct3;
    set &dsin;
    &level1='ZZZZZZ';
  run;
  %let dsin=_npct3;
%end;



/*--------------------------------------------------------*
         Pass on settings to the npctcalc macro
 *--------------------------------------------------------*/

%*- Not only will npctcalc do the calculations, it will -;
%*- trap many errors as well. -;
%npctcalc(level1=&level1,
          level2=&level2,
         lvl1tot=&lvl1tot,
         lvl2tot=&lvl2tot,
            dsin=&dsin,
              by=&by,
          tmtvar=&tmtvar,
          tmttot=&tmttot,
           dspop=&dspop,
        uniqueid=&uniqueid,
        addzeros=&addzeros,
         pctcalc=&pctcalc,
           nsort=&nsort);



/*--------------------------------------------------------*
      Drop unwanted observations from npctcalc dataset
 *--------------------------------------------------------*/

data npctcalc;
  set npctcalc;
  %if "&tmtall" NE "Y" %then %do;
    if &tmtvar=&tmttot then delete;
  %end;
  %if "&lvl1all" NE "Y" %then %do;
    if &level1=&lvl1tot then delete;
  %end;
  %if "&lvl2all" NE "Y" %then %do;
    if &level2=&lvl2tot and &level1 NE &lvl1tot then delete;
  %end;
run;



/*--------------------------------------------------------*
        Create a "by" value dataset if required
 *--------------------------------------------------------*/

%*- Look to see if the "bypop" marker variable is in the -;
%if %length(&dspop) %then %let bypop=%varnum(npctpop,bypop);

%if &bypop and %length(&fmtin) %then %do;
  proc sort nodupkey data=npctpop(keep=&by) out=npctby;
    by &by;
  run;

  data npctby;
    set npctby;
    _obs=_n_;
  run;
%end;



/*--------------------------------------------------------*
               Create percentage format
 *--------------------------------------------------------*/

%if %length(&pctfmt) EQ 0 %then %do;

  %let pctfmt=pctfmt.;
  %let pctwidth=6;

  proc format;
    picture pctfmt (round)
    0        = '(  0%)' (noedit)
    0<-<1    = '( <1%)' (noedit)
    1-<9.5   = '9%)' (prefix='(  ')
    9.5-99   = '99%)' (prefix='( ')
    99<-<100 = '(>99%)' (noedit)
    100      = '(100%)' (noedit)
    ;
  run;

%end;



/*========================================================*
 *========================================================*
         Define macro to do "flatten" processing
 *========================================================*
 *========================================================*/

%macro flatten(ds);

  proc sql noprint;
    select distinct &tmtvar into :flatvars
    separated by ' TMT' from &ds;
  quit;
  run;

  %let flatvars=TMT&flatvars;

  data &ds;
    length idlabel $ 40 npct $ %eval(&nwidth+&spacing+&pctwidth);
    set &ds;
    idlabel=put(&tmtvar,&tmtfmt);
    npct=put(n,&nwidth..)||repeat(' ',&spacing-1)||put(pct,&pctfmt);
  run;

  proc sort data=&ds;
    by &by &level1 &level2 &tmtvar;
  run;

  proc transpose data=&ds out=&ds(drop=_name_) prefix=TMT;
    by &by &level1 &level2;
    var npct;
    id &tmtvar;
    idlabel idlabel;
  run;

%mend flatten;



/*========================================================*
 *========================================================*
             Define Style 1 reporting macro
 *========================================================*
 *========================================================*/

%macro style1(ds);
%local i;
%if "&flatten" NE "Y" %then %do;

  proc report missing data=&ds nowd &headline &headskip
    %if %length(&split) %then %do;
      split="&split"
    %end;
    spacing=&spacing;
    &byline    
    columns 
      %if "%substr(&order,1,1)" EQ "N" %then %do;
        sort1
      %end;
      &level1 
      %if "%substr(&order,2,1)" EQ "N" %then %do;
        sort2
      %end;
      &level2 &tmtvar,(n pct);
    %if "%substr(&order,1,1)" EQ "N" %then %do;
      define sort1 / group noprint;
    %end;
    define &level1 / group order=internal left width=&width1 flow;
    %if "%substr(&order,2,1)" EQ "N" %then %do;
      define sort2 / group noprint;
    %end;
    define &level2 / group order=internal left width=&width2 flow;
    define &tmtvar / across order=internal f=&tmtfmt
    %if %length(&tmtlabel) %then %do;
      &tmtlabel
    %end;
    ;
    define n / analysis width=&nwidth f=&nwidth.. 
    %if %length(&nlabel) %then %do;
      &nlabel
    %end;
    ;
    define pct / analysis width=&pctwidth f=&pctfmt 
    %if %length(&pctlabel) %then %do;
      &pctlabel
    %end;
    ;
    break after &level1 / skip;
  run;

%end;

%else %do;

  %flatten(&ds)

  proc report missing data=&ds nowd &headline &headskip
    %if %length(&split) %then %do;
      split="&split"
    %end;
    spacing=&spacing;
    &byline    
    columns 
      %if "%substr(&order,1,1)" EQ "N" %then %do;
        sort1
      %end;
      &level1 
      %if "%substr(&order,2,1)" EQ "N" %then %do;
        sort2
      %end;
      &level2 
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        (&tmtlabel &flatvars)
      %end;
      %else %do;
        &flatvars
      %end;
      ;
    %if "%substr(&order,1,1)" EQ "N" %then %do;
      define sort1 / group noprint;
    %end;
    define &level1 / order order=internal left width=&width1 flow;
    %if "%substr(&order,2,1)" EQ "N" %then %do;
      define sort2 / group noprint;
    %end;
    define &level2 / order order=internal left width=&width2 flow;
    %do i=1 %to %words(&flatvars);
      define %scan(&flatvars,&i,%str( )) / display;
    %end;
    break after &level1 / skip;
  run;

%end;
%mend style1;


/*========================================================*
 *========================================================*
             Define Style 2 reporting macro
 *========================================================*
 *========================================================*/

%macro style2(ds);
%local i opts;

%let opts=%sysfunc(getoption(missing,keyword));
options missing=' ';

%if "&flatten" NE "Y" %then %do;

  proc sort data=&ds;
    by &by &tmtvar &level1 &level2;
  run;

  data &ds;
    length _col1 $ &indent _col2 $ &width2;
    set &ds;
    by &by &tmtvar &level1;
    _col1=substr(left(&level1),1,&indent);
    if first.&level1 then do;
      if &level2=&lvl2tot then do;
        _col2=left(&level2);
        output;
        &level2=' ';
        _col2=substr(left(&level1),&indent+1);
        n=.;
        pct=.;
        output;
      end;
      else do;
        _col2=&level2;
        output;
        &level2=' ';
        _col2=substr(left(&level1),&indent+1);
        n=.;
        pct=.;
        output;
      end;
    end;
    else do;
      _col2=&level2;
      output;
    end;
  run;

  proc report missing data=&ds nowd &headline &headskip
    %if %length(&split) %then %do;
      split="&split"
    %end;
    spacing=&spacing;
    &byline    
    columns 
      %if "%substr(&order,1,1)" EQ "N" %then %do;
        sort1
      %end;
      &level1 _col1
      %if "%substr(&order,2,1)" EQ "N" %then %do;
        sort2
      %end;
      &level2 _col2 &tmtvar,(n pct);
    %if "%substr(&order,1,1)" EQ "N" %then %do;
      define sort1 / group noprint;
    %end;
    define &level1 / group order=internal noprint width=&width1;
    define _col1 / group order=internal left width=&indent
      "%substr(%varlabel(&ds,&level1),1,&indent)" " ";
    %if "%substr(&order,2,1)" EQ "N" %then %do;
      define sort2 / group noprint;
    %end;
    define &level2 / group order=internal noprint width=&width2;
    define _col2 / group order=internal left width=&width2 flow spacing=0
    "%substr(%varlabel(&ds,&level1),&indent+1)"
    "%varlabel(&ds,&level2)"
    ;
    define &tmtvar / across order=internal f=&tmtfmt
    %if %length(&tmtlabel) %then %do;
      &tmtlabel
    %end;
    ;
    define n / analysis width=&nwidth f=&nwidth.. 
    %if %length(&nlabel) %then %do;
      &nlabel
    %end;
    ;
    define pct / analysis width=&pctwidth f=&pctfmt 
    %if %length(&pctlabel) %then %do;
      &pctlabel
    %end;
    ;
    break after &level1 / skip;
  run;

%end;

%else %do;

  %flatten(&ds)

  proc sort data=&ds;
    by &by &level1 &level2;
  run;

  data &ds;
    length _col1 $ &indent _col2 $ &width2;
    set &ds;
    by &by &level1;
    _col1=substr(left(&level1),1,&indent);
    if first.&level1 then do;
      if &level2=&lvl2tot then do;
        _col2=left(&level2);
        output;
        &level2=' ';
        _col2=substr(left(&level1),&indent+1);
        %do i=1 %to %words(&flatvars);
          %scan(&flatvars,&i,%str( ))=' ';
        %end;
        output;
      end;
      else do;
        _col2=&level2;
        output;
        &level2=' ';
        _col2=substr(left(&level1),&indent+1);
        %do i=1 %to %words(&flatvars);
          %scan(&flatvars,&i,%str( ))=' ';
        %end;
        output;
      end;
    end;
    else do;
      _col2=&level2;
      output;
    end;
  run;

  proc report missing data=&ds nowd &headline &headskip
    %if %length(&split) %then %do;
      split="&split"
    %end;
    spacing=&spacing;
    &byline    
    columns 
      %if "%substr(&order,1,1)" EQ "N" %then %do;
        sort1
      %end;
      &level1 _col1
      %if "%substr(&order,2,1)" EQ "N" %then %do;
        sort2
      %end;
      &level2 _col2
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        (&tmtlabel &flatvars)
      %end;
      %else %do;
        &flatvars
      %end;
      ;
    %if "%substr(&order,1,1)" EQ "N" %then %do;
      define sort1 / order noprint;
    %end;
    define &level1 / order order=internal noprint width=&width1;
    define _col1 / order order=internal left width=&indent
      "%substr(%varlabel(&ds,&level1),1,&indent)" " ";
    %if "%substr(&order,2,1)" EQ "N" %then %do;
      define sort2 / order noprint;
    %end;
    define &level2 / order order=internal noprint width=&width2;
    define _col2 / order order=internal left width=&width2 flow spacing=0
    "%substr(%varlabel(&ds,&level1),&indent+1)"
    "%varlabel(&ds,&level2)"
    ;
    %do i=1 %to %words(&flatvars);
      define %scan(&flatvars,&i,%str( )) / display;
    %end;
    break after &level1 / skip;
  run;

%end;
options &opts;
%mend style2;



/*========================================================*
 *========================================================*
             Define Style 3 reporting macro
 *========================================================*
 *========================================================*/

%macro style3(ds);
%local i;
%if "&flatten" NE "Y" %then %do;

  proc report missing data=&ds nowd &headline &headskip
    %if %length(&split) %then %do;
      split="&split"
    %end;
    spacing=&spacing;
    &byline    
    columns 
      %if "%substr(&order,1,1)" EQ "N" %then %do;
        sort1
      %end;
      &level1 
      %if "%substr(&order,2,1)" EQ "N" %then %do;
        sort2
      %end;
      &level2 &tmtvar,(n pct);
    %if "%substr(&order,1,1)" EQ "N" %then %do;
      define sort1 / group noprint;
    %end;
    define &level1 / group order=internal noprint width=&width1;
    %if "%substr(&order,2,1)" EQ "N" %then %do;
      define sort2 / group noprint;
    %end;
    define &level2 / group order=internal left width=&width2 flow;
    define &tmtvar / across order=internal f=&tmtfmt
    %if %length(&tmtlabel) %then %do;
      &tmtlabel
    %end;
    ;
    define n / analysis width=&nwidth f=&nwidth.. 
    %if %length(&nlabel) %then %do;
      &nlabel
    %end;
    ;
    define pct / analysis width=&pctwidth f=&pctfmt 
    %if %length(&pctlabel) %then %do;
      &pctlabel
    %end;
    ;
    break after &level1 / skip;
  run;

%end;

%else %do;

  %flatten(&ds)

  proc report missing data=&ds nowd &headline &headskip
    %if %length(&split) %then %do;
      split="&split"
    %end;
    spacing=&spacing;
    &byline    
    columns 
      %if "%substr(&order,1,1)" EQ "N" %then %do;
        sort1
      %end;
      &level1 
      %if "%substr(&order,2,1)" EQ "N" %then %do;
        sort2
      %end;
      &level2 
      %if %length(%sysfunc(compress(&tmtlabel,%str(%'%")))) %then %do;
        (&tmtlabel &flatvars)
      %end;
      %else %do;
        &flatvars
      %end;
      ;
    %if "%substr(&order,1,1)" EQ "N" %then %do;
      define sort1 / group noprint;
    %end;
    define &level1 / order order=internal noprint width=&width1;
    %if "%substr(&order,2,1)" EQ "N" %then %do;
      define sort2 / group noprint;
    %end;
    define &level2 / order order=internal left width=&width2 flow;
    %do i=1 %to %words(&flatvars);
      define %scan(&flatvars,&i,%str( )) / display;
    %end;
    break after &level1 / skip;
  run;

%end;
%mend style3;



/*--------------------------------------------------------*
                  Call the reporting macro
 *--------------------------------------------------------*/

%let macro=style&style;
%if &bypop and %length(&fmtin) %then %do;
  %do i=1 %to %nobs(npctby);
    data _npct;
      merge npctby(in=_by where=(_obs=&i)) npctcalc;
      by &by;
      if _by;
      drop _obs;
    run;
    data _npctpop;
      merge npctby(in=_by where=(_obs=&i)) npctpop;
      by &by;
      if _by;
      drop _obs;
    run;
    %popfmt(dspop=_npctpop,fmtin=&fmtin,tmtvar=&tmtvar,n=&n,
            tmttot=&tmttot,split=&split,fmtout=&fmtout)
    %&macro(_npct);
  %end;
%end;
%else %do;
  %if %length(&dspop) %then %do;
    %popfmt(dspop=npctpop,fmtin=&fmtin,tmtvar=&tmtvar,n=&n,
            tmttot=&tmttot,split=&split,fmtout=&fmtout);
  %end;
  %&macro(npctcalc);
%end;



/*--------------------------------------------------------*
                    Tidy up and exit
 *--------------------------------------------------------*/

proc datasets nolist;
  delete npctcalc npctpop npctby _npct _npctpop;
run;
quit;

%goto skip;
%error: 
%put ERROR: (npcttab) Leaving npcttab macro due to error(s) listed;
%skip:


%mend;