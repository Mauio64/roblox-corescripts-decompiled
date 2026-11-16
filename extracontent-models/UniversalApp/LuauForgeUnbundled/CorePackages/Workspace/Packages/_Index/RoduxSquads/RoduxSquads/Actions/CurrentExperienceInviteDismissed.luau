return require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux").makeActionCreator("CurrentExperienceInviteDismissed", function(p2)
	return {
		payload = { notificationId = p2 }
	}
end)
