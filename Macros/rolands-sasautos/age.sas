/*<pre><b>
/ Program   : age
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To calculate the age of a person at a specified date
/ SubMacros : none
/ Notes     : You use this in a data step as shown in the usage notes. The age
/             will be an integer. 
/ Usage     : data test;
/               age=%age(dob,date);
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ dob               (pos) Date of birth
/ date              (pos) Date on which age is to be calculated
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro age(dob,date);
year(&date)-year(&dob)-1+((month(&date)>month(&dob)) 
or ((month(&date)=month(&dob)) and (day(&date)>=day(&dob))))
%mend;
