local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Signals")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxSubscriptionFlowCompleteReason")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")

local v5 = nil

local function fn()
	local signal, v6 = Signals.createSignal(PromptState.Unspecified)

	local signal2, v7 = Signals.createSignal(nil)
	local signal3, v8 = Signals.createSignal(false)
	local signal4, v9 = Signals.createSignal({})
	local signal5, v10 = Signals.createSignal("")
	local signal6, v11 = Signals.createSignal(false)
	local signal7, v12 = Signals.createSignal({})
	local signal8, v13 = Signals.createSignal({})
	local signal9, v14 = Signals.createSignal(nil)
	local signal10, v15 = Signals.createSignal(nil)

	local computed = Signals.createComputed(function(p2)
		local v16 = signal2(p2)

		return v16 and v16.ProductKey and v16.ProductKey.Id or ""
	end)

	local v16 = nil
	local v17 = nil
	local v18 = nil
	local v19 = nil

	local function setOnFlowComplete(p2)
		v16 = p2
	end

	local function triggerOnFlowComplete(p2)
		if v16 then
			v16(p2)
		end
	end

	local function setOnBackButtonActivated(p2)
		v18 = p2
	end

	local function triggerOnBackButtonActivated()
		if v18 then
			v18()
		end
	end

	local function setOnCtaOverride(p2)
		v19 = p2
	end

	local function getOnCtaOverride()
		return v19
	end

	local function setOnUnmountUI(p2)
		v17 = p2
	end

	local function triggerUnmountUI()
		if v17 then
			v17()
			v17 = nil
		end
	end

	return {
		getPromptState = signal,
		setPromptState = v6,
		getRobloxSubscriptionProduct = signal2,
		setRobloxSubscriptionProduct = v7,
		getPurchaseFlowOptions = signal8,
		setPurchaseFlowOptions = v13,
		getDidTryPurchasing = signal3,
		setDidTryPurchasing = v8,
		getPaymentSessionId = signal5,
		setPaymentSessionId = v10,
		getEntryContext = signal7,
		setEntryContext = v12,
		getErrorReason = signal9,
		setErrorReason = v14,
		getReferrerId = signal10,
		setReferrerId = v15,
		setOnFlowComplete = setOnFlowComplete,
		triggerOnFlowComplete = triggerOnFlowComplete,
		getPurchaseUIOptions = signal4,
		setPurchaseUIOptions = v9,
		getIsNativePurchase = signal6,
		setIsNativePurchase = v11,
		getRobloxSubscriptionProductId = computed,
		setOnUnmountUI = setOnUnmountUI,
		triggerUnmountUI = triggerUnmountUI,
		setOnBackButtonActivated = setOnBackButtonActivated,
		triggerOnBackButtonActivated = triggerOnBackButtonActivated,
		setOnCtaOverride = setOnCtaOverride,
		getOnCtaOverride = getOnCtaOverride
	}
end

return {
	get = function()
		if v5 == nil then
			v5 = Signals.createComputed(fn)(false)
		end

		return v5
	end,
	cleanup = function()
		v5 = nil
	end
}
