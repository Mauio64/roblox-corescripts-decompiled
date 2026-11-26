local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetCollectibleResellableInstances", function(p2, p3)
	module.isType(p2, "string", "SetCollectibleResellableInstances expects collectibleItemId")
	module.isType(p3, "table", "SetCollectibleResellableInstances expects collectibleItemInstances")

	return { collectibleItemId = p2, collectibleItemInstances = p3 }
end)
