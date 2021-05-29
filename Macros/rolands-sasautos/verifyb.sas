/*<pre><b>
/ Program   : verifyb
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 31 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the position of the first character in a string that does
/             not match any character in a reference string BUT STARTING FROM THE
/             BACK.
/ SubMacros : none
/ Notes     : This is a "backwards" version of the familiar verify macro.
/ Usage     : %let pos=%verifyb(&text,%str( )); %*- last non-blank character -;
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

%macro verifyb(text,ref);
%local pos error;
%let error=0;
%if not %length(&text) %then %do;
  %put ERROR: (verifyb) No text string supplied for verifyb to act on.;
  %let error=1;
%end;
%if not %length(&ref) %then %do;
  %put ERROR: (verifyb) No reference string supplied for verifyb to use.;
  %let error=1;
%end;

%if &error %then %goto error;

%do pos=%length(&text) %to 1 %by -1;
  %if NOT %index(&ref,%qsubstr(&text,&pos,1)) %then %goto gotit;
%end;

%gotit:
&pos


%goto skip;
%error: %put ERROR: (verifyb) Leaving verifyb macro due to error(s) listed.;
%skip:
%mend;
