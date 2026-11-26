return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("ChangedParticipants", function(p2, p3, p4, p5)
	return { conversationId = p2, participants = p3, title = p4, lastUpdated = p5 }
end)
