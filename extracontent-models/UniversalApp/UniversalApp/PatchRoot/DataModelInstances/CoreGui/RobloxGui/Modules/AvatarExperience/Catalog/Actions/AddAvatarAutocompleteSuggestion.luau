local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "Actions.AddAutocompleteSuggestion.prefix")
	ArgCheck.isType(p2, "table", "Actions.AddAutocompleteSuggestion.autocompleteSuggestions")

	return {
		prefix = p1,
		autocompleteSuggestions = p2
	}
end)
