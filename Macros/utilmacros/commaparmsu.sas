/*<pre><b>
/ Program   : commaparmsu.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 10-Jun-2014
/ Purpose   : Function-style macro to add back commas between macro parameters
/             where these have been deliberately omitted in a string and to 
/             convert parameter names to uppercase.
/ SubMacros : none
/ Notes     : The result will be returned macro UNQUOTED so that equals signs
/             are not macro quoted.
/
/             Where a controlling macro allows the user to run other macros and
/             supply parameters values then it is common practice to not use
/             commas to separate the parameter values and to add these
/             programatically when the called macro is invoked. This is done to
/             avoid having to macro quote the whole string due to the presence
/             of commas. This macro adds back the commas to the parameter list
/             that are needed when the macro is called.
/
/             The macro removes spaces either side of the equals sign and
/             precedes the parameter name with a comma (removing the very first
/             comma).
/
/             Parameter names will converted to upper case. If you do not want 
/             this then to be done then use the %comm2parms macro instead.
/
/             Enclose the string for conversion inside %nrbquote() when calling
/             this macro otherwise the first parameter name in the string will
/             be interpreted as a macro parameter of the %commaparmsu macro.
/
/ Usage     : %let params=%commaparmsu(%nrbquote(&str));
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ str               (pos) String
/===============================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description------------------------
/ rrb  16Apr13         New (v1.0)
/ rrb  10Jun14         Header tidy (v1.0)
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/=============================================================================*/

%put MACRO CALLED: commaparmsu v1.0;

%macro commaparmsu(str);
%unquote(%qsubstr(%qsysfunc(prxchange(%nrbquote(s�\s*(\w+)\s*=\s*�,\U\1\E=�),-1,
%nrbquote(&str))),2))
%mend commaparmsu;
