local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Display").shouldUseDeviceSafeInsets

local function readStatusBarHeight()
	if shouldUseDeviceSafeInsets then
		return 0
	end

	local statusBarSize = UserInputService.StatusBarSize

	if statusBarSize then
		return statusBarSize.Y
	end

	return 0
end

return function()
	local state, setState = React.useState(function()
		if shouldUseDeviceSafeInsets then
			return 0
		end

		local statusBarSize = UserInputService.StatusBarSize

		if statusBarSize then
			return statusBarSize.Y
		end

		return 0
	end)

	React.useEffect(function()
		local v6

		if shouldUseDeviceSafeInsets then
			v6 = 0
		else
			local statusBarSize = UserInputService.StatusBarSize
			v6 = not statusBarSize and 0 or statusBarSize.Y
		end

		setState(v6)

		local statusBarSizeChangedConnection = UserInputService:GetPropertyChangedSignal("StatusBarSize"):Connect(function()
			local v8

			if shouldUseDeviceSafeInsets then
				v8 = 0
			else
				local statusBarSize = UserInputService.StatusBarSize
				v8 = not statusBarSize and 0 or statusBarSize.Y
			end

			setState(v8)
		end)

		return function()
			statusBarSizeChangedConnection:Disconnect()
		end
	end, {})

	return state
end
