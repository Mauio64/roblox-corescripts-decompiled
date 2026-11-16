local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetCollectibleItemInfo", function(p2, p3)
	module.isType(p2, "string", "SetCollectibleItemInfo expects collectibleItemId")
	module.isType(p3, "table", "SetCollectibleItemInfo expects collectibleItemData")

	return { collectibleItemId = p2, collectibleItemData = p3 }
end)
