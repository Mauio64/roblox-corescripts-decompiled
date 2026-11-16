local vrService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/MockableProxyServices").VRService
local isVRModeInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isVRModeInStudio")

local function isSpatial()
	if isVRModeInStudio() then
		return true
	end

	return vrService.VREnabled
end

return isSpatial
