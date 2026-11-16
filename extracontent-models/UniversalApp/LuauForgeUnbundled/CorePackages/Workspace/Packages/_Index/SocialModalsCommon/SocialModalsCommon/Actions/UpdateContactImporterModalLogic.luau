return require("@game/CorePackages/Workspace/Packages/_Workspace/SocialModalsCommon/Rodux").makeActionCreator("UpdateContactImporterModalLogic", function(p2)
	assert(
		type(p2) == "table",
		string.format(
			"UpdateContactImporterModalLogic action expects params to be a table, was %s",
			(type(p2))
		)
	)

	return p2
end)
