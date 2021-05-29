/*<pre><b>
/ Program   : nodup
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 01 June 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To drop duplicates in a space-delimited list
/ SubMacros : %words
/ Notes     : 
/ Usage     : %let str=%nodup(aaa bbb aaa);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ list              (pos) space-delimited list of items
/ casesens=no       Case sensitive. no by default.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro nodup(list,casesens=no);
%local i j match item error;
%let error=0;
%if not %length(&casesens) %then %let casesens=no;
%let casesens=%upcase(%substr(&casesens,1,1));

%if not %index(YN,&casesens) %then %do;
  %put ERROR: (nodup) casesens must nbe set to yes or no;
  %let error=1;
%end;

%if &error %then %goto error;

%do i=1 %to %words(&list);
  %let item=%scan(&list,&i,%str( ));
  %let match=NO;
  %if &i LT %words(&list) %then %do;
    %do j=%eval(&i+1) %to %words(&list);
      %if &casesens EQ Y %then %do;
        %if "&item" EQ "%scan(&list,&j,%str( ))" %then %let match=YES;
      %end;
      %else %do;
        %if "%upcase(&item)" EQ "%upcase(%scan(&list,&j,%str( )))" %then %let match=YES;
      %end;
    %end;
  %end;
  %if &match EQ NO %then &item;
%end;

%goto skip;
%error: %put ERROR: (nodup) Leaving nodup macro due to error(s) listed.;
%skip:

%mend nodup;
  