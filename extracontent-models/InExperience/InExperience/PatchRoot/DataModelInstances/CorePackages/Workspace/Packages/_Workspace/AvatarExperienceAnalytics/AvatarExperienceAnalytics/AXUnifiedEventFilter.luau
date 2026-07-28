local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType
local WidgetUiTreatment = UnifiedEventLogEnums.WidgetUiTreatment
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local sendAXCounterV2 = require(script.Parent.sendAXCounterV2)
local FFlagAXUnifiedImpressionsOnThumbnail = require(Parent.AvatarExperienceFlags).FFlagAXUnifiedImpressionsOnThumbnail
local v9 = game:DefineFastFlag("AXSendPurchaseAttempt", false)
local v10 = game:DefineFastFlag("AXUnifiedFilterWidgetLoadedAndUIImpression", false)
local t1 = {}
local t2 = {
	AssetTypeIdStringToName = {},
	BundleTypeIdStringToName = {}
}

for _, v14 in (Enum.BundleType:GetEnumItems()) do
	t2.BundleTypeIdStringToName[tostring(v14.Value)] = v14.Name
end

for _, v16 in (Enum.AvatarAssetType:GetEnumItems()) do
	t2.AssetTypeIdStringToName[tostring(v16.Value)] = v16.Name
end

function t1.hasOrganicData(t3: {[any]: any}) -- line: 107
	if t3.assetType or (t3.bundleType or t3.organicItemPrice or t3.organicItemWearAfterPurchase or t3.organicItemSaveToMyAvatars or t3.organicAssetIds or t3.organicBundleIds) then
		return true
	end

	return false
end
function t1.hasWidgetData(t4: {[any]: any}) -- line: 123
	if t4.widgetId or (t4.widgetType or t4.assetIds or t4.bundleIds or t4.widgetItemIds or t4.organicResultIds or t4.widgetItemPrice or t4.uiTreatmentType or t4.themeId or t4.widgetItemWearAfterPurchase or t4.widgetItemSaveToMyAvatars) then
		return true
	end

	return false
end
function t1.hasUiElementData(t5: {[any]: any}) -- line: 144
	if t5.elementName then
		return true
	end

	return false
end
function t1.hasItemId(t6: {[any]: any}) -- line: 152
	-- upvalues: MarketplaceUnifiedAction (copy), v10 (copy)
	local action = t6.action
	local itemId = t6.itemId

	if action == MarketplaceUnifiedAction.UNDEFINED_ACTION or (action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK or action == MarketplaceUnifiedAction.WIDGET_IMPRESSION) or v10 and (action == MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION or action == MarketplaceUnifiedAction.WIDGET_LOADED) then
		return true
	end

	return itemId ~= nil and itemId ~= ""
end
function t1.hasValidItemType(t7: {[any]: any}) -- line: 175
	-- upvalues: MarketplaceUnifiedItemType (copy), v10 (copy), MarketplaceUnifiedAction (copy)
	local itemType = t7.itemType

	if itemType == MarketplaceUnifiedItemType.UNDEFINED_ITEM_TYPE or itemType == nil then
		local action = t7.action

		if v10 then
			return action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK or (action == MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION or (action == MarketplaceUnifiedAction.WIDGET_IMPRESSION or action == MarketplaceUnifiedAction.WIDGET_LOADED))
		end

		return action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK or action == MarketplaceUnifiedAction.WIDGET_IMPRESSION
	end

	return itemType == MarketplaceUnifiedItemType.ASSET or (itemType == MarketplaceUnifiedItemType.BUNDLE or itemType == MarketplaceUnifiedItemType.LOOK)
end
function t1.hasValidAction(t8: {[any]: any}) -- line: 196
	-- upvalues: MarketplaceUnifiedAction (copy)
	local action = t8.action

	return action ~= nil and action ~= MarketplaceUnifiedAction.UNDEFINED_ACTION
end
function t1.hasValidSurface(t9: {[any]: any}) -- line: 201
	-- upvalues: UnifiedLoggingSurface (copy)
	local surface = t9.surface

	return surface ~= nil and surface ~= UnifiedLoggingSurface.UNDEFINED_SURFACE
end
function t1.hasRequestIdForWidgetLog(t10: {[any]: any}) -- line: 206
	-- upvalues: t1 (copy)
	if t1.hasWidgetData(t10) then
		return t10.requestId ~= nil and t10.requestId ~= ""
	end

	return true
end
function t1.hasValidSizeAndPosition(t11: {[any]: any}) -- line: 216
	-- upvalues: MarketplaceUnifiedAction (copy)
	local action = t11.action

	if action == MarketplaceUnifiedAction.ITEM_IMPRESSION or (action == MarketplaceUnifiedAction.ITEM_SELECTED or action == MarketplaceUnifiedAction.ITEM_DESELECTED or action == MarketplaceUnifiedAction.PURCHASE_SUCCESS) then
		local v33 = t11.screenSizeWidth or 0
		local v34 = t11.screenSizeHeight or 0
		local v35 = v33 > 0 and v34 > 0
		local v36 = t11.elementSizeWidth or 0
		local v37 = t11.elementSizeHeight or 0
		local v38 = v36 > 0 and v37 > 0
		local v39 = t11.gridPositionRow or 0
		local v40 = t11.gridPositionColumn or 0
		local v41 = v39 > 0 and v40 > 0

		return v35 and (v38 and v41)
	end

	if action == MarketplaceUnifiedAction.WIDGET_IMPRESSION then
		local v42 = t11.gridPositionRow or 0
		local v43 = t11.gridPositionColumn or 0

		return v42 > 0 and v43 == 1
	end

	return true
end
function t1.hasValidFilter(t12: {[any]: any}) -- line: 251
	-- upvalues: FFlagAXUnifiedImpressionsOnThumbnail (copy), MarketplaceUnifiedAction (copy), UnifiedLoggingSurface (copy), UnifiedEventLogEnums (copy)
	local surface = t12.surface
	local keyword = t12.keyword
	local category = t12.category
	local subcategory = t12.subcategory
	local filterPriceMin = t12.filterPriceMin
	local filterPriceMax = t12.filterPriceMax
	local filterPrice = t12.filterPrice
	local filterCreatorsName = t12.filterCreatorsName
	local filterCreators = t12.filterCreators
	local v54 = true

	if category ~= nil and category ~= "" then
		if subcategory ~= nil and subcategory == "" then
			v54 = false
		end
	elseif not FFlagAXUnifiedImpressionsOnThumbnail then
		v54 = t12.action == MarketplaceUnifiedAction.WIDGET_IMPRESSION or (t12.action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK or t12.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT)
	end

	local v55 = true

	if keyword or surface == UnifiedLoggingSurface.SEARCH_RESULTS then
		v55 = surface == UnifiedLoggingSurface.SEARCH_RESULTS and (keyword ~= nil and keyword ~= "")
	end

	local v56 = true

	if filterPriceMin and filterPriceMin ~= "" or filterPriceMax and filterPriceMax ~= "" then
		v56 = filterPrice == UnifiedEventLogEnums.FiltersPrice.PRICE_RANGE
	end

	local v57 = true

	if filterCreatorsName and filterCreatorsName ~= "" then
		v57 = filterCreators == UnifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME
	end

	return v55 and (v54 and (v56 and v57))
end
function t1.hasValidEntityData(t13: {[any]: any}) -- line: 297
	-- upvalues: UnifiedLoggingSurface (copy), v9 (copy), MarketplaceUnifiedAction (copy), t1 (copy), MarketplaceUnifiedItemType (copy), t2 (copy), WidgetUiTreatment (copy)
	if t13.surface == UnifiedLoggingSurface.CUSTOMIZE then
		return true
	end

	if v9 and t13.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT then
		return true
	end

	local n1 = 0
	local v60 = t1.hasOrganicData(t13)
	local v61 = t1.hasWidgetData(t13)
	local v62 = t1.hasUiElementData(t13)

	if v60 then
		n1 += 1
	end

	if v61 then
		n1 += 1
	end

	if v62 then
		n1 += 1
	end

	if n1 ~= 1 then
		return false
	end

	if v60 then
		if t13.organicItemPrice == nil or not (t13.organicItemPrice >= 0) then
			return false
		end

		if t13.itemType == MarketplaceUnifiedItemType.LOOK then
			if t13.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT then
				return true
			end

			local v63 = not not t13.organicAssetIds and (t13.organicAssetIds ~= "" or false)
			local v64 = not not t13.organicBundleIds and (t13.organicBundleIds ~= "" or false)

			return v63 or v64
		end

		local v65 = t13.assetType and t2.AssetTypeIdStringToName[tostring(t13.assetType)] ~= nil
		local v66 = t13.bundleType and t2.BundleTypeIdStringToName[tostring(t13.bundleType)] ~= nil

		if not v65 and not v66 then
			return false
		end

		return true
	end

	if v61 then
		local v67 = t13.widgetId ~= nil and t13.widgetId ~= ""
		local v68 = t13.widgetType ~= nil and t13.widgetType ~= ""
		local v69 = not not t13.widgetItemIds and (t13.widgetItemIds ~= "" or false)
		local v70 = not not t13.assetIds and (t13.assetIds ~= "" or false)
		local v71 = not not t13.bundleIds and (t13.bundleIds ~= "" or false)
		local v72 = t13.itemType ~= MarketplaceUnifiedItemType.LOOK or (t13.action == MarketplaceUnifiedAction.PURCHASE_ATTEMPT or (v70 or v71))
		local v73 = not not t13.uiTreatmentType and (t13.uiTreatmentType ~= WidgetUiTreatment.UNKNOWN_WIDGET_UI or false)
		local v74 = t13.widgetType == "ThemedAvatarItemsWidget"
		local v75 = t13.themeId ~= nil and t13.themeId ~= ""
		local v76 = not v74 or v75
		local v77 = t13.widgetItemPrice ~= nil and t13.widgetItemPrice >= 0

		if t13.action == MarketplaceUnifiedAction.WIDGET_IMPRESSION then
			v77 = true
		end

		return v67 and (v68 and (v69 and (v72 and (v73 and (v76 and v77)))))
	end

	if v62 then
		return t13.elementName ~= nil and t13.elementName ~= ""
	end

	return false
end
function t1.filter(p1) -- line: 407
	-- upvalues: t1 (copy), MarketplaceUnifiedAction (copy), sendAXCounterV2 (copy), UnifiedLoggingSurface (copy)
	local v79 = t1.hasItemId(p1)
	local v80 = t1.hasValidItemType(p1)
	local v81 = t1.hasValidAction(p1)
	local v82 = t1.hasValidSurface(p1)
	local v83 = t1.hasRequestIdForWidgetLog(p1)
	local v84 = t1.hasValidSizeAndPosition(p1)
	local v85 = t1.hasValidFilter(p1)
	local v86 = t1.hasValidEntityData(p1)
	local v87 = v79 and (v80 and (v81 and (v82 and (v83 and (v84 and (v85 and v86))))))

	if not v87 then
		local s1 = ""

		if not v79 then
			s1 ..= "hasItemId "
		end

		if not v80 then
			s1 ..= "hasValidItemType "
		end

		if not v81 then
			s1 ..= "hasValidAction "
		end

		if not v82 then
			s1 ..= "hasValidSurface "
		end

		if not v83 then
			s1 ..= "hasRequestIdForWidgetLog "
		end

		if not v84 then
			s1 ..= "hasValidSizeAndPosition "
		end

		if not v85 then
			s1 ..= "hasValidFilter "
		end

		if not v86 then
			s1 ..= "hasValidEntityData "
		end

		if p1.action == MarketplaceUnifiedAction.ITEM_IMPRESSION then
			warn("Failed to send unified impression event. Failing Check(s): " .. s1)
		elseif p1.action == MarketplaceUnifiedAction.ITEM_SELECTED then
			warn("Failed to send unified click event. Failing Check(s): " .. s1)
		elseif p1.action == MarketplaceUnifiedAction.PURCHASE_SUCCESS then
			warn("Failed to send unified purchase event. Failing Check(s): " .. s1)
		else
			warn("Failed to send unified event. Failing Check(s): " .. s1)
		end
	end

	sendAXCounterV2("AXUnifiedFilter", {
		success = tostring(v87),
		action = tostring(p1.action or MarketplaceUnifiedAction.UNDEFINED_ACTION),
		surface = tostring(p1.surface or UnifiedLoggingSurface.UNDEFINED_SURFACE),
		hasItemId = tostring(v79),
		hasValidItemType = tostring(v80),
		hasValidAction = tostring(v81),
		hasValidSurface = tostring(v82),
		hasRequestIdForWidgetLog = tostring(v83),
		hasValidSizeAndPosition = tostring(v84),
		hasValidFilter = tostring(v85),
		hasValidEntityData = tostring(v86)
	})

	return v87
end

return t1
