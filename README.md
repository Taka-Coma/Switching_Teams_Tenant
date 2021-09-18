# Switch_Teams_Tenant
- Move Teams contents from one tenant to the other
- Here, teams (groups), channels and memberships are assumed to move.
	- User account mapping and moving files are not included. 

---

## Preparation (for MacOS)

1. Install PowerShell
```
brew install --cask powershell
```

2. Install a module for Teams
```
Install-Module -Name MicrosoftTeams -AllowPrerelease -Force  
```
- Need the prerelease version for handling information of private channels.

3. Execution of a ps1 file (on PowerShell)
```
./<file_name>.ps1
```
---

## Extract Information from the old Tenant (`getInfo.ps1`)

1. Connect to the old Tenant
```
### Connect to Teams of old tenant; authentication required through a browser 
Connect-MicrosoftTeams
```

2. Obtain Team list
```
Get-Team -User <user_account> | Export-Csv -path teams.csv -Encoding UTF8
### post-edit the csv file so that including all teams you want to handle.
```
- Teams only owned by the user can be obtained.

3. Obtain Member List of a Team
```
Get-TeamUser -GroupId <group_id> | Export-Csv -path members.csv -Encoding UTF8
```
- Specify the team by `group_id`.

4. Obtain Channel List
```
Get-TeamChannel -GroupId <group_id> | Export-Csv -path ./channels.csv -Encoding UTF8
```

5. Obtain Member List of a Channel
```
Get-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> | Export-Csv -path channel_users.csv -Encoding UTF8
```
- Specify the channel by `channel_name`

6. Mapping of Old Accounts to New Accounts in Python (`user_mapping.py`)
- Mapping file (`mapping.csv`) must be taken from authorized persons of your tenants.

---

## Store Information to the new Tenant  (`addInfo.ps1`)

1. Connect to the new Tenant
```
### Connect to Teams of new tenant; authentication required through a browser 
Connect-MicrosoftTeams
```

2. Create Team
```
### Create a new team and hold team info in $group
$group = New-Team -DisplayName <team_name> -Description <team_description> -Visibility <team_visibility>
```

3. Add Members to the Team
```
Add-TeamUser -GroupId <group_id> -User <user_account> -Role <user_role>
```

4. Add Channels to the Team
```
New-TeamChannel -GroupId <group_id> -DisplayName <channel_name> -Description <channel_description> -MembershipType <channel_membership_type>
```

5. Add Members to a Private Channel
```
if(<role> -eq 'Member'){
	Add-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> -User <user_account> 
}else{
	Add-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> -User <user_account>
	Add-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> -User <user_account> -Role <user_role>
}
```
- An owner member must be registered as an ordinary member in advance. 


---

## Note
- Member list of a private channel which you are not an owner CANNOT be obtained.
	- Only owners of the channel can be obtained.
- Some members added to a private channel with the Owner role are failed.
	- I don't know why this happens occasionally and what types of users are involved. 

---

## References
- Command list of PowerShell + Teams
	- https://docs.microsoft.com/en-us/powershell/module/teams/add-teamuser?view=teams-ps
- Reference
	- https://www.oge.saga-u.ac.jp/online/teams-powershell-member-management.html (in Japanese)
