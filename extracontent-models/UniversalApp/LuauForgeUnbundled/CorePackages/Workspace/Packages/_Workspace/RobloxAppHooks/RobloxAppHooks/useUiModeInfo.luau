local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/React")

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppEnums")
local deviceType = RobloxAppEnums.DeviceType
local uiMode = RobloxAppEnums.UiMode
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppHooks/useDeviceType")

local v5 = {
	[deviceType.Desktop] = uiMode.Unknown,
	[deviceType.Tablet] = uiMode.Unknown,
	[deviceType.Phone] = uiMode.Unknown,
	[deviceType.Console] = uiMode.TenFoot,
	[deviceType.VR] = uiMode.VR
}

local function useUiModeInfo()
	local v6 = useDeviceType()
	local v7 = v5[v6] or uiMode.Unknown

	return (React.useMemo(function()
		return { deviceType = v6, uiMode = v7 }
	end, { v6, v7 }))
end

return useUiModeInfo
