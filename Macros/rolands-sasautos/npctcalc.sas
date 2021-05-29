/*<pre><b>
/ Program   : npctcalc
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 05 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To calculate "n" and "pct" for Clinical reports with two grouping
/             variables.
/ SubMacros : %words %varnum %vartype %varlen %commas
/ Notes     : N will be the count of unique subject identities, rather than the
/             frequency count. Percentages can be calculated in a variety of ways
/             as detailed below. Variables created will be "n" and "pct". pct
/             will be scaled to 100. The various methods for calculating the
/             percentage are explained in the pctcalc= parameter description.
/
/             You can optionally add variables "sort1" and "sort2" to the dataset
/             to help you order the data before you produce a table. It is the
/             value of "n" (except turned negative) for one of the treatment arms
/             you choose to be merged in with the rest of the data. Then if you
/             sort by this value it can order the analysis into the most
/             significant results first. Note that this value will be NEGATIVE as
/             it will be calculated as 0-n. This is so that you can sort in
/             ascending order which is more usual.
/
/             The output dataset will be named "npctcalc" and will have the
/             variable "n" and "pct" added with "sort1" and "sort2" added as well
/             if the nsort= parameter is set. If a population dataset is
/             specified then one called "npctpop" will be created with the "n"
/             count for the population. If by= variables were specified and these
/             were all present in the input population dataset then they will
/             also be present in the output population dataset by a "bypop"
/             variable added all set to numeric "1". This is to act as an
/             indicator.
/
/ Usage     : %npctcalc(dsin=ae,level1=body,level2=pref,uniqueid=subject,
/             tmtvar=tmtord,tmttot='Z',nsort='Z')
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ level1=           Higher level grouping variable. Must be character and six
/                   bytes minimum.
/ level2=           Lower level grouping variable. Must be character and six
/                   bytes minimum.
/ lvl1tot=' TOTAL'  The label for the total of all level1 items. This should
/                   start with a blank for sorting purposes. Must be quoted.
/                   This macro creates a format named $left. that will align
/                   the formatted value one character from the left. This macro
/                   requires this parameter to be set. If you do not want the
/                   observations it creates using it then you can always reject
/                   them from the output dataset.
/ lvl2tot=' TOTAL'  The label for the total of all items grouped by the level1
/                   value. This should start with a blank for sorting purposes.
/                   Must be quoted. This macro creates a format named $left.
/                   that will align the formatted value one character from the
/                   left. This macro requires this parameter to be set. If you do
/                   not want the observations it creates using it then you can
/                   always reject them from the output dataset.
/ dsin=             Input dataset for analysis.
/ by=               "by" variable(s) if required. Should be unquoted. Separate
/                   with spaces if more than one.
/ tmtvar=           Treatment arm identifier variable. One variable only.
/ tmttot=           Value representing the total for all treatment arms. This
/                   will not be calculated if it is blank. If this is a character
/                   then it must be enclosed in quotes.
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
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  02Nov02         Added nsort processing at end.
/ rrb  05nov02         Population dataset is also output named "npctpop"
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro npctcalc(level1=,
                level2=,
               lvl1tot=' TOTAL',
               lvl2tot=' TOTAL',
                  dsin=,
                    by=,
                tmtvar=,
                tmttot=,
                 dspop=,
              uniqueid=,
              addzeros=yes,
               pctcalc=T,
                 nsort=
                 );


/*--------------------------------------------------------*
     Check we have enough parameters set to proceed
 *--------------------------------------------------------*/

%local error bypop i;
%if %length(&addzeros) EQ 0 %then %let addzeros=yes;
%let addzeros=%upcase(%substr(&addzeros,1,1));
%if %length(&pctcalc) EQ 0 %then %let pctcalc=total;
%let pctcalc=%upcase(%substr(&pctcalc,1,1));

%let error=0;

%if %length(%sysfunc(compress(&pctcalc,TLP))) GT 0 %then %do;
  %let error=1;
  %put ERROR: (pctcalc) pctcalc= parameter must be set to T, L or P;
%end;
%else %if "&pctcalc" EQ "P" and %length(&dspop) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (pctcalc) pctcalc=P but no dspop= dataset specified;
%end;

%if %length(&level1) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) level1= parameter not set;
%end;
%else %if %words(&level1) GT 1 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Only one variable may be specified to level1=;
%end;

%if %length(&level2) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) level2= parameter not set;
%end;
%else %if %words(&level2) GT 1 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Only one variable may be specified to level2=;
%end;

%if %length(&lvl1tot) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) lvl1tot= label must be supplied even if not displayed;
%end;
%else %if not %index(%str(%'%"),%qsubstr(&lvl1tot,1,1)) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) lvl1tot=&lvl1tot must be enclosed in quotes;
%end;
%else %if %qsubstr(&lvl1tot,2,1) NE %str( ) 
  %then %let lvl1tot=%qsubstr(&lvl1tot,1,1) %qsubstr(&lvl1tot,2);

%if %length(&lvl2tot) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) lvl2tot= label must be supplied even if not displayed;
%end;
%else %if not %index(%str(%'%"),%qsubstr(&lvl2tot,1,1)) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) lvl2tot=&lvl2tot must be enclosed in quotes;
%end;
%else %if %qsubstr(&lvl2tot,2,1) NE %str( ) 
  %then %let lvl2tot=%qsubstr(&lvl2tot,1,1) %qsubstr(&lvl2tot,2);

%if %length(&dsin) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) dsin= parameter not set;
%end;

%if %length(&tmtvar) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) tmtvar= parameter not set;
%end;

%if %length(&uniqueid) EQ 0 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) uniqueid= parameter not set;
%end;

%if &error %then %goto error;



/*--------------------------------------------------------*
   Check the supplied variable names against the datasets
 *--------------------------------------------------------*/

data _npctin;
  set &dsin;
run;

%if not %varnum(_npctin,&tmtvar) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Treatment variable "&tmtvar" not in input dataset;
%end;

%if not %varnum(_npctin,&level1) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level1 variable "&level1" not in input dataset;
%end;
%else %if "%vartype(_npctin,&level1)" NE "C" %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level1 variable "&level1" must be character;
%end;
%else %if %varlen(_npctin,&level1,nodollar) LT 7 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level1 variable "&level1" must be at least six characters long;
%end;
%else %if %eval(%length(&lvl1tot)-2) GT %varlen(_npctin,&level1,nodollar) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level1 total string "&lvl1tot" is longer than variable length;
%end;

%if not %varnum(_npctin,&level2) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level2 variable "&level2" not in input dataset;
%end;
%else %if "%vartype(_npctin,&level2)" NE "C" %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level2 variable "&level2" must be character;
%end;
%else %if %varlen(_npctin,&level2,nodollar) LT 7 %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level2 variable "&level2" must be at least six characters long;
%end;
%else %if %eval(%length(&lvl2tot)-2) GT %varlen(_npctin,&level2,nodollar) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Level2 total string "&lvl2tot" is longer than variable length;
%end;

%if not %varnum(_npctin,&uniqueid) %then %do;
  %let error=1;
  %put ERROR: (npctcalc) Uniqueid variable "&uniqueid" not in input dataset;
%end;

%do i=1 %to %words(&by);
  %if not %varnum(_npctin,%scan(&by,&i,%str( ))) %then %do;
    %let error=1;
    %put ERROR: (npctcalc) By variable "&by" not in input dataset;
  %end;
%end;


%if %length(&dspop) GT 0 %then %do;
  data _npctpop;
    set &dspop;
  run;

  %if not %varnum(_npctpop,&tmtvar) %then %do;
    %let error=1;
    %put ERROR: (npctcalc) Treatment variable "&tmtvar" not in population dataset;
  %end;

  %if not %varnum(_npctpop,&uniqueid) %then %do;
    %let error=1;
    %put ERROR: (npctcalc) Uniqueid variable "&uniqueid" not in population dataset;
  %end;
%end;

%if &error %then %goto error;



/*--------------------------------------------------------*
    Keep only the variables we need in the input datasets
 *--------------------------------------------------------*/

*- keep only required variables in the input dataset -;
data _npctin;
  set _npctin(keep=&by &tmtvar &level1 &level2 &uniqueid);
run;


%*- keep only required variables in the population dataset -;
%if %length(&dspop) GT 0 %then %do;
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
  data _npctpop;
    set _npctpop(keep=&tmtvar &uniqueid
    %if &bypop %then %do;
      &by
    %end;
    );
  run;
%end;



/*--------------------------------------------------------*
       Add extra observations corresponding to totals
 *--------------------------------------------------------*/

%*- add totals for all treatment arms if set -;
%if %length(&tmttot) GT 0 %then %do;
  data _npctin;
    set _npctin _npctin(in=_all);
    if _all then &tmtvar=&tmttot;
  run;

  %if %length(&dspop) GT 0 %then %do;
    data _npctpop;
      set _npctpop _npctpop(in=_all);
      if _all then &tmtvar=&tmttot;
    run;
  %end;
%end;


*- add totals for all level2 categories -;
data _npctin;
  set _npctin _npctin(in=_all);
  if _all then &level2=&lvl2tot;
run;


*- add totals for all level1 categories -;
data _npctin;
  set _npctin _npctin(in=_all);
  if _all then &level1=&lvl1tot;
run;




/*--------------------------------------------------------*
          Calculate totals for population dataset
 *--------------------------------------------------------*/

%if %length(&dspop) GT 0 %then %do;

  proc summary nway data=_npctpop;
    class
    %if &bypop %then %do;
      &by 
    %end;
      &tmtvar &uniqueid;
    output out=_npctpop(drop=_type_ _freq_);
  run;

  proc summary nway data=_npctpop;
    class
    %if &bypop %then %do;
      &by
    %end;
      &tmtvar;
    output out=_npctpop(drop=_type_ rename=(_freq_=total));
  run;

%end;


/*--------------------------------------------------------*
           Calculate "n" values for input data
 *--------------------------------------------------------*/

proc summary nway data=_npctin;
  class &by &tmtvar &level1 &level2 &uniqueid;
  output out=_npctin(drop=_type_ _freq_);
run;

proc summary nway data=_npctin;
  class &by &tmtvar &level1 &level2;
  output out=_npctin(drop=_type_ rename=(_freq_=n));
run;

data _npctin;
  set _npctin;
  if &level1=&lvl1tot then if &level2=&lvl2tot;
run;



/*--------------------------------------------------------*
                Add zeros if option is set
 *--------------------------------------------------------*/

%*- We must add zeros if "nsort" has been set otherwise  -;
%*- we will have missing values for "sort1" and "sort2". -;
%*- We can always remove them later if the user did not  -;
%*- request them. -;
%if "&addzeros" EQ "Y" or %length(&nsort) GT 0 %then %do;
  proc sql noprint;
    create table _npctz as select 0 as n, * from
    (select distinct %commas(&by &level1 &level2) from _npctin),
    (select distinct &tmtvar from _npctin)
    order by %commas(&by &tmtvar &level1 &level2);
  quit;

  data _npctin;
    merge _npctz _npctin;
    by &by &tmtvar &level1 &level2;
  run;

  proc datasets nolist;
    delete _npctz;
  run;
  quit;
%end;



/*--------------------------------------------------------*
                  Calculate percentages
 *--------------------------------------------------------*/

%if "&pctcalc" EQ "T" %then %do;
  *- calculate pct purely based on overall treatment arm totals -;
  data _npctin;
    merge _npctin(where=(&level1=&lvl1tot and &level2=&lvl2tot)
                 rename=(n=total))
          _npctin;
    by &by &tmtvar;
    pct=100*n/total;
    drop total;
  run;
%end;
%else %if "&pctcalc" EQ "L" %then %do;
  *- calculate pct on level2 totals -;
  data _npctin;
    merge _npctin(where=(&level2=&lvl2tot)
                 rename=(n=total))
          _npctin;
    by &by &tmtvar &level1;
    pct=100*n/total;
    drop total;
  run;
  *- now override pct for level2 totals with pct based on overall totals -;
  data _npctin;
    merge _npctin(where=(&level1=&lvl1tot and &level2=&lvl2tot)
                 rename=(n=total))
          _npctin;
    by &by &tmtvar;
    if &level2=&lvl2tot then pct=100*n/total;
    drop total;
  run;
%end;

%*- If the pop dataset exists then overall totals will get their pct -;
%*- recalculated based on population totals. And if pctcalc=P then   -;
%*- every pct value will be based on these population totals -;
%if %length(&dspop) GT 0 %then %do;
  %*- the following will be true if 1) nothing specified to by= -;
  %*- or 2) by= specified and the pop datasets has all by vars  -;
  %if &bypop %then %do;
    data _npctin;
      merge _npctpop
            _npctin;
      by &by &tmtvar;
      %if "&pctcalc" EQ "P" %then %do;
        pct=100*n/total;
      %end;
      %else %do;
        if &level1=&lvl1tot and &level2=&lvl2tot then pct=100*n/total;
      %end;
      drop total;
    run;
  %end;
  %*- this means by= was specified but the pop dataset does not have -;
  %*- all the by vars so we need to merge by treatment arm -;
  %else %do;
    proc sort data=_npctin;
      by &tmtvar &level1 &level2;
    run;
    data _npctin;
      merge _npctpop
            _npctin;
      by &tmtvar;
      %if "&pctcalc" EQ "P" %then %do;
        pct=100*n/total;
      %end;
      %else %do;
        if &level1=&lvl1tot and &level2=&lvl2tot then pct=100*n/total;
      %end;
      drop total;
    run;
    proc sort data=_npctin;
      by &by &tmtvar &level1 &level2;
    run;
  %end;
%end;


/*--------------------------------------------------------*
               Make a format named $left
 *--------------------------------------------------------*/

*- If you use proc report to display the output dataset then you will want  -;
*- the total labels not to have a space in front. So this $left format will -;
*- do this for you. Use order=internal and f=$left. in combination and it   -;
*- will left align the totals labels -;
proc format;
  value $left
  &lvl1tot="%substr(&lvl1tot,3,%length(&lvl1tot)-3)"
  %if &lvl2tot NE &lvl1tot %then %do;
    &lvl2tot="%substr(&lvl2tot,3,%length(&lvl2tot)-3)"
  %end;
  other=[$char200]
  ;
run;



/*--------------------------------------------------------*
            Create "nsort" variables if option set
 *--------------------------------------------------------*/

%if %length(&nsort) GT 0 %then %do;
  proc sort data=_npctin;
    by &by &level1 &level2;
  run;

  *- merge in level1 "n" value -;
  data _npctin;
    merge _npctin(where=(&tmtvar=&nsort and &level2=&lvl2tot)
                 rename=(n=nsort))
          _npctin(in=_in);
    by &by &level1;
    if _in;
    sort1=0-nsort;
    drop nsort;
  run;

  *- merge in level2 "n" value -;
  data _npctin;
    merge _npctin(where=(&tmtvar=&nsort)
                 rename=(n=nsort))
          _npctin(in=_in);
    by &by &level1 &level2;
    if _in;
    sort2=0-nsort;
    drop nsort;
  run;

  proc sort data=_npctin;
    by &by &tmtvar &level1 &level2;
  run;
%end;



/*--------------------------------------------------------*
           Remove added zeros depending on option
 *--------------------------------------------------------*/

%if "&addzeros" NE "Y" and %length(&nsort) GT 0 %then %do;

  *- if nsort has been set then zeros will have been added  -;
  *- even if the user did not want them so that their sort1 -;
  *- and sort2 variables could be added. So reset them to   -;
  *- missing now but keep the observations.  -;
  data _npctin;
    set _npctin;
    if n=0 then do;
      n=.;
      pct=.;
    end;
  run;

%end;



/*--------------------------------------------------------*
                    Tidy up and exit
 *--------------------------------------------------------*/

data npctcalc;
  set _npctin;
  *- note that the $left. format is being assigned -;
  *- to the level1 and level2 variables -;
  format &level1 &level2 $left.;
run;

%if %length(&dspop) %then %do;
  data npctpop;
    %if %length(&by) and &bypop %then %do;
      retain bypop 1;
    %end;
    set _npctpop(rename=(total=n));
  run;
%end;


proc datasets nolist;
    delete _npctin
  %if %length(&dspop) GT 0 %then %do;
    _npctpop
  %end;
  ;
run;
quit;


%goto skip;
%error: 
%put ERROR: (npctcalc) Leaving npctcalc macro due to error(s) listed;
%skip:
%mend;