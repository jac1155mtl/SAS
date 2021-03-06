/*<pre><b>
/ Program   : getvalue
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 26 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return a variable's value
/ SubMacros : none
/ Notes     : Character values will be returned in double quotes.
/ Usage     : %let value=%getvalue(dsname,varname,1);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                Dataset name (pos)
/ var               Variable name (pos)
/ obs               Observation number (pos). Defaults to "1".
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro getvalue(ds,var,obs);

%local dsid rc varnum value;
%if not %length(&obs) %then %let obs=1;


%let dsid=%sysfunc(open(&ds,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (getvalue) Dataset &ds not opened due to the following reason:;
  %put %sysfunc(sysmsg());
%end;
%else %do;
  %let varnum=%sysfunc(varnum(&dsid,&var));
  %if &varnum LT 1 %then %put ERROR: (getvalue) Variable &var not in dataset &ds;
  %else %do;
    %let rc=%sysfunc(fetchobs(&dsid,&obs));
    %if &rc = -1 %then %put ERROR: (getvalue) Observation &obs is beyond dataset end;
    %else %do;
      %if "%sysfunc(vartype(&dsid,&varnum))" EQ "C" %then %do;
        %let value=%sysfunc(getvarc(&dsid,&varnum));
"&value"
      %end;
      %else %do;
        %let value=%sysfunc(getvarn(&dsid,&varnum));
&value
      %end;
    %end;
  %end;
  %let rc=%sysfunc(close(&dsid));
%end;

%mend;
