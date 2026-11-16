local HttpService = game:GetService("HttpService")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteStoreTypes")
local MarketplaceItemFavoriteUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteUrlBuilder")

local function requestMarketplaceItemFavoriteUpdate(p2, p3, p4)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot update favorite status: missing or invalid local player ID"
		})
	end

	local favoriteUrl = MarketplaceItemFavoriteUrlBuilder.buildFavoriteUrl(tostring(localPlayerUserId), p2, p3)

	local config = HttpRequest.config({
		requestFunction = function(p5, p6, p7)
			return HttpRequest.requestFunctions.RequestInternal(p5, p6, p7)
		end
	})

	local v7 = if p4 then HttpService:JSONEncode({}) else nil
	return config(favoriteUrl, p4 and "POST" or "DELETE", { postBody = v7 })
end

return requestMarketplaceItemFavoriteUpdate
