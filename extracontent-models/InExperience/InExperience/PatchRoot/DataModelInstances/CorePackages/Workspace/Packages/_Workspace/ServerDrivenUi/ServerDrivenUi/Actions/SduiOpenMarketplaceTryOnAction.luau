local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local AvatarExperienceAnalytics2 = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics2.UnifiedEventLogEnums
local AvatarExperienceAnalytics3 = require(parent.AvatarExperienceAnalytics)
local sendUnifiedEventLog = AvatarExperienceAnalytics3.sendUnifiedEventLog
local AvatarExperienceAnalytics4 = require(parent.AvatarExperienceAnalytics)
local UnifiedEventCounterAggregator = AvatarExperienceAnalytics4.UnifiedEventCounterAggregator
local AvatarExperienceAnalytics5 = require(parent.AvatarExperienceAnalytics)
local AXUnifiedEventFilter = AvatarExperienceAnalytics5.AXUnifiedEventFilter
local AvatarExperienceAnalytics6 = require(parent.AvatarExperienceAnalytics)
local FFlagAXUnifiedEventCounters = AvatarExperienceAnalytics6.Flags.FFlagAXUnifiedEventCounters

local AvatarExperienceAnalytics7 = require(parent.AvatarExperienceAnalytics)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics7.Flags.FFlagAXUnifiedEventStrictPayloads

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarExperienceNavigation2 = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation2.Enums.UnifiedLoggingSurface
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local NavigateDown = NavigationRodux.Thunks.NavigateDown
local AppPage = RobloxAppEnums.AppPage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local AvatarExperienceAnalytics8 = require(parent.AvatarExperienceAnalytics)
local AnalyticsService = AvatarExperienceAnalytics8.AnalyticsService
local AvatarExperienceAnalytics9 = require(parent.AvatarExperienceAnalytics)
local ImpressionEnums = AvatarExperienceAnalytics9.Enums.ImpressionEnums

local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local FFlagAXFixHomeAvatarsUnifiedPurchase = SharedFlags.FFlagAXFixHomeAvatarsUnifiedPurchase
local FFlagAXDiscoveryItemPurchaseAttribution = SharedFlags.FFlagAXDiscoveryItemPurchaseAttribution
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local defineFastFlag = game:DefineFastFlag("AXFixHomepageTryOnScreenAnalytics", false)

local v = {
	[AppPage.Home] = ImpressionEnums.MarketplaceSurfaceType.DISCOVERY_HOMEPAGE,
	[AppPage.SearchPage] = ImpressionEnums.MarketplaceSurfaceType.DISCOVERY_SEARCH_RESULTS
}

local v2 = {
	[AppPage.Home] = UnifiedLoggingSurface.DISCOVERY_HOMEPAGE,
	[AppPage.SearchPage] = UnifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
}

local function reportOpenMarketplaceTryOnPropError(p, message: string, propName: string?) -- 4 equivalent calls inferred from this helper
	local v3 = { name = SduiActionType.OpenMarketplaceTryOn, message = message }

	if propName ~= nil then
		v3.propName = propName
	end

	p.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, v3, p.appPage)
end

return function(p, p2, p3)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		local v3 = { name = SduiActionType.OpenMarketplaceTryOn, message = "Missing actionParams" }

		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, v3, p3.appPage)
	else
		assert(actionParams, "actionParams must exist")

		local v3 = actionParams.itemId
		local itemId = tostring(v3)

		if v3 == nil then
			reportOpenMarketplaceTryOnPropError(p3, `Missing itemId: {itemId}`, "itemId") -- inferred equivalent call
		else
			local itemType = tostring(actionParams.itemType)

			if itemType == "Asset" or itemType == "Bundle" or itemType == "Look" then
				local itemType2

				if itemType == "Asset" then
					itemType2 = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
				elseif itemType == "Bundle" then
					itemType2 = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
				elseif itemType == "Look" then
					itemType2 = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
				else
					itemType2 = UnifiedEventLogEnums.MarketplaceUnifiedItemType.UNDEFINED_ITEM_TYPE
				end

				local itemSubTypeName = actionParams.itemSubTypeName

				if (itemType == "Asset" or itemType == "Bundle") and itemSubTypeName == nil then
					reportOpenMarketplaceTryOnPropError(p3, `Missing itemSubTypeName: {nil}`, "itemSubTypeName") -- inferred equivalent call
				else
					local itemPrice

					if FFlagAXUnifiedEventCounters then
						itemPrice = tonumber(actionParams.itemPrice)
					else
						itemPrice = actionParams.itemPrice
					end

					if itemPrice == nil then
						reportOpenMarketplaceTryOnPropError(p3, `Missing itemPrice: {nil}`, "itemPrice") -- inferred equivalent call
					end

					local detail = itemType .. itemId

					local v4 = v2[p3.appPage]

					local avatarUnifiedAttribution = FFlagAXFixHomeAvatarsUnifiedPurchase and {
						widgetId = findAnalyticsFieldInAncestors("widgetId", p2),
						widgetType = findAnalyticsFieldInAncestors("widgetType", p2),
						widgetItemIds = findAnalyticsFieldInAncestors("widgetItemIds", p2),
						requestId = findAnalyticsFieldInAncestors("requestId", p2),
						itemPosition = findAnalyticsFieldInAncestors("itemPosition", p2)
					} or nil

					local v5 = "TryOnScreen"

					local surface = v[p3.appPage]

					if surface == nil then
						p3.dependencies.logger.reportError(
							SduiErrorType.InvalidActionParams,
							{
								name = SduiActionType.OpenMarketplaceTryOn,
								message = `Unsupported appPage for OpenMarketplaceTryOn action: {p3.appPage}`
							},
							p3.appPage
						)
					else
						local v6 = {
							actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
							group = "AvatarItemWidgetClick",
							surface = surface,
							item_id = v3,
							item_type = itemType
						}

						if not defineFastFlag and p3.appPage == AppPage.Home then
							v6 = {
								actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
								group = "HomePageAvatarWidgetClick",
								surface = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE,
								item_id = v3,
								item_type = itemType
							}
							v5 = "HomeTryOnScreen"
						end

						v6.event_sender_api = ImpressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
						AnalyticsService.EventStream:sendTelemetryEvent(v5, "marketplaceOrganicFELog", v6)
						local v7

						if FFlagAXFixHomeAvatarsUnifiedPurchase then
							local v8

							if
								avatarUnifiedAttribution.widgetId == nil
								or avatarUnifiedAttribution.widgetType == nil
								or avatarUnifiedAttribution.widgetItemIds == nil
							then
								v8 = false
							else
								v8 = avatarUnifiedAttribution.requestId ~= nil
							end

							v7 = {
								action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
								surface = v4,
								itemId = 0,
								itemType = 0
							}

							if FFlagAXUnifiedEventStrictPayloads then
								v3 = itemId
							end

							v7.itemId = v3
							v7.itemType = itemType2

							if v8 then
								local widgetId

								if FFlagAXUnifiedEventStrictPayloads then
									widgetId = tostring(avatarUnifiedAttribution.widgetId)
								else
									widgetId = avatarUnifiedAttribution.widgetId
								end

								v7.widgetId = widgetId
								local widgetType

								if FFlagAXUnifiedEventStrictPayloads then
									widgetType = tostring(avatarUnifiedAttribution.widgetType)
								else
									widgetType = avatarUnifiedAttribution.widgetType
								end

								v7.widgetType = widgetType
								local widgetItemIds

								if FFlagAXUnifiedEventStrictPayloads then
									widgetItemIds = tostring(avatarUnifiedAttribution.widgetItemIds)
								else
									widgetItemIds = avatarUnifiedAttribution.widgetItemIds
								end

								v7.widgetItemIds = widgetItemIds
								local requestId

								if FFlagAXUnifiedEventStrictPayloads then
									requestId = tostring(avatarUnifiedAttribution.requestId)
								else
									requestId = avatarUnifiedAttribution.requestId
								end

								v7.requestId = requestId

								v7.uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP
								v7.widgetItemPrice = itemPrice
							else
								v7.organicItemPrice = itemPrice
							end
						else
							v7 = {
								action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
								surface = UnifiedLoggingSurface.DISCOVERY_HOMEPAGE,
								itemId = v3,
								itemType = itemType2,
								widgetId = "DiscoveryHomepageAvatarWidget:1234",
								widgetType = "DiscoveryHomepageAvatarWidget",
								uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP,
								widgetItemPrice = itemPrice
							}
						end

						if FFlagAXDiscoveryItemPurchaseAttribution then
							sendUnifiedEventLog(v7)
						else
							if FFlagAXUnifiedEventCounters then
								UnifiedEventCounterAggregator.record(
									v7,
									AXUnifiedEventFilter.filter(v7, { skipReporting = true })
								)
							end

							AnalyticsService.EventStream:sendTelemetryEvent(
								UnifiedEventLogConstants.EVENT_NAME,
								UnifiedEventLogConstants.EVENT_NAME,
								v7
							)
						end
					end

					local v6 = {
						name = AppPage.AvatarExperienceWrapper,
						detail = detail,
						extraProps = 0
					}

					local extraProps = { routeName = AvatarScreen.TryOnItem, params = 0 }

					if itemType == "Look" then
						itemSubTypeName = nil
					end

					local params = {
						itemId = itemId,
						itemType = itemType,
						itemSubTypeName = itemSubTypeName,
						mountAsFullView = false,
						mountAnimation = true,
						showRobuxBalance = true,
						showDropDownTopBar = true,
						fromSurface = v4,
						detail = detail,
						hideTab = true,
						simpleView = p3.appPage == AppPage.Home and not FFlagAXEnableHomeTryOnComplexView,
						shouldNavigateDown = true,
						avatarUnifiedAttribution = 0
					}

					if not FFlagAXFixHomeAvatarsUnifiedPurchase then
						avatarUnifiedAttribution = nil
					end

					params.avatarUnifiedAttribution = avatarUnifiedAttribution
					extraProps.params = params
					v6.extraProps = extraProps

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v6))
					else
						p3.dependencies.dispatch(NavigateDown(v6))
					end
				end
			else
				reportOpenMarketplaceTryOnPropError(p3, `Invalid itemType: {itemType}`, "itemType") -- inferred equivalent call
			end
		end
	end
end
