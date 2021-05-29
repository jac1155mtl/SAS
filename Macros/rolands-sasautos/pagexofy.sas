/*<pre><b>
/ Program   : pagexofy
/ Version   : 2.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 27 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To put a "Page x of y" label where a special target character is
/             found. It will also replace another special character with a space
/             if it is found.
/ SubMacros : none
/ Notes     : THIS MACRO ISSUES WINDOWS COMMANDS. If you want to run this on a
/             different platform then you will have to change the commands.
/             The places you make this change are clearly indicated in the code.
/
/             The assumption made is that there is one target character per page.
/             There can be as many subspace characters as you like, though.
/             Alignment depends on where the target character is found. It is to
/             the right of the target unless the target character is the last in
/             the line in which case it will be to the left. If there are any
/             other characters in the way then they will be overwritten.
/
/ Usage     : %pagexofy(myfile.lst)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ filename          (pos) Must be a file name and not a fileref.
/ subspace='FE'x    Special character to replace with a space.
/ target='FF'x      Target character for "Page x of y" label.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  22jul03         Version 2.0 uses _infile_ and _file_
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro pagexofy(filename,subspace='FE'x,target='FF'x);
%local tempname opts totpages;
%let opts=%sysfunc(getoption(xwait,keyword)) %sysfunc(getoption(xsync,keyword));
%let filename=%sysfunc(compress(&filename,%str(%'%")));
%let tempname=%scan(&filename,1,.).tmp;

options noxwait xsync;

*- WINDOWS COMMAND. CHANGE FOR DIFFERENT OPERATING SYSTEM -;
x "rename &filename &tempname";

data _null_;
  retain totpages 0;
  infile "&tempname" pad eof=last;
  input;
  if index(_infile_,&target) then totpages=totpages+1;
  return;
last:
  call symput('totpages',compress(put(totpages,11.)));
run;


data _null_;
  retain pagecnt 0;
  length label $ 30;
  infile "&tempname" pad;
  file "&filename";
  input;
  _file_=translate(_infile_,' ',&subspace);
  if index(_file_,&target) then do;
    pagecnt=pagecnt+1;
    label='Page '||compress(put(pagecnt,11.))||" of &totpages";
    if index(_file_,&target)=length(_file_) 
      then substr(_file_,length(_file_)-length(label)+1)=label;
    else substr(_file_,index(_file_,&target),length(label))=label;
  end;
  _file_=trim(_file_);
  put;
run;


*- WINDOWS COMMAND. CHANGE FOR DIFFERENT OPERATING SYSTEM -;
x "erase &tempname";

options &opts;

%mend;
