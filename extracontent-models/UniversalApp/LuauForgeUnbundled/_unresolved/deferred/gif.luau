local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local localeProvider = require("@luauforge/deferred/gfP").Locale.LocaleProvider

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")
local module2 = require("@luauforge/bundled/dYT")

local module3 = require("@luauforge/bundled/dxy")

local module4 = require("@luauforge/deferred/gig")
local module5 = require("@luauforge/deferred/fvr")
local module6 = require("@luauforge/deferred/gii")
local module7 = require("@luauforge/deferred/gim")

local module8 = require("@luauforge/deferred/gfc")

local module9 = require("@luauforge/deferred/gfb")

local extended = Roact.PureComponent:extend("PremiumUpsellContainer")

function extended:init()
	function self.closeCentralOverlay()
		self.props.navigation.goBack()
	end

	function self.promptPremium()
		self.endPurchase()
		self.props.promptPremium()
	end

	function self.cancelPurchase()
		self.endPurchase()

		if self.props.onCancel then
			self.props.onCancel()
		end
	end

	function self.endPurchase()
		self.props.navigation.goBack()

		if self.props.onOverlayClosed then
			self.props.onOverlayClosed()
		end
	end

	function self.sendAnalyticEvent(p2, p3, p4)
		self.props.analytics.EventStream:setRBXEventStream(p2, p3, p4)
	end

	function self.sendCounter(p2)
		local diag = self.props.analytics.Diag
		local rawValue = module5.toRawValue(self.props.triggerContext)
		diag:reportCounter(p2, 1)
		diag:reportCounter(rawValue .. p2, 1)
	end
end

function extended.didMount(p2)
	if
		p2.props.iapProductsFetchingStatus == module3.NotStarted
		or p2.props.iapProductsFetchingStatus == module3.Failed
	then
		p2.props.dispatchFetchIAPProducts(p2.props.networking)
	end
end

function extended.render(props)
	local createElement = Roact.createElement
	local v6 = { locale = LocalizationService.RobloxLocaleId }

	local createElement2 = Roact.createElement
	local v9 = {
		screenSize = props.props.screenSize,
		currencySymbol = 0,
		robuxPrice = 0,
		robuxAmount = 0,
		iapProductsFetchingStatus = 0,
		promptPremium = 0,
		cancelPurchase = 0,
		endPurchase = 0,
		sendAnalyticEvent = 0,
		sendCounter = 0,
		eventPrefix = 0,
		dispatchCentralOverlay = 0
	}

	local v10 = if props.props.subscriptionProduct then props.props.subscriptionProduct.currencySymbol else nil
	v9.currencySymbol = v10

	local v11 = if props.props.subscriptionProduct then props.props.subscriptionProduct.price else nil
	v9.robuxPrice = v11
	local v12 = if props.props.subscriptionProduct then props.props.subscriptionProduct.robuxAmount else nil
	v9.robuxAmount = v12

	v9.iapProductsFetchingStatus = props.props.iapProductsFetchingStatus

	v9.promptPremium = props.promptPremium
	v9.cancelPurchase = props.cancelPurchase
	v9.endPurchase = props.endPurchase

	v9.sendAnalyticEvent = props.sendAnalyticEvent
	v9.sendCounter = props.sendCounter

	v9.eventPrefix = module5.toRawValue(props.props.triggerContext)

	v9.dispatchCentralOverlay = props.props.dispatchCentralOverlay
	return createElement(localeProvider, v6, {
		PremiumUpsellOverlay = createElement2(module4, v9)
	})
end

local v5 = RoactRodux.connect(module6, module7)(extended)

return (module9((module8((roactServices.connect({
	networking = module,
	analytics = module2
})(v5))))))
