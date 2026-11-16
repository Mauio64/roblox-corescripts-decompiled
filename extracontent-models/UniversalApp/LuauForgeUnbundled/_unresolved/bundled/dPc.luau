local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetRecommendedItemsV2", function(p2, p3, p4)
	return { items = p2, itemTypeId = p3, recommendationsType = p4 }
end)
