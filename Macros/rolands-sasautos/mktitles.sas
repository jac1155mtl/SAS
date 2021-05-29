/*<pre><b>
/ Program   : mktitles
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To create a sas dataset containing titles and footnotes out of a 
/             flat file.
/ SubMacros : none
/ Notes     : This is driven by special labels looked for in the first column.
/             These labels are "program:", "seq:", "titles:", "footnotes:" and
/             "end:" as shown below:
/
/ program: <program name> 
/ seq: <sequence identifier if required>
/ titles:
/ First title centred
/  Second title aligned one spave from left
/ footnotes:
/ First footnote all of which will be left-aligned
/  Second footnote aligned one space from the left
/ end:
/
/ Usage     : %mktitles(flatfile,mart.titles)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ flatfile          (pos) Name of flat file containing titles and footnotes.
/ dsout             (pos) Name of sas dataset created.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro mktitles(flatfile,dsout);

data &dsout;
  length program $ 16 seq $ 8 text $ 200 type $ 1;
  infile "%sysfunc(compress(&flatfile,%str(%'%")))" pad eof=eof;
findprog:
  input @1 text $char200.;
  if substr(upcase(text),1,8) NE "PROGRAM:" then goto findprog;
  program=left(scan(text,2,':'));
findseq:
  input @1 text $char200.;
  if substr(upcase(text),1,4) NE "SEQ:" then goto findseq;
  seq=left(scan(text,2,':'));
findtitl:
  input @1 text $char200.;
  if substr(upcase(text),1,7) NE "TITLES:" then goto findtitl;
  type='T';
  number=0;
  input @1 text $char200.;
  do while(upcase(substr(text,1,10)) NE "FOOTNOTES:");
    number=number+1;
    output;
    input @1 text $char200.;
  end;
  type='F';
  number=0;
  input @1 text $char200.;
  do while(upcase(substr(text,1,4)) NE "END:");
    number=number+1;
    output;
    input @1 text $char200.;
  end;
  return;
eof:
run;

%mend;