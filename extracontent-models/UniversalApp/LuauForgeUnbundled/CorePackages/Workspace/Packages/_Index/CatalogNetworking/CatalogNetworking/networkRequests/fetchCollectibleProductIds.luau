local HttpService = game:GetService("HttpService")

local buildApiSiteUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/SocialCommon").Utils.buildApiSiteUrl
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Dash")

local v5 = buildApiSiteUrl("apis") .. "/marketplace-items/v1/items/details"

local function fetchCollectibleProductIds(callback, p2)
	return callback(v5, "POST", {
		postBody = HttpService:JSONEncode({ itemIds = p2 })
	}):andThen(function(p3)
		return Dash.collectArray(p3.responseBody or {}, function(p4, data)
			if data.collectibleItemId and data.collectibleProductId then
				return {
					collectibleItemId = data.collectibleItemId,
					collectibleProductId = data.collectibleProductId,
					resaleProductId = data.lowestAvailableResaleProductId
				}
			end

			return nil
		end)
	end):catch(function(p3)
		warn("[CatalogNetworking] fetchCollectibleProductIds failed:", (tostring(p3)))
		return {}
	end)
end

return fetchCollectibleProductIds
