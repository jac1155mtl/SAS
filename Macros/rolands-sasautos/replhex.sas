/*<pre><b>
/ Program   : replhex
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 17 December 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To replace occurrences of a specified hex character in a flat file
/             with another specified character.
/ SubMacros : none
/ Notes     : Hex characters must be specified in quoted form such as 'FE'x. 
/             The target character does not have to be hex and the replacement
/             character can be hex if you want. Note that a space specified as a
/             replacement character must be quoted and not left blank.
/             You can use the %asciinonp macro to show up what non-printable hex
/             characters are in a flat file.
/ Usage     : %replhex(infile,outfile,'FE'x,' ')
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ infile            (pos) Input file
/ file              (pos) Output file
/ target            (pos) Target character (quoted)
/ repl              (pos) Replacement character (quoted)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  15jun03         Use _file_ and _infile_ instead.
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro replhex(infile,file,target,repl);

%local error;
%let error=0;

       /*--------------------------------------*
            Check we have all parameters set
        *--------------------------------------*/

%if not %length(&infile) %then %do;
  %let error=1;
  %put ERROR: (replhex) No input file specified;
%end;

%if not %length(&file) %then %do;
  %let error=1;
  %put ERROR: (replhex) No output file specified;
%end;

%if not %length(&target) %then %do;
  %let error=1;
  %put ERROR: (replhex) No target character specified;
%end;

%if not %length(&repl) %then %do;
  %let error=1;
  %put ERROR: (replhex) No replacement character specified;
%end;

%if &error %then %goto error;



       /*--------------------------------------*
               Start processing the data
        *--------------------------------------*/

data _null_;
  infile "&infile";
  file "&file" notitles noprint;
  input;
  if _infile_ ne ' ' then _file_=translate(_infile_,&repl,&target);
  put;
run;


%goto skip;
%error:
%put ERROR: (replhex) Leaving replhex macro due to error(s) listed;
%skip:
%mend;
