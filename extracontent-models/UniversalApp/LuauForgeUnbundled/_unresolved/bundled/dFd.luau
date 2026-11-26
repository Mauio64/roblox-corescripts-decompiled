local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local module = require("@luauforge/bundled/dzP")

return makeActionCreator("AddAutocompleteSuggestionTable", function(p2)
	module.isType(p2, "table", "Actions.AddAutocompleteSuggestionTable.suggestionTable")

	return { suggestionTable = p2 }
end)
