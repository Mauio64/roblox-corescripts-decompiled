local CorePackages = game:GetService("CorePackages")
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossDeviceLoginUsingQRCodes

return function() -- line: 5
	-- upvalues: GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy)
	return GetFFlagEnableCrossDeviceLoginUsingQRCodes()
end
