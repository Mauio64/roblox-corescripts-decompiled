local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")

return Rodux.makeActionCreator("UpdateCollectibleResellableInstance", function(p2, p3, p4)
	return {
		collectibleItemId = p2,
		collectibleInstanceId = p3,
		collectibleInstanceData = p4
	}
end)
