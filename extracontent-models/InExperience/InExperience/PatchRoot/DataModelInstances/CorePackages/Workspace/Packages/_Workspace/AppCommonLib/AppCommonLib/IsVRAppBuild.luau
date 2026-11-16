local VRService = game:GetService("VRService")

local isVRModeInStudio = require(script.Parent.isVRModeInStudio)

return function()
	if isVRModeInStudio() then
		return true
	end

	return VRService:IsVRAppBuild()
end
