local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local PurchaseCompleteRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PurchaseCompleteRecieved")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")

return rodux.createReducer(false, {
	[PurchaseCompleteRecieved.name] = function(p2, p3): boolean
		return true
	end,
	[CompleteRequest.name] = function(p2, p3): boolean
		return false
	end
})
