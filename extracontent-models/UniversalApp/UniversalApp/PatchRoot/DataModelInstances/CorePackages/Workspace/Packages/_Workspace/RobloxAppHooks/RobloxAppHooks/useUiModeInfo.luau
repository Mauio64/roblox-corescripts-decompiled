local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local React = require(Parent.React)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType
local UiMode = RobloxAppEnums.UiMode
local useDeviceType = require(script.Parent.useDeviceType)
local t1 = {
	[DeviceType.Desktop] = UiMode.Unknown,
	[DeviceType.Tablet] = UiMode.Unknown,
	[DeviceType.Phone] = UiMode.Unknown,
	[DeviceType.Console] = UiMode.TenFoot,
	[DeviceType.VR] = UiMode.VR
}

local function useUiModeInfo() -- line: 36
	-- upvalues: useDeviceType (copy), t1 (copy), UiMode (copy), React (copy)
	local v9 = useDeviceType()
	local v10 = t1[v9] or UiMode.Unknown

	return (React.useMemo(function() -- line: 40
		-- upvalues: v9 (copy), v10 (copy)
		return {
			deviceType = v9,
			uiMode = v10
		}
	end, {
		v9,
		v10
	}))
end

return useUiModeInfo
