/*<pre><b>
/ Program   : titlelen
/ Version   : 1.1
/ Author    : Roland Rashleigh-Berry
/ Date      : 10 January 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To create a copy of sashelp.vtitle but with the length added.
/ SubMacros : %casestrvar
/ Notes     : The orginal length of titles and footnotes is unknown since the
/             original trailing spaces are not shown in sashelp.vtitle. This
/             macro will generate a dummy report and work out the original length
/             of the titles and footnotes to the nearest multiple of 2. If any
/             mixed-case form of "#byvar" or "#byval" is detected in a title line
/             then these strings (only) will be converted to uppercase.
/
/             This macro was written for Windows and there is a DOS command in it
/             to delete the temporary flat file. If you are running this on a 
/             different platform then you will have to change the command.
/
/ Usage     : %titlelen
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ dsout=titlelen    Name of the output dataset.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  19jan03         "center" option used and then restored to previous.
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro titlelen(dsout=titlelen);

%local opts;
%let opts=%sysfunc(getoption(center));
options center;

data _titles;
  length ltext $ 200;
  set sashelp.vtitle;
  ltext=left(text);
run;

proc sort data=_titles;
  by type ltext;
run;


data _null_;
  file "titlelen.tmp" print titles footnotes ls=200 ps=21;
  put 'xxxxxxxxxx';
run;

data _ltitles;
  retain type 'T';
  length ltext $ 200;
  infile "titlelen.tmp" pad;
  input ltext $char200.;
  if ltext='xxxxxxxxxx' then type='F';
  else if ltext ne ' ' then do;
    start=verify(ltext,' ');
    ltext=left(ltext);
    output;
  end;
run;

options noxwait;
x 'erase titlelen.tmp';

proc sort data=_ltitles;
  by type ltext;
run;

data _titles;
  merge _ltitles _titles;
  by type ltext;
  if type='T' and text ne ' ' then do;
    %casestrvar(text,'#BYVAR');
    %casestrvar(text,'#BYVAL');
  end;
  length=2*(100-(start-verify(text,' ')));
  if (length-length(text)) EQ 1 then length=length-1;
  drop ltext start;
run;

proc sort data=_titles out=&dsout;
  by descending type number;
run;

proc datasets nolist;
  delete _titles _ltitles;
run;
quit;

options &opts;

%mend;  