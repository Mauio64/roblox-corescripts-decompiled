return require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux").makeActionCreator("CurrentExperienceInviteReceived", function(p2, p3, p4, p5)
	return {
		payload = {
			experienceInviteId = p2,
			membershipEntityId = p3,
			notificationId = p4,
			isInviter = p5
		}
	}
end)
