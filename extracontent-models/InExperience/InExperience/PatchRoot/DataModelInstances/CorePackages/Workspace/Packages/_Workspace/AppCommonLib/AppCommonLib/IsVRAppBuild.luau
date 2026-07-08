local VRService = game:GetService("VRService")
local isVRModeInStudio = require(script.Parent.isVRModeInStudio)

return function() -- line: 7
	-- upvalues: isVRModeInStudio (copy), VRService (copy)
	if isVRModeInStudio() then
		return true
	end

	if game:GetEngineFeature("MaquettesBuildFlagsEnabled") then
		return VRService:IsVRAppBuild()
	end

	return VRService.VREnabled
end
