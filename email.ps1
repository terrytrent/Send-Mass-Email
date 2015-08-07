param(
[string]$ConfigFile
)

cls

if($ConfigFile -eq ""){
echo "You did not specify a configuration file.`n`nPlease specify a configuration file using the -ConfigFile Parameter.`n`nExample:`n        .\email.ps1 -ConfigFile C:\temp\config.xml`n"
Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
echo `n
exit
}

[xml]$xmlfile = get-content $ConfigFile
$FirstName = $xmlfile.configuration.SendMassMailMeta.FromLine.FirstName
$LastName = $xmlfile.configuration.SendMassMailMeta.FromLine.LastName
$EmailAddress = $xmlfile.configuration.SendMassMailMeta.FromLine.EmailAddress
$from="$FirstName $LastName <$EmailAddress>"
$SMTPServer = $xmlfile.configuration.SendMassMailMeta.SMTPServer
$EmailSubject = $xmlfile.configuration.SendMassMailMeta.EmailSubject
$ListToSend = $xmlfile.configuration.SendMassMailMeta.ListToSend
$ListToSend = import-csv "$ListToSend"
$BodyAsHTML = $xmlfile.configuration.SendMassMailContent.BodyAsHTML
$BodyHTMLToSend = $xmlfile.configuration.SendMassMailContent.BodyHTMLToSend
$BodyTextToSend = $xmlfile.configuration.SendMassMailContent.BodyTextToSend
$attachments = $xmlfile.configuration.SendMassMailContent.attachment

echo "Sending Mass Email from $from...`n"

foreach ($email in $listToSend){

	#setting variables from each row
	$toName=$email.FullName
	$toEmail=$email.Email
	$ccName=$email.Manager
	$ccEmail=$email.ManEmail
	

	#setting variables to be used in the send-mailmessage line
	$to="$toName <$toEmail>"
	$cc="$ccName <$ccEmail>"
	

	$Subject=$EmailSubject -replace "%toName%",$toName
	$Subject=$Subject -replace "%toEmail%",$toEmail
	$Subject=$Subject -replace "%ccName%",$ccName
	$Subject=$Subject -replace "%ccEmail%",$ccEmail


	if($BodyAsHTML -eq "Yes"){

		$body = get-content $BodyHTMLToSend | out-string
		$body=$body -replace "%toName%",$toName
		$body=$body -replace "%toEmail%",$toEmail
		$body=$body -replace "%ccName%",$ccName
		$body=$body -replace "%ccEmail%",$ccEmail
		
		
		send-mailmessage -to "$to" -cc "$cc" -from "$from" -subject "$Subject" -body $body -bodyashtml -useSSL -smtpserver $smtpserver -attachments $attachments

	}
	else{

		$body = get-content $BodyTextToSend | out-string
		$body=$body -replace "%toName%",$toName
		$body=$body -replace "%toEmail%",$toEmail
		$body=$body -replace "%ccName%",$ccName
		$body=$body -replace "%ccEmail%",$ccEmail

		send-mailmessage -to "$to" -cc "$cc" -from "$from" -subject $Subject -body $body -useSSL -smtpserver $smtpserver -attachment $attachments

	}
}

echo "Emails sent successfully`n`n"
Write-Host -NoNewLine 'Press any key clear the screen and exit...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
cls