local module = require("@luauforge/bundled/dTl")
local module2 = require("@luauforge/bundled/dTx")

local module3 = require("@luauforge/bundled/dTB")

local getMarketplaceCatalogCategoryStore = module2.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore

return {
	selectedCameraCategoryInfo = module.createComputed(function(p2)
		local activeLeafId = module3.getActiveLeafId(p2)

		if activeLeafId == nil or activeLeafId == "" then
			return nil
		end

		local data = getMarketplaceCatalogCategoryStore(p2).getMarketplaceCatalogCategory(activeLeafId).data(p2)

		if data == nil then
			return nil
		end

		return {
			CameraFocus = data.cameraFocus,
			CameraZoomRadius = data.cameraZoomRadius,
			CanAnimateCameraBasedMood = data.canAnimateCameraBasedMood
		}
	end)
}
