local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/dwM")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("AddAvatarAutocompleteSuggestion", function(p2, p3)
	module.isType(p2, "string", "Actions.AddAutocompleteSuggestion.prefix")
	module.isType(p3, "table", "Actions.AddAutocompleteSuggestion.autocompleteSuggestions")

	return { prefix = p2, autocompleteSuggestions = p3 }
end)
