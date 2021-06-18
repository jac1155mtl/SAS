/*********************************************************************
PURPOSE             : ADD PREFIX OR SUFFIX TO GROUP OF VARIABLES

SOURCE              : https://support.sas.com/kb/48/674.html
---------------------------------------------------------------------
SNIPPET HISTORY     :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Jo Ann Colas        17JUN2021   create
*********************************************************************/;

**-----------------------------------------------------------------**
CREATE MACRO VARIABLE WITH LIST OF VARS TO BE RENAMED
**-----------------------------------------------------------------**;
**ADD PREFIX TO ALL OF VARIABLES;
proc sql noprint;
    select cats(name, "=", "OLD_", name)
    into :list separated by " "
    from dictionary.columns
    where libname = "WORK"
        and memname = "CARS"
;quit;
%put &=list;

**ADD SUFFIX TO ALL OF VARIABLES;
proc sql noprint;
    select cats(name, "=", name, "_OLD")
    into :list separated by " "
    from dictionary.columns
    where libname = "WORK"
        and memname = "CARS"
;quit;
%put &=list;

**ADD SUFFIX TO SUBSET OF VARIABLES;
proc sql noprint;
    select cats(name, "=", name, "_OLD")
    into :list separated by " "
    from dictionary.columns
    where libname = "WORK"
        and memname = "CARS"
        and upcase(name) like 'SCORE%'
;quit;
%put &=list;

**-----------------------------------------------------------------**
RENAME THE VARIABLES
**-----------------------------------------------------------------**;
proc datasets library = WORK nolist;
    modify cars;
    rename &list.;
run;

**VERIFY THE CHANGE;
proc contents data=CARS;
run;
