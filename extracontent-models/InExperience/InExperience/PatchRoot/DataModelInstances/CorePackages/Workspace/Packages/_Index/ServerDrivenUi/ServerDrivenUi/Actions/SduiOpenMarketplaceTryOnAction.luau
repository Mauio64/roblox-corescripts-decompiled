local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local UnifiedEventLogConstants = require(Parent.AvatarExperienceAnalytics).UnifiedEventLogConstants
local UnifiedEventLogEnums = require(Parent.AvatarExperienceAnalytics).UnifiedEventLogEnums
local AvatarScreen = require(Parent.AvatarExperienceNavigation).Enums.AvatarScreen
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local NavigationRodux = require(Parent.NavigationRodux)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local AppPage = RobloxAppEnums.AppPage
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local AnalyticsService = require(Parent.AvatarExperienceAnalytics).AnalyticsService
local ImpressionEnums = require(Parent.AvatarExperienceAnalytics).Enums.ImpressionEnums
local SharedFlags = require(Parent.SharedFlags)
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local FFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local FFlagAXAvatarSortInDiscoveryUnifiedPurchase = SharedFlags.FFlagAXAvatarSortInDiscoveryUnifiedPurchase
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local v22 = game:DefineFastFlag("AXFixHomepageTryOnScreenAnalytics", false)
local v23 = if not FFlagAXTryOnScreenImprovements then nil else {
	[AppPage.Home] = ImpressionEnums.MarketplaceSurfaceType.DISCOVERY_HOMEPAGE,
	[AppPage.SearchPage] = ImpressionEnums.MarketplaceSurfaceType.DISCOVERY_SEARCH_RESULTS
}
local v24 = if not FFlagAXAvatarSortInDiscoveryUnifiedPurchase then nil else {
	[AppPage.Home] = UnifiedLoggingSurface.DISCOVERY_HOMEPAGE,
	[AppPage.SearchPage] = UnifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
}

local function reportOpenMarketplaceTryOnPropError(p1, s1: string, s2: string?) -- line: 56
	-- upvalues: SduiActionType (copy), SduiErrorType (copy)
	local t1 = {
		name = SduiActionType.OpenMarketplaceTryOn,
		message = s1
	}

	if s2 ~= nil then
		t1.propName = s2
	end

	p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, t1, p1.appPage)
end

return function(p2, _, p4) -- line: 69
	-- upvalues: SduiActionType (copy), SduiErrorType (copy), UnifiedEventLogEnums (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), v24 (copy), FFlagAXTryOnScreenImprovements (copy), v23 (copy), ImpressionEnums (copy), v22 (copy), AppPage (copy), AnalyticsService (copy), UnifiedLoggingSurface (copy), UnifiedEventLogConstants (copy), AvatarScreen (copy), FFlagAXFixPurchaseSurfaceLogging (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy)
	local v33 = p2 and p2.actionParams or nil

	if v33 == nil then
		local t2 = {
			message = "Missing actionParams",
			name = SduiActionType.OpenMarketplaceTryOn
		}

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, t2, p4.appPage)

		return
	end

	assert(v33, "actionParams must exist")

	local itemId = v33.itemId
	local str = tostring(itemId)

	if itemId == nil then
		local v37 = `Missing itemId: { str }`
		local t3 = {
			name = SduiActionType.OpenMarketplaceTryOn,
			message = v37,
			propName = "itemId"
		}

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, t3, p4.appPage)

		return
	end

	local str2 = tostring(v33.itemType)

	if str2 ~= "Asset" and str2 ~= "Bundle" and str2 ~= "Look" then
		local v40 = `Invalid itemType: { str2 }`
		local t4 = {
			name = SduiActionType.OpenMarketplaceTryOn,
			message = v40,
			propName = "itemType"
		}

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, t4, p4.appPage)

		return
	end

	local v42 = if str2 ~= "Asset" then if str2 ~= "Bundle" then if str2 ~= "Look" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.UNDEFINED_ITEM_TYPE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK else UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	local itemSubTypeName = v33.itemSubTypeName

	if (str2 == "Asset" or str2 == "Bundle") and itemSubTypeName == nil then
		local v44 = `Missing itemSubTypeName: { itemSubTypeName }`
		local t5 = {
			name = SduiActionType.OpenMarketplaceTryOn,
			message = v44,
			propName = "itemSubTypeName"
		}

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, t5, p4.appPage)

		return
	end

	local itemPrice = v33.itemPrice

	if itemPrice == nil then
		local v47 = `Missing itemPrice: { itemPrice }`
		local t6 = {
			name = SduiActionType.OpenMarketplaceTryOn,
			message = v47,
			propName = "itemPrice"
		}

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, t6, p4.appPage)
	end

	local v49 = str2 .. str
	local v50 = nil
	local v51 = nil

	if FFlagAXAvatarSortInDiscoveryUnifiedPurchase then
		v51 = v24[p4.appPage]
	end

	if FFlagAXTryOnScreenImprovements then
		local s3 = "TryOnScreen"

		v50 = v23[p4.appPage]

		if v50 == nil then
			p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				name = SduiActionType.OpenMarketplaceTryOn,
				message = `Unsupported appPage for OpenMarketplaceTryOn action: { p4.appPage }`
			}, p4.appPage)
		else
			local t7 = {
				group = "AvatarItemWidgetClick",
				actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
				surface = v50,
				item_id = itemId,
				item_type = str2
			}

			if not v22 and p4.appPage == AppPage.Home then
				s3 = "HomeTryOnScreen"
				t7 = {
					group = "HomePageAvatarWidgetClick",
					actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
					surface = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE,
					item_id = itemId,
					item_type = str2
				}
			end

			t7.event_sender_api = ImpressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
			AnalyticsService.EventStream:sendTelemetryEvent(s3, "marketplaceOrganicFELog", t7)

			local t8 = {
				widgetId = "DiscoveryHomepageAvatarWidget:1234",
				widgetType = "DiscoveryHomepageAvatarWidget",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
				surface = UnifiedLoggingSurface.DISCOVERY_HOMEPAGE,
				itemId = itemId,
				itemType = v42,
				uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP,
				widgetItemPrice = itemPrice
			}

			AnalyticsService.EventStream:sendTelemetryEvent(UnifiedEventLogConstants.EVENT_NAME, UnifiedEventLogConstants.EVENT_NAME, t8)
		end
	end

	local t9 = {
		name = AppPage.AvatarExperienceWrapper,
		detail = v49,
		extraProps = {
			routeName = AvatarScreen.TryOnItem,
			params = {
				mountAsFullView = false,
				mountAnimation = true,
				showRobuxBalance = true,
				showDropDownTopBar = true,
				itemId = str,
				itemType = str2,
				itemSubTypeName = if str2 ~= "Look" then itemSubTypeName else nil,
				fromHome = not FFlagAXTryOnScreenImprovements or nil,
				fromSurface = if not FFlagAXAvatarSortInDiscoveryUnifiedPurchase then if not FFlagAXFixPurchaseSurfaceLogging then nil else v50 else v51,
				detail = v49,
				hideTab = not not FFlagAXTryOnScreenImprovements or nil,
				simpleView = if not FFlagAXTryOnScreenImprovements then nil else p4.appPage == AppPage.Home and not FFlagAXEnableHomeTryOnComplexView,
				shouldNavigateDown = not not FFlagAXTryOnScreenImprovements or nil
			}
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v21.down(v21.fromLegacyPage(t9))

		return
	end

	p4.dependencies.dispatch(NavigateDown(t9))
end
