$teams = Import-Csv ./teams.csv | Select-Object GroupId, DisplayName
$my_id = <my_id>

### for each team
foreach ($team in $teams){
	$path = "members_$($team.DisplayName).csv"
	Get-TeamUser -GroupId $team.GroupId | Export-Csv -path $path -Encoding UTF8

	$path = "channels_$($team.DisplayName).csv"
	$channels = Get-TeamChannel -GroupId $team.GroupId
	$channels | Export-Csv -path $path -Encoding UTF8

	foreach ($channel in $channels){
		if ($channel.MembershipType -eq 'Private'){
			$path = "channel_members_$($team.DisplayName)_$($channel.DisplayName).csv"
			Get-TeamChannelUser -GroupId $team.GroupId -DisplayName $channel.DisplayName | Export-Csv -path $path -Encoding UTF8
		}
	}
}
