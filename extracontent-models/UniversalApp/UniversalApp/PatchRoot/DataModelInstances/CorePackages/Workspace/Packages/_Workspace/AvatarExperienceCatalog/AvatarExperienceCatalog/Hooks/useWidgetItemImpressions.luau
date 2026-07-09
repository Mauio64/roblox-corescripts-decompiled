local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)

require(AvatarExperienceCatalogParent.AppCommonLib)
require(AvatarExperienceCatalogParent.AvatarExperienceCommon)

local SeenImpressionsStore = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics).Store.SeenImpressionsStore
local Category = SeenImpressionsStore.Category
local useOnRequestImpressionsSignal = require(AvatarExperienceCatalog.Components.Hooks.useOnRequestImpressionsSignal)

local function useWidgetItemImpressions(t1: {[any]: any}) -- line: 61
	-- upvalues: useOnRequestImpressionsSignal (copy), React (copy), SeenImpressionsStore (copy), Category (copy), Cryo (copy)
	local v10 = useOnRequestImpressionsSignal()
	local widgetId = t1.widgetId
	local content = t1.content
	local widgetRow = t1.widgetRow
	local itemsPerRow = t1.itemsPerRow
	local widgetAnalyticsInfo = t1.widgetAnalyticsInfo
	local uiTreatmentType = t1.uiTreatmentType
	local reportItemImpression = t1.reportItemImpression
	local buildItemImpressionInfo = t1.buildItemImpressionInfo
	local v19 = React.useCallback(function(t2: {[any]: any}) -- line: 74
		-- upvalues: widgetId (copy), SeenImpressionsStore (copy), Category (copy), content (copy), buildItemImpressionInfo (copy), Cryo (copy), widgetAnalyticsInfo (copy), widgetRow (copy), itemsPerRow (copy), uiTreatmentType (copy), reportItemImpression (copy)
		for _, v22 in t2 do
			local v23 = widgetId .. "_" .. v22

			if not SeenImpressionsStore.hasSeen(Category.WidgetItems, v23) then
				local v24 = content[v22] or {}
				local v25

				if buildItemImpressionInfo then
					v25 = buildItemImpressionInfo(v24, v22)
				else
					local v26 = if v24.id == nil then nil else tostring(v24.id)

					v25 = Cryo.Dictionary.join(widgetAnalyticsInfo, {
						widgetPosition = widgetRow,
						widgetId = widgetId,
						itemPosition = v22,
						itemId = v26,
						itemType = v24.type,
						widgetAbsPosition = (widgetRow - 1) * itemsPerRow,
						uiTreatmentType = uiTreatmentType
					})
				end

				reportItemImpression(v25)
				SeenImpressionsStore.markSeen(Category.WidgetItems, v23)
			end
		end
	end, {
		widgetId,
		content,
		widgetRow,
		itemsPerRow,
		widgetAnalyticsInfo,
		uiTreatmentType,
		reportItemImpression,
		buildItemImpressionInfo
	})

	return {
		onRequestImpressionsSignal = v10,
		onImpressionsDetected = v19
	}
end

return useWidgetItemImpressions
