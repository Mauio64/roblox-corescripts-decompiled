local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetPriceRange", function(p2, p3)
	module.isType(p2, "number", "SetPriceRange expects minPrice")
	module.isType(p3, "number", "SetPriceRange expects maxPrice")

	return {
		priceRange = { minPrice = p2, maxPrice = p3 }
	}
end)
