local HttpService = game:GetService("HttpService")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module3 = require("@luauforge/bundled/fHh")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

require("@luauforge/bundled/dPs")
require("@luauforge/deferred/hcc")

local module4 = require("@luauforge/deferred/hcg")

local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local fFlagTTOnboardingSheet = module3.Flags.FFlagTTOnboardingSheet

local v5 = {
	OpenRobloxPlus = {
		onActivated = function(p2, p3)
			module3.initiateRobloxSubscriptionPurchase(
				nil,
				nil,
				nil,
				module3.SurfaceName.MarketplaceHeroUnit,
				module3.SurfaceContext.InApp,
				nil,
				p3
			)
		end,
		isHidden = function(p2)
			return p2.hasRobloxSubscription or p2.plusPurchasingBlocked
		end
	},
	OpenFreeRobloxPlus = {
		onActivated = function(p2, p3)
			module3.initiateRobloxSubscriptionPurchase(
				{ sheetKind = module3.RobloxPlusSheetKind.TT },
				nil,
				nil,
				module3.SurfaceName.MarketplaceHeroUnit,
				module3.SurfaceContext.InApp,
				nil,
				p3
			)
		end,
		isHidden = function(p2)
			return not fFlagTTOnboardingSheet or p2.hasRobloxSubscription or p2.plusPurchasingBlocked
		end
	}
}

local function sendHeroUnitButtonClick(p2, data, unifiedLoggingSurface, guid)
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local requestId = widgetAnalyticsInfo.requestId
	local widgetId = widgetAnalyticsInfo.widgetId
	local widgetType = widgetAnalyticsInfo.widgetType
	local widgetItemIds = widgetAnalyticsInfo.widgetItemIds

	if requestId and widgetId and widgetType and widgetItemIds and #widgetItemIds > 0 then
		AvatarExperienceAnalytics.sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface,
			keyword = widgetAnalyticsInfo.query,
			requestId = requestId,
			elementName = unifiedLoggingElementNameEnums.HERO_UNIT_ACTION_BUTTON,
			widgetId = widgetId,
			widgetType = widgetType,
			widgetItemIds = table.concat(widgetItemIds, ","),
			uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT,
			elementMetadata = HttpService:JSONEncode({
				tag_id = data.tagId,
				button_action = p2.action,
				purchase_flow_uuid = guid
			}),
			gridPositionRow = data.widgetRow,
			gridPositionColumn = 1
		})
	else
		AvatarExperienceAnalytics.sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface,
			keyword = widgetAnalyticsInfo.query,
			requestId = requestId,
			elementName = unifiedLoggingElementNameEnums.HERO_UNIT_ACTION_BUTTON,
			elementMetadata = HttpService:JSONEncode({
				widget_id = widgetId,
				widget_type = widgetType,
				tag_id = data.tagId,
				button_action = p2.action,
				purchase_flow_uuid = guid
			}),
			gridPositionRow = data.widgetRow,
			gridPositionColumn = 1
		})
	end
end

local function useHeroUnitButtonAction(p2, data)
	local v6 = module4()
	local unifiedLoggingSurface = getUnifiedLoggingSurface((useAvatarRoute()))
	local v8 = useAppPolicy(function(p3)
		return p3.getDisableBlackbirdEntrypoints()
	end)

	local v9 = if p2 then v5[p2.action] else nil
	local localizedText = if p2 then p2.localizedText else nil
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local widgetRow = data.widgetRow
	local tagId = data.tagId

	return React.useMemo(function()
		if p2 == nil or v9 == nil or localizedText == nil or localizedText == "" then
			return nil
		end

		local v10 = { hasRobloxSubscription = v6, plusPurchasingBlocked = v8 }

		if v9.isHidden(v10) then
			return nil
		end

		return {
			text = localizedText,
			onActivated = function()
				local guid = HttpService:GenerateGUID(false)
				sendHeroUnitButtonClick(
					p2,
					{
						widgetAnalyticsInfo = widgetAnalyticsInfo,
						widgetRow = widgetRow,
						tagId = tagId
					},
					unifiedLoggingSurface,
					guid
				)

				v9.onActivated(v10, {
					clientSessionId = {
						clientSessionIdType = module3.PurchaseClientSessionIdType.PurchaseFlowUUID,
						clientSessionId = guid
					}
				})
			end
		}
	end, {
		p2,
		v9,
		localizedText,
		v6,
		v8,
		unifiedLoggingSurface,
		widgetAnalyticsInfo,
		widgetRow,
		tagId
	})
end

return useHeroUnitButtonAction
