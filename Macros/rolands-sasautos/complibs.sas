/*<pre><b>
/ Program   : complibs
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 05 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To compare datasets in two libraries.
/ SubMacros : %supasort %attrc %words
/ Notes     : This is a Clinical Reporting utility macro. It is for comparing
/             different versions of the data to identify what has been added or
/             deleted or changed. Each dataset is compared with each identically
/             named dataset in each library. Titles will be assigned internally
/             during macro execution.
/
/             You can either set up the librefs before calling this macro and
/             pass the pure libref names to the parameters or if you put in
/             quotes then it will assign the librefs for you and deassign on
/             completion.
/
/             Note that you must supply a list of typical sort variables for your
/             datasets that you use to define uniqueness of the observations. You
/             should hard-code these in as a default. %supasort will be called to
/             sort the datasets for variables matching this list. This is a 
/             requirement since we can not assume the downloaded datasets are in
/             any particular order and we need an order for comparisons.
/
/ Usage     : %complibs(base,comp)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ libold            (pos) Libref of old library or path name enclosed in quotes.
/ libnew            (pos) Libref of new library or path name enclosed in quotes.
/ sortvars          List of variables separated by spaces that you would use to
/                   sort the datasets to obtain uniqueness.
/ options           Options for "proc compare". "listall" is the default.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro complibs(libold,
                libnew,
                sortvars=subject session page occ1 occ2,
                options=listall
                );

%local fnew fold refnew refold sortedby dslist i;

%*- Set up libref if libnew is a file name (starts with a quote) -;
%if %index(%str(%'%"),%qsubstr(&libnew,1,1)) %then %do;
  %let fnew=Y;
  %let refnew=NEW;
  libname NEW &libnew access=readonly;
%end;
%else %let refnew=%upcase(&libnew);


%*- Set up libref if libold is a file name (starts with a quote) -;
%if %index(%str(%'%"),%qsubstr(&libold,1,1)) %then %do;
  %let fold=Y;
  %let refold=OLD;
  libname OLD &libold access=readonly;
%end;
%else %let refold=%upcase(&libold);


*- Get a list of datasets in the old library -;
proc sort data=sashelp.vtable(keep=memname libname memtype 
                     where=(libname="&refold" and memtype='DATA')) 
           out=_baseds(drop=libname memtype); 
  by memname; 
run; 


*- Get a list of datasets in the new library -;
proc sort data=sashelp.vtable(keep=memname libname memtype 
                     where=(libname="&refnew" and memtype='DATA')) 
           out=_compds(drop=libname memtype); 
  by memname; 
run; 


*- Select out those datasets that exist in both libraries -;
data _both; 
  merge _baseds(in=_base) _compds(in=_comp); 
  by memname; 
  if _base and _comp; 
run; 


*- Write list of matching datasets out to a macro variable -;
proc sql noprint; 
  select memname into :dslist separated by ' ' from _both; 
quit; 


%*- For each dataset in the list, do the following -;  
%do i=1 %to %words(&dslist); 

  *- Base data ready for sorting -;
  data _base; 
    set &refold..%scan(&dslist,&i,%str( )); 
  run; 
    
  *- Compare data ready for sorting -;
  data _comp; 
    set &refnew..%scan(&dslist,&i,%str( )); 
  run; 

  %*- sort base and compare data into matching variable order -;
  %supasort(_base _comp,&sortvars) 

  *- assign title for the output -;
  title "Comparison of %scan(&dslist,&i,%str( )) dataset between 
&refold and &refnew libraries"; 

  %*- obtain list of variables base dataset was sorted by -;
  %let sortedby=%attrc(_base,sortedby); 
  
  *- Do the comparison between the datasets -;
  proc compare base=_base compare=_comp &options; 
    id &sortedby; 
  run; 
  
%end; 


*- Tidy up temporary datasets now we are finished -;
proc datasets nolist; 
  delete _baseds _compds _both _base _comp; 
run; 
quit; 


%*- Clear librefs if these were assigned internally -;
%if "&fnew" EQ "Y" %then %do;
  libname &refnew;
%end;
%if "&fold" EQ "Y" %then %do;
  libname &refold;
%end;


%mend;
  