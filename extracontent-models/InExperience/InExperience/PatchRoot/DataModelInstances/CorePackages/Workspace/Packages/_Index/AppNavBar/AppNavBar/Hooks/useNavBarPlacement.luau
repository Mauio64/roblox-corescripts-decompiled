local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local useDeviceOrientation = require(ParentParentParent.RobloxAppHooks).useDeviceOrientation
local DeviceOrientationMode = require(ParentParentParent.RobloxAppEnums).DeviceOrientationMode
local UserInputService = require(ParentParentParent.MockableProxyServices).UserInputService
local Placement = require(ParentParent.Enum.Placement)
local Mocks = require(ParentParent.Mocks)

local function useNavBarPlacement() -- line: 17
	-- upvalues: useDeviceOrientation (copy), DeviceOrientationMode (copy), React (copy), UserInputService (copy), Mocks (copy), Placement (copy)
	local v10 = useDeviceOrientation() == DeviceOrientationMode.Portrait
	local v11, v12 = React.useState(UserInputService.TouchEnabled)

	React.useEffect(function() -- line: 22
		-- upvalues: v12 (copy), UserInputService (copy)
		v12(UserInputService.TouchEnabled)

		local connection = UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function() -- line: 24
			-- upvalues: v12 (copy), UserInputService (copy)
			v12(UserInputService.TouchEnabled)
		end)

		return function() -- line: 27
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	if Mocks.navBarPlacement ~= nil then
		return Mocks.navBarPlacement
	end

	if v11 and v10 then
		return Placement.Bottom
	end

	return Placement.Left
end

return useNavBarPlacement
