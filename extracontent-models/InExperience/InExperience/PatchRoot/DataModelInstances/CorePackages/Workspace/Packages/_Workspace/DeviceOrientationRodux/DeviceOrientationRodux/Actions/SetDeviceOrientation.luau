local parent = script:FindFirstAncestor("DeviceOrientationRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(deviceOrientation)
	return { deviceOrientation = deviceOrientation }
end)
