/*<pre><b>
/ Program   : testsumtab
/ Version   : 1.0
/ Tester    : -------
/ Date      : -- --- 2003
/ Purpose   : Test pack for macro whose identity follows "test" in program name.
/ Notes     : This test pack is for validating the macro whose name follows 
/             "test" in the program name above. Only the user can validate the
/             macros. The user must add to or change the code below to the extent
/             that they are satisfied that the macro being tested is performing
/             correctly. The user must keep this code member and its log and, 
/             if relevent, list output in a secure place to prove they have done
/             this and that the macro is working as intended and fulfil any other
/             mandatory requirements before the macro being tested could be
/             deemed as "validated" and fit to run in a production environment.
/             Also the macros, once validated, must be kept in an area where only
/             those authorised to do so can update the macros and only if they 
/             follow mandatory procedures for initiating change, changing and re-
/             validating the macros and follow any other mandatory procedures for
/             doing so.
/
/             First line contains "endsas;" so this code as supplied will
/             terminate and not run unless the user makes changes. If "endsas;"
/             is present as the first line of code then it means this test pack
/             has not been run against the macro being tested. The tester should
/             fill in the "Tester" and "Date" fields above and any amendments to
/             the test pack should be documented in the "Amendment History"
/             section below.
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/===============================================================================*/

endsas;


proc format;
  value $tmt 'A'='Drug A' 'B'='Drug B' 'Z'='All drugs';
  value cat 1-10='1-10' 11-100='11-100';
run;

data pop;
  year=1999;
  tmt='A';
  id=1;output;
  id=2;output;
  id=3;output;
  tmt='B';
  id=4;output;
  id=5;output;
  id=6;output;
  id=7;output;
  id=8;output;
  year=2000;
  tmt='A';
  id=1;output;
  id=2;output;
  id=3;output;
  tmt='B';
  id=4;output;
  id=5;output;
  id=6;output;
run;


data test;
group='This is a long group value that will stretch across the numeric fields';
subject=1;
label tmt='Treatment';
id=1;
varc1='aa';
varc2='bb';
varn1=33.23;
varn2=99.2;
varnc=11;
tmt='B';output;
varc1='  ';output;
varc1='aa';
id=2;
varn1=35.9;
varn2=98;
output;
id=3;
tmt='A';output;
format varnc cat.;
label group='Grouping value';
run;

options center mprint macrogen missing=' ' ls=90 ps=43;

%sumtab(dsin=test,tmtvar=tmt,tmtfmt=$tmt.,style=2,uniqueid=id,level1=group,
varlist=varc1 varc2 varn1 varn2 varnc,fmtin=$tmt.,width1=20,width2=13,
dspop=pop,flatten=yes,tmttot='Z',tmtpos=center,tmtlabel="__Treatment__",
missing=yes,tmtall=no);

  