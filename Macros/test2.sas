**REPLACE A STRING IN A MACRO VARIABLE;
%let rule = there are a lot of words in this macro variable;

data _null_;
    rule = tranwrd("&rule.","a lot of","many");
    call symputx("rule",strip(rule));
run;

%put &=rule;
