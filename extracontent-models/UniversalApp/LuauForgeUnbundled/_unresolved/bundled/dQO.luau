local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("AppendCollectibleResellersInstances", function(p2, p3)
	module.isType(p2, "string", "AppendCollectibleResellersInstances expects collectibleItemId")
	module.isType(p3, "table", "AppendCollectibleResellersInstances expects collectibleItemInstances")

	return { collectibleItemId = p2, collectibleItemInstances = p3 }
end)
