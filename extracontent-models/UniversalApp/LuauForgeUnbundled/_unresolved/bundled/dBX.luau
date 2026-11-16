local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local module = require("@luauforge/bundled/dwM")

return makeActionCreator("AddAutocompleteSuggestion", function(p2, p3)
	module.isType(p2, "string", "Actions.AddAutocompleteSuggestion.prefix")
	module.isType(p3, "table", "Actions.AddAutocompleteSuggestion.autocompleteSuggestion")

	return { prefix = p2, autocompleteSuggestion = p3 }
end)
