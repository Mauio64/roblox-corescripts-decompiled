local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local IXPUtils = require(Parent.IXPUtils)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXAvatarsTabIXP = AvatarExperienceFlags.FFlagAXAvatarsTabIXP
local FFlagAXAvatarsTabIXPEnabledForAll = AvatarExperienceFlags.FFlagAXAvatarsTabIXPEnabledForAll

return IXPUtils.defineIXPTest({
	name = "AvatarExperience.UA.MarketplaceView.AvatarsTab",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	getIsUserInExperiment = function(p1) -- line: 27
		return p1.IsAvatarsTabEnabled ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 31
		return true
	end,
	getEnabledFlag = function() -- line: 35
		-- upvalues: FFlagAXAvatarsTabIXP (copy)
		return FFlagAXAvatarsTabIXP
	end,
	getEnabledForAllFlag = function() -- line: 39
		-- upvalues: FFlagAXAvatarsTabIXPEnabledForAll (copy)
		return FFlagAXAvatarsTabIXPEnabledForAll
	end,
	variables = {
		EnabledForUser = function(p2, p3) -- line: 44
			return p3 or (p2.IsAvatarsTabEnabled or false)
		end
	}
})
