local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local marketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local marketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType
local widgetUiTreatment = UnifiedEventLogEnums.WidgetUiTreatment

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")

local fFlagAXUnifiedImpressionsOnThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXFixHomeAvatarsUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagAXFixHomeAvatarsUnifiedPurchase
local fFlagAXEnableUnifiedLoggingAvatarMoment = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagAXEnableUnifiedLoggingAvatarMoment
local fFlagAXUnifiedEventCounters = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventCounters

local defineFastFlag = game:DefineFastFlag("AXSendPurchaseAttempt", false)

local defineFastFlag2 = game:DefineFastFlag("AXUnifiedFilterWidgetLoadedAndUIImpression", false)
local defineFastFlag3 = game:DefineFastFlag("AXAlignUnifiedFilterSearchKeyword", false)

local enumItems = Enum.BundleType:GetEnumItems()
local v5 = { AssetTypeIdStringToName = {}, BundleTypeIdStringToName = {} }
local v6 = {}

for k, enumItem in enumItems do
	v5.BundleTypeIdStringToName[tostring(enumItem.Value)] = enumItem.Name
end

local enumItems2 = Enum.AvatarAssetType:GetEnumItems()

for k, enumItem in enumItems2 do
	v5.AssetTypeIdStringToName[tostring(enumItem.Value)] = enumItem.Name
end

function v6.hasOrganicData(data): boolean
	if
		data.assetType
		or data.bundleType
		or data.organicItemPrice
		or data.organicItemWearAfterPurchase
		or data.organicItemSaveToMyAvatars
		or data.organicAssetIds
		or data.organicBundleIds
	then
		return true
	end

	return false
end

function v6.hasWidgetData(data): boolean
	if
		data.widgetId
		or data.widgetType
		or data.assetIds
		or data.bundleIds
		or data.widgetItemIds
		or data.organicResultIds
		or data.widgetItemPrice
		or data.uiTreatmentType
		or data.themeId
		or data.widgetItemWearAfterPurchase
		or data.widgetItemSaveToMyAvatars
	then
		return true
	end

	return false
end

function v6.hasUiElementData(p2): boolean
	if p2.elementName then
		return true
	end

	return false
end

function v6.hasItemId(p2): boolean
	local action = p2.action
	local itemId = p2.itemId

	if fFlagAXEnableUnifiedLoggingAvatarMoment and action == marketplaceUnifiedAction.PAGE_EXIT then
		return true
	end

	if
		action == marketplaceUnifiedAction.UNDEFINED_ACTION
		or action == marketplaceUnifiedAction.UI_ELEMENT_CLICK
		or action == marketplaceUnifiedAction.PAGE_VIEW
		or action == marketplaceUnifiedAction.WIDGET_IMPRESSION
		or defineFastFlag2
		and (action == marketplaceUnifiedAction.UI_ELEMENT_IMPRESSION or action == marketplaceUnifiedAction.WIDGET_LOADED)
	then
		return true
	end

	return itemId ~= nil and itemId ~= ""
end

function v6.hasValidItemType(p2): boolean
	local itemType = p2.itemType

	if itemType ~= marketplaceUnifiedItemType.UNDEFINED_ITEM_TYPE and itemType ~= nil then
		return itemType == marketplaceUnifiedItemType.ASSET
			or itemType == marketplaceUnifiedItemType.BUNDLE
			or itemType == marketplaceUnifiedItemType.LOOK
	end

	local action = p2.action

	if fFlagAXEnableUnifiedLoggingAvatarMoment and action == marketplaceUnifiedAction.PAGE_EXIT then
		return true
	end

	if defineFastFlag2 then
		return action == marketplaceUnifiedAction.UI_ELEMENT_CLICK
			or action == marketplaceUnifiedAction.UI_ELEMENT_IMPRESSION
			or action == marketplaceUnifiedAction.PAGE_VIEW
			or action == marketplaceUnifiedAction.WIDGET_IMPRESSION
			or action == marketplaceUnifiedAction.WIDGET_LOADED
	end

	return action == marketplaceUnifiedAction.UI_ELEMENT_CLICK
		or action == marketplaceUnifiedAction.PAGE_VIEW
		or action == marketplaceUnifiedAction.WIDGET_IMPRESSION
end

function v6.hasValidAction(p2): boolean
	local action = p2.action
	return action ~= nil and action ~= marketplaceUnifiedAction.UNDEFINED_ACTION
end

function v6.hasValidSurface(p2): boolean
	local surface = p2.surface
	return surface ~= nil and surface ~= unifiedLoggingSurface.UNDEFINED_SURFACE
end

function v6.hasRequestIdForWidgetLog(p2): boolean
	if not v6.hasWidgetData(p2) then
		return true
	end

	return p2.requestId ~= nil and p2.requestId ~= ""
end

function v6.hasValidSizeAndPosition(data)
	local action = data.action

	if
		fFlagAXFixHomeAvatarsUnifiedPurchase
		and action == marketplaceUnifiedAction.PURCHASE_SUCCESS
		and (data.surface == unifiedLoggingSurface.DISCOVERY_HOMEPAGE or data.surface == unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS)
		or fFlagAXEnableUnifiedLoggingAvatarMoment
		and action == marketplaceUnifiedAction.PURCHASE_SUCCESS
		and data.surface == unifiedLoggingSurface.SHOP_AVATAR_MOMENT
	then
		return true
	end

	if
		action == marketplaceUnifiedAction.ITEM_IMPRESSION
		or action == marketplaceUnifiedAction.ITEM_SELECTED
		or action == marketplaceUnifiedAction.ITEM_DESELECTED
		or action == marketplaceUnifiedAction.PURCHASE_SUCCESS
	then
		local screenSizeWidth = data.screenSizeWidth or 0
		local screenSizeHeight = data.screenSizeHeight or 0
		local v7 = screenSizeWidth > 0 and screenSizeHeight > 0
		local elementSizeWidth = data.elementSizeWidth or 0
		local elementSizeHeight = data.elementSizeHeight or 0
		local v8 = elementSizeWidth > 0 and elementSizeHeight > 0
		local gridPositionRow = data.gridPositionRow or 0
		local gridPositionColumn = data.gridPositionColumn or 0
		local v9 = gridPositionRow > 0 and gridPositionColumn > 0
		return v7 and v8 and v9
	else
		if action ~= marketplaceUnifiedAction.WIDGET_IMPRESSION then
			return true
		end

		local gridPositionRow = data.gridPositionRow or 0
		local gridPositionColumn = data.gridPositionColumn or 0
		return gridPositionRow > 0 and gridPositionColumn == 1
	end
end

function v6.hasValidFilter(data)
	local surface = data.surface
	local keyword = data.keyword
	local category = data.category
	local subcategory = data.subcategory
	local filterPriceMin = data.filterPriceMin
	local filterPriceMax = data.filterPriceMax
	local filterPrice = data.filterPrice
	local filterCreatorsName = data.filterCreatorsName
	local filterCreators = data.filterCreators

	if defineFastFlag3 and keyword ~= nil then
		if keyword == "" then
			return false
		end

		if
			data.action == marketplaceUnifiedAction.PURCHASE_ATTEMPT
			or data.action == marketplaceUnifiedAction.PURCHASE_SUCCESS
		then
			return true
		end

		return surface == unifiedLoggingSurface.SEARCH_RESULTS
			or surface == unifiedLoggingSurface.ITEM_DETAILS
	else
		local v7 = true

		if category == nil or category == "" then
			if not fFlagAXUnifiedImpressionsOnThumbnail then
				v7 = data.action == marketplaceUnifiedAction.WIDGET_IMPRESSION
					or data.action == marketplaceUnifiedAction.UI_ELEMENT_CLICK
					or data.action == marketplaceUnifiedAction.PAGE_VIEW
					or data.action == marketplaceUnifiedAction.PURCHASE_ATTEMPT
					or fFlagAXEnableUnifiedLoggingAvatarMoment
					and data.action == marketplaceUnifiedAction.PAGE_EXIT
			end
		elseif subcategory ~= nil and subcategory == "" then
			v7 = false
		end

		local v8

		if defineFastFlag3 or not keyword and surface ~= unifiedLoggingSurface.SEARCH_RESULTS then
			v8 = true
		else
			v8 = surface == unifiedLoggingSurface.SEARCH_RESULTS and keyword ~= nil and keyword ~= ""
		end

		local v9 = (not filterPriceMin or filterPriceMin == "")
			and (not filterPriceMax or filterPriceMax == "")
			or filterPrice == UnifiedEventLogEnums.FiltersPrice.PRICE_RANGE

		local v10 = not filterCreatorsName
			or filterCreatorsName == ""
			or filterCreators == UnifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME

		return v8 and v7 and v9 and v10
	end
end

local function isValidPrice(p2): boolean
	local v7 = tonumber(p2)
	return v7 ~= nil and v7 >= 0
end

function v6.hasValidEntityData(data)
	if
		data.surface == unifiedLoggingSurface.CUSTOMIZE
		or defineFastFlag and data.action == marketplaceUnifiedAction.PURCHASE_ATTEMPT
	then
		return true
	end

	local count = 0
	local organicData = v6.hasOrganicData(data)
	local widgetData = v6.hasWidgetData(data)
	local uiElementData = v6.hasUiElementData(data)

	if organicData then
		count += 1
	end

	if widgetData then
		count += 1
	end

	if uiElementData then
		count += 1
	end

	if count ~= 1 then
		return false
	end

	if organicData then
		local v7

		if fFlagAXUnifiedEventCounters then
			local organicItemPrice = tonumber(data.organicItemPrice)
			v7 = not (organicItemPrice == nil) and organicItemPrice >= 0
		else
			v7 = not (data.organicItemPrice == nil) and data.organicItemPrice >= 0
		end

		if not v7 then
			return false
		end

		if data.itemType == marketplaceUnifiedItemType.LOOK then
			if data.action == marketplaceUnifiedAction.PURCHASE_ATTEMPT then
				return true
			end

			local v8 = data.organicAssetIds and data.organicAssetIds ~= "" and true or false
			local v9 = data.organicBundleIds and data.organicBundleIds ~= "" and true or false
			return v8 or v9
		else
			local v8 = data.assetType and v5.AssetTypeIdStringToName[tostring(data.assetType)] ~= nil
			local v9 = data.bundleType and v5.BundleTypeIdStringToName[tostring(data.bundleType)] ~= nil

			if v8 or v9 then
				return true
			end

			return false
		end
	elseif widgetData then
		local v7 = not (data.widgetId == nil) and data.widgetId ~= ""
		local v8 = not (data.widgetType == nil) and data.widgetType ~= ""
		local v9 = data.widgetItemIds and data.widgetItemIds ~= "" and true or false

		local v10 = data.assetIds and data.assetIds ~= "" and true or false
		local v11 = data.bundleIds and data.bundleIds ~= "" and true or false

		local v12 = data.itemType ~= marketplaceUnifiedItemType.LOOK
			or data.action == marketplaceUnifiedAction.PURCHASE_ATTEMPT
			or (v10 or v11)

		local v13 = data.uiTreatmentType
			and data.uiTreatmentType ~= widgetUiTreatment.UNKNOWN_WIDGET_UI
			and true
			or false

		local v14 = data.widgetType == "ThemedAvatarItemsWidget"
		local v15 = data.themeId ~= nil and data.themeId ~= ""
		local v17

		if fFlagAXUnifiedEventCounters then
			local widgetItemPrice = tonumber(data.widgetItemPrice)
			v17 = not (widgetItemPrice == nil) and widgetItemPrice >= 0
		else
			v17 = not (data.widgetItemPrice == nil) and data.widgetItemPrice >= 0
		end

		local v18 = data.action == marketplaceUnifiedAction.WIDGET_IMPRESSION or v17

		return v7 and v8 and v9 and v12 and v13 and (not v14 or v15) and v18
	else
		if not uiElementData then
			return false
		end

		return data.elementName ~= nil and data.elementName ~= ""
	end
end

function v6.filter(p2, p3)
	local itemId = v6.hasItemId(p2)
	local validItemType = v6.hasValidItemType(p2)
	local validAction = v6.hasValidAction(p2)
	local validSurface = v6.hasValidSurface(p2)
	local requestIdForWidgetLog = v6.hasRequestIdForWidgetLog(p2)
	local validSizeAndPosition = v6.hasValidSizeAndPosition(p2)
	local validFilter = v6.hasValidFilter(p2)
	local validEntityData = v6.hasValidEntityData(p2)
	local v7 = itemId
		and validItemType
		and validAction
		and validSurface
		and requestIdForWidgetLog
		and validSizeAndPosition
		and validFilter
		and validEntityData

	if fFlagAXUnifiedEventCounters and p3 ~= nil and p3.skipReporting then
		return v7
	end

	if not v7 then
		local v8 = ""

		if not itemId then
			v8 ..= "hasItemId "
		end

		if not validItemType then
			v8 ..= "hasValidItemType "
		end

		if not validAction then
			v8 ..= "hasValidAction "
		end

		if not validSurface then
			v8 ..= "hasValidSurface "
		end

		if not requestIdForWidgetLog then
			v8 ..= "hasRequestIdForWidgetLog "
		end

		if not validSizeAndPosition then
			v8 ..= "hasValidSizeAndPosition "
		end

		if not validFilter then
			v8 ..= "hasValidFilter "
		end

		if not validEntityData then
			v8 ..= "hasValidEntityData "
		end

		if p2.action == marketplaceUnifiedAction.ITEM_IMPRESSION then
			warn("Failed to send unified impression event. Failing Check(s): " .. v8)
		elseif p2.action == marketplaceUnifiedAction.ITEM_SELECTED then
			warn("Failed to send unified click event. Failing Check(s): " .. v8)
		elseif p2.action == marketplaceUnifiedAction.PURCHASE_SUCCESS then
			warn("Failed to send unified purchase event. Failing Check(s): " .. v8)
		else
			warn("Failed to send unified event. Failing Check(s): " .. v8)
		end
	end

	sendAXCounterV2("AXUnifiedFilter", {
		success = tostring(v7),
		action = tostring(p2.action or marketplaceUnifiedAction.UNDEFINED_ACTION),
		surface = tostring(p2.surface or unifiedLoggingSurface.UNDEFINED_SURFACE),
		hasItemId = tostring(itemId),
		hasValidItemType = tostring(validItemType),
		hasValidAction = tostring(validAction),
		hasValidSurface = tostring(validSurface),
		hasRequestIdForWidgetLog = tostring(requestIdForWidgetLog),
		hasValidSizeAndPosition = tostring(validSizeAndPosition),
		hasValidFilter = tostring(validFilter),
		hasValidEntityData = tostring(validEntityData)
	})

	return v7
end

return v6
