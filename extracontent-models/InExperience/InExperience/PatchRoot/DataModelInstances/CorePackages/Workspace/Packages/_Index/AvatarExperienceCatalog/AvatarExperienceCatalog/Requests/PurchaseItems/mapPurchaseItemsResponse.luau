local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local function mapPurchaseItemsResponse(p)
	local lineItems = {}

	for _, fulfillmentGroup in p.fulfillmentGroups do
		for _, lineItem in fulfillmentGroup.lineItems do
			local v

			if lineItem.assetId then
				v = lineItem.assetId
			else
				v = lineItem.bundleId
			end

			local name

			if lineItem.assetId then
				name = Enum.AvatarItemType.Asset.Name
			else
				name = Enum.AvatarItemType.Bundle.Name
			end

			if v and name then
				lineItems[getTryOnItemReducerKey(v, name)] = {
					collectibleProductId = lineItem.collectibleProductId,
					agreedPriceRobux = lineItem.agreedPriceRobux,
					assetId = lineItem.assetId,
					bundleId = lineItem.bundleId,
					status = lineItem.status,
					errorReason = lineItem.errorReason
				}
			end
		end
	end

	return { status = p.status, lineItems = lineItems }
end

return mapPurchaseItemsResponse
