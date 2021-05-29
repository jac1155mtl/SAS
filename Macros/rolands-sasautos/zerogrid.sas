/*<pre><b>
/ Program   : zerogrid
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 12 August 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To create a "grid" of combined values with a variable set to zero
/             for all combinations of values.
/ SubMacros : %commas
/ Notes     : Output sort order will be by supplied variable name if nothing is
/             specified.
/ Usage     : %zerogrid(dsout=grid,var1=subject,ds1=demog,var2=tmtarm,
/             ds2=demog,zerovar=count,sortby=tmtarm subject)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ dsout=zerogrid    Output dataset name (defaults to "zerogrid")
/ zerovar           Name of variable to set to 0 for all observations
/ sortby            Variable list to sort output dataset by (defaults to supplied
/                   variable order)
/ var1              First variable for extracting distinct values
/ ds1               Dataset source of first variable
/ var2              Second variable for extracting distinct values
/ ds2               Dataset source of second variable
/ var3              Third variable for extracting distinct values
/ ds3               Dataset source of third variable
/ var4              Fourth variable for extracting distinct values
/ ds4               Dataset source of fourth variable
/ var5              Fifth variable for extracting distinct values
/ ds5               Dataset source of fifth variable
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro zerogrid(dsout=zerogrid,
                sortby=,
                zerovar=,
                var1=,
                ds1=,
                var2=,
                ds2=,
                var3=,
                ds3=,
                var4=,
                ds4=,
                var5=,
                ds5=
               );

%local error i;
%let error=0;

%if not %length(&dsout) %then %do;
  %let error=1;
  %put ERROR: (zerogrid) Output dataset dsout= not given a name;
%end;

%if not %length(&zerovar) %then %do;
  %let error=1;
  %put ERROR: (zerogrid) Zero value variable zerovar= not given a name;
%end;

%do i=1 %to 5;
  %if %length(&&var&i) and not %length(&&ds&i) %then %do;
    %let error=1;
    %put ERROR: (zerogrid) Variable name supplied as var&i=&&var&i but no ds&i=;
  %end;
  %if %length(&&ds&i) and not %length(&&var&i) %then %do;
    %let error=1;
    %put ERROR: (zerogrid) Dataset name supplied as ds&i=&&ds&i but no var&i=;
  %end;
%end;

%if not %length(&sortby) %then %let sortby=&var1 &var2 &var3 &var4 &var5;

%if &error %then %goto error;


proc sql noprint;
  create table &dsout as 
  select 0 as &zerovar, * from
  %if %length(&var1) and %length(&ds1) %then %do;
  (select distinct(&var1) from &ds1)
  %end;
  %if %length(&var2) and %length(&ds2) %then %do;
  , (select distinct(&var2) from &ds2)
  %end;
  %if %length(&var3) and %length(&ds3) %then %do;
  , (select distinct(&var3) from &ds3)
  %end;
  %if %length(&var4) and %length(&ds4) %then %do;
  , (select distinct(&var4) from &ds4)
  %end;
  %if %length(&var5) and %length(&ds5) %then %do;
  , (select distinct(&var5) from &ds5)
  %end;
  order by %commas(&sortby);
quit;

%goto skip;
%error:
%put ERROR: (zerogrid) Leaving zerogrid macro due to error(s) listed;
%skip:
%mend;