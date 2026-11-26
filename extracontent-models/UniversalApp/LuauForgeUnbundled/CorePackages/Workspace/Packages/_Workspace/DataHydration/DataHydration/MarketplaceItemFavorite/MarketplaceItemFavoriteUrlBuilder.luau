local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteStoreTypes")

local url = Http.Url

local v5 = { Asset = "assets", Bundle = "bundles" }

local v6 = {
	Asset = "catalog/v1/favorites/users/assets/favorite",
	Bundle = "catalog/v1/favorites/users/bundles/favorite"
}

return {
	buildFavoriteUrl = function(p2, p3, p4)
		return urlBuilder.new({
			base = url.CATALOG_URL,
			path = "v1/favorites/users/{userId}/{itemPath}/{itemId}/favorite"
		})({ userId = p2, itemPath = v5[p3], itemId = p4 })
	end,
	getEndpointName = function(p2)
		return v6[p2]
	end
}
