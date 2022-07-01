# make sure input the json file
param( [Parameter(Mandatory=$true)] $userConfig )

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


function CreateADgroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )
    
    $name = $groupObject.name

    echo "Creating $name group ..."
    New-ADGroup -Name $name -GroupScope Global
}

function CreateADUser() {
    param( [Parameter(Mandatory=$true)] $userObject )    
    

    $firstname = $userObject.firstname;
    $lastname = $userObject.lastname;
    $fullname = "{0} {1}" -f ($firstname , $lastname);
    $SamAccountName = $userObject.username.tolower();
    $principalname = $userObject.username.tolower();
    $password = $userObject.password;

    echo "Creating $SamAccountName User ..."

    New-ADUser -Name "$fullname" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    foreach ($group in $userObject.groups) {
        try {
            Get-ADGroup -Identity $group
            Add-ADGroupMember -Identity $group -Members $SamAccountName
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "Failed to add $SamAccountName to $group"
        }
    }
}

$json = (get-content $userConfig | convertfrom-json)

$Global:Domain = $json.domain

ShowBanner

foreach( $group in $json.groups){
    CreateADgroup $group 
}

foreach( $user in  $json.users){
    CreateADUser $user
}