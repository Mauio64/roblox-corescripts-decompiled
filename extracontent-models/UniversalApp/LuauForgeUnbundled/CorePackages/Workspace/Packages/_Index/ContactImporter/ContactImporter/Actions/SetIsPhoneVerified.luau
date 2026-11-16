return require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").Rodux.makeActionCreator("SetIsPhoneVerified", function(p2)
	assert(
		type(p2) == "table",
		string.format("SetIsPhoneVerified action expects params to be a table, was %s", (type(p2)))
	)

	return p2
end)
