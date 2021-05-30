/* CONVERT DATEIME VARIABLE IN CLINICAL DATASET TO CHAR DATE VARIABLE */

%put MACRO CALLED: dtmtodtc v2.0;

%macro dtmtodtc(invar=,outvar=);
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
