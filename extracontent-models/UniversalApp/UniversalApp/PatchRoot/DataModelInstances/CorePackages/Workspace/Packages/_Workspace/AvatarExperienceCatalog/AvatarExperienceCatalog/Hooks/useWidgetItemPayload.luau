local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)

require(Parent.AvatarExperienceCommon)

local function useWidgetItemPayload(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), Cryo (copy)
	return React.useMemo(function() -- line: 34
		-- upvalues: Cryo (copy), t1 (copy)
		return Cryo.Dictionary.join(t1.widgetAnalyticsInfo or {}, {
			action = t1.action,
			itemId = t1.itemId,
			itemType = t1.itemType,
			itemPosition = t1.itemPosition,
			gridPositionRow = t1.gridPositionRow,
			gridPositionColumn = t1.gridPositionColumn,
			uiTreatmentType = t1.uiTreatmentType,
			themeId = t1.themeId,
			category = t1.category,
			subcategory = t1.subcategory,
			taxonomyId = t1.taxonomyId,
			widgetItemPrice = t1.widgetItemPrice,
			widgetTimedOption = t1.widgetTimedOption,
			widgetAssetType = t1.widgetAssetType,
			widgetBundleType = t1.widgetBundleType,
			widgetLookType = t1.widgetLookType,
			assetIds = t1.assetIds,
			bundleIds = t1.bundleIds
		})
	end, {
		t1.action,
		t1.widgetAnalyticsInfo,
		t1.itemId,
		t1.itemType,
		t1.itemPosition,
		t1.gridPositionRow,
		t1.gridPositionColumn,
		t1.uiTreatmentType,
		t1.themeId,
		t1.category,
		t1.subcategory,
		t1.taxonomyId,
		t1.widgetItemPrice,
		t1.widgetTimedOption,
		t1.widgetAssetType,
		t1.widgetBundleType,
		t1.widgetLookType,
		t1.assetIds,
		t1.bundleIds
	})
end

return useWidgetItemPayload
