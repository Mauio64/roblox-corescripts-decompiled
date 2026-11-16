local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").UnifiedEventLogConstants
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").UnifiedEventLogEnums
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").sendUnifiedEventLog
local unifiedEventCounterAggregator = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").UnifiedEventCounterAggregator
local axUnifiedEventFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").AXUnifiedEventFilter
local fFlagAXUnifiedEventCounters = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").Flags.FFlagAXUnifiedEventCounters

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").Flags.FFlagAXUnifiedEventStrictPayloads

local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceNavigation").Enums.AvatarScreen
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")

local navigateDown = NavigationRodux.Thunks.NavigateDown
local appPage = RobloxAppEnums.AppPage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").AnalyticsService
local impressionEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").Enums.ImpressionEnums

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local fFlagAXFixHomeAvatarsUnifiedPurchase = SharedFlags.FFlagAXFixHomeAvatarsUnifiedPurchase
local fFlagAXDiscoveryItemPurchaseAttribution = SharedFlags.FFlagAXDiscoveryItemPurchaseAttribution
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local defineFastFlag = game:DefineFastFlag("AXFixHomepageTryOnScreenAnalytics", false)

local v5 = {
	[appPage.Home] = impressionEnums.MarketplaceSurfaceType.DISCOVERY_HOMEPAGE,
	[appPage.SearchPage] = impressionEnums.MarketplaceSurfaceType.DISCOVERY_SEARCH_RESULTS
}

local v6 = {
	[appPage.Home] = unifiedLoggingSurface.DISCOVERY_HOMEPAGE,
	[appPage.SearchPage] = unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
}

local function reportOpenMarketplaceTryOnPropError(p2, p3, propName)
	local v7 = { name = sduiActionType.OpenMarketplaceTryOn, message = p3 }

	if propName ~= nil then
		v7.propName = propName
	end

	p2.dependencies.logger.reportError(sduiErrorType.InvalidActionParams, v7, p2.appPage)
end

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		local v7 = {
			name = sduiActionType.OpenMarketplaceTryOn,
			message = "Missing actionParams"
		}

		p4.dependencies.logger.reportError(sduiErrorType.InvalidActionParams, v7, p4.appPage)
	else
		assert(actionParams, "actionParams must exist")

		local v7 = actionParams.itemId
		local v8 = tostring(v7)

		if v7 == nil then
			local formatted = `Missing itemId: {v8}`
			local v9 = {
				name = sduiActionType.OpenMarketplaceTryOn,
				message = formatted
			}

			v9.propName = "itemId"

			p4.dependencies.logger.reportError(sduiErrorType.InvalidActionParams, v9, p4.appPage)
		else
			local itemType = tostring(actionParams.itemType)

			if itemType == "Asset" or itemType == "Bundle" or itemType == "Look" then
				local v9

				if itemType == "Asset" then
					v9 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
				elseif itemType == "Bundle" then
					v9 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
				elseif itemType == "Look" then
					v9 = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
				else
					v9 = unifiedEventLogEnums.MarketplaceUnifiedItemType.UNDEFINED_ITEM_TYPE
				end

				local itemSubTypeName = actionParams.itemSubTypeName

				if (itemType == "Asset" or itemType == "Bundle") and itemSubTypeName == nil then
					local formatted = `Missing itemSubTypeName: {nil}`
					local v10 = {
						name = sduiActionType.OpenMarketplaceTryOn,
						message = formatted
					}

					v10.propName = "itemSubTypeName"

					p4.dependencies.logger.reportError(sduiErrorType.InvalidActionParams, v10, p4.appPage)
				else
					local itemPrice

					if fFlagAXUnifiedEventCounters then
						itemPrice = tonumber(actionParams.itemPrice)
					else
						itemPrice = actionParams.itemPrice
					end

					if itemPrice == nil then
						local formatted = `Missing itemPrice: {nil}`
						local v10 = {
							name = sduiActionType.OpenMarketplaceTryOn,
							message = formatted
						}

						v10.propName = "itemPrice"

						p4.dependencies.logger.reportError(
							sduiErrorType.InvalidActionParams,
							v10,
							p4.appPage
						)
					end

					local v10 = itemType .. v8

					local v11 = v6[p4.appPage]

					local v12 = fFlagAXFixHomeAvatarsUnifiedPurchase and {
						widgetId = findAnalyticsFieldInAncestors("widgetId", p3),
						widgetType = findAnalyticsFieldInAncestors("widgetType", p3),
						widgetItemIds = findAnalyticsFieldInAncestors("widgetItemIds", p3),
						requestId = findAnalyticsFieldInAncestors("requestId", p3),
						itemPosition = findAnalyticsFieldInAncestors("itemPosition", p3)
					} or nil

					local v13 = "TryOnScreen"

					local v14 = v5[p4.appPage]

					if v14 == nil then
						p4.dependencies.logger.reportError(
							sduiErrorType.InvalidActionParams,
							{
								name = sduiActionType.OpenMarketplaceTryOn,
								message = `Unsupported appPage for OpenMarketplaceTryOn action: {p4.appPage}`
							},
							p4.appPage
						)
					else
						local v15 = {
							actionType = impressionEnums.ActionType.UI_BUTTON_CLICK,
							group = "AvatarItemWidgetClick",
							surface = v14,
							item_id = v7,
							item_type = itemType
						}

						if not defineFastFlag and p4.appPage == appPage.Home then
							v15 = {
								actionType = impressionEnums.ActionType.UI_BUTTON_CLICK,
								group = "HomePageAvatarWidgetClick",
								surface = impressionEnums.MarketplaceSurfaceType.HOMEPAGE,
								item_id = v7,
								item_type = itemType
							}
							v13 = "HomeTryOnScreen"
						end

						v15.event_sender_api = impressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
						analyticsService.EventStream:sendTelemetryEvent(v13, "marketplaceOrganicFELog", v15)
						local v16

						if fFlagAXFixHomeAvatarsUnifiedPurchase then
							local v17

							if v12.widgetId == nil or v12.widgetType == nil or v12.widgetItemIds == nil then
								v17 = false
							else
								v17 = v12.requestId ~= nil
							end

							v16 = {
								action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
								surface = v11,
								itemId = 0,
								itemType = 0
							}

							if fFlagAXUnifiedEventStrictPayloads then
								v7 = v8
							end

							v16.itemId = v7
							v16.itemType = v9

							if v17 then
								local v18 = if fFlagAXUnifiedEventStrictPayloads then tostring(v12.widgetId) else v12.widgetId
								v16.widgetId = v18

								local v19 = if fFlagAXUnifiedEventStrictPayloads then tostring(v12.widgetType) else v12.widgetType
								v16.widgetType = v19

								local v20 = if fFlagAXUnifiedEventStrictPayloads then tostring(v12.widgetItemIds) else v12.widgetItemIds
								v16.widgetItemIds = v20

								local v21 = if fFlagAXUnifiedEventStrictPayloads then tostring(v12.requestId) else v12.requestId
								v16.requestId = v21

								v16.uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP
								v16.widgetItemPrice = itemPrice
							else
								v16.organicItemPrice = itemPrice
							end
						else
							v16 = {
								action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
								surface = unifiedLoggingSurface.DISCOVERY_HOMEPAGE,
								itemId = v7,
								itemType = v9,
								widgetId = "DiscoveryHomepageAvatarWidget:1234",
								widgetType = "DiscoveryHomepageAvatarWidget",
								uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP,
								widgetItemPrice = itemPrice
							}
						end

						if fFlagAXDiscoveryItemPurchaseAttribution then
							sendUnifiedEventLog(v16)
						else
							if fFlagAXUnifiedEventCounters then
								unifiedEventCounterAggregator.record(
									v16,
									axUnifiedEventFilter.filter(v16, {
										skipReporting = true
									})
								)
							end

							analyticsService.EventStream:sendTelemetryEvent(
								unifiedEventLogConstants.EVENT_NAME,
								unifiedEventLogConstants.EVENT_NAME,
								v16
							)
						end
					end

					local v15 = {
						name = appPage.AvatarExperienceWrapper,
						detail = v10,
						extraProps = 0
					}

					local v16 = { routeName = avatarScreen.TryOnItem, params = 0 }

					if itemType == "Look" then
						itemSubTypeName = nil
					end

					local v17 = {
						itemId = v8,
						itemType = itemType,
						itemSubTypeName = itemSubTypeName,
						mountAsFullView = false,
						mountAnimation = true,
						showRobuxBalance = true,
						showDropDownTopBar = true,
						fromSurface = v11,
						detail = v10,
						hideTab = true,
						simpleView = p4.appPage == appPage.Home and not fFlagAXEnableHomeTryOnComplexView,
						shouldNavigateDown = true,
						avatarUnifiedAttribution = 0
					}

					if not fFlagAXFixHomeAvatarsUnifiedPurchase then
						v12 = nil
					end

					v17.avatarUnifiedAttribution = v12
					v16.params = v17
					v15.extraProps = v16

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v15))
					else
						p4.dependencies.dispatch(navigateDown(v15))
					end
				end
			else
				local formatted = `Invalid itemType: {itemType}`
				local v9 = {
					name = sduiActionType.OpenMarketplaceTryOn,
					message = formatted
				}

				v9.propName = "itemType"

				p4.dependencies.logger.reportError(sduiErrorType.InvalidActionParams, v9, p4.appPage)
			end
		end
	end
end
