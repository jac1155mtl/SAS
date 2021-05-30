/* https://www.skythisweek.info/checkdups.htm */

%macro checkdups(sds,vars);
%local nobs sds vars;
   options nosource nonotes errors=0;
   proc sort data=&sds out=_null_ dupout=_dups nodupkey;
      by &vars;
   run;
   proc sql noprint;
     select nobs into :nobs separated by " "
	   from dictionary.tables
     where libname='WORK' and memname='_DUPS';
   quit;
   options source notes errors=20;
%if &nobs = 0 %then %put NOTE: No duplicate values of (&vars) in &sds;
%else               %put WARNING: Duplicate values of (&vars) in &sds;
%mend checkdups;
 
/* This macro checks a SAS dataset for duplicates on one or more variables */
%checkdups(ssbsect,var1 var2 var3);
