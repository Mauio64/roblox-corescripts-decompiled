local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PlatformInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PlatformInterface")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local v5 = { PlatformInterface }

local function openRobuxStore()
	return Thunk.new("openRobuxStore", v5, function(object, p2)
		local v6 = p2[PlatformInterface]

		object:dispatch(SetPromptState(PromptState.UpsellInProgress))
		v6.openRobuxStore()
	end)
end

return openRobuxStore
