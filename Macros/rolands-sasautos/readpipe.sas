/*<pre><b>
/ Program   : readpipe
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 05 May 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To read the output of a UNIX command and assign it to a macro
/             variable.
/ SubMacros : none
/ Notes     : The same can be achieved by directing the output from the Unix 
/             command to a file and reading it in using the %readfile macro. This
/             is an amended version of the %readfile macro. The only advantage 
/             with this macro is in avoiding the creation of a named file with
/             its inherent risk of overwriting something important. 
/ Usage     : %let mvar=%readpipe(echo $USER);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ command           (pos) Unix command. This should not be enclosed in quotes but
/                   may be enclosed in %str(), %quote() etc..
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro readpipe(command); 
%local fname fid str rc; 
%let rc=%sysfunc(filename(fname,&command,pipe));   
%if &rc NE 0 %then %do; 
  %put ERROR: (readpipe) Pipe file could not be assigned due to the following:; 
  %put %sysfunc(sysmsg()); 
%end; 
%else %do; 
  %let fid=%sysfunc(fopen(&fname,s)); 
  %if &fid EQ 0 %then %do; 
%put ERROR: (readpipe) Pipe file could not be opened due to the following:; 
%put %sysfunc(sysmsg()); 
  %end; 
  %else %do; 
    %do %while(%sysfunc(fread(&fid)) EQ 0); 
      %let rc=%sysfunc(fget(&fid,str,200)); 
&str 
    %end; 
    %let rc=%sysfunc(fclose(&fid)); 
    %if &rc NE 0 %then %do; 
%put ERROR: (readpipe) Pipe file could not be closed due to the following:; 
%put %sysfunc(sysmsg()); 
    %end; 
    %let rc=%sysfunc(filename(fname)); 
    %if &rc NE 0 %then %do; 
%put ERROR: (readpipe) Pipe file could not be deassigned due to the following:; 
%put %sysfunc(sysmsg()); 
    %end; 
  %end; 
%end; 
%mend;
  