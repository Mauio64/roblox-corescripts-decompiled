local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local ImpressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)
local selectHydratedWidgetData = require(AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData)
local Constants = require(AvatarExperienceCatalog.Constants)
local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)

local function useOnCatalogSortImpressionsDetectedCallback(data)
	local catalogAnalytics = useCatalogPageMonolithDependencies().catalogAnalytics

	local widgetInfo = data.widgetInfo
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local widgetRow = data.widgetRow
	local itemsPerRow = data.itemsPerRow
	local uiTreatmentType = data.uiTreatmentType

	local v = useStore()

	local id = widgetInfo and widgetInfo.id or ""
	local content

	if widgetInfo then
		content = widgetInfo.content
	else
		content = nil
	end

	return React.useCallback(function(items)
		local hydratedLooks = nil
		local function getHydratedLooks() -- 1 equivalent call inferred from this helper
			if hydratedLooks ~= nil then
				return hydratedLooks
			end

			local v2 = selectHydratedWidgetData(v:getState())
			hydratedLooks = v2 and v2[ItemTypeEnum.Look] or false
			return hydratedLooks
		end

		for _, item in items do
			local v2 = content and content[item] or {}
			local id2

			if v2.id ~= nil then
				id2 = tostring(v2.id)
			end

			local v3 = v2.type == ItemTypeEnum.Look
			local lookType

			if v3 then
				local hydratedLooks2 = getHydratedLooks() -- inferred equivalent call

				local v4 = hydratedLooks2 and hydratedLooks2[id2]

				if v4 and v4.lookType then
					lookType = v4.lookType
				end
			end

			if FFlagAXDeferLookImpressionsForHydration and v3 and lookType == nil then
				sendAXCounterV2(Constants.COUNTERS.LookImpressionMissingLookType)
			end

			local v4 = {
				widgetPosition = widgetRow,
				widgetId = id,
				itemPosition = item,
				itemId = id2,
				itemType = v2.type,
				lookType = lookType,
				widgetAbsPosition = (widgetRow - 1) * itemsPerRow,
				uiTreatmentType = uiTreatmentType
			}

			catalogAnalytics.widgetInteractionV2(
				Cryo.Dictionary.join(widgetAnalyticsInfo, v4),
				ImpressionEnums.ActionType.ITEM_IMPRESSION
			)
		end
	end, {
		id,
		content,
		widgetAnalyticsInfo,
		widgetRow,
		itemsPerRow,
		uiTreatmentType,
		v,
		catalogAnalytics
	})
end

return useOnCatalogSortImpressionsDetectedCallback
