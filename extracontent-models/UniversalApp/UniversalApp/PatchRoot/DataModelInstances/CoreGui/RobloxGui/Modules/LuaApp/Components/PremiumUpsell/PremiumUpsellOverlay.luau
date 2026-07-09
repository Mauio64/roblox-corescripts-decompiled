local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local PremiumUpsellFlow = IAPExperience.PurchaseFlow.PremiumUpsellFlow
local PremiumUpsellFlowState = IAPExperience.PurchaseFlow.PremiumUpsellFlowState
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local PremiumUpsellCounter = require(script.Parent.Enum.PremiumUpsellCounter)
local v10 = Roact.PureComponent:extend(script.Name)

function v10.init(p1) -- line: 42
	-- upvalues: PurchaseErrorType (copy), PremiumUpsellCounter (copy)
	p1.state = {
		errorType = PurchaseErrorType.None
	}

	function p1.failFlow(p2, p3) -- line: 47
		-- upvalues: p1 (copy), PremiumUpsellCounter (copy), PurchaseErrorType (copy)
		p1.sendCounter(PremiumUpsellCounter.Failed)

		local t1 = {}

		if p3 ~= nil then
			t1 = p3
		end

		if p2 ~= nil then
			t1.errorType = p2
		else
			t1.errorType = PurchaseErrorType.Unknown
		end

		p1:setState(t1)
	end
	function p1.purchasePremium() -- line: 63
		-- upvalues: p1 (copy), PremiumUpsellCounter (copy)
		p1.sendCounter(PremiumUpsellCounter.Confirmed)
		p1.props.promptPremium()
	end
	function p1.cancelPurchase() -- line: 68
		-- upvalues: p1 (copy), PremiumUpsellCounter (copy)
		p1.sendCounter(PremiumUpsellCounter.Cancelled)
		p1.props.cancelPurchase()
	end
	function p1.flowComplete() -- line: 73
		-- upvalues: p1 (copy)
		p1.props.endPurchase()
	end
	function p1.sendAnalyticEvent(s1: string, t2: {[any]: any}) -- line: 77
		-- upvalues: p1 (copy)
		p1.props.sendAnalyticEvent(p1.props.eventPrefix .. "PremiumUpsell", s1, t2)
	end
	function p1.sendCounter(p4) -- line: 81
		-- upvalues: p1 (copy), PremiumUpsellCounter (copy)
		p1.props.sendCounter(PremiumUpsellCounter.toRawValue(p4))
	end
end
function v10.didMount(p5) -- line: 86
	-- upvalues: PremiumUpsellCounter (copy)
	p5.sendCounter(PremiumUpsellCounter.Shown)
end
function v10.didUpdate(t3: {[any]: any}, t4: {[any]: any}) -- line: 90
	-- upvalues: RetrievalStatus (copy), PremiumUpsellCounter (copy)
	local props = t3.props

	if props.iapProductsFetchingStatus ~= t4.iapProductsFetchingStatus and props.iapProductsFetchingStatus == RetrievalStatus.Failed then
		t3.sendCounter(PremiumUpsellCounter.InvalidProducts)
		t3.failFlow()
	end
end
function v10.getFlowState(p6) -- line: 101
	-- upvalues: PurchaseErrorType (copy), PremiumUpsellFlowState (copy), RetrievalStatus (copy)
	local state = p6.state
	local props = p6.props

	if state.errorType ~= PurchaseErrorType.None then
		return PremiumUpsellFlowState.Error
	end

	if props.iapProductsFetchingStatus ~= RetrievalStatus.Done then
		return PremiumUpsellFlowState.None
	end

	if props.robuxPrice ~= nil then
		return PremiumUpsellFlowState.PurchaseModal
	end

	return PremiumUpsellFlowState.Error
end
function v10.getErrorType(p7) -- line: 122
	return p7.state.errorType
end
function v10.render(p8) -- line: 128
	-- upvalues: Roact (copy), PremiumUpsellFlow (copy)
	local props = p8.props

	return Roact.createElement(PremiumUpsellFlow, {
		screenSize = props.screenSize,
		currencySymbol = props.currencySymbol,
		robuxPrice = props.robuxPrice,
		robuxAmount = props.robuxAmount,
		purchaseState = p8:getFlowState(),
		errorType = p8:getErrorType(),
		purchasePremium = p8.purchasePremium,
		cancelPurchase = p8.cancelPurchase,
		flowComplete = p8.flowComplete,
		onAnalyticEvent = p8.sendAnalyticEvent,
		eventPrefix = props.eventPrefix,
		dispatchCentralOverlay = props.dispatchCentralOverlay
	})
end

return v10
