game:DefineFastFlag("SocialNetworksInEditProfileIXPSetupEnabled_v6", false)
game:DefineFastFlag("SocialNetworksInEditProfileIXPEnabled", false)

local defineFastString = game:DefineFastString("SocialNetworksEditProfileIXPLayer", "Social.EditProfilePage")

local parent = script:FindFirstAncestor("EditProfile").Parent
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local variants = {
	Control = "control",
	VisibilityLast = "visibilityLast",
	VisibilityFirst = "visibilityFirst"
}

local function GetFFlagSocialNetworksInEditProfileIXPEnabled() -- 1 equivalent call inferred from this helper
	return game:GetFastFlag("SocialNetworksInEditProfileIXPEnabled")
end

local function getExperimentVariant(options)
	if GetFFlagSocialNetworksInEditProfileIXPEnabled() then -- inferred equivalent call
		return ((options or {})[defineFastString] or {}).editSocialNetworks or variants.Control
	end

	return nil
end

local SocialNetworksInEditProfileIXP = {}

function SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled()
	return game:GetFastFlag("SocialNetworksInEditProfileIXPSetupEnabled_v6")
end

SocialNetworksInEditProfileIXP.getExperimentVariant = getExperimentVariant

function SocialNetworksInEditProfileIXP.useGetExperimentVariant(p)
	return useUserExperiment({ defineFastString }, getExperimentVariant, p.isExposureEnabled)
end

SocialNetworksInEditProfileIXP.Variants = variants
return SocialNetworksInEditProfileIXP
