local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

require(script.Parent.MarketplaceItemFavoriteStoreTypes)
local MarketplaceItemFavoriteUrlBuilder = require(script.Parent.MarketplaceItemFavoriteUrlBuilder)

local function requestMarketplaceItemFavoriteUpdate(p, p2: string, flag: boolean)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot update favorite status: missing or invalid local player ID"
		})
	end

	local favoriteUrl = MarketplaceItemFavoriteUrlBuilder.buildFavoriteUrl(tostring(localPlayerUserId), p, p2)

	local config = HttpRequest.config({
		requestFunction = function(p3: string, p4: string, p5)
			return HttpRequest.requestFunctions.RequestInternal(p3, p4, p5)
		end
	})
	local postBody

	if flag then
		postBody = HttpService:JSONEncode({})
	end

	return config(favoriteUrl, flag and "POST" or "DELETE", { postBody = postBody })
end

return requestMarketplaceItemFavoriteUpdate
