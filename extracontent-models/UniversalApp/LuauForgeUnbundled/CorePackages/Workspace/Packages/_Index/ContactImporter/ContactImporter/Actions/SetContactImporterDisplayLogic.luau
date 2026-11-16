return require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").Rodux.makeActionCreator("SetContactImporterDisplayLogic", function(p2)
	assert(
		type(p2) == "table",
		string.format(
			"SetContactImporterDisplayLogic action expects params to be a table, was %s",
			(type(p2))
		)
	)

	return p2
end)
