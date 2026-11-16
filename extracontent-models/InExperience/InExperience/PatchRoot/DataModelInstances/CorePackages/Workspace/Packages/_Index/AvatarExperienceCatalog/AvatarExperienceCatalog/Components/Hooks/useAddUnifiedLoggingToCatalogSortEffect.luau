local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local Cryo = require(parent.Cryo)

require(parent.AvatarExperienceCommon)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiSeeAllClickLogging = AvatarExperienceFlags.FFlagAXSduiSeeAllClickLogging

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging

local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local WidgetIxpLayerMap = require(AvatarExperienceCatalog.Utils.WidgetIxpLayerMap)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function useAddUnifiedLoggingToCatalogSortEffect(data)
	local containerRef = data.containerRef
	local widgetInfo = data.widgetInfo
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local widgetRow = data.widgetRow
	local uiTreatmentType = data.uiTreatmentType

	local widgetIxpLayer = WidgetIxpLayerMap[widgetInfo.type]

	React.useEffect(function()
		addUnifiedEventLogging(containerRef, Cryo.Dictionary.join(widgetAnalyticsInfo, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
			gridPositionRow = widgetRow,
			gridPositionColumn = 1,
			uiTreatmentType = uiTreatmentType,
			themeId = widgetInfo.tagId
		}), { sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME })

		local current = containerRef.current

		if widgetIxpLayer and current then
			current:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, widgetIxpLayer)
		elseif current then
			current:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, nil)
		end
	end, { widgetIxpLayer, widgetRow, uiTreatmentType, widgetInfo.tagId, widgetAnalyticsInfo })

	if FFlagAXSduiSeeAllClickLogging then
		local seeAllRef = data.seeAllRef

		local v = data.seeAllCallback ~= nil

		React.useEffect(function()
			if v and seeAllRef and seeAllRef.current then
				addUnifiedEventLogging(seeAllRef, {
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					requestId = widgetAnalyticsInfo.requestId,
					elementName = "SEE_ALL",
					elementMetadata = HttpService:JSONEncode({
						widget_id = widgetAnalyticsInfo.widgetId,
						widget_type = widgetAnalyticsInfo.widgetType,
						tag_id = widgetInfo.tagId
					}),
					gridPositionRow = widgetRow,
					gridPositionColumn = 1
				}, { sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME })
			end
		end, { v, widgetRow, widgetInfo.tagId, widgetAnalyticsInfo })
	end
end

return useAddUnifiedLoggingToCatalogSortEffect
