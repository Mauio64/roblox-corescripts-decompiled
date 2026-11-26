local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetCatalogMetadata", function(p2)
	module.isType(p2, "table", "SetCatalogMetadata expects 'metadata' to be a table.")

	return { metadata = p2 }
end)
