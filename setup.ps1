# run this script only in virtual machince
# if you run this script in your computer, it could harm you machine

function ShowBanner {
    $banner  = @()
    $banner+= $Global:Spacing + ''                                               
    $banner+= $Global:Spacing + '======================================'
    $banner+= $Global:Spacing + '     __                            '
    $banner+= $Global:Spacing + '    / /____ ________ ____ ____ __ '
    $banner+= $Global:Spacing + '   /  _/ // / __/ // / // / // / '
    $banner+= $Global:Spacing + '  /_/\_\\_, /_/  \_,_/\_,_/\_,_/  '
    $banner+= $Global:Spacing + '       /___/                     '
    $banner+= $Global:Spacing + ''
    $banner+= $Global:Spacing + ''
    $banner+= $Global:Spacing + 'vulnerable active directory by kyruuu'
    $banner+= $Global:Spacing + '======================================'
    $banner | foreach-object {
        Write-Host $_ -ForegroundColor @('Cyan')
    }                             
}

$groups = [System.Collections.ArrayList](Get-Content "groups.txt")
$firstnames = [System.Collections.ArrayList](Get-Content "firstname.txt")
$lastnames = [System.Collections.ArrayList](Get-Content "lastname.txt")
$passwords = [System.Collections.ArrayList](Get-Content "password.txt")


$group = @()
$user = @()


$max_groups = 7
for ($i = 0; $i -lt $max_groups; $i++){
    $g = (Get-Random -InputObject $groups)
    $group += @{"name" = "$g"}
    $groups.Remove($g)
}

$max_users = 64
for ($i = 0; $i -lt $max_users; $i++){
    $f = (Get-Random -InputObject $firstnames)
    $l = (Get-Random -InputObject $lastnames)
    $p = (Get-Random -InputObject $passwords)
    $userd = @{
        "name" = "$f $l"
        "password" = "$p"
        "groups" = @((Get-Random -InputObject $group).name)
    }
    $user += $userd
    $passwords.Remove($p)
    $firstnames.Remove($f)
    $lastnames.Remove($l)
}

function CreateADgroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )
    
    $name = $groupObject.name

    New-ADGroup -Name $name -GroupScope Global
}

function CreateADUser() {
    param( [Parameter(Mandatory=$true)] $userObject )    
    

    $name = $userObject.name;
    $firstname  = $userObject.name.split(' ')[0]
    $lastname = $userObject.name.split(' ')[1]
    $username = "{0}{1}" -f ($firstname[0] , $lastname);
    $SamAccountName = $username.tolower();
    $principalname = $username.tolower();
    $password = $userObject.password;

    New-ADUser -Name $name -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    foreach ($group in $userObject.groups) {
        try {
            Get-ADGroup -Identity $group
            Add-ADGroupMember -Identity $group -Members $SamAccountName
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "Failed to add $SamAccountName to $group cz the group doesn't exist"
        }
    }
}

$Global:Domain = "kyruuu.com"

ShowBanner

secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

echo "creating all random groups and users ..."

foreach( $i in $group){
    CreateADgroup $i 
}

foreach( $i in  $user){
    CreateADUser $i
}

echo "done, you're ready to go!"