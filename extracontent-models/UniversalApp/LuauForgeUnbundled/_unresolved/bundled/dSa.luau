local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dwM")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetMarketplaceFee", function(p2)
	module.isType(p2, "table", "marketplaceFeeInfo")
	return { marketplaceFeeInfo = p2 }
end)
