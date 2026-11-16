local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("CatalogNetworking").Parent

local SocialCommon = require(parent.SocialCommon)
local buildApiSiteUrl = SocialCommon.Utils.buildApiSiteUrl
local Dash = require(parent.Dash)

local v = buildApiSiteUrl("apis") .. "/marketplace-items/v1/items/details"

local function fetchCollectibleProductIds(callback, itemIds)
	return callback(v, "POST", {
		postBody = HttpService:JSONEncode({ itemIds = itemIds })
	}):andThen(function(p)
		return Dash.collectArray(p.responseBody or {}, function(_, data)
			if data.collectibleItemId and data.collectibleProductId then
				return {
					collectibleItemId = data.collectibleItemId,
					collectibleProductId = data.collectibleProductId,
					resaleProductId = data.lowestAvailableResaleProductId
				}
			end

			return nil
		end)
	end):catch(function(p)
		warn("[CatalogNetworking] fetchCollectibleProductIds failed:", (tostring(p)))
		return {}
	end)
end

return fetchCollectibleProductIds
