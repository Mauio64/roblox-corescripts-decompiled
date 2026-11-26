local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzO")

return Rodux.makeActionCreator("SetSearchTime", function(p2, p3)
	module.isNonEmptyString(p2, "SetSearchTime: searchUuid")
	module.isNonNegativeNumber(p3, "SetSearchTime: searchTime")
	return { searchUuid = p2, searchTime = p3 }
end)
