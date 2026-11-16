local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceItemFavoriteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/createMarketplaceItemFavoriteStore")
local getMarketplaceAssetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceAsset/getMarketplaceAssetStore")

return Signals.createComputed(function()
	return createMarketplaceItemFavoriteStore({
		itemType = "Asset",
		getFavoriteCount = function(p2)
			local data = getMarketplaceAssetStore(false).getMarketplaceAssetInfo(p2).data(false)

			if data then
				return data.favoriteCount
			end

			return nil
		end,
		setFavoriteCount = function(p2, p3)
			getMarketplaceAssetStore(false).updateMarketplaceAssetInfo(p2, { favoriteCount = p3 })
		end
	})
end)
