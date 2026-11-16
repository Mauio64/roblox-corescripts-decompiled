return require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux").makeActionCreator("CurrentExperienceInviteUpdated", function(p2)
	return {
		payload = { experienceInvite = p2 }
	}
end)
