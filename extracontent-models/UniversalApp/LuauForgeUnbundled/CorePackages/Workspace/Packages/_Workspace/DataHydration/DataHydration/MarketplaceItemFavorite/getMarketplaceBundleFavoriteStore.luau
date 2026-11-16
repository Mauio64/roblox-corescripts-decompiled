local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceItemFavoriteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/createMarketplaceItemFavoriteStore")
local getMarketplaceBundleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceBundle/getMarketplaceBundleStore")

return Signals.createComputed(function()
	return createMarketplaceItemFavoriteStore({
		itemType = "Bundle",
		getFavoriteCount = function(p2)
			local data = getMarketplaceBundleStore(false).getMarketplaceBundleInfo(p2).data(false)

			if data then
				return data.favoriteCount
			end

			return nil
		end,
		setFavoriteCount = function(p2, p3)
			getMarketplaceBundleStore(false).updateMarketplaceBundleInfo(p2, { favoriteCount = p3 })
		end
	})
end)
