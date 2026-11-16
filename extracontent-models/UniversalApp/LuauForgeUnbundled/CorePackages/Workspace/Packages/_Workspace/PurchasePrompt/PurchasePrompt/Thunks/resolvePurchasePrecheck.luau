local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseWarning")
local launchRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/launchRobuxUpsell")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local function resolvePurchasePrecheck(p2)
	return Thunk.new("resolvePurchasePrecheck", {}, function(object, p3)
		if p2 == PurchaseWarning.U13PaymentModal then
			return object:dispatch(SetPromptState(PromptState.U13PaymentModal))
		end

		if p2 == PurchaseWarning.U13MonthlyThreshold1Modal then
			return object:dispatch(SetPromptState(PromptState.U13MonthlyThreshold1Modal))
		end

		if p2 == PurchaseWarning.RequireEmailVerification then
			return object:dispatch(SetPromptState(PromptState.RequireEmailVerification))
		end

		if p2 == PurchaseWarning.U13MonthlyThreshold2Modal then
			return object:dispatch(SetPromptState(PromptState.U13MonthlyThreshold2Modal))
		end

		if p2 == PurchaseWarning.ParentalConsentWarningPaymentModal13To17 then
			return object:dispatch(SetPromptState(PromptState.ParentalConsentWarningPaymentModal13To17))
		end

		return object:dispatch(launchRobuxUpsell())
	end)
end

return resolvePurchasePrecheck
