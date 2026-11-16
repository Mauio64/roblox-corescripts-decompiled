local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetWindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetWindowState")
local ButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ButtonState")

return rodux.createReducer(ButtonState.Enabled, {
	[SetWindowState.name] = function(p2, p3)
		return p3.state
	end
})
