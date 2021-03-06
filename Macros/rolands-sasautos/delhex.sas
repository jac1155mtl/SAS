/*<pre><b>
/ Program   : delhex
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 17 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To delete occurrences of a specified hex character in a flat file.
/ SubMacros : none
/ Notes     : Hex characters must be specified in quoted form such as 'FE'x. 
/             The target character does not have to be hex.
/             You can use the %hexchars macro to show up what non-printable hex
/             characters are in a flat file.
/ Usage     : %delhex(infile,outfile,'FE'x)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ infile            (pos) Input file
/ file              (pos) Output file
/ target            (pos) Target character (quoted)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  15jun03         Use _file_ and _infile_
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro delhex(infile,file,target);

%local error;
%let error=0;

       /*--------------------------------------*
            Check we have all parameters set
        *--------------------------------------*/

%if not %length(&infile) %then %do;
  %let error=1;
  %put ERROR: (delhex) No input file specified;
%end;

%if not %length(&file) %then %do;
  %let error=1;
  %put ERROR: (delhex) No output file specified;
%end;

%if not %length(&target) %then %do;
  %let error=1;
  %put ERROR: (delhex) No target character specified;
%end;

%if &error %then %goto error;



       /*--------------------------------------*
               Start processing the data
        *--------------------------------------*/

data _null_;
  infile "&infile";
  file "&file" notitles noprint;
  input;
  if _infile_ ne ' ' then _file_=compress(_infile_,&target);
  put;
run;


%goto skip;
%error:
%put ERROR: (delhex) Leaving delhex macro due to error(s) listed;
%skip:
%mend;
