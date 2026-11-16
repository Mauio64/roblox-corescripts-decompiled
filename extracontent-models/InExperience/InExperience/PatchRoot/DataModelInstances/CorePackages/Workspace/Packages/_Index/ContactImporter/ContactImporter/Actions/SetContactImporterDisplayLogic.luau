local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.Rodux.makeActionCreator(script.Name, function(p)
	assert(
		type(p) == "table",
		string.format("SetContactImporterDisplayLogic action expects params to be a table, was %s", (type(p)))
	)

	return p
end)
