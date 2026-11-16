return require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux").makeActionCreator("RequestReceivedCountUpdated", function(value)
	assert(type(value) == "number", "Request count must be a number")

	return {
		payload = { count = value }
	}
end)
