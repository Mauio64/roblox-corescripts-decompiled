local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

require(parent.AvatarExperienceCommon)
local Cryo = require(parent.Cryo)

local CartIdService = require(AvatarExperienceAnalytics.Lib.CartIdService)

local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)
local getMarketplaceUnifiedAssetType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType)
local getMarketplaceUnifiedBundleType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType)
local getWidgetAttributionFields = require(AvatarExperienceAnalytics.Utils.getWidgetAttributionFields)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function appendMISPrefixToCartId(p: string) -- 3 equivalent calls inferred from this helper
	return "MIS_" .. p
end

return function(items, items2, data, data2, action, surface: number?, p, p2)
	local itemIds = {}
	local total = 0
	local itemIds2 = {}

	local itemIds3 = {}
	local total2 = 0
	local itemIds4 = {}

	local result = {}

	local result2 = {}

	for _, item in items do
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
			local v = nil

			for _, item2 in items2 do
				if item2.itemId == item.itemId and item2.itemType == item.itemType then
					v = item2
					break
				end
			end

			local v2 = {
				cartId = appendMISPrefixToCartId(CartIdService.getCartId()), -- inferred equivalent call
				action = action,
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
			local itemType

			if item.itemType == "Asset" then
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
			else
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
			end

			v2.itemType = itemType
			local surface2

			if FFlagAXUnifiedEventStrictPayloads then
				surface2 = surface
			end

			v2.surface = surface2
			local assetType

			if item.itemType == "Asset" then
				if FFlagAXUnifiedEventStrictPayloads then
					assetType = getMarketplaceUnifiedAssetType(item.itemSubType)
				else
					assetType = item.itemSubType
				end
			end

			v2.assetType = assetType
			local bundleType

			if item.itemType == "Bundle" then
				if FFlagAXUnifiedEventStrictPayloads then
					bundleType = getMarketplaceUnifiedBundleType(item.itemSubType)
				else
					bundleType = item.itemSubType
				end
			end

			v2.bundleType = bundleType
			local widgetId

			if v.widgetInfo then
				widgetId = v.widgetInfo.widgetId
			end

			v2.widgetId = widgetId
			local widgetType

			if v.widgetInfo then
				widgetType = v.widgetInfo.widgetType
			end

			v2.widgetType = widgetType
			local widgetItemPrice

			if v.widgetInfo then
				widgetItemPrice = item.priceInRobux
			end

			v2.widgetItemPrice = widgetItemPrice
			local organicItemPrice

			if not v.widgetInfo then
				organicItemPrice = item.priceInRobux
			end

			v2.organicItemPrice = organicItemPrice
			v2.status = item.status
			table.insert(result, v2)
			local v3

			if FFlagAXUnifiedEventStrictPayloads then
				v3 = getWidgetAttributionFields(v.widgetInfo)
			end

			if v3 then
				local v4 = #result
				local join = Cryo.Dictionary.join
				local widgetAssetType

				if item.itemType == "Asset" then
					widgetAssetType = getMarketplaceUnifiedAssetType(item.itemSubType)
				end

				local widgetBundleType

				if item.itemType == "Bundle" then
					widgetBundleType = getMarketplaceUnifiedBundleType(item.itemSubType)
				end

				result2[v4] = join(v3, {
					widgetAssetType = widgetAssetType,
					widgetBundleType = widgetBundleType
				})
			end
		end
	end

	if #itemIds > 0 or #itemIds2 > 0 then
		local v = not (#itemIds > 0) and "" or table.concat(itemIds, ",")
		local v2 = not (#itemIds2 > 0) and "" or table.concat(itemIds2, ",")

		local v3 = {
			cartId = appendMISPrefixToCartId(CartIdService.getCartId()), -- inferred equivalent call
			action = action,
			itemId = data.itemId,
			itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
			surface = 0
		}
		local surface2

		if FFlagAXUnifiedEventStrictPayloads then
			surface2 = surface
		end

		v3.surface = surface2

		if data.isOrganicLook then
			v3.organicAssetIds = v
			v3.organicBundleIds = v2
			v3.organicItemPrice = total
		else
			v3.assetIds = v
			v3.bundleIds = v2
			v3.widgetItemPrice = total
		end

		table.insert(result, v3)
		local v4

		if FFlagAXUnifiedEventStrictPayloads and not data.isOrganicLook then
			v4 = getWidgetAttributionFields(p)
		end

		if v4 then
			result2[#result] = v4
		end
	end

	if not (#itemIds3 > 0 or #itemIds4 > 0) then
		return result, result2
	end

	local v = not (#itemIds3 > 0) and "" or table.concat(itemIds3, ",")
	local v2 = not (#itemIds4 > 0) and "" or table.concat(itemIds4, ",")

	local v3 = {
		cartId = appendMISPrefixToCartId(CartIdService.getCartId()), -- inferred equivalent call
		action = action,
		itemId = data2.itemId,
		itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
		surface = 0
	}

	if not FFlagAXUnifiedEventStrictPayloads then
		surface = nil
	end

	v3.surface = surface

	if data2.isOrganicLook then
		v3.organicAssetIds = v
		v3.organicBundleIds = v2
		v3.organicItemPrice = total2
	else
		v3.assetIds = v
		v3.bundleIds = v2
		v3.widgetItemPrice = total2
	end

	table.insert(result, v3)
	local v4

	if FFlagAXUnifiedEventStrictPayloads and not data2.isOrganicLook then
		v4 = getWidgetAttributionFields(p2)
	end

	if v4 then
		result2[#result] = v4
	end

	return result, result2
end
