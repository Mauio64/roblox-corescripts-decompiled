local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

local defineFastFlag = game:DefineFastFlag("EnableCommunityProfilePageIXPSetupEnabled_v4", false)

local defineFastFlag2 = game:DefineFastFlag("EnableCommunityProfilePageIXPEnabledForAll", false)

local defineFastString = game:DefineFastString(
	"EnableCommunityProfilePageExperimentLayer",
	"Social.CommunityProfileView"
)

local IXPService = game:GetService("IXPService")

local parent = ProfilePlatform.Parent
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local function isFeatureActive(options)
	local v = (options or {})[defineFastString] or {}

	return defineFastFlag2 or v.enableCommunityProfilePage == true
end

local EnableCommunityProfilePageIXP = {}
EnableCommunityProfilePageIXP.EnableCommunityProfilePageExperimentLayer = defineFastString
EnableCommunityProfilePageIXP.FFlagIsSetupEnabled = defineFastFlag
EnableCommunityProfilePageIXP.isFeatureActive = isFeatureActive

function EnableCommunityProfilePageIXP.useIsFeatureActive(p)
	local v

	if p then
		v = p.isExposureEnabled
	end

	return useUserExperiment({ defineFastString }, isFeatureActive, v)
end

function EnableCommunityProfilePageIXP.logExposure()
	IXPService:LogUserLayerExposure(defineFastString)
end

return EnableCommunityProfilePageIXP
