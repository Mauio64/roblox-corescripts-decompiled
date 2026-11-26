local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")

return rodux.createReducer({}, {
	[ErrorOccurred.name] = function(p2, p3)
		return p3.purchaseError
	end,
	[CompleteRequest.name] = function(p2, p3)
		return {}
	end
})
