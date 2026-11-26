local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetCollectibleResaleData", function(p2, p3)
	module.isType(p2, "string", "SetCollectibleResaleData expects collectibleItemId")
	module.isType(p3, "table", "SetCollectibleResaleData expects resaleData")

	return { collectibleItemId = p2, resaleData = p3 }
end)
