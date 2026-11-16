local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
require("@luauforge/bundled/dMq")
require("@luauforge/bundled/dMr")

return Rodux.makeActionCreator("SetCatalogSort", function(p2, p3)
	module.isType(p2, "string", "sort")
	module.isTypeOrNil(p3, "string", "sortAggregation")

	return { sort = p2, sortAggregation = p3 }
end)
