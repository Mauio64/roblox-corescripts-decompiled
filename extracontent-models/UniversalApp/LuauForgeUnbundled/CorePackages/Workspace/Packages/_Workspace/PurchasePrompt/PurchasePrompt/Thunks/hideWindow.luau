local SetButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetButtonState")
local WindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/WindowState")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local function hideWindow()
	return Thunk.new("hideWindow", {}, function(object, p2)
		return object:dispatch(SetButtonState(WindowState.Hidden))
	end)
end

return hideWindow
