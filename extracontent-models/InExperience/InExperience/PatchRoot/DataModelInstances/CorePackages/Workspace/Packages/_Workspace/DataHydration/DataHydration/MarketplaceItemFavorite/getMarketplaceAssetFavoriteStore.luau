local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Signals = require(parent.Signals)

local createMarketplaceItemFavoriteStore = require(script.Parent.createMarketplaceItemFavoriteStore)
local getMarketplaceAssetStore = require(DataHydration.MarketplaceAsset.getMarketplaceAssetStore)

return Signals.createComputed(function()
	return createMarketplaceItemFavoriteStore({
		itemType = "Asset",
		getFavoriteCount = function(p: string)
			local data = getMarketplaceAssetStore(false).getMarketplaceAssetInfo(p).data(false)
			return if data then data.favoriteCount else nil
		end,
		setFavoriteCount = function(p: string, favoriteCount: number)
			getMarketplaceAssetStore(false).updateMarketplaceAssetInfo(p, {
				favoriteCount = favoriteCount
			})
		end
	})
end)
