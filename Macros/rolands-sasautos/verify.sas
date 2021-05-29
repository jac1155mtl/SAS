/*<pre><b>
/ Program   : verify
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 31 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the position of the first character in a string that does
/             not match any character in a reference string.
/ SubMacros : none
/ Notes     : This is a substitute for the SI-supplied macro of the same name. It
/             works in the same way. This was written in case you want to bypass
/             the SI-supplied macros.
/ Usage     : %let pos=%verify(&text,%str( )); %*- first non-blank character -;
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ text              (pos) Text to verify
/ ref               (pos) String of reference characters
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro verify(text,ref);
%local pos error;
%let error=0;
%if not %length(&text) %then %do;
  %put ERROR: (verify) No text string supplied for verify to act on.;
  %let error=1;
%end;
%if not %length(&ref) %then %do;
  %put ERROR: (verify) No reference string supplied for verify to use.;
  %let error=1;
%end;

%if &error %then %goto error;

%do pos=1 %to %length(&text);
  %if NOT %index(&ref,%qsubstr(&text,&pos,1)) %then %goto gotit;
%end;

%gotit: 
%if &pos GT %length(&text) %then 0;
%else &pos;

%goto skip;
%error: %put ERROR: (verify) Leaving verify macro due to error(s) listed.;
%skip:
%mend;
