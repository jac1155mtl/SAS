/*<pre><b>
/ Program   : jobinfo
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 29 November 2002
/ Contact   : roland@rashleigh-berry.fsnet.co.uk
/ Purpose   : To store important job information
/ SubMacros : none
/ Notes     : This was written for a Microsoft Windows 98 platform. You will have
/             to amend this to work on other platforms.
/ Usage     : %jobinfo
/ 
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ N/A
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/ 
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/

%macro jobinfo;
%global _sysin_ _prog_ _user_ _path_;
%let _sysin_=%sysfunc(getoption(sysin));
%let _prog_=%scan(&_sysin_,-2,.\/);

/**
Use the following line for Windows NT
%let _user_=%sysget(USERNAME);
..or use the following line for Unix
%let _user_=%sysget(USER);
..or leave out if there is no username
**/

/**
Use the following line for Unix
%let _path_=%sysget(PWD);
..but if not Unix then use the following method to match your platform
**/

filename _here './';
%let _path_=%sysfunc(pathname(_here));
filename _here;

%put;
%put MSG: (jobinfo) The following global macro variables have been set up;
%put MSG: (jobinfo) and can be used in your code. ;
%put _sysin_=&_sysin_;
%put _prog_=&_prog_;
%put _user_=&_user_;
%put _path_=&_path_;

%mend;
