return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("PlayerAdded", function(p2, p3, p4, p5)
	return {
		userId = tostring(p2),
		username = p3,
		displayName = p4,
		hasVerifiedBadge = p5
	}
end)
