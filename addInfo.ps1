$teams = Import-Csv ./teams_new.csv
foreach ($team in $teams){
	$group_id = $team.GroupId
	$team_name = $team.DisplayName
	
	$members = Import-Csv "./members_$($team_name)_mapped.csv" 
	foreach($m in $members){
		Add-TeamUser -GroupId $group_id -User $m.User -Role $m.Role
	}
	
	$channels = Import-Csv "./channels_$($team_name).csv"
	foreach ($channel in $channels){
		$channel_name = $channel.DisplayName
		New-TeamChannel -GroupId $group_id -DisplayName $channel_name -Description $channel.Description -MembershipType $channel.MembershipType

		if ($channel.MembershipType -eq 'Private'){
			$channel_members = Import-Csv "./channel_members_$($team_name)_$($channel_name)_mapped.csv"
			foreach($m in $channel_members){
				if($m.Role -eq 'Member'){
					Add-TeamChannelUser -GroupId $group_id -DisplayName $channel_name -User $m.User 
				}else{
					Add-TeamChannelUser -GroupId $group_id -DisplayName $channel_name -User $m.User
					Add-TeamChannelUser -GroupId $group_id -DisplayName $channel_name -User $m.User -Role $m.Role 
				}
			}
		}
	}

}
