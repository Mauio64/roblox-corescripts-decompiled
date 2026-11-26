local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.ItemTypeEnum

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local impressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local fFlagAXDeferLookImpressionsForHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXDeferLookImpressionsForHydration

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useStore

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local selectHydratedWidgetData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedWidgetData")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")
local useCatalogPageMonolithDependencies = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/useCatalogPageMonolithDependencies")

local function useOnCatalogSortImpressionsDetectedCallback(data)
	local catalogAnalytics = useCatalogPageMonolithDependencies().catalogAnalytics

	local widgetInfo = data.widgetInfo
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local widgetRow = data.widgetRow
	local itemsPerRow = data.itemsPerRow
	local uiTreatmentType = data.uiTreatmentType

	local v5 = useStore()

	local id = widgetInfo and widgetInfo.id or ""
	local content = if widgetInfo then widgetInfo.content else nil

	return React.useCallback(function(items)
		local hydratedLooks = nil
		local function getHydratedLooks()
			if hydratedLooks ~= nil then
				return hydratedLooks
			end

			local v6 = selectHydratedWidgetData(v5:getState())
			hydratedLooks = v6 and v6[itemTypeEnum.Look] or false
			return hydratedLooks
		end

		for k, item in items do
			local v6 = content and content[item] or {}

			local id2 = if v6.id ~= nil then tostring(v6.id) else nil

			local v7 = v6.type == itemTypeEnum.Look
			local lookType

			if v7 then
				if hydratedLooks == nil then
					local v8 = selectHydratedWidgetData(v5:getState())
					hydratedLooks = v8 and v8[itemTypeEnum.Look] or false
				end

				local v9 = hydratedLooks and hydratedLooks[id2]

				if v9 and v9.lookType then
					lookType = v9.lookType
				end
			end

			if fFlagAXDeferLookImpressionsForHydration and v7 and lookType == nil then
				sendAXCounterV2(Constants.COUNTERS.LookImpressionMissingLookType)
			end

			local v8 = {
				widgetPosition = widgetRow,
				widgetId = id,
				itemPosition = item,
				itemId = id2,
				itemType = v6.type,
				lookType = lookType,
				widgetAbsPosition = (widgetRow - 1) * itemsPerRow,
				uiTreatmentType = uiTreatmentType
			}

			catalogAnalytics.widgetInteractionV2(
				Cryo.Dictionary.join(widgetAnalyticsInfo, v8),
				impressionEnums.ActionType.ITEM_IMPRESSION
			)
		end
	end, {
		id,
		content,
		widgetAnalyticsInfo,
		widgetRow,
		itemsPerRow,
		uiTreatmentType,
		v5,
		catalogAnalytics
	})
end

return useOnCatalogSortImpressionsDetectedCallback
