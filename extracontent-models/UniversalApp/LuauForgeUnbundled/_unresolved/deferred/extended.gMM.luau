local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/deferred/gKv")
local premiumUpsellFlow = module.PurchaseFlow.PremiumUpsellFlow
local premiumUpsellFlowState = module.PurchaseFlow.PremiumUpsellFlowState
local purchaseErrorType = module.PurchaseFlow.PurchaseErrorType

local module2 = require("@luauforge/bundled/dAB")

local module3 = require("@luauforge/deferred/gMN")

local extended = Roact.PureComponent:extend("PremiumUpsellOverlay")

function extended:init()
	self.state = { errorType = purchaseErrorType.None }

	function self.failFlow(errorType, p2)
		self.sendCounter(module3.Failed)

		local v5 = p2 == nil and {} or p2

		if errorType == nil then
			v5.errorType = purchaseErrorType.Unknown
		else
			v5.errorType = errorType
		end

		self:setState(v5)
	end

	function self.purchasePremium()
		self.sendCounter(module3.Confirmed)
		self.props.promptPremium()
	end

	function self.cancelPurchase()
		self.sendCounter(module3.Cancelled)
		self.props.cancelPurchase()
	end

	function self.flowComplete()
		self.props.endPurchase()
	end

	function self.sendAnalyticEvent(p2, p3)
		self.props.sendAnalyticEvent(self.props.eventPrefix .. "PremiumUpsell", p2, p3)
	end

	function self.sendCounter(p2)
		self.props.sendCounter(module3.toRawValue(p2))
	end
end

function extended.didMount(p2)
	p2.sendCounter(module3.Shown)
end

function extended.didUpdate(data, p2)
	local props = data.props

	if
		props.iapProductsFetchingStatus ~= p2.iapProductsFetchingStatus
		and props.iapProductsFetchingStatus == module2.Failed
	then
		data.sendCounter(module3.InvalidProducts)
		data.failFlow()
	end
end

function extended:getFlowState()
	local state = self.state
	local props = self.props

	if state.errorType ~= purchaseErrorType.None then
		return premiumUpsellFlowState.Error
	end

	if props.iapProductsFetchingStatus ~= module2.Done then
		return premiumUpsellFlowState.None
	end

	if props.robuxPrice == nil then
		return premiumUpsellFlowState.Error
	end

	return premiumUpsellFlowState.PurchaseModal
end

function extended:getErrorType()
	return self.state.errorType
end

function extended:render()
	local props2 = self.props

	return Roact.createElement(premiumUpsellFlow, {
		screenSize = props2.screenSize,
		currencySymbol = props2.currencySymbol,
		robuxPrice = props2.robuxPrice,
		robuxAmount = props2.robuxAmount,
		purchaseState = self:getFlowState(),
		errorType = self:getErrorType(),
		purchasePremium = self.purchasePremium,
		cancelPurchase = self.cancelPurchase,
		flowComplete = self.flowComplete,
		onAnalyticEvent = self.sendAnalyticEvent,
		eventPrefix = props2.eventPrefix,
		dispatchCentralOverlay = props2.dispatchCentralOverlay
	})
end

return extended
