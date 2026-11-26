local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/ecq")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation

local localeProvider = require("@luauforge/deferred/gKv").Locale.LocaleProvider

require("@luauforge/deferred/gWx")
local module3 = require("@luauforge/deferred/gWI")
local module4 = require("@luauforge/deferred/gWP")
local module5 = require("@luauforge/deferred/gWQ")

local module6 = require("@luauforge/bundled/dAB")

local module7 = require("@luauforge/deferred/gWO")

local extended = Roact.PureComponent:extend("BuyRobuxContainer")

local default = require("@luauforge/bundled/gWy").PaymentsProtocol.default

local getFFlagUseEnablePremiumUserFeaturesAppPolicy = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseEnablePremiumUserFeaturesAppPolicy

local module8 = require("@luauforge/deferred/gWW")

function extended:init()
	function self.endPurchase()
		self.props.dispatchClearNativePurchaseResult()
	end

	function self.sendAnalyticEvent(p3, p4, p5)
		self.props.analytics.EventStream:setRBXEventStream(p3, p4, p5)
	end

	function self.sendCounter(p3)
		self.props.analytics.Diag:reportCounter(p3, 1)
	end

	function self.dispatchFetchIAPPurchaseWarning(p3, p4)
		return self.props.dispatchFetchIAPPurchaseWarning(
			self.props.networking,
			p3,
			p4,
			self.props.isPremium
		)
	end

	function self.dispatchPostAckPurchaseWarning(p3)
		return self.props.dispatchPostAckPurchaseWarning(self.props.networking, p3)
	end

	function self.dispatchCheckUserPurchaseSettings()
		return self.props.dispatchCheckUserPurchaseSettings(self.props.networking)
	end

	function self.onWillUnmount()
		default:isAvailable():andThen(function(p3)
			if p3 then
				default:sendIAPEvent("BrowseProductEnd")
			end
		end)
	end
end

function extended.didMount(p2)
	local props = p2.props

	if
		p2.props.iapProductsFetchingStatus == module6.NotStarted
		or p2.props.iapProductsFetchingStatus == module6.Failed
	then
		p2.props.dispatchFetchIAPProducts(p2.props.networking)
	end

	if
		p2.props.nativeProductsFetchingStatus == module6.NotStarted
		or p2.props.nativeProductsFetchingStatus == module6.Failed
	then
		p2.props.dispatchFetchNativeIAPProducts()
	end

	default:isAvailable():andThen(function(p3)
		if p3 then
			default:sendIAPEvent("BrowseProductStart")
		end
	end)

	if module8() then
		props.dispatchFetchUserBalance(p2.props.networking, (tostring(p2.props.userId)))
	end
end

function extended.didUpdate(p2, p3)
	local props = p2.props

	if
		props.iapProductsFetchingStatus ~= p3.iapProductsFetchingStatus
		and props.iapProductsFetchingStatus == module6.Failed
	then
		p2.sendCounter(module7.toRawValue(module7.InvalidProducts))
	end

	local v5

	if props.iapProductsFetchingStatus == module6.Done then
		v5 = props.nativeProductsFetchingStatus == module6.Done
	else
		v5 = false
	end

	if v5 and #props.robuxPackages == 0 then
		default:isAvailable():andThen(function(p4)
			if p4 then
				default:sendIAPEvent("ProductNotAvailable")
			end
		end)
		p2.props.dispatchNavigateBack()
	end
end

function extended.render(props)
	return Roact.createElement(localeProvider, {
		locale = LocalizationService.RobloxLocaleId
	}, {
		BuyRobuxOverlay = Roact.createElement(module3, {
			screenSize = props.props.screenSize,
			networking = props.props.networking,
			robuxBalance = props.props.robuxBalance,
			robuxPackages = props.props.robuxPackages,
			analyticId = props.props.analyticId,
			iapPurchase = props.props.iapPurchase,
			iapProductsFetchingStatus = props.props.iapProductsFetchingStatus,
			nativeProductsFetchingStatus = props.props.nativeProductsFetchingStatus,
			dispatchFetchIAPPurchaseWarning = props.dispatchFetchIAPPurchaseWarning,
			dispatchPostAckPurchaseWarning = props.dispatchPostAckPurchaseWarning,
			dispatchCentralOverlay = props.props.dispatchCentralOverlay,
			dispatchCheckUserPurchaseSettings = props.dispatchCheckUserPurchaseSettings,
			endPurchase = props.endPurchase,
			promptRobux = props.props.promptRobux,
			sendAnalyticEvent = props.sendAnalyticEvent,
			sendCounter = props.sendCounter,
			eventPrefix = "",
			onPageClose = props.props.dispatchNavigateBack
		})
	})
end

function extended.willUnmount(p2)
	p2.onWillUnmount()
end

local v5 = RoactRodux.connect(module4, module5)(extended)

if getFFlagUseEnablePremiumUserFeaturesAppPolicy() then
	v5 = roactAppPolicy.connect(function(p2, p3)
		return {
			enablePremiumUserFeatures = p2.getEnablePremiumUserFeatures()
		}
	end)(v5)
end

return (withNavigation((roactServices.connect({
	networking = module,
	analytics = module2,
	linking = appLinking
})(v5))))
