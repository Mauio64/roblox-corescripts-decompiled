local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)

local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets

local function readStatusBarHeight() -- 3 equivalent calls inferred from this helper
	if shouldUseDeviceSafeInsets then
		return 0
	end

	local statusBarSize = UserInputService.StatusBarSize
	return if statusBarSize then statusBarSize.Y else 0
end

return function()
	local state, setState = React.useState(function()
		return readStatusBarHeight() -- inferred equivalent call
	end)

	React.useEffect(function()
		setState(readStatusBarHeight()) -- inferred equivalent call

		local statusBarSizeChangedConnection = UserInputService:GetPropertyChangedSignal("StatusBarSize"):Connect(function()
			setState(readStatusBarHeight()) -- inferred equivalent call
		end)

		return function()
			statusBarSizeChangedConnection:Disconnect()
		end
	end, {})

	return state
end
