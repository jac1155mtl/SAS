/*********************************************************************
MACRO NAME          : pwd

PURPOSE             : Macro for returning random generic password string
                      with at least 1 uppercase character, 1 lowcase character,
                      1 digit and 1 special character

PARAMETERS          : pwdLength - length of password generated
                                  [default = 16]
                      pwdVar    - macro variable holding the password generated
                                  [default = password]
RETURNS             : macro variable with random generic password string

EXTERNAL MACROS     : n/a

NOTES               : run %pwd(help) for syntax help in SAS

SPECIAL REQUIREMENTS: n/a

EXAMPLES            : %pwd(); 
                      %pwd(help);
                      %pwd(pwdLength=20,pwVar=tblPwd);
---------------------------------------------------------------------
MACRO HISTORY       :

Programmer(s)       Date(s)     Brief Description of Modifications
-------------------+-----------+-------------------------------------
Lars Tynelius        18DEC2007  created
				http://cijas.blogspot.com/2012/01/password-generator-with-sas.html
Jo Ann Colas         19MAY2021  Add special characters to password string
                                add new parameter: pwdVar = name of macro 
                                variable that holds password generated
*********************************************************************/;

%put MACRO CALLED: pwd;

%macro pwd(help,pwdLength=16,pwdVar=password);
    %local ER ROR uppChars lowChars numChars spcChars chars charsLength 
    uppLength lowLength numLength specLengh _rc i repChar repPos;

    %global &pwdVar.;
    
    %let ER = ER;
    %let ROR = ROR;

    %*SYNTAX HELP in SAS;
    %if (%bquote(%upcase(&help.)) eq HELP) %then %do;
        %put NOTE: +--------------------------------------------------------------+;
        %put NOTE: | Help for macro PWD                                           |;
        %put NOTE: |   Macro for generating random password string containing     |;
        %put NOTE: |   at least one digit, one uppercase char, one lowercase      |;
        %put NOTE: |   char and one special char.                                 |;
        %put NOTE: |                                                              |;
        %put NOTE: |   Parameters                                                 |;
        %put NOTE: |     pwdLength....: Length of the password generated, def 16  |;
        %put NOTE: |     pwdVar.......: macro var holding password, def password  |;
        %put NOTE: |                                                              |;
        %put NOTE: +--------------------------------------------------------------+;
        %goto endmacro;
    %end;
    %else %if (%bquote(%upcase(&help.)) ne ) %then %do;
        %put &ER.&ROR.: Your &help request is not valid. Run pwd(help) for brief syntax help.;
        %goto endmacro;
    %end;
    %*CHECKING FOR REQUIRED PARAMETERS;
	%if %length(&pwdLength.) = 0 %then %do;
		%put &ER.&ROR.:(PWD) Parameter PWDLENGTH required;
		%goto endmacro;
	%end;
    %else %if %length(&pwdLength.) = 0 %then %do;
		%put &ER.ROR:(PWD) Parameter PWDVAR required;
		%goto endmacro;
	%end;

    %*LIST OF POSSIBLE CHARACTERS TO INCLUDE;
    %let uppChars = QWERTYUIOPASDFGHJKLZXCVBNM;
    %let lowChars = qwertyuiopasdfghjklzxcvbnm;
    %let numChars = 1234567890;
    %let spcChars = !@#$%^&?_-=+*;

    %let chars = &uppChars.&lowChars.&spcChars.&numChars.;

    %let charsLength = %length(&chars.) + 1;
    %let numLength   = %length(&numChars.) + 1;
    %let uppLength   = %length(&uppChars.) + 1;
    %let lowLength   = %length(&lowChars.) + 1;
    %let spcLength   = %length(&spcChars.) + 1;

    %*BUILD THE PASSWORD;
    %let _rc =;
    %do i = 1 %to &pwdLength.;
        %*choose a random character;
        %let char&i. = %cmpres(%substr(&chars.,%sysfunc(floor(%sysfunc(ranuni(0))*(&charsLength.-1)+1)),1));

        %*add new random character;
        %let _rc = &_rc.&&char&i.;
    %end;

    %*AT LEAST ONE DIGIT MUST BE IN THE PASSWORD;
    %if %length(%sysfunc(compress(&_rc,&numChars.))) eq &pwdLength. %then %do;
        %put NOTE: At least one digit must be in the password;
        %put NOTE: Adding one digit to the password;

        %*take a random number;
        %let repChar = %cmpres(%substr(&numChars.,%sysfunc(floor(%sysfunc(ranuni(0))*(&numLength.-1)+1)),1));
        
        %*pick a position in the current password;
        %let repPos = %cmpres(%sysfunc(floor(%sysfunc(ranuni(0))*((&pwdLength.+1)-1))));

        %*replace the character with the number;
        %let char&repPos. = &repChar;

        %let _rc = ;
        %do i = 1 %to &pwdLength.;
            %let _rc = &_rc.&&char&i.;
        %end;
    %end;

    %*AT LEAST ONE LOWER CASE CHARACTER MUST BE IN THE PASSWORD;
    %if %length(%sysfunc(compress(&_rc,&lowChars.))) eq &pwdLength. %then %do;
        %put NOTE: At least one lower case character must be in the password;
        %put NOTE: Adding one lower case character to the password;

        %*take a random number;
        %let repChar = %cmpres(%substr(&lowChars.,%sysfunc(floor(%sysfunc(ranuni(0))*(&lowLength.-1)+1)),1));
        
        %*pick a position in the current password;
        %let repPos = %cmpres(%sysfunc(floor(%sysfunc(ranuni(0))*((&pwdLength.+1)-1))));

        %*replace the character with the number;
        %let char&repPos. = &repChar;

        %let _rc = ;
        %do i = 1 %to &pwdLength.;
            %let _rc = &_rc.&&char&i.;
        %end;
    %end;

    %*AT LEAST ONE UPPER CASE CHARACTER MUST BE IN THE PASSWORD;
    %if %length(%sysfunc(compress(&_rc,&uppChars.))) eq &pwdLength. %then %do;
        %put NOTE: At least one upper case character must be in the password;
        %put NOTE: Adding one upper case character to the password;

        %*take a random number;
        %let repChar = %cmpres(%substr(&uppChars.,%sysfunc(floor(%sysfunc(ranuni(0))*(&uppLength.-1)+1)),1));
        
        %*pick a position in the current password;
        %let repPos = %cmpres(%sysfunc(floor(%sysfunc(ranuni(0))*((&pwdLength.+1)-1))));

        %*replace the character with the number;
        %let char&repPos. = &repChar;

        %let _rc = ;
        %do i = 1 %to &pwdLength.;
            %let _rc = &_rc.&&char&i.;
        %end;
    %end;

    %*AT LEAST ONE SPECIAL CHARACTER MUST BE IN THE PASSWORD;
    %if %length(%sysfunc(compress(&_rc,&spcChars.))) eq &pwdLength. %then %do;
        %put NOTE: At least one special character must be in the password;
        %put NOTE: Adding one special character to the password;

        %*take a random number;
        %let repChar = %cmpres(%substr(&spcChars.,%sysfunc(floor(%sysfunc(ranuni(0))*(&spcLength.-1)+1)),1));
        
        %*pick a position in the current password;
        %let repPos = %cmpres(%sysfunc(floor(%sysfunc(ranuni(0))*((&pwdLength.+1)-1))));

        %*replace the character with the number;
        %let char&repPos. = &repChar;

        %let _rc = ;
        %do i = 1 %to &pwdLength.;
            %let _rc = &_rc.&&char&i.;
        %end;
    %end;

    %*OUTPUT PASSWORD;
    %let &pwdVar. = &_rc.;

%put --------------------EOF pwd.sas--------------------------;
%endmacro:
%mend pwd;
