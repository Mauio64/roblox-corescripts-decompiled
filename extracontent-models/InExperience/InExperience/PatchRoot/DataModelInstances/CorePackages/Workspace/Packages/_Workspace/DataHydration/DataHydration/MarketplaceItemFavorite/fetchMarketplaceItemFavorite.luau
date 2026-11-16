local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

require(script.Parent.MarketplaceItemFavoriteStoreTypes)
local MarketplaceItemFavoriteUrlBuilder = require(script.Parent.MarketplaceItemFavoriteUrlBuilder)

local function fetchMarketplaceItemFavorite(p, p2: string)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot fetch favorite status: missing or invalid local player ID"
		})
	end

	local favoriteUrl = MarketplaceItemFavoriteUrlBuilder.buildFavoriteUrl(tostring(localPlayerUserId), p, p2)

	return HttpRequest.config({
		requestFunction = function(p3: string, p4: string, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})(favoriteUrl, "GET")
end

return fetchMarketplaceItemFavorite
