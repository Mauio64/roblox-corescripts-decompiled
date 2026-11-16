local defineFastFlag = game:DefineFastFlag("EnableCommunityProfilePageIXPSetupEnabled_v4", false)

local defineFastFlag2 = game:DefineFastFlag("EnableCommunityProfilePageIXPEnabledForAll", false)

local defineFastString = game:DefineFastString(
	"EnableCommunityProfilePageExperimentLayer",
	"Social.CommunityProfileView"
)

local IXPService = game:GetService("IXPService")

local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactAppExperiment").useUserExperiment

local function isFeatureActive(options)
	local v5 = (options or {})[defineFastString] or {}

	return defineFastFlag2 or v5.enableCommunityProfilePage == true
end

return {
	EnableCommunityProfilePageExperimentLayer = defineFastString,
	FFlagIsSetupEnabled = defineFastFlag,
	isFeatureActive = isFeatureActive,
	useIsFeatureActive = function(p2)
		local v8 = if p2 then p2.isExposureEnabled else nil
		return useUserExperiment({ defineFastString }, isFeatureActive, v8)
	end,
	logExposure = function()
		IXPService:LogUserLayerExposure(defineFastString)
	end
}
