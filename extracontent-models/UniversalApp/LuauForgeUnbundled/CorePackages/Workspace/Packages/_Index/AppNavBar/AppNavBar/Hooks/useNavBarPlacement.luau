local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/React")
local useDeviceOrientation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RobloxAppHooks").useDeviceOrientation
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RobloxAppEnums").DeviceOrientationMode

local userInputService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/MockableProxyServices").UserInputService

local Placement = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Enum/Placement")
local Mocks = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Mocks")

local function useNavBarPlacement()
	local v5 = useDeviceOrientation() == deviceOrientationMode.Portrait

	local state, setState = React.useState(userInputService.TouchEnabled)
	React.useEffect(function()
		setState(userInputService.TouchEnabled)
		local touchEnabledChangedConnection = userInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function()
			setState(userInputService.TouchEnabled)
		end)
		return function()
			touchEnabledChangedConnection:Disconnect()
		end
	end, {})

	if Mocks.navBarPlacement ~= nil then
		return Mocks.navBarPlacement
	end

	if state and v5 then
		return Placement.Bottom
	end

	return Placement.Left
end

return useNavBarPlacement
