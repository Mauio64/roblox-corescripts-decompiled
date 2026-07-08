local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("CatalogNetworking").Parent
local buildApiSiteUrl = require(Parent.SocialCommon).Utils.buildApiSiteUrl
local Dash = require(Parent.Dash)
local v5 = buildApiSiteUrl("apis") .. "/marketplace-items/v1/items/details"

local function fetchCollectibleProductIds(p1, t1: {[any]: any}) -- line: 11
	-- upvalues: HttpService (copy), v5 (copy), Dash (copy)
	local json = HttpService:JSONEncode({
		itemIds = t1
	})

	return p1(v5, "POST", {
		postBody = json
	}):andThen(function(p2) -- line: 14
		-- upvalues: Dash (copy)
		return Dash.collectArray(p2.responseBody or {}, function(_, p4) -- line: 15
			if p4.collectibleItemId and p4.collectibleProductId then
				return {
					collectibleItemId = p4.collectibleItemId,
					collectibleProductId = p4.collectibleProductId,
					resaleProductId = p4.lowestAvailableResaleProductId
				}
			end

			return nil
		end)
	end):catch(function(p5) -- line: 26
		warn("[CatalogNetworking] fetchCollectibleProductIds failed:", (tostring(p5)))

		return {}
	end)
end

return fetchCollectibleProductIds
