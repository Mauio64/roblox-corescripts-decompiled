local CorePackages = game:GetService("CorePackages")
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)

local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local function getViewportSize() -- 1 equivalent call inferred from this helper
	return workspace.CurrentCamera.ViewportSize
end

local function getDeviceOrientation() -- 1 equivalent call inferred from this helper
	local viewportSize = getViewportSize() -- inferred equivalent call

	if viewportSize.X > viewportSize.Y then
		return DeviceOrientationMode.Landscape
	end

	return DeviceOrientationMode.Portrait
end

return {
	getDeviceType = function()
		return AppCommonLib.getDeviceType(getDeviceOrientation()) -- inferred equivalent call
	end,
	DeviceTypes = RobloxAppEnums.DeviceType,
	getDeviceOrientation = getDeviceOrientation,
	getViewportSize = getViewportSize
}
