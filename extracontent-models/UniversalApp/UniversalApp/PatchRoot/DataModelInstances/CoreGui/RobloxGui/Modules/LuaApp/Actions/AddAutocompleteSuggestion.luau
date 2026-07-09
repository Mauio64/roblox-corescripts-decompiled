local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return makeActionCreator(script.Name, function(p1, p2) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "Actions.AddAutocompleteSuggestion.prefix")
	ArgCheck.isType(p2, "table", "Actions.AddAutocompleteSuggestion.autocompleteSuggestion")

	return {
		prefix = p1,
		autocompleteSuggestion = p2
	}
end)
