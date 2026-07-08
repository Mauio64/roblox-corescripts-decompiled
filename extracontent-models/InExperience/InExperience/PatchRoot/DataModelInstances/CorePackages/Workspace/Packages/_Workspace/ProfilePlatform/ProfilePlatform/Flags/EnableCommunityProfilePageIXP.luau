local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local v2 = game:DefineFastFlag("EnableCommunityProfilePageIXPSetupEnabled_v4", false)
local v3 = game:DefineFastFlag("EnableCommunityProfilePageIXPEnabledForAll", false)
local v4 = game:DefineFastString("EnableCommunityProfilePageExperimentLayer", "Social.CommunityProfileView")
local IXPService = game:GetService("IXPService")
local ProfilePlatformParent = ProfilePlatform.Parent
local useUserExperiment = require(ProfilePlatformParent.RoactAppExperiment).useUserExperiment

local function isFeatureActive(p1) -- line: 15
	-- upvalues: v4 (copy), v3 (copy)
	local v10 = (p1 or {})[v4] or {}

	return v3 or v10.enableCommunityProfilePage == true
end

return {
	EnableCommunityProfilePageExperimentLayer = v4,
	FFlagIsSetupEnabled = v2,
	isFeatureActive = isFeatureActive,
	useIsFeatureActive = function(t1: {[any]: any}?) -- line: 27
		-- upvalues: useUserExperiment (copy), v4 (copy), isFeatureActive (copy)
		return useUserExperiment({ v4 }, isFeatureActive, if not t1 then nil else t1.isExposureEnabled)
	end,
	logExposure = function() -- line: 34
		-- upvalues: IXPService (copy), v4 (copy)
		IXPService:LogUserLayerExposure(v4)
	end
}
