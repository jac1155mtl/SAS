/*<pre><b>
/ Program   : aligndp
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 28 August 2003
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To create a string from a numeric value with decimal points aligned
/ SubMacros : none
/ Notes     : This must be used in a data step. If the number can not be aligned
/             without losing digits then the alignment will not be correct.
/ Usage     : %aligndp(numvar,charvar,4);
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ numvar            (pos) numeric variable
/ charvar           (pos) output character variable to contain aligned number
/ dpos              (pos) required position of decimal point
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro aligndp(numvar,charvar,dpos);
  length _fmt $ 8;
  _fmt='best'||compress(put(min(32,vlength(&charvar)),2.))||'.';
  &charvar=putn(&numvar,_fmt);
  if index(&charvar,'.')>&dpos
    and substr(&charvar,1,index(&charvar,'.')-&dpos)=' ' 
    then &charvar=substr(&charvar,index(&charvar,'.')-&dpos+1);
  else if not index(&charvar,'.') then do;
    if substr(&charvar,1,vlength(&charvar)-&dpos+1)=' '
      then &charvar=substr(&charvar,vlength(&charvar)-&dpos+2);
    else &charvar=left(&charvar);
  end;
%mend;
