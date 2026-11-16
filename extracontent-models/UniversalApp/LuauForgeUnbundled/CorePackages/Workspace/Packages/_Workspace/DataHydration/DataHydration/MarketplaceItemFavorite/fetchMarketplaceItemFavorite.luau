local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteStoreTypes")
local MarketplaceItemFavoriteUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteUrlBuilder")

local function fetchMarketplaceItemFavorite(p2, p3)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot fetch favorite status: missing or invalid local player ID"
		})
	end

	local favoriteUrl = MarketplaceItemFavoriteUrlBuilder.buildFavoriteUrl(tostring(localPlayerUserId), p2, p3)

	return HttpRequest.config({
		requestFunction = function(p4, p5, p6)
			return HttpRequest.requestFunctions.HttpRbxApi(p4, p5, p6)
		end
	})(favoriteUrl, "GET")
end

return fetchMarketplaceItemFavorite
