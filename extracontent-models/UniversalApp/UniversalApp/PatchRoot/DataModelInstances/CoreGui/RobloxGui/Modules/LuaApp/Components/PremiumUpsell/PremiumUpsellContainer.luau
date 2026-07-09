local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local LocaleProvider = require(CorePackages.Workspace.Packages.IAPExperience).Locale.LocaleProvider
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local PremiumUpsellOverlay = require(script.Parent.PremiumUpsellOverlay)
local PremiumUpsellTriggerContext = require(script.Parent.Enum.PremiumUpsellTriggerContext)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local v17 = Roact.PureComponent:extend(script.Name)

function v17.init(p1) -- line: 28
	-- upvalues: PremiumUpsellTriggerContext (copy)
	function p1.closeCentralOverlay() -- line: 29
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
	function p1.promptPremium() -- line: 33
		-- upvalues: p1 (copy)
		p1.endPurchase()
		p1.props.promptPremium()
	end
	function p1.cancelPurchase() -- line: 38
		-- upvalues: p1 (copy)
		p1.endPurchase()

		if p1.props.onCancel then
			p1.props.onCancel()
		end
	end
	function p1.endPurchase() -- line: 45
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()

		if p1.props.onOverlayClosed then
			p1.props.onOverlayClosed()
		end
	end
	function p1.sendAnalyticEvent(s1: string, s2: string, t1: {[any]: any}) -- line: 52
		-- upvalues: p1 (copy)
		p1.props.analytics.EventStream:setRBXEventStream(s1, s2, t1)
	end
	function p1.sendCounter(s3: string) -- line: 57
		-- upvalues: p1 (copy), PremiumUpsellTriggerContext (copy)
		local Diag = p1.props.analytics.Diag
		local v27 = PremiumUpsellTriggerContext.toRawValue(p1.props.triggerContext)

		Diag:reportCounter(s3, 1)
		Diag:reportCounter(v27 .. s3, 1)
	end
end
function v17.didMount(p2) -- line: 65
	-- upvalues: RetrievalStatus (copy)
	if p2.props.iapProductsFetchingStatus == RetrievalStatus.NotStarted or p2.props.iapProductsFetchingStatus == RetrievalStatus.Failed then
		p2.props.dispatchFetchIAPProducts(p2.props.networking)
	end
end
function v17.render(p3) -- line: 74
	-- upvalues: Roact (copy), LocaleProvider (copy), LocalizationService (copy), PremiumUpsellOverlay (copy), PremiumUpsellTriggerContext (copy)
	return Roact.createElement(LocaleProvider, {
		locale = LocalizationService.RobloxLocaleId
	}, {
		PremiumUpsellOverlay = Roact.createElement(PremiumUpsellOverlay, {
			screenSize = p3.props.screenSize,
			currencySymbol = if not p3.props.subscriptionProduct then nil else p3.props.subscriptionProduct.currencySymbol,
			robuxPrice = if not p3.props.subscriptionProduct then nil else p3.props.subscriptionProduct.price,
			robuxAmount = if not p3.props.subscriptionProduct then nil else p3.props.subscriptionProduct.robuxAmount,
			iapProductsFetchingStatus = p3.props.iapProductsFetchingStatus,
			promptPremium = p3.promptPremium,
			cancelPurchase = p3.cancelPurchase,
			endPurchase = p3.endPurchase,
			sendAnalyticEvent = p3.sendAnalyticEvent,
			sendCounter = p3.sendCounter,
			eventPrefix = PremiumUpsellTriggerContext.toRawValue(p3.props.triggerContext),
			dispatchCentralOverlay = p3.props.dispatchCentralOverlay
		})
	})
end

local v18 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v17)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics
})(v18))))))
