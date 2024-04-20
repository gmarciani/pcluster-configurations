# Active Directory

## Directory Management

### Management Instance

Launch an EC2 Windows instance (at least t2.medium) joined to the AD domain.

check that the instance is joined to the domain:

```
Get-CimInstance Win32_ComputerSystem
```

Install the AD software:
```
Install-WindowsFeature RSAT
```

### General Constants

```
$Domain = "DC=corp,DC=mgiacomo,DC=com"
$AdminUser = "Admin"
$AdminPassword = "p@ssw0rd"
$AdminSecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$AdminCredential = New-Object System.Management.Automation.PSCredential $AdminUser, $AdminSecurePassword
```

### Groups Management

Create a group:
```
$Group = "EngineeringTeam"
New-ADGroup -Name $Group -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=CORP,$Domain" -Credential $AdminCredential
```

Delete a group:

```
$Group = "EngineeringTeam"
Remove-ADGroup -Name $Group -Credential $AdminCredential
```

Read group members:

```
$Group = "EngineeringTeam"
Get-ADGroupMember -Identity $Group -Credential $AdminCredential
```

### Users Management

Create a user:

```
$User = "user1"
$UserPassword = "p@ssw0rd"
$UserSecurePassword = ConvertTo-SecureString $UserPassword -AsPlainText -Force
New-ADUser -Name $User -AccountPassword $UserSecurePassword -Enabled:$true -Credential $AdminCredential
```

Add a user to a group:

```
$User = "user1"
$Group = "EngineeringTeam"
Add-ADGroupMember -Identity $Group -Members $User -Credential $AdminCredential
```

Change user password:

```
$User = "user1"
$NewUserPassword = "p@ssw0rd-changed-1"
$NewUserSecurePassword = ConvertTo-SecureString $UserPassword -AsPlainText -Force
Set-ADAccountPassword -Identity $User -SearchBase $Domain -Reset -NewPassword $NewUserSecurePassword -Credential $AdminCredential
```

Delete a user:

```
$User = "user1"
Remove-ADUser -Identity $User -Confirm:$false -Credential $AdminCredential
```

Describe all users:
```
Get-ADUser -Filter * -SearchBase $Domain -Credential $AdminCredential
```

Describe a user:
```
$User = "user1"
Get-ADUser -Identity $User -SearchBase $Domain -Credential $AdminCredential -Properties *
Get-ADUser -Identity $User -SearchBase $Domain -Properties * -Credential $AdminCredential | Out-String -Stream | Select-String "DistinguishedName","MemberOf","ObjectClass","SamAccountName","userAccountControl","HomeDirectory","unixHomeDirectory","EmailAddress"
```

### Configure custom home directory

```
$User = "user1"
$CustomHomeDir = "/shared/home/$User"
Set-ADUser -identity $User -Add @{ unixHomeDirectory="$CustomHomeDir"} -Credential $AdminCredential
```

### Computers Management
```
$Computer = "IP-3-5-62-29"
Get-ADComputer -identity $Computer -Credential $AdminCredential -Properties *

$Computer = "LOGIN-NODES-NLB-1"
New-ADComputer -Name $Computer -Path "OU=Computers,OU=corp,DC=corp,DC=mgiacomo3,DC=com" -Credential $AdminCredential
Get-ADComputer -identity $Computer -Credential $AdminCredential -Properties *
Set-ADComputer -Identity $Computer -ServicePrincipalNames @{ Add="host/krb-0-krb09-1sy8vaj9cuovj-9ed1fb4d2ce794d6.elb.eu-west-1.amazonaws.com" } -Credential $AdminCredential
```

### DNS Management
```
$DomainControllerIp = "3.5.6.36"
Get-DnsServer -ComputerName $DomainControllerIp -Credential $AdminCredential
Add-DnsServerResourceRecordCName -Name "login-pcluster.corp.mgiacomo3.com" -ComputerName 3.5.6.36 -HostNameAlias "login-pcluster.corp.mgiacomo3.com" -ZoneName "corp.mgiacomo3.com"
```