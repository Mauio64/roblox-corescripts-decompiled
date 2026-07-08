local CorePackages = game:GetService("CorePackages")
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

return {
	getDeviceType = function() -- line: 26
		-- upvalues: AppCommonLib (copy), DeviceOrientationMode (copy)
		local getDeviceType = AppCommonLib.getDeviceType
		local ViewportSize = workspace.CurrentCamera.ViewportSize

		return getDeviceType(if not (ViewportSize.X > ViewportSize.Y) then DeviceOrientationMode.Portrait else DeviceOrientationMode.Landscape)
	end,
	DeviceTypes = RobloxAppEnums.DeviceType,
	getDeviceOrientation = function() -- line: 19
		-- upvalues: DeviceOrientationMode (copy)
		local ViewportSize = workspace.CurrentCamera.ViewportSize

		if ViewportSize.X > ViewportSize.Y then
			return DeviceOrientationMode.Landscape
		end

		return DeviceOrientationMode.Portrait
	end,
	getViewportSize = function() -- line: 14
		return workspace.CurrentCamera.ViewportSize
	end
}
