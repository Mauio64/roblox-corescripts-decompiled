local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local seenImpressionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").Store.SeenImpressionsStore
local category = seenImpressionsStore.Category

local useOnRequestImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useOnRequestImpressionsSignal")

local function useWidgetItemImpressions(data)
	local v5 = useOnRequestImpressionsSignal()

	local widgetId = data.widgetId
	local content = data.content
	local widgetRow = data.widgetRow
	local itemsPerRow = data.itemsPerRow
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local uiTreatmentType = data.uiTreatmentType
	local reportItemImpression = data.reportItemImpression
	local buildItemImpressionInfo = data.buildItemImpressionInfo

	return {
		onRequestImpressionsSignal = v5,
		onImpressionsDetected = React.useCallback(function(items)
			for k, item in items do
				local v6 = widgetId .. "_" .. item

				if seenImpressionsStore.hasSeen(category.WidgetItems, v6) then
					continue
				end

				local v7 = content[item] or {}
				local v8

				if buildItemImpressionInfo then
					v8 = buildItemImpressionInfo(v7, item)
				else
					local v9 = if v7.id ~= nil then tostring(v7.id) else nil
					v8 = Cryo.Dictionary.join(widgetAnalyticsInfo, {
						widgetPosition = widgetRow,
						widgetId = widgetId,
						itemPosition = item,
						itemId = v9,
						itemType = v7.type,
						widgetAbsPosition = (widgetRow - 1) * itemsPerRow,
						uiTreatmentType = uiTreatmentType
					})
				end

				reportItemImpression(v8)
				seenImpressionsStore.markSeen(category.WidgetItems, v6)
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
