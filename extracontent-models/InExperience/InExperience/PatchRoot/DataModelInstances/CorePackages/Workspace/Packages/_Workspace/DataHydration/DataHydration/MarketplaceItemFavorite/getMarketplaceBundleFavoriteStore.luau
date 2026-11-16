local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Signals = require(parent.Signals)

local createMarketplaceItemFavoriteStore = require(script.Parent.createMarketplaceItemFavoriteStore)
local getMarketplaceBundleStore = require(DataHydration.MarketplaceBundle.getMarketplaceBundleStore)

return Signals.createComputed(function()
	return createMarketplaceItemFavoriteStore({
		itemType = "Bundle",
		getFavoriteCount = function(p: string)
			local data = getMarketplaceBundleStore(false).getMarketplaceBundleInfo(p).data(false)
			return if data then data.favoriteCount else nil
		end,
		setFavoriteCount = function(p: string, favoriteCount: number)
			getMarketplaceBundleStore(false).updateMarketplaceBundleInfo(p, {
				favoriteCount = favoriteCount
			})
		end
	})
end)
