local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)

require(AvatarExperienceCatalogParent.AvatarExperienceCommon)

local AvatarExperienceAnalytics = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local WidgetIxpLayerMap = require(AvatarExperienceCatalog.Utils.WidgetIxpLayerMap)

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function useAddUnifiedLoggingToCatalogSortEffect(t1: {[any]: any}) -- line: 72
	-- upvalues: WidgetIxpLayerMap (copy), React (copy), addUnifiedEventLogging (copy), Cryo (copy), UnifiedEventLogEnums (copy), UnifiedEventLogConstants (copy), WidgetConstants (copy)
	local containerRef = t1.containerRef
	local widgetInfo = t1.widgetInfo
	local widgetAnalyticsInfo = t1.widgetAnalyticsInfo
	local widgetRow = t1.widgetRow
	local uiTreatmentType = t1.uiTreatmentType
	local v18 = WidgetIxpLayerMap[widgetInfo.type]

	React.useEffect(function() -- line: 81
		-- upvalues: addUnifiedEventLogging (copy), containerRef (copy), Cryo (copy), widgetAnalyticsInfo (copy), UnifiedEventLogEnums (copy), widgetRow (copy), uiTreatmentType (copy), widgetInfo (copy), UnifiedEventLogConstants (copy), v18 (copy), WidgetConstants (copy)
		addUnifiedEventLogging(containerRef, Cryo.Dictionary.join(widgetAnalyticsInfo, {
			gridPositionColumn = 1,
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
			gridPositionRow = widgetRow,
			uiTreatmentType = uiTreatmentType,
			themeId = widgetInfo.tagId
		}), {
			sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
		})

		local current = containerRef.current

		if v18 and current then
			current:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, v18)

			return
		end

		if current then
			current:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, nil)
		end
	end, {
		v18,
		widgetRow,
		uiTreatmentType,
		widgetInfo.tagId,
		widgetAnalyticsInfo
	})
end

return useAddUnifiedLoggingToCatalogSortEffect
