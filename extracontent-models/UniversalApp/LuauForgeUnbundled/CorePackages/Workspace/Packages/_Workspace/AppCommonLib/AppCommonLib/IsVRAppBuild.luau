local VRService = game:GetService("VRService")

local isVRModeInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isVRModeInStudio")

return function()
	if isVRModeInStudio() then
		return true
	end

	return VRService:IsVRAppBuild()
end
