local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("EquippedDeepLinkCatalogItem", function(data)
	return {
		wasItemEquipped = data.wasItemEquipped,
		fetchItemFailed = data.fetchItemFailed,
		itemId = data.itemId,
		itemType = data.itemType
	}
end)
