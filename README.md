# Send-Mass-Email

Generates and sends email to a list in a CSV File

Instructions:

1) Compile your CSV file with the contacts you wish to email and save in 'CSV File' folder
2) Create your email in HTMl and save in 'HTML Message' folder
3) Copy the ConfigExample.xml and edit with the proper information, including CSV File, HTML File, and Image File Locations
        For Example: MassMail-8-7-2015_config.xml
4) Run email.ps1 with config file specified
		For Example: .\email.ps1 -ConfigFile C:\temp\MassMail-8-7-2015_config.xml
