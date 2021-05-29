/*<pre><b>
/ Program   : eqsuff
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 01 June 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To 
/ SubMacros : %words %quotelst
/ Notes     : Use this when you want to "put" the values of a list of variables
/             out to the log.
/ Usage     : put %eqsuff(&varlist);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ 
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro eqsuff(list);
%if %words(&list) %then %quotelst(&list,quote=,delim=%str(= ))=;
%mend;


  