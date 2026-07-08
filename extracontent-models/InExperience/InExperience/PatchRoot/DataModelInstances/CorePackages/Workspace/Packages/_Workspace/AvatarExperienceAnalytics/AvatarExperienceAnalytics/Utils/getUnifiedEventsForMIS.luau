local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local CartIdService = require(AvatarExperienceAnalytics.Lib.CartIdService)
local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)

return function(p1, p2, p3, p4, p5) -- line: 13
	-- upvalues: CartIdService (copy), UnifiedEventLogEnums (copy)
	local n1 = 0
	local t1 = {}
	local t2 = {}
	local n2 = 0
	local t3 = {}
	local t4 = {}
	local t5 = {}

	for _, v17 in p1 do
		if p3 and (p3.lookAssetInfos[v17.itemId] or p3.lookBundleInfos[v17.itemId]) then
			if p3.lookAssetInfos[v17.itemId] then
				table.insert(t1, v17.itemId)
				n1 += v17.priceInRobux
			elseif p3.lookBundleInfos[v17.itemId] then
				table.insert(t2, v17.itemId)
				n1 += v17.priceInRobux
			end
		elseif p4 and (p4.lookAssetInfos[v17.itemId] or p4.lookBundleInfos[v17.itemId]) then
			if p4.lookAssetInfos[v17.itemId] then
				table.insert(t3, v17.itemId)
				n2 += v17.priceInRobux
			elseif p4.lookBundleInfos[v17.itemId] then
				table.insert(t4, v17.itemId)
				n2 += v17.priceInRobux
			end
		else
			local v18 = nil

			for _, v20 in p2 do
				if v20.itemId == v17.itemId and v20.itemType == v17.itemType then
					v18 = v20

					break
				end
			end

			table.insert(t5, {
				cartId = CartIdService.getCartId(),
				action = p5,
				itemId = v17.itemId,
				itemType = if v17.itemType ~= "Asset" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
				assetType = if v17.itemType ~= "Asset" then nil else v17.itemSubType,
				bundleType = if v17.itemType ~= "Bundle" then nil else v17.itemSubType,
				widgetId = if not v18.widgetInfo then nil else v18.widgetInfo.widgetId,
				widgetType = if not v18.widgetInfo then nil else v18.widgetInfo.widgetType,
				widgetItemPrice = if not v18.widgetInfo then nil else v17.priceInRobux,
				organicItemPrice = if not v18.widgetInfo then v17.priceInRobux else nil,
				status = v17.status
			})
		end
	end

	if #t1 > 0 or #t2 > 0 then
		local v21 = not (#t1 > 0) and "" or table.concat(t1, ",")
		local v22 = not (#t2 > 0) and "" or table.concat(t2, ",")
		local t6 = {
			cartId = CartIdService.getCartId(),
			action = p5,
			itemId = p3.itemId,
			itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
		}

		if p3.isOrganicLook then
			t6.organicAssetIds = v21
			t6.organicBundleIds = v22
			t6.organicItemPrice = n1
		else
			t6.assetIds = v21
			t6.bundleIds = v22
			t6.widgetItemPrice = n1
		end

		table.insert(t5, t6)
	end

	if #t3 > 0 or #t4 > 0 then
		local v24 = not (#t3 > 0) and "" or table.concat(t3, ",")
		local v25 = not (#t4 > 0) and "" or table.concat(t4, ",")
		local t7 = {
			cartId = CartIdService.getCartId(),
			action = p5,
			itemId = p4.itemId,
			itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
		}

		if p4.isOrganicLook then
			t7.organicAssetIds = v24
			t7.organicBundleIds = v25
			t7.organicItemPrice = n2
		else
			t7.assetIds = v24
			t7.bundleIds = v25
			t7.widgetItemPrice = n2
		end

		table.insert(t5, t7)
	end

	return t5
end
