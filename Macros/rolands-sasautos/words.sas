/*<pre><b>
/ Program   : words
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To return the number of words in a string
/ SubMacros : none
/ Notes     : You can change the delimiter to other than a space if required.
/ Usage     : %let words=%words(string);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ str               String (pos) UNQUOTED
/ delim=%str( )     Delimeter (defaults to a space)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro words(str,delim=%str( ));

%local i;

%let i=1;

%do %while(%length(%scan(&str,&i,&delim)) GT 0);
  %let i=%eval(&i + 1);
%end;

%eval(&i - 1)

%mend;
