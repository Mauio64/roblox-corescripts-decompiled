local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetCollectibleMarketplaceResaleParameters", function(p2, p3, p4)
	module.isType(
		p2,
		"string",
		"SetCollectibleMarketplaceResaleParameters action expects collectibleItemId to be a string"
	)

	module.isType(
		p3,
		"table",
		"SetCollectibleMarketplaceResaleParameters action expects resaleParametersInfo to be a table"
	)

	return {
		collectibleItemId = p2,
		resaleParametersInfo = p3,
		itemSubTypeNameString = p4
	}
end)
