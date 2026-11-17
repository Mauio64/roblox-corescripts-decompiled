local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Signals = require(parent.Signals)

local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
require(RobloxSubscriptionPurchaseApp.types)

local v = nil

local function fn()
	local signal, setPromptState = Signals.createSignal(PromptState.Unspecified)

	local signal2, setRobloxSubscriptionProduct = Signals.createSignal(nil)
	local signal3, setDidTryPurchasing = Signals.createSignal(false)
	local signal4, setPurchaseUIOptions = Signals.createSignal({})
	local signal5, setPaymentSessionId = Signals.createSignal("")
	local signal6, setIsNativePurchase = Signals.createSignal(false)
	local signal7, setEntryContext = Signals.createSignal({})
	local signal8, setPurchaseFlowOptions = Signals.createSignal({})
	local signal9, setErrorReason = Signals.createSignal(nil)
	local signal10, setReferrerId = Signals.createSignal(nil)

	local getRobloxSubscriptionProductId = Signals.createComputed(function(p)
		local v2 = signal2(p)

		return v2 and v2.ProductKey and v2.ProductKey.Id or ""
	end)

	local v2 = nil
	local v3 = nil
	local v4 = nil
	local v5 = nil
	local membershipConfigSnapshot = nil

	local function setOnFlowComplete(callback)
		v2 = callback
	end

	local function triggerOnFlowComplete(p)
		if v2 then
			v2(p)
		end
	end

	local function setOnBackButtonActivated(callback)
		v4 = callback
	end

	local function triggerOnBackButtonActivated()
		if v4 then
			v4()
		end
	end

	local function setOnCtaOverride(p)
		v5 = p
	end

	local function getOnCtaOverride()
		return v5
	end

	local function setMembershipConfigSnapshot(p)
		membershipConfigSnapshot = p
	end

	local function getMembershipConfigSnapshot()
		return membershipConfigSnapshot
	end

	local function setOnUnmountUI(callback)
		v3 = callback
	end

	local function triggerUnmountUI()
		if v3 then
			v3()
			v3 = nil
		end
	end

	return {
		getPromptState = signal,
		setPromptState = setPromptState,
		getRobloxSubscriptionProduct = signal2,
		setRobloxSubscriptionProduct = setRobloxSubscriptionProduct,
		getPurchaseFlowOptions = signal8,
		setPurchaseFlowOptions = setPurchaseFlowOptions,
		getDidTryPurchasing = signal3,
		setDidTryPurchasing = setDidTryPurchasing,
		getPaymentSessionId = signal5,
		setPaymentSessionId = setPaymentSessionId,
		getEntryContext = signal7,
		setEntryContext = setEntryContext,
		getErrorReason = signal9,
		setErrorReason = setErrorReason,
		getReferrerId = signal10,
		setReferrerId = setReferrerId,
		setOnFlowComplete = setOnFlowComplete,
		triggerOnFlowComplete = triggerOnFlowComplete,
		getPurchaseUIOptions = signal4,
		setPurchaseUIOptions = setPurchaseUIOptions,
		getIsNativePurchase = signal6,
		setIsNativePurchase = setIsNativePurchase,
		getRobloxSubscriptionProductId = getRobloxSubscriptionProductId,
		setOnUnmountUI = setOnUnmountUI,
		triggerUnmountUI = triggerUnmountUI,
		setOnBackButtonActivated = setOnBackButtonActivated,
		triggerOnBackButtonActivated = triggerOnBackButtonActivated,
		setOnCtaOverride = setOnCtaOverride,
		getOnCtaOverride = getOnCtaOverride,
		setMembershipConfigSnapshot = setMembershipConfigSnapshot,
		getMembershipConfigSnapshot = getMembershipConfigSnapshot
	}
end

local RobloxSubscriptionStore = {}

function RobloxSubscriptionStore.get()
	if v == nil then
		v = Signals.createComputed(fn)(false)
	end

	return v
end

function RobloxSubscriptionStore.cleanup()
	v = nil
end

return RobloxSubscriptionStore
