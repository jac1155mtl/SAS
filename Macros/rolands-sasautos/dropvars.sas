/*<pre><b>
/ Program   : dropvars
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 02 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To drop a list of unwanted variables in a list of datasets.
/ SubMacros : %dsall %words %varlist
/ Notes     : You can use the _all_ notation to refer to all the datasets in a
/             library.
/ Usage     : %dropvars(work._all,x1 x2)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ list              (pos) List of datasets. The _all_ notation can be used.
/ drop              (pos) List of variables to drop.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro dropvars(list,drop);
%local dropvars varlist i j;
%dsall(&list)
%let drop=%quotelst(%upcase(&drop));

%do i=1 %to %words(&_dsall_);
  %let dropvars=;
  %let varlist=%varlist(%scan(&_dsall_,&i,%str( )));
  %do j=1 %to %words(&varlist);
    %if %index(&drop,"%upcase(%scan(&varlist,&j,%str( )))") 
      %then %let dropvars=&dropvars %scan(&varlist,&j,%str( ));
  %end;
  %if %length(&dropvars) %then %do;
    data %scan(&_dsall_,&i,%str( ));
      set %scan(&_dsall_,&i,%str( ));
      drop &dropvars;
    run;
  %end;
%end;

%mend;
  