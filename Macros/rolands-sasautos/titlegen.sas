/*<pre><b>
/ Program   : titlegen
/ Version   : 2.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To generate titles and footnotes from a dataset of the style
/             created by the %mktitles macro.
/ SubMacros : none
/ Notes     : You would normally select from the dataset created by %mktitles
/             macro and add special headers and footnotes if required and then
/             pass the resulting dataset to this macro so that the titles and
/             footnote statements were generated.
/ Usage     : %titlegen(dsname)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                (pos) SAS dataset containing titles and footnotes
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ rrb  16jan03         Test for "length" variable and if present, use.
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro titlegen(ds);

data _null_;
  set &ds;
  if length=. then length=.;
  if length ne . then do;
    if type EQ 'T' then do;
      if length>length(text) then call execute('title'||compress(put(number,2.))||' "'||
          trim(text)||repeat(' ',length-length(text)-1)||'";');
      else call execute('title'||compress(put(number,2.))||' "'||trim(text)||'";');
    end;
    else if type EQ 'F' then do;
      if length>length(text) then call execute('footnote'||compress(put(number,2.))||' "'||
          trim(text)||repeat(' ',length-length(text)-1)||'";');
      else call execute('footnote'||compress(put(number,2.))||' "'||trim(text)||'";');
    end;
  end;
  else do;
    if type EQ 'T' then do;
      if substr(text,1,1) EQ ' ' then call execute('title'||compress(put(number,2.))||
        ' "'||text||'";');
      else call execute('title'||compress(put(number,2.))||' "'||trim(text)||'";');
    end;
    else if type EQ 'F' then 
      call execute('footnote'||compress(put(number,2.))||' "'||text||'";');
  end;
run;

%mend;