# Switch_Teams_Tenant

- Command list of PowerShell + Teams
	- https://docs.microsoft.com/en-us/powershell/module/teams/add-teamuser?view=teams-ps
- 参考
	- https://www.oge.saga-u.ac.jp/online/teams-powershell-member-management.html
---

## 準備 (for MacOS)

1. Install PowerShell
```
brew install --cask powershell
```

2. Install a module for Teams
```
Install-Module -Name MicrosoftTeams -AllowPrerelease -Force  
```
- Need the prerelease version for handling information of private channels.

3. ps1 ファイルの実行（PowerShell 上）
```
./<file_name>.ps1
```
---

## 旧 Teams からデータを取得 (`getInfo.ps1`)

1. 旧テナントに接続
```
### Connect to Teams of old tenant; authentication required through a browser 
Connect-MicrosoftTeams
```

2. チーム一覧の取得
```
Get-Team -User <user_account> | Export-Csv -path teams.csv -Encoding UTF8
### post-edit the csv file so that including all teams you want to handle.
```

3. チームメンバ取得
```
### Get member list of a team (specified by group_id)
Get-TeamUser -GroupId <group_id> | Export-Csv -path members.csv -Encoding UTF8
```

4. チャネルの取得
```
Get-TeamChannel -GroupId <group_id> | Export-Csv -path ./channels.csv -Encoding UTF8
```

5. プライベートチャネルユーザ一覧の取得
```
Get-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> | Export-Csv -path channel_users.csv -Encoding UTF8
```

6. ユーザ ID のマッピング（old -> new）：python コード (`user_mapping.py`)
- Mapping file (`mapping.csv`) must be taken from authorized persons of your tenants.

---

## 新 Teams へデータを移行 (`addInfo.ps1`)

1. 新テナントに接続
```
### Connect to Teams of new tenant; authentication required through a browser 
Connect-MicrosoftTeams
```

2. チームの作成
```
### Create a new team and hold team info in $group
$group = New-Team -DisplayName <team_name> -Description <team_description> -Visibility <team_visibility>
```

3. メンバの登録
```
Add-TeamUser -GroupId <group_id> -User <user_account> -Role <user_role>
```

4. チャネルの登録
```
New-TeamChannel -GroupId <group_id> -DisplayName <channel_name> -Description <channel_description> -MembershipType <channel_membership_type>
```

5. プライベートチャネルユーザの登録
- 注意：一度チャネルのメンバとして登録しないと所有者にできない
	- Role = Member は使えない（Role なしで登録が Member 登録に相当）
```
if(<role> -eq 'Member'){
	Add-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> -User <user_account> 
}else{
	Add-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> -User <user_account>
	Add-TeamChannelUser -GroupId <group_id> -DisplayName <channel_name> -User <user_account> -Role <user_role>
}
```
