local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
require(script.Parent.Generated.UnifiedEventTypes)
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType
local WidgetUiTreatment = UnifiedEventLogEnums.WidgetUiTreatment

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local sendAXCounterV2 = require(script.Parent.sendAXCounterV2)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local SharedFlags = require(parent.SharedFlags)
local FFlagAXFixHomeAvatarsUnifiedPurchase = SharedFlags.FFlagAXFixHomeAvatarsUnifiedPurchase
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags2.FFlagAXEnableUnifiedLoggingAvatarMoment
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventCounters = AvatarExperienceFlags2.FFlagAXUnifiedEventCounters

local defineFastFlag = game:DefineFastFlag("AXSendPurchaseAttempt", false)

local defineFastFlag2 = game:DefineFastFlag("AXUnifiedFilterWidgetLoadedAndUIImpression", false)
local defineFastFlag3 = game:DefineFastFlag("AXAlignUnifiedFilterSearchKeyword", false)

local enumItems = Enum.BundleType:GetEnumItems()
local v = { AssetTypeIdStringToName = {}, BundleTypeIdStringToName = {} }
local AXUnifiedEventFilter = {}

for _, enumItem in enumItems do
	v.BundleTypeIdStringToName[tostring(enumItem.Value)] = enumItem.Name
end

local enumItems2 = Enum.AvatarAssetType:GetEnumItems()

for _, enumItem in enumItems2 do
	v.AssetTypeIdStringToName[tostring(enumItem.Value)] = enumItem.Name
end

function AXUnifiedEventFilter.hasOrganicData(data): boolean
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

function AXUnifiedEventFilter.hasWidgetData(data): boolean
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

function AXUnifiedEventFilter.hasUiElementData(p): boolean
	return if p.elementName then true else false
end

function AXUnifiedEventFilter.hasItemId(p): boolean
	local action = p.action
	local itemId = p.itemId

	if FFlagAXEnableUnifiedLoggingAvatarMoment and action == MarketplaceUnifiedAction.PAGE_EXIT then
		return true
	end

	if
		action == MarketplaceUnifiedAction.UNDEFINED_ACTION
		or action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK
		or action == MarketplaceUnifiedAction.PAGE_VIEW
		or action == MarketplaceUnifiedAction.WIDGET_IMPRESSION
		or defineFastFlag2
		and (action == MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION or action == MarketplaceUnifiedAction.WIDGET_LOADED)
	then
		return true
	end

	return itemId ~= nil and itemId ~= ""
end

function AXUnifiedEventFilter.hasValidItemType(p): boolean
	local itemType = p.itemType

	if itemType ~= MarketplaceUnifiedItemType.UNDEFINED_ITEM_TYPE and itemType ~= nil then
		return itemType == MarketplaceUnifiedItemType.ASSET
			or itemType == MarketplaceUnifiedItemType.BUNDLE
			or itemType == MarketplaceUnifiedItemType.LOOK
	end

	local action = p.action

	if FFlagAXEnableUnifiedLoggingAvatarMoment and action == MarketplaceUnifiedAction.PAGE_EXIT then
		return true
	end

	if defineFastFlag2 then
		return action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK
			or action == MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION
			or action == MarketplaceUnifiedAction.PAGE_VIEW
			or action == MarketplaceUnifiedAction.WIDGET_IMPRESSION
			or action == MarketplaceUnifiedAction.WIDGET_LOADED
	end

	return action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK
		or action == MarketplaceUnifiedAction.PAGE_VIEW
		or action == MarketplaceUnifiedAction.WIDGET_IMPRESSION
end

function AXUnifiedEventFilter.hasValidAction(p): boolean
	local action = p.action
	return action ~= nil and action ~= MarketplaceUnifiedAction.UNDEFINED_ACTION
end

function AXUnifiedEventFilter.hasValidSurface(p): boolean
	local surface = p.surface
	return surface ~= nil and surface ~= UnifiedLoggingSurface.UNDEFINED_SURFACE
end

function AXUnifiedEventFilter.hasRequestIdForWidgetLog(p): boolean
	return not AXUnifiedEventFilter.hasWidgetData(p) or p.requestId ~= nil and p.requestId ~= ""
end

function AXUnifiedEventFilter.hasValidSizeAndPosition(data)
	local action = data.action

	if
		FFlagAXFixHomeAvatarsUnifiedPurchase
		and action == MarketplaceUnifiedAction.PURCHASE_SUCCESS
		and (data.surface == UnifiedLoggingSurface.DISCOVERY_HOMEPAGE or data.surface == UnifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS)
		or FFlagAXEnableUnifiedLoggingAvatarMoment
		and action == MarketplaceUnifiedAction.PURCHASE_SUCCESS
		and data.surface == UnifiedLoggingSurface.SHOP_AVATAR_MOMENT
	then
		return true
	end

	if
		action == MarketplaceUnifiedAction.ITEM_IMPRESSION
		or action == MarketplaceUnifiedAction.ITEM_SELECTED
		or action == MarketplaceUnifiedAction.ITEM_DESELECTED
		or action == MarketplaceUnifiedAction.PURCHASE_SUCCESS
	then
		local screenSizeWidth = data.screenSizeWidth or 0
		local screenSizeHeight = data.screenSizeHeight or 0
		local v2

		if screenSizeWidth > 0 then
			v2 = screenSizeHeight > 0
		else
			v2 = false
		end

		local elementSizeWidth = data.elementSizeWidth or 0
		local elementSizeHeight = data.elementSizeHeight or 0
		local v3

		if elementSizeWidth > 0 then
			v3 = elementSizeHeight > 0
		else
			v3 = false
		end

		local gridPositionRow = data.gridPositionRow or 0
		local gridPositionColumn = data.gridPositionColumn or 0
		local v4 = gridPositionRow > 0 and gridPositionColumn > 0
		return v2 and v3 and v4
	else
		if action ~= MarketplaceUnifiedAction.WIDGET_IMPRESSION then
			return true
		end

		local gridPositionRow = data.gridPositionRow or 0
		local gridPositionColumn = data.gridPositionColumn or 0
		return gridPositionRow > 0 and gridPositionColumn == 1
	end
end

function AXUnifiedEventFilter.hasValidFilter(data)
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
			data.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT
			or data.action == MarketplaceUnifiedAction.PURCHASE_SUCCESS
		then
			return true
		end

		return surface == UnifiedLoggingSurface.SEARCH_RESULTS or surface == UnifiedLoggingSurface.ITEM_DETAILS
	else
		local v2 = true

		if category == nil or category == "" then
			if not FFlagAXUnifiedImpressionsOnThumbnail then
				v2 = data.action == MarketplaceUnifiedAction.WIDGET_IMPRESSION
					or data.action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK
					or data.action == MarketplaceUnifiedAction.PAGE_VIEW
					or data.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT
					or FFlagAXEnableUnifiedLoggingAvatarMoment and data.action == MarketplaceUnifiedAction.PAGE_EXIT
			end
		elseif subcategory ~= nil and subcategory == "" then
			v2 = false
		end

		local v3

		if defineFastFlag3 or not keyword and surface ~= UnifiedLoggingSurface.SEARCH_RESULTS then
			v3 = true
		elseif surface == UnifiedLoggingSurface.SEARCH_RESULTS and keyword ~= nil then
			v3 = keyword ~= ""
		else
			v3 = false
		end

		local v4 = (not filterPriceMin or filterPriceMin == "") and (not filterPriceMax or filterPriceMax == "")
			or filterPrice == UnifiedEventLogEnums.FiltersPrice.PRICE_RANGE

		local v5 = not filterCreatorsName
			or filterCreatorsName == ""
			or filterCreators == UnifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME

		return v3 and v2 and v4 and v5
	end
end

local function isValidPrice(p): boolean -- 2 equivalent calls inferred from this helper
	local v2 = tonumber(p)
	return v2 ~= nil and v2 >= 0
end

function AXUnifiedEventFilter.hasValidEntityData(data)
	if
		data.surface == UnifiedLoggingSurface.CUSTOMIZE
		or defineFastFlag and data.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT
	then
		return true
	end

	local count = 0
	local organicData = AXUnifiedEventFilter.hasOrganicData(data)
	local widgetData = AXUnifiedEventFilter.hasWidgetData(data)
	local uiElementData = AXUnifiedEventFilter.hasUiElementData(data)

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
		local v2

		if FFlagAXUnifiedEventCounters then
			v2 = isValidPrice(data.organicItemPrice) -- inferred equivalent call
		elseif data.organicItemPrice == nil then
			v2 = false
		else
			v2 = data.organicItemPrice >= 0
		end

		if not v2 then
			return false
		end

		if data.itemType == MarketplaceUnifiedItemType.LOOK then
			if data.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT then
				return true
			end

			local v3 = data.organicAssetIds and data.organicAssetIds ~= "" and true or false
			local v4 = data.organicBundleIds and data.organicBundleIds ~= "" and true or false
			return v3 or v4
		else
			local v3 = data.assetType and v.AssetTypeIdStringToName[tostring(data.assetType)] ~= nil
			local v4 = data.bundleType and v.BundleTypeIdStringToName[tostring(data.bundleType)] ~= nil
			return if v3 or v4 then true else false
		end
	elseif widgetData then
		local v2

		if data.widgetId == nil then
			v2 = false
		else
			v2 = data.widgetId ~= ""
		end

		local v3

		if data.widgetType == nil then
			v3 = false
		else
			v3 = data.widgetType ~= ""
		end

		local v4 = data.widgetItemIds and data.widgetItemIds ~= "" and true or false

		local v5 = data.assetIds and data.assetIds ~= "" and true or false
		local v6 = data.bundleIds and data.bundleIds ~= "" and true or false

		local v7 = data.itemType ~= MarketplaceUnifiedItemType.LOOK
			or data.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT
			or (v5 or v6)

		local v8 = data.uiTreatmentType and data.uiTreatmentType ~= WidgetUiTreatment.UNKNOWN_WIDGET_UI and true
			or false

		local v9 = data.widgetType == "ThemedAvatarItemsWidget"
		local v10 = data.themeId ~= nil and data.themeId ~= ""
		local v11

		if FFlagAXUnifiedEventCounters then
			v11 = isValidPrice(data.widgetItemPrice) -- inferred equivalent call
		elseif data.widgetItemPrice == nil then
			v11 = false
		else
			v11 = data.widgetItemPrice >= 0
		end

		local v12 = data.action == MarketplaceUnifiedAction.WIDGET_IMPRESSION or v11

		return v2 and v3 and v4 and v7 and v8 and (not v9 or v10) and v12
	else
		return not not uiElementData and data.elementName ~= nil and data.elementName ~= ""
	end
end

function AXUnifiedEventFilter.filter(p, p2)
	local itemId = AXUnifiedEventFilter.hasItemId(p)
	local validItemType = AXUnifiedEventFilter.hasValidItemType(p)
	local validAction = AXUnifiedEventFilter.hasValidAction(p)
	local validSurface = AXUnifiedEventFilter.hasValidSurface(p)
	local requestIdForWidgetLog = AXUnifiedEventFilter.hasRequestIdForWidgetLog(p)
	local validSizeAndPosition = AXUnifiedEventFilter.hasValidSizeAndPosition(p)
	local validFilter = AXUnifiedEventFilter.hasValidFilter(p)
	local validEntityData = AXUnifiedEventFilter.hasValidEntityData(p)
	local v2 = itemId
		and validItemType
		and validAction
		and validSurface
		and requestIdForWidgetLog
		and validSizeAndPosition
		and validFilter
		and validEntityData

	if FFlagAXUnifiedEventCounters and p2 ~= nil and p2.skipReporting then
		return v2
	end

	if not v2 then
		local v3 = ""

		if not itemId then
			v3 ..= "hasItemId "
		end

		if not validItemType then
			v3 ..= "hasValidItemType "
		end

		if not validAction then
			v3 ..= "hasValidAction "
		end

		if not validSurface then
			v3 ..= "hasValidSurface "
		end

		if not requestIdForWidgetLog then
			v3 ..= "hasRequestIdForWidgetLog "
		end

		if not validSizeAndPosition then
			v3 ..= "hasValidSizeAndPosition "
		end

		if not validFilter then
			v3 ..= "hasValidFilter "
		end

		if not validEntityData then
			v3 ..= "hasValidEntityData "
		end

		if p.action == MarketplaceUnifiedAction.ITEM_IMPRESSION then
			warn("Failed to send unified impression event. Failing Check(s): " .. v3)
		elseif p.action == MarketplaceUnifiedAction.ITEM_SELECTED then
			warn("Failed to send unified click event. Failing Check(s): " .. v3)
		elseif p.action == MarketplaceUnifiedAction.PURCHASE_SUCCESS then
			warn("Failed to send unified purchase event. Failing Check(s): " .. v3)
		else
			warn("Failed to send unified event. Failing Check(s): " .. v3)
		end
	end

	sendAXCounterV2("AXUnifiedFilter", {
		success = tostring(v2),
		action = tostring(p.action or MarketplaceUnifiedAction.UNDEFINED_ACTION),
		surface = tostring(p.surface or UnifiedLoggingSurface.UNDEFINED_SURFACE),
		hasItemId = tostring(itemId),
		hasValidItemType = tostring(validItemType),
		hasValidAction = tostring(validAction),
		hasValidSurface = tostring(validSurface),
		hasRequestIdForWidgetLog = tostring(requestIdForWidgetLog),
		hasValidSizeAndPosition = tostring(validSizeAndPosition),
		hasValidFilter = tostring(validFilter),
		hasValidEntityData = tostring(validEntityData)
	})

	return v2
end

return AXUnifiedEventFilter
