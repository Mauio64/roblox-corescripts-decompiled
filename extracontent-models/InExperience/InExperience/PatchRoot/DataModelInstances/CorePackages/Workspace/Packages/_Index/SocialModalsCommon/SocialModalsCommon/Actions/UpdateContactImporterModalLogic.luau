local parent = script:FindFirstAncestor("SocialModalsCommon").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	assert(
		type(p) == "table",
		string.format("UpdateContactImporterModalLogic action expects params to be a table, was %s", (type(p)))
	)

	return p
end)
