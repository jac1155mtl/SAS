/*<pre><b>
/ Program   : qcompress
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 31 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To compress a macro variable string and return the result quoted.
/ SubMacros : none
/ Notes     : This is a function-style macro.
/ Usage     : %let tidy=%qcompress(&string);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string            (pos) String to compress.
/ ref               (pos) Reference characters to remove from the string.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro qcompress(string,ref);
%local i error;
%let error=0;

%if not %length(&string) %then %goto skip;

%if not %length(&ref) %then %do;
  %put ERROR: (qcompress) No reference characters supplied to compress string with.;
  %let error=1;
%end;

%if &error %then %goto error;


%qsysfunc(compress(&string,&ref))

%goto skip;
%error: %put ERROR: (qcompress) Leaving qcompress macros due to error(s) listed.;
%skip:
%mend;
  