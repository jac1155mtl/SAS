/*<pre><b>
/ Program   : testnpcttab
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


data test;
  length body pref $ 20 tmt $ 1;
  year=1999;
  tmt='A';
  id=1;body='Head';pref='Cough';output;
  id=1;body='Head';pref='Sneeze';output;
  id=1;body='Head';pref='Earache';output;
  id=2;body='Legs';pref='Bad foot';output;
  id=3;body='Head';pref='Cough';output;
  tmt='B';
  id=4;body='Legs';pref='Bad foot';output;
  id=4;body='Legs';pref='Bad ankle';output;
  id=4;body='Head';pref='Earache';output;
  id=5;body='Legs';pref='Bad foot';output;
  year=2000;
  tmt='A';
  id=1;body='Head';pref='Cough';output;
  id=1;body='Head';pref='Sneeze';output;
  id=1;body='Head';pref='Earache';output;
  id=2;body='Legs';pref='Bad foot';output;
  id=3;body='Head';pref='Cough';output;
  tmt='B';
  id=4;body='Legs';pref='Bad foot';output;
  id=4;body='Legs';pref='Bad ankle';output;
  id=4;body='Head';pref='Earache';output;
  id=5;body='Legs';pref='Bad foot';output;
  label body='Body System' pref='Preferred Term';
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

proc format;
  value $tmt
  'A'='Drug A'
  'B'='Drug B'
  'Z'='All Drugs'
;
run;
options ls=90 ps=43 nodate nonumber macrogen spool;

%npcttab(by=year,tmtlabel=' ',flatten=yes,style=3,order=ll,lvl2all=no,
dsin=test,level1=body,level2=pref,uniqueid=id,
tmtvar=tmt,tmttot='Z',fmtin=$tmt.,tmtfmt=$tmt.,
dspop=pop,nsort='Z',split=/,n=n);



  