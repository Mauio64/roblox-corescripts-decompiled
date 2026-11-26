require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")

local CartIdService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Lib/CartIdService")

local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local getMarketplaceUnifiedAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedAssetType")
local getMarketplaceUnifiedBundleType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedBundleType")
local getWidgetAttributionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getWidgetAttributionFields")
local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local function appendMISPrefixToCartId(p2)
	return "MIS_" .. p2
end

return function(items, items2, data, data2, p2, surface, p3, p4)
	local itemIds = {}
	local total = 0
	local itemIds2 = {}

	local itemIds3 = {}
	local total2 = 0
	local itemIds4 = {}

	local result = {}

	local result2 = {}

	for k, item in items do
		if data and (data.lookAssetInfos[item.itemId] or data.lookBundleInfos[item.itemId]) then
			if data.lookAssetInfos[item.itemId] then
				table.insert(itemIds, item.itemId)

				total += item.priceInRobux
			elseif data.lookBundleInfos[item.itemId] then
				table.insert(itemIds2, item.itemId)

				total += item.priceInRobux
			end
		elseif data2 and (data2.lookAssetInfos[item.itemId] or data2.lookBundleInfos[item.itemId]) then
			if data2.lookAssetInfos[item.itemId] then
				table.insert(itemIds3, item.itemId)

				total2 += item.priceInRobux
			elseif data2.lookBundleInfos[item.itemId] then
				table.insert(itemIds4, item.itemId)

				total2 += item.priceInRobux
			end
		else
			local v5 = nil

			for k2, item2 in items2 do
				if item2.itemId == item.itemId and item2.itemType == item.itemType then
					v5 = item2
					break
				end
			end

			local v7 = {
				cartId = "MIS_" .. CartIdService.getCartId(),
				action = p2,
				itemId = item.itemId,
				itemType = 0,
				surface = 0,
				assetType = 0,
				bundleType = 0,
				widgetId = 0,
				widgetType = 0,
				widgetItemPrice = 0,
				organicItemPrice = 0,
				status = 0
			}
			local v8 = if item.itemType == "Asset" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET else UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
			v7.itemType = v8

			v7.surface = if fFlagAXUnifiedEventStrictPayloads then surface else nil
			local v10

			if item.itemType == "Asset" then
				v10 = if fFlagAXUnifiedEventStrictPayloads then getMarketplaceUnifiedAssetType(item.itemSubType) else item.itemSubType
			end

			v7.assetType = v10
			local v11

			if item.itemType == "Bundle" then
				v11 = if fFlagAXUnifiedEventStrictPayloads then getMarketplaceUnifiedBundleType(item.itemSubType) else item.itemSubType
			end

			v7.bundleType = v11

			local v12 = if v5.widgetInfo then v5.widgetInfo.widgetId else nil
			v7.widgetId = v12
			local v13 = if v5.widgetInfo then v5.widgetInfo.widgetType else nil
			v7.widgetType = v13
			local v14 = if v5.widgetInfo then item.priceInRobux else nil
			v7.widgetItemPrice = v14
			local v15 = if not v5.widgetInfo then item.priceInRobux else nil
			v7.organicItemPrice = v15
			v7.status = item.status
			table.insert(result, v7)

			local v16 = if fFlagAXUnifiedEventStrictPayloads then getWidgetAttributionFields(v5.widgetInfo) else nil

			if v16 then
				local v17 = #result
				local join = Cryo.Dictionary.join
				local v19 = if item.itemType == "Asset" then getMarketplaceUnifiedAssetType(item.itemSubType) else nil

				local v20 = if item.itemType == "Bundle" then getMarketplaceUnifiedBundleType(item.itemSubType) else nil
				result2[v17] = join(v16, {
					widgetAssetType = v19,
					widgetBundleType = v20
				})
			end
		end
	end

	if #itemIds > 0 or #itemIds2 > 0 then
		local v5 = not (#itemIds > 0) and "" or table.concat(itemIds, ",")
		local v6 = not (#itemIds2 > 0) and "" or table.concat(itemIds2, ",")
		local v7 = {
			cartId = "MIS_" .. CartIdService.getCartId(),
			action = p2,
			itemId = data.itemId,
			itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
			surface = if fFlagAXUnifiedEventStrictPayloads then surface else nil
		}

		if data.isOrganicLook then
			v7.organicAssetIds = v5
			v7.organicBundleIds = v6
			v7.organicItemPrice = total
		else
			v7.assetIds = v5
			v7.bundleIds = v6
			v7.widgetItemPrice = total
		end

		table.insert(result, v7)
		local v9 = if fFlagAXUnifiedEventStrictPayloads and not data.isOrganicLook then getWidgetAttributionFields(p3) else nil

		if v9 then
			result2[#result] = v9
		end
	end

	if not (#itemIds3 > 0 or #itemIds4 > 0) then
		return result, result2
	end

	local v5 = not (#itemIds3 > 0) and "" or table.concat(itemIds3, ",")
	local v6 = not (#itemIds4 > 0) and "" or table.concat(itemIds4, ",")
	local v7 = {
		cartId = "MIS_" .. CartIdService.getCartId(),
		action = p2,
		itemId = data2.itemId,
		itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
		surface = 0
	}

	if not fFlagAXUnifiedEventStrictPayloads then
		surface = nil
	end

	v7.surface = surface

	if data2.isOrganicLook then
		v7.organicAssetIds = v5
		v7.organicBundleIds = v6
		v7.organicItemPrice = total2
	else
		v7.assetIds = v5
		v7.bundleIds = v6
		v7.widgetItemPrice = total2
	end

	table.insert(result, v7)

	local v8 = if fFlagAXUnifiedEventStrictPayloads and not data2.isOrganicLook then getWidgetAttributionFields(p4) else nil

	if v8 then
		result2[#result] = v8
	end

	return result, result2
end
