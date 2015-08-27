#!/usr/bin/perl
use warnings; use strict;
use Mail::Mailer;
my $mail = Mail::Mailer->new("sendmail");
$mail->open({
        From=>'lutaoact@gmail.com',
        To=>'lutaoact@139.com',
        Subject=>'Friendly greeting',
        }) or die "Cannot send mail";
print $mail "Dear you:\nHow are you? Write when you get the chance!";
$mail->close or die "couldn't send whole message: $!\n";
