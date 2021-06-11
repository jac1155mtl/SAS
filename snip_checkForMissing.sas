/* Check for missing values for all variables */

**CREATE FORMAT TO FLAG MISSING VALUES;
proc format;
    value nm
        low-high  = 'OK'
        other     = 'MISSING'
    ;
  
    value $ch
        ''  = 'MISSING'
        other = 'OK'
    ;
run;

**CHECK FOR ANY MISSING VALUES;
proc freq data=dsn;
    table _all_ / missing;
    format _numeric_ nm. _character_ $ch.;
run;
