local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetCollectibleResellersInstances", function(p2, p3)
	module.isType(p2, "string", "SetCollectibleResellersInstances expects collectibleItemId")
	module.isType(p3, "table", "SetCollectibleResellersInstances expects collectibleItemInstances")

	return { collectibleItemId = p2, collectibleItemInstances = p3 }
end)
