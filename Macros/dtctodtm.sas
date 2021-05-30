/* CONVERT DATEIME VARIABLE IN CLINICAL DATASET TO CHAR DATE VARIABLE */

%put MACRO CALLED: dtmtodtc v3.0;

%macro dtmtodtc(invar=,invar_dd,invar_mmm,invar_yyyy=,outvar=);
    %local invar invar_dd invar_mmm invar_yyyy outvar outvar_dd outvar_mmm outvar_yyyy;
  
  *if date component variables have the same prefix as &invar., then we do not need to specify them;
  %if %length(&invar.) > 0 and (%length(&invar_dd.) = 0 and %length(&invar_mmm.) = 0 and %length(&invar_yyyy) = 0) %then %do;
    %let invar_dd   = &invar._dd;
    %let invar_mmm  = &invar._mmm;
    %let invar_yyyy = &invar._yyyy;
  %end;
  
  if not missing(&invar.) then &outvar. = put(datepart(&invar.),date9.);
    else do;
        if not missing(&invar._dd) then &outvar._dd = put(&invar._dd,z2.);
        else &outvar._dd = 'UU';

        if not missing(&invar._mm) then &outvar._mm = upcase(put(month(&invar._mm),monname3.));
        else &outvar._mm = 'UUU';
        
        if not missing(&invar._yyyy) then &outvar._yyyy = put(&invar._yyyy,4.);
        else &outvar._yyyy = 'UUUU';

        &outvar. = &outvar._dd || &outvar._mm || &outvar._yyyy;
    end;

    drop &outvar._dd &outvar._mm &outvar._yyyy;
%mend;
