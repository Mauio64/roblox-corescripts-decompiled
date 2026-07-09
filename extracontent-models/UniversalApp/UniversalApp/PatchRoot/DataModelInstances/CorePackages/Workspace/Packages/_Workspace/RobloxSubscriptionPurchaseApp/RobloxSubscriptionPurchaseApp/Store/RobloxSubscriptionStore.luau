local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Signals = require(RobloxSubscriptionPurchaseAppParent.Signals)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
require(RobloxSubscriptionPurchaseApp.types)

local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)
local u6 = nil

local function v7() -- line: 57
	-- upvalues: Signals (copy), PromptState (copy), FFlagRobloxPlusFAEFreeTrial (copy)
	local v8, v9 = Signals.createSignal(PromptState.Unspecified)
	local v10, v11 = Signals.createSignal(nil)
	local v12, v13 = Signals.createSignal(false)
	local v14, v15 = Signals.createSignal({})
	local v16, v17 = Signals.createSignal("")
	local v18, v19 = Signals.createSignal(false)
	local v20, v21 = Signals.createSignal({})
	local v22, v23 = Signals.createSignal({})
	local v24, v25 = Signals.createSignal(nil)
	local v26 = Signals.createComputed(function(p1) -- line: 69
		-- upvalues: v10 (copy)
		local v32 = v10(p1)

		return v32 and (not not v32.ProductKey and v32.ProductKey.Id) or ""
	end)
	local u27 = nil
	local u28 = nil
	local u29 = nil
	local u30 = nil

	return {
		getPromptState = v8,
		setPromptState = v9,
		getRobloxSubscriptionProduct = v10,
		setRobloxSubscriptionProduct = v11,
		getPurchaseFlowOptions = v22,
		setPurchaseFlowOptions = v23,
		getDidTryPurchasing = v12,
		setDidTryPurchasing = v13,
		getPaymentSessionId = v16,
		setPaymentSessionId = v17,
		getEntryContext = v20,
		setEntryContext = v21,
		getErrorReason = v24,
		setErrorReason = v25,
		setOnFlowComplete = function(p2: ((...any) -> ...any)) -- line: 81
			-- upvalues: u27 (ref)
			u27 = p2
		end,
		triggerOnFlowComplete = function(p3) -- line: 85
			-- upvalues: u27 (ref)
			if u27 then
				u27(p3)
			end
		end,
		getPurchaseUIOptions = v14,
		setPurchaseUIOptions = v15,
		getIsNativePurchase = v18,
		setIsNativePurchase = v19,
		getRobloxSubscriptionProductId = v26,
		setOnUnmountUI = function(p4: ((...any) -> ...any)?) -- line: 115
			-- upvalues: u28 (ref)
			u28 = p4
		end,
		triggerUnmountUI = function() -- line: 119
			-- upvalues: u28 (ref)
			if u28 then
				u28()
				u28 = nil
			end
		end,
		setOnBackButtonActivated = function(p5: ((...any) -> ...any)?) -- line: 91
			-- upvalues: u29 (ref)
			u29 = p5
		end,
		triggerOnBackButtonActivated = function() -- line: 95
			-- upvalues: u29 (ref)
			if u29 then
				u29()
			end
		end,
		setOnCtaOverride = function(p6: ((...any) -> ...any)?) -- line: 101
			-- upvalues: FFlagRobloxPlusFAEFreeTrial (copy), u30 (ref)
			if not FFlagRobloxPlusFAEFreeTrial then
				return
			end

			u30 = p6
		end,
		getOnCtaOverride = function() -- line: 108
			-- upvalues: FFlagRobloxPlusFAEFreeTrial (copy), u30 (ref)
			if not FFlagRobloxPlusFAEFreeTrial then
				return nil
			end

			return u30
		end
	}
end

return {
	get = function() -- line: 159
		-- upvalues: u6 (ref), Signals (copy), v7 (copy)
		if u6 == nil then
			u6 = Signals.createComputed(v7)(false)
		end

		return u6
	end,
	cleanup = function() -- line: 166
		-- upvalues: u6 (ref)
		u6 = nil
	end
}
