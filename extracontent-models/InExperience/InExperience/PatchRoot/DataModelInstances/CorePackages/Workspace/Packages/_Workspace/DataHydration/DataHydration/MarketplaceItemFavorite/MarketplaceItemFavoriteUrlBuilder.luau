local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
require(script.Parent.MarketplaceItemFavoriteStoreTypes)

local Url = Http.Url

local v = { Asset = "assets", Bundle = "bundles" }

local v2 = {
	Asset = "catalog/v1/favorites/users/assets/favorite",
	Bundle = "catalog/v1/favorites/users/bundles/favorite"
}
local MarketplaceItemFavoriteUrlBuilder = {}

function MarketplaceItemFavoriteUrlBuilder.buildFavoriteUrl(userId: string, p, itemId: string)
	return urlBuilder.new({
		base = Url.CATALOG_URL,
		path = "v1/favorites/users/{userId}/{itemPath}/{itemId}/favorite"
	})({ userId = userId, itemPath = v[p], itemId = itemId })
end

function MarketplaceItemFavoriteUrlBuilder.getEndpointName(p)
	return v2[p]
end

return MarketplaceItemFavoriteUrlBuilder
