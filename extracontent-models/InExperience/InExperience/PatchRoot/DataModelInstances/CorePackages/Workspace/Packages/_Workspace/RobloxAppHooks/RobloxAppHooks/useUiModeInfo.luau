local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local React = require(parent.React)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType
local UiMode = RobloxAppEnums.UiMode
local useDeviceType = require(script.Parent.useDeviceType)

local v = {
	[DeviceType.Desktop] = UiMode.Unknown,
	[DeviceType.Tablet] = UiMode.Unknown,
	[DeviceType.Phone] = UiMode.Unknown,
	[DeviceType.Console] = UiMode.TenFoot,
	[DeviceType.VR] = UiMode.VR
}

local function useUiModeInfo()
	local deviceType = useDeviceType()
	local uiMode = v[deviceType] or UiMode.Unknown

	return (React.useMemo(function()
		return { deviceType = deviceType, uiMode = uiMode }
	end, { deviceType, uiMode }))
end

return useUiModeInfo
