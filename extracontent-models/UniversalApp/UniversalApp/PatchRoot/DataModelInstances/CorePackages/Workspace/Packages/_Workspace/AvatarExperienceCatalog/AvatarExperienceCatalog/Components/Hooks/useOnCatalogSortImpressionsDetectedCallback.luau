local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local ItemTypeEnum = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Enums.ItemTypeEnum
local AvatarExperienceAnalytics = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics)
local ImpressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local FFlagAXDeferLookImpressionsForHydration = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXDeferLookImpressionsForHydration
local useStore = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useStore

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local selectHydratedWidgetData = require(AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData)
local Constants = require(AvatarExperienceCatalog.Constants)
local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)

local function useOnCatalogSortImpressionsDetectedCallback(t1: {[any]: any}) -- line: 60
	-- upvalues: useCatalogPageMonolithDependencies (copy), useStore (copy), React (copy), selectHydratedWidgetData (copy), ItemTypeEnum (copy), FFlagAXDeferLookImpressionsForHydration (copy), sendAXCounterV2 (copy), Constants (copy), Cryo (copy), ImpressionEnums (copy)
	local catalogAnalytics = useCatalogPageMonolithDependencies().catalogAnalytics
	local widgetInfo = t1.widgetInfo
	local widgetAnalyticsInfo = t1.widgetAnalyticsInfo
	local widgetRow = t1.widgetRow
	local itemsPerRow = t1.itemsPerRow
	local uiTreatmentType = t1.uiTreatmentType
	local v22 = useStore()
	local v23 = widgetInfo and widgetInfo.id or ""
	local v24 = if not widgetInfo then nil else widgetInfo.content

	return React.useCallback(function(t2: {[any]: any}) -- line: 79
		-- upvalues: selectHydratedWidgetData (copy), v22 (copy), ItemTypeEnum (copy), v24 (copy), FFlagAXDeferLookImpressionsForHydration (copy), sendAXCounterV2 (copy), Constants (copy), widgetRow (copy), v23 (copy), itemsPerRow (copy), uiTreatmentType (copy), catalogAnalytics (copy), Cryo (copy), widgetAnalyticsInfo (copy), ImpressionEnums (copy)
		local u26 = nil

		local function getHydratedLooks() -- line: 85
			-- upvalues: u26 (ref), selectHydratedWidgetData (copy), v22 (copy), ItemTypeEnum (copy)
			if u26 ~= nil then
				return u26
			end

			local v38 = selectHydratedWidgetData(v22:getState())

			u26 = not not v38 and (v38[ItemTypeEnum.Look] or false)

			return u26
		end

		for _, v29 in t2 do
			local v30 = v24 and v24[v29] or {}
			local v31 = if v30.id == nil then nil else tostring(v30.id)
			local v32 = v30.type == ItemTypeEnum.Look
			local v33 = nil

			if v32 then
				local v34

				if u26 ~= nil then
					v34 = u26
				else
					local v35 = selectHydratedWidgetData(v22:getState())

					u26 = not not v35 and (v35[ItemTypeEnum.Look] or false)
					v34 = u26
				end

				local v36 = v34 and v34[v31]

				v33 = if not v36 or not v36.lookType then nil else v36.lookType
			end

			if FFlagAXDeferLookImpressionsForHydration and v32 and v33 == nil then
				sendAXCounterV2(Constants.COUNTERS.LookImpressionMissingLookType)
			end

			local t3 = {
				widgetPosition = widgetRow,
				widgetId = v23,
				itemPosition = v29,
				itemId = v31,
				itemType = v30.type,
				lookType = v33,
				widgetAbsPosition = (widgetRow - 1) * itemsPerRow,
				uiTreatmentType = uiTreatmentType
			}

			catalogAnalytics.widgetInteractionV2(Cryo.Dictionary.join(widgetAnalyticsInfo, t3), ImpressionEnums.ActionType.ITEM_IMPRESSION)
		end
	end, {
		v23,
		v24,
		widgetAnalyticsInfo,
		widgetRow,
		itemsPerRow,
		uiTreatmentType,
		v22,
		catalogAnalytics
	})
end

return useOnCatalogSortImpressionsDetectedCallback
