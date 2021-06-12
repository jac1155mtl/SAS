/* */
%macro email;
    *Set sender's email address and other options;
    options 
        emailsys    = smtp
        emailhost   = mail.company.com
        emailid     = 'SenderFirst SenderLast <email@company.com>';

    *Initialize email file ref, set recipients' email addresses, and define subject line.;
    filename 
        mailout1 
        email
        to      = ('FirstName Lastname <email@company.com>'
                   ,'FirstName Lastname <email@company.com>')
        subject = ("INSERT SUBJECT HERE")
        cc      = ('FirstName Lastname <email@company.com>'
                   ,'FirstName Lastname <email@company.com>')
        attach  = ("Insert filename with extension here" ) /*if attaching a separate file to the email*/
    ;

    data _null_;
        file mailout1 notitles;
        put 
            // @1 "****** This message was automatically generated ******"
            // @1 "INSERT EMAIL BODY TEXT HERE"
        ;
    run;
%mend email;
%email;
