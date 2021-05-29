/*<pre><b>
/ Program   : qcmpres
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To process a macro variable string with "trim" and "left" and
/             compress double blanks
/ SubMacros : none
/ Notes     : This is a substitute for the SI supplied sasautos macro of the same
/             name.
/ Usage     : %let tidy=%qcmpres(&string);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ string            (pos) String to left justify and trim and compress for double
/                   blanks.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro qcmpres(string);
%unquote(%sysfunc(compbl(%superq(string))))
%mend;
  