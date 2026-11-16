local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
require(parent.AppCommonLib)

require(parent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

local SeenImpressionsStore = AvatarExperienceAnalytics.Store.SeenImpressionsStore
local Category = SeenImpressionsStore.Category

local useOnRequestImpressionsSignal = require(AvatarExperienceCatalog.Components.Hooks.useOnRequestImpressionsSignal)

local function useWidgetItemImpressions(data)
	local onRequestImpressionsSignal = useOnRequestImpressionsSignal()

	local widgetId = data.widgetId
	local content = data.content
	local widgetRow = data.widgetRow
	local itemsPerRow = data.itemsPerRow
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local uiTreatmentType = data.uiTreatmentType
	local reportItemImpression = data.reportItemImpression
	local buildItemImpressionInfo = data.buildItemImpressionInfo

	return {
		onRequestImpressionsSignal = onRequestImpressionsSignal,
		onImpressionsDetected = React.useCallback(function(items)
			for _, item in items do
				local v = widgetId .. "_" .. item

				if SeenImpressionsStore.hasSeen(Category.WidgetItems, v) then
					continue
				end

				local v2 = content[item] or {}
				local v3

				if buildItemImpressionInfo then
					v3 = buildItemImpressionInfo(v2, item)
				else
					local itemId

					if v2.id ~= nil then
						itemId = tostring(v2.id)
					end

					v3 = Cryo.Dictionary.join(widgetAnalyticsInfo, {
						widgetPosition = widgetRow,
						widgetId = widgetId,
						itemPosition = item,
						itemId = itemId,
						itemType = v2.type,
						widgetAbsPosition = (widgetRow - 1) * itemsPerRow,
						uiTreatmentType = uiTreatmentType
					})
				end

				reportItemImpression(v3)
				SeenImpressionsStore.markSeen(Category.WidgetItems, v)
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
	}
end

return useWidgetItemImpressions
