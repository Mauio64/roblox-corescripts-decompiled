local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module = require("@luauforge/bundled/dwq")

return function(p2, p3)
	local v5 = p2 or deviceOrientationMode.Portrait
	assert(v5, "")

	if p3.type == module.name then
		return p3.deviceOrientation
	end

	return v5
end
