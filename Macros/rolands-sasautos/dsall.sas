/*<pre><b>
/ Program   : dsall
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 02 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To expand out the _all_ in a dataset list into all datasets in the
/             library.
/ SubMacros : %words %dslist
/ Notes     : This is NOT a function-style macro. See usage notes.
/             The list of datasets will be written to the global macro variable
/             _dsall_.
/ Usage     : %dsall(sasuser.test work._all_);
/             %let dsall=&_dsall_;
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ list              (pos) List of datasets some of which may be referred to 
/                   using the _all_ notation.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro dsall(list);
%global _dsall_;
%let _dsall_=;
%local i;
%do i=1 %to %words(&list);
  %if "%upcase(%scan(%scan(&list,&i,%str( )),2,.))" NE "_ALL_" %then 
    %let _dsall_=&_dsall_ %scan(&list,&i,%str( ));
  %else %do;
    %dslist(%scan(%scan(&list,&i,%str( )),1,.),yes)
    %let _dsall_=&_dsall_ &_dslist_;
  %end;
%end;
%mend;
