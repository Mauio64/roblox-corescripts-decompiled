local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local MockableProxyServices = require(parent2.MockableProxyServices)
local UserInputService = MockableProxyServices.UserInputService

local Placement = require(parent.Enum.Placement)
local Mocks = require(parent.Mocks)

local function useNavBarPlacement()
	local v = useDeviceOrientation() == DeviceOrientationMode.Portrait

	local state, setState = React.useState(UserInputService.TouchEnabled)
	React.useEffect(function()
		setState(UserInputService.TouchEnabled)
		local touchEnabledChangedConnection = UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function()
			setState(UserInputService.TouchEnabled)
		end)
		return function()
			touchEnabledChangedConnection:Disconnect()
		end
	end, {})

	if Mocks.navBarPlacement ~= nil then
		return Mocks.navBarPlacement
	end

	return if state and v then Placement.Bottom else Placement.Left
end

return useNavBarPlacement
