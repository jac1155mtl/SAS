/*<pre><b>
/ Program   : nodata
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 23 June 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To produce a "No Data" report in the absence of qualifying data.
/ SubMacros : %nobs %titlelen %titlegen
/ Notes     : This macro will see if a global macro variable _nodata_ has been
/             set up and will use any contents assigned to it for the message
/             for the report.
/
/             Note that the actual report must be bracketed in a macro so that
/             this macro will execute that macro if it finds observations in the
/             dataset you supply to it. It default to the name "report". This
/             macro will not work correctly unless you indeed bracket the actual
/             report in a macro definition.
/
/             This macro calls the macro %titlelen which has Windows commands in
/             it. If you work on a different platform then you will have to
/             ensure that %titlelen has been tailored to your platform.
/
/             If no observations are found in the test dataset then the report
/             will be produced with any last #byval/#byvar title dropped and all
/             footnotes dropped but these will be fully restored at the end of 
/             the macro. 
/
/ Usage     : %nodata(dsname,repmacro)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                (pos) Dataset name to check for existing obsrvations to
/                   report.
/ macro=report      Name of macro that contains the report you want to run if
/                   observations exist in the test dataset. Default to "report".            / skip=10           Number of blank lines to throw before the "no data" message.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro nodata(ds,macro=report,skip=10);

%global _nodata_;
%local msg;
%let msg=NO DATA FOUND TO MEET THIS CRITERION;

%if %nobs(&ds) %then %&macro;
%else %do;

  %*- store all the titles and footnotes along with their true lengths -;
  %titlelen

  *- create a dummy dataset for producing the message -;
  data _nodata;
    %if %length(&_nodata_) %then %do;
      length dummy $ %length(&_nodata_);
      do i=1 to &skip;
        dummy=' ';
        output;
      end;
      dummy="&_nodata_";
      output;
    %end;
    %else %do;
      length dummy $ %length(&msg);
      do i=1 to &skip;
        dummy=' ';
        output;
      end;
      dummy="&msg";
      output;
    %end;
  run;

  %*- remove any #byvar #byval last title -;
  %bytitle

  *- remove any footnotes -;
  footnote1;

  proc report data=_nodata;
    columns dummy;
    define dummy / display ' ';  
  run;

  proc datasets nolist;
    delete _nodata;
  run;
  quit;

  %titlegen(titlelen)
  
%end;

%mend;  