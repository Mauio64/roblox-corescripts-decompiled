local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetProductPayload")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagPromptPurchaseClearStateOnCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagPromptPurchaseClearStateOnCompletion")

local v5 = {}

return (rodux.createReducer(v5, {
	[SetProductPayload.name] = function(p2, p3)
		return p3.productPayload
	end,
	[CompleteRequest.name] = function(p2, p3)
		if fFlagEnableUnifiedPurchaseFlowForDevSubs and p2.kind == "DeveloperSubscription" or FFlagPromptPurchaseClearStateOnCompletion then
			return v5
		end

		return p2
	end
}))
