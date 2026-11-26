local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local SubscriptionPurchaseInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SubscriptionPurchaseInfoReceived")
local getPreviewImageUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/getPreviewImageUrl")

return (rodux.createReducer({}, {
	[SubscriptionPurchaseInfoReceived.name] = function(p2, p3)
		p3.subscriptionPurchaseInfo.ImageUrl = getPreviewImageUrl(p3.subscriptionPurchaseInfo)
		return p3.subscriptionPurchaseInfo
	end,
	[CompleteRequest.name] = function(p2, p3)
		return {}
	end
}))
