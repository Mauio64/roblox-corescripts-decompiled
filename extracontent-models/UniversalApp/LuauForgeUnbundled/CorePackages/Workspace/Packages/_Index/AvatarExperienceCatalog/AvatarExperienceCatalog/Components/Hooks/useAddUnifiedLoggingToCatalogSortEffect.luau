local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")

local fFlagAXSduiSeeAllClickLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXSduiSeeAllClickLogging

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging

local WidgetConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/WidgetConstants")
local WidgetIxpLayerMap = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/WidgetIxpLayerMap")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local function useAddUnifiedLoggingToCatalogSortEffect(data)
	local containerRef = data.containerRef
	local widgetInfo = data.widgetInfo
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local widgetRow = data.widgetRow
	local uiTreatmentType = data.uiTreatmentType

	local v5 = WidgetIxpLayerMap[widgetInfo.type]

	React.useEffect(function()
		addUnifiedEventLogging(containerRef, Cryo.Dictionary.join(widgetAnalyticsInfo, {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
			gridPositionRow = widgetRow,
			gridPositionColumn = 1,
			uiTreatmentType = uiTreatmentType,
			themeId = widgetInfo.tagId
		}), { sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME })

		local current = containerRef.current

		if v5 and current then
			current:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, v5)
		elseif current then
			current:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, nil)
		end
	end, { v5, widgetRow, uiTreatmentType, widgetInfo.tagId, widgetAnalyticsInfo })

	if fFlagAXSduiSeeAllClickLogging then
		local seeAllRef = data.seeAllRef

		local v6 = data.seeAllCallback ~= nil

		React.useEffect(function()
			if v6 and seeAllRef and seeAllRef.current then
				addUnifiedEventLogging(seeAllRef, {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					requestId = widgetAnalyticsInfo.requestId,
					elementName = "SEE_ALL",
					elementMetadata = HttpService:JSONEncode({
						widget_id = widgetAnalyticsInfo.widgetId,
						widget_type = widgetAnalyticsInfo.widgetType,
						tag_id = widgetInfo.tagId
					}),
					gridPositionRow = widgetRow,
					gridPositionColumn = 1
				}, { sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME })
			end
		end, { v6, widgetRow, widgetInfo.tagId, widgetAnalyticsInfo })
	end
end

return useAddUnifiedLoggingToCatalogSortEffect
