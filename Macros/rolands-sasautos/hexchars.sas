/*<pre><b>
/ Program   : hexchars
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 15 June 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To show up ascii non-printables characters in a flat file by
/             displaying their hex codes.
/ SubMacros : none
/ Notes     : 
/ Usage     : %hexchars(infile,outfile)
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ infile            (pos) Input file
/ file              (pos) Output file
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro hexchars(infile,file);

data _null_;
  length char $ 1;
  retain outpos 0 ;
  infile "&infile";
  file "&file" notitles noprint;
  input;
  outpos=1;
  if _infile_ ne ' ' then do;
    _file_=repeat(' ',399);
    do i=1 to length(_infile_);
      char=substr(_infile_,i,1);
      rank=rank(char);
      if 32 <= rank <= 126 then do;
        substr(_file_,outpos,1)=char;
        outpos=outpos+1;
      end;
      else do;
        substr(_file_,outpos,4)='<'||put(rank,hex2.)||'>';
        outpos=outpos+4;
      end;
    end;
    _file_=trim(_file_);
  end;
  put;
run;

%mend;
