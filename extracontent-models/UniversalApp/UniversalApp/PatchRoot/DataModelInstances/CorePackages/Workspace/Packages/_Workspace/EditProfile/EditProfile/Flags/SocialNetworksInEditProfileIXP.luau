game:DefineFastFlag("SocialNetworksInEditProfileIXPSetupEnabled_v6", false)
game:DefineFastFlag("SocialNetworksInEditProfileIXPEnabled", false)

local v1 = game:DefineFastString("SocialNetworksEditProfileIXPLayer", "Social.EditProfilePage")
local Parent = script:FindFirstAncestor("EditProfile").Parent
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment
local t1 = {
	Control = "control",
	VisibilityLast = "visibilityLast",
	VisibilityFirst = "visibilityFirst"
}

local function GetFFlagSocialNetworksInEditProfileIXPEnabled() -- line: 21
	return game:GetFastFlag("SocialNetworksInEditProfileIXPEnabled")
end
local function getExperimentVariant(p1) -- line: 25
	-- upvalues: v1 (copy), t1 (copy)
	if not game:GetFastFlag("SocialNetworksInEditProfileIXPEnabled") then
		return nil
	end

	return ((p1 or {})[v1] or {}).editSocialNetworks or t1.Control
end

return {
	GetFFlagSocialNetworksInEditProfileIXPSetupEnabled = function() -- line: 17
		return game:GetFastFlag("SocialNetworksInEditProfileIXPSetupEnabled_v6")
	end,
	getExperimentVariant = getExperimentVariant,
	useGetExperimentVariant = function(t2: {[any]: any}) -- line: 39
		-- upvalues: useUserExperiment (copy), v1 (copy), getExperimentVariant (copy)
		return useUserExperiment({ v1 }, getExperimentVariant, t2.isExposureEnabled)
	end,
	Variants = t1
}
