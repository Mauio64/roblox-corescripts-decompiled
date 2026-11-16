local getTryOnItemReducerKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Utils.getTryOnItemReducerKey

local function mapPurchaseItemsResponse(p2)
	local v5 = {}

	for k, fulfillmentGroup in p2.fulfillmentGroups do
		for k2, lineItem in fulfillmentGroup.lineItems do
			local v6 = if lineItem.assetId then lineItem.assetId else lineItem.bundleId
			local name

			if lineItem.assetId then
				name = Enum.AvatarItemType.Asset.Name
			else
				name = Enum.AvatarItemType.Bundle.Name
			end

			if v6 and name then
				v5[getTryOnItemReducerKey(v6, name)] = {
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

	return { status = p2.status, lineItems = v5 }
end

return mapPurchaseItemsResponse
