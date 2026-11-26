local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("SetOwnedItemIdsBySubtype", function(p2, p3)
	return { itemSubType = p2, itemIds = p3 }
end)
