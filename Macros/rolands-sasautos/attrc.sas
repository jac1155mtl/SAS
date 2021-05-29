/*<pre><b>
/ Program   : attrc
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ SubMacros : none
/ Purpose   : To return a character attribute of a dataset
/ Notes     : This is a low-level utility macro that other shell macros will call
/             About all you would use this for is to get the dataset label and 
/             the variables a dataset is sorted by.
/ Usage     : %let dslabel=%attrc(dsname,label);
/             %let sortseq=%attrc(dsname,sortedby);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                Dataset name (pos)
/ attrib            Attribute (pos)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro attrc(ds,attrib);

%local dsid rc;

%let dsid=%sysfunc(open(&ds,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (attrc) Dataset &ds not opened due to the following reason:;
  %put %sysfunc(sysmsg());
%end;
%else %do;
%sysfunc(attrc(&dsid,&attrib))
  %let rc=%sysfunc(close(&dsid));
%end;

%mend;
