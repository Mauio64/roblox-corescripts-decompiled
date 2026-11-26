return require("@game/CorePackages/Workspace/Packages/_Workspace/NextDataExpirationTimeRodux/Rodux").makeActionCreator("SetNextDataExpirationTime", function(value, value2, p2)
	assert(type(value) == "string", "SetNextDataExpirationTime: key must be a string!")

	local v5 = type(value2) == "number" and value2 > 0
	assert(v5, "SetNextDataExpirationTime: nextDataExpirationTime must be a positive number!")

	return { key = value, nextDataExpirationTime = value2, namespace = p2 }
end)
