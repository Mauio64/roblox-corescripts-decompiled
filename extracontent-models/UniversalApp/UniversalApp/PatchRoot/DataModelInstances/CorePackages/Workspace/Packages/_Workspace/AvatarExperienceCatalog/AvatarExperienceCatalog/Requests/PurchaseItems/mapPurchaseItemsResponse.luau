local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local getTryOnItemReducerKey = require(Parent.AvatarExperienceCommon).Utils.getTryOnItemReducerKey

require(script.Parent.PurchaseItemsTypes)

local function mapPurchaseItemsResponse(p1) -- line: 10
	-- upvalues: getTryOnItemReducerKey (copy)
	local t1 = {}

	for _, v7 in p1.fulfillmentGroups do
		for _, v9 in v7.lineItems do
			local v10 = if not v9.assetId then v9.bundleId else v9.assetId
			local v11 = if not v9.assetId then Enum.AvatarItemType.Bundle.Name else Enum.AvatarItemType.Asset.Name

			if v10 and v11 then
				t1[getTryOnItemReducerKey(v10, v11)] = {
					collectibleProductId = v9.collectibleProductId,
					agreedPriceRobux = v9.agreedPriceRobux,
					assetId = v9.assetId,
					bundleId = v9.bundleId,
					status = v9.status,
					errorReason = v9.errorReason
				}
			end
		end
	end

	return {
		status = p1.status,
		lineItems = t1
	}
end

return mapPurchaseItemsResponse
