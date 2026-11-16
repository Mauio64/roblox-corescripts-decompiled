local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

return Rodux.makeActionCreator("ReceivedRecentlyViewedItemsData", function(data)
	return {
		assetData = data.assetData,
		bundleData = data.bundleData,
		widget = data.widget
	}
end)
