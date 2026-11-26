local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetUserInventoryRecommendationsFetchStatus", function(p2, p3)
	return { searchUuid = p2, status = p3 }
end)
