return require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/Rodux").makeActionCreator("SetPlayabilityStatus", function(p2)
	assert(type(p2) == "table", "SetPlayabilityStatus action expects playabilityStatus to be a table")

	return { playabilityStatus = p2 }
end)
