/*<pre><b>
/ Program   : titles
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To generate titles for a report
/ SubMacros : %titlegen %stdfoot %jobinfo
/ Notes     : This is a suggestion only and is here for illustration purposes.
/             This assumes you have run the %jobinfo macro already.
/             This code will need amending to comply with your site standards.
/             Explanations are given in the code so that you can suitably amend
/             this macro.
/ Usage     : %titles
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ seq=              Sequence character if required to select correct set of 
/                   titles where more than one set exists for a program.
/ ds=               Dataset that contains all the titles and footnotes for all
/                   programs. You should hard-code this to match site standards.
/ target='FF'x      Target character to place last in footnote so that the 
/                   %pagexofy macro can place the "Page x of y" label there.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro titles(seq=,ds=,target='FF'x);
%local ls incr;
%let incr=0;
%let ls=%sysfunc(getoption(linesize));

/**********
This first section commented out is where you will put the code to generate
your standard top title lines that go above the titles specified in the 
titles flatfile. You will have set up global macro variables in your project
macro to create these. For illustration purposes I have assumed you have set
up three pieces of information and stored then in the global macro variables
_text1_, _text2_ and _text3_. I am assuming you want to put _text1_ in the
top title with _text2_ on the far right. For the second title I am assuming
you just have _text3_ on the left. You can therefore amend this code to suit
your requirements and it should cover all possibilities.

The macro variable "incr" will need incrementing for each of your special
title lines and this will get added on to the numbers for your titles in
your titles dataset so that the specified titles begin in the correct place.


title1 "&_text1_%sysfunc(repeat(%str( ),
%eval(&ls-%length(&_text1_)-%length(&_text2_)-1)))&_text2_";

title2 "&_text3_%sysfunc(repeat(%str( ),%eval(&ls-%length(&_text3_)-1)))";

%let incr=2;
***********/

data _titles;
  set &ds(where=(program="&_prog_"
  %if %length(&seq) %then %do;
    and seq="&seq"
  %end;
  ));
  if type='T' then number=number+&incr;
run;

%titlegen(_titles)

%stdfoot(target=&target)

proc datasets nolist;
  delete _titles;
run;
quit;


%mend;
  