local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return makeActionCreator(script.Name, function(p1) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "Actions.AddAutocompleteSuggestionTable.suggestionTable")

	return {
		suggestionTable = p1
	}
end)
