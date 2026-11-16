return require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Rodux").makeActionCreator("ReceivedUserInviteStatus", function(p2, p3)
	return { userId = tostring(p2), inviteStatus = p3 }
end)
