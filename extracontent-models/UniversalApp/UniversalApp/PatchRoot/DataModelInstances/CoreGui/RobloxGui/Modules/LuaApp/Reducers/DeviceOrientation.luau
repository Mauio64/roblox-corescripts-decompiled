local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local SetDeviceOrientation = require(Modules.LuaApp.Actions.SetDeviceOrientation)

return function(p1, p2) -- line: 9
	-- upvalues: DeviceOrientationMode (copy), SetDeviceOrientation (copy)
	local v7 = p1 or DeviceOrientationMode.Portrait

	assert(v7, "")

	if p2.type == SetDeviceOrientation.name then
		return p2.deviceOrientation
	end

	return v7
end
