local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local LocaleProvider = require(CorePackages.Workspace.Packages.IAPExperience).Locale.LocaleProvider
local RobuxUpsellOverlay = require(script.Parent.RobuxUpsellOverlay)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local RobuxUpsellTriggerContext = require(script.Parent.Enum.RobuxUpsellTriggerContext)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)
local GetFFlagUADesktopPurchaseWarnings = require(Modules.LuaApp.Flags.GetFFlagUADesktopPurchaseWarnings)
local GetFFlagGuardTermOfUseByIsLinkAllowed = require(Modules.LuaApp.Flags.GetFFlagGuardTermOfUseByIsLinkAllowed)
local GetUpsellSuggestions = require(CorePackages.Workspace.Packages.IAPExperience).Api.PaymentsGateway.GetUpsellSuggestions
local PaymentPlatformUtils = require(Modules.LuaApp.Thunks.Economy.Util.PaymentPlatformUtils)
local v27 = Roact.PureComponent:extend(script.Name)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local FFlagEnableUpsellSuggestionsAnalyticsId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUpsellSuggestionsAnalyticsId
local UpsellSuggestionsAPIMaxPackages = require(CorePackages.Workspace.Packages.SharedFlags).UpsellSuggestionsAPIMaxPackages

function v27.init(p1) -- line: 54
	-- upvalues: HttpService (copy), RobuxUpsellTriggerContext (copy), PaymentPlatform (copy), getPaymentPlatform (copy), UrlBuilder (copy)
	p1.state = {
		analyticId = HttpService:GenerateGUID(false)
	}

	function p1.openSecuritySettings() -- line: 59
		-- upvalues: p1 (copy)
		p1.endPurchase()
		p1.props.openSecuritySettings()
	end
	function p1.openBuyRobux() -- line: 64
		-- upvalues: p1 (copy)
		p1.endPurchase()
		p1.props.openBuyRobux()
	end
	function p1.endPurchase() -- line: 69
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
		p1.props.endPurchase()

		if p1.props.onOverlayClosed then
			p1.props.onOverlayClosed()
		end
	end
	function p1.sendAnalyticEvent(s1: string, s2: string, t1: {[any]: any}) -- line: 77
		-- upvalues: p1 (copy)
		p1.props.analytics.EventStream:setRBXEventStream(s1, s2, t1)
	end
	function p1.sendCounter(s3: string) -- line: 82
		-- upvalues: p1 (copy), RobuxUpsellTriggerContext (copy), PaymentPlatform (copy), getPaymentPlatform (copy)
		local Diag = p1.props.analytics.Diag
		local v44 = RobuxUpsellTriggerContext.toRawValue(p1.props.triggerContext)

		Diag:reportCounter(s3, 1)
		Diag:reportCounter(v44 .. s3, 1)

		local v45 = PaymentPlatform.toRawValue(getPaymentPlatform())

		Diag:reportCounter(s3 .. v45, 1)
		Diag:reportCounter(v44 .. s3 .. v45, 1)
	end
	function p1.handleOpenTermsOfUseOpen() -- line: 92
		-- upvalues: p1 (copy), UrlBuilder (copy)
		if p1.props.disableWebViewSupport == true then
			p1.props.linking:openURL(UrlBuilder.static.about.terms())

			return
		end

		p1.props.openTermsOfUse()
	end
end
function v27.isLinkAllowed(_) -- line: 101
	-- upvalues: UserInputService (copy)
	local Platform = UserInputService:GetPlatform()

	return Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.Linux)
end
function v27.render(p3) -- line: 109
	-- upvalues: Roact (copy), LocaleProvider (copy), LocalizationService (copy), RobuxUpsellOverlay (copy), PaymentPlatformUtils (copy), getPaymentPlatform (copy), GetUpsellSuggestions (copy), UpsellSuggestionsAPIMaxPackages (copy), FFlagEnableUpsellSuggestionsAnalyticsId (copy), GetFFlagUADesktopPurchaseWarnings (copy), GetFFlagGuardTermOfUseByIsLinkAllowed (copy), RobuxUpsellTriggerContext (copy)
	return Roact.createElement(LocaleProvider, {
		locale = LocalizationService.RobloxLocaleId
	}, {
		RobuxUpsellOverlay = Roact.createElement(RobuxUpsellOverlay, {
			screenSize = p3.props.screenSize,
			networking = p3.props.networking,
			userId = p3.props.userId,
			fetchUpsellSuggestions = function() -- line: 119
				-- upvalues: PaymentPlatformUtils (copy), getPaymentPlatform (copy), GetUpsellSuggestions (copy), p3 (copy), UpsellSuggestionsAPIMaxPackages (copy), FFlagEnableUpsellSuggestionsAnalyticsId (copy)
				local v46 = PaymentPlatformUtils.paymentPlatformToUpsellPlatform(getPaymentPlatform())

				return GetUpsellSuggestions(v46, p3.props.userRobux, p3.props.priceInRobux, UpsellSuggestionsAPIMaxPackages, p3.props.itemProductId, p3.props.itemName, game.GameId, FFlagEnableUpsellSuggestionsAnalyticsId and p3.state.analyticId or nil)
			end,
			dispatchFetchRobuxProduct = function() -- line: 133
				-- upvalues: p3 (copy)
				return p3.props.dispatchFetchRobuxProduct(p3.props.networking, p3.props.userRobux, p3.props.priceInRobux, p3.props.itemProductId, p3.props.itemName, game.GameId)
			end,
			dispatchFetchIAPPurchaseWarning = function(s4: string, n1: number) -- line: 144
				-- upvalues: GetFFlagUADesktopPurchaseWarnings (copy), p3 (copy)
				if GetFFlagUADesktopPurchaseWarnings() then
					return p3.props.dispatchFetchIAPPurchaseWarning(p3.props.networking, s4, n1, p3.props.isPremium)
				end

				return p3.props.dispatchFetchIAPPurchaseWarning(p3.props.networking, s4)
			end,
			dispatchPostAckPurchaseWarning = function(p4) -- line: 157
				-- upvalues: p3 (copy)
				return p3.props.dispatchPostAckPurchaseWarning(p3.props.networking, p4)
			end,
			dispatchCheckUserPurchaseSettings = function() -- line: 161
				-- upvalues: p3 (copy)
				return p3.props.dispatchCheckUserPurchaseSettings(p3.props.networking)
			end,
			dispatchCentralOverlay = p3.props.dispatchCentralOverlay,
			iapPurchase = p3.props.iapPurchase,
			itemProductId = p3.props.itemProductId,
			itemIcon = p3.props.itemIcon,
			itemName = p3.props.itemName,
			beforeRobuxBalance = p3.props.userRobux,
			priceInRobux = p3.props.priceInRobux,
			endPurchase = p3.endPurchase,
			promptRobux = p3.props.promptRobux,
			openTermsOfUse = if not GetFFlagGuardTermOfUseByIsLinkAllowed() then p3.handleOpenTermsOfUseOpen else p3:isLinkAllowed() and p3.handleOpenTermsOfUseOpen or nil,
			openSecuritySettings = p3.openSecuritySettings,
			openBuyRobux = p3.openBuyRobux,
			renderChallenge = p3.props.renderChallenge,
			purchaseItem = p3.props.purchaseItem,
			equipItem = p3.props.equipItem,
			openSettingsPage = p3.props.openSettingsPage,
			sendAnalyticEvent = p3.sendAnalyticEvent,
			sendCounter = p3.sendCounter,
			eventPrefix = RobuxUpsellTriggerContext.toRawValue(p3.props.triggerContext),
			analyticId = p3.state.analyticId
		})
	})
end

local v31 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v27)
local v32 = RoactAppPolicy.connect(function(p5, _) -- line: 198
	return {
		disableWebViewSupport = not p5.getWebViewSupport(),
		enablePremiumUserFeatures = p5.getEnablePremiumUserFeatures()
	}
end)(v31)

return (withNavigation((withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics,
	linking = AppLinking
})(v32))))))))
