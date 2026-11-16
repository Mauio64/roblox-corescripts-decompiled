game:DefineFastFlag("SocialNetworksInEditProfileIXPSetupEnabled_v6", false)
game:DefineFastFlag("SocialNetworksInEditProfileIXPEnabled", false)

local defineFastString = game:DefineFastString(
	"SocialNetworksEditProfileIXPLayer",
	"Social.EditProfilePage"
)

local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactAppExperiment").useUserExperiment

local v5 = {
	Control = "control",
	VisibilityLast = "visibilityLast",
	VisibilityFirst = "visibilityFirst"
}

local function GetFFlagSocialNetworksInEditProfileIXPEnabled()
	return game:GetFastFlag("SocialNetworksInEditProfileIXPEnabled")
end

local function getExperimentVariant(options)
	if game:GetFastFlag("SocialNetworksInEditProfileIXPEnabled") then
		return ((options or {})[defineFastString] or {}).editSocialNetworks or v5.Control
	end

	return nil
end

return {
	GetFFlagSocialNetworksInEditProfileIXPSetupEnabled = function()
		return game:GetFastFlag("SocialNetworksInEditProfileIXPSetupEnabled_v6")
	end,
	getExperimentVariant = getExperimentVariant,
	useGetExperimentVariant = function(p2)
		return useUserExperiment({ defineFastString }, getExperimentVariant, p2.isExposureEnabled)
	end,
	Variants = v5
}
