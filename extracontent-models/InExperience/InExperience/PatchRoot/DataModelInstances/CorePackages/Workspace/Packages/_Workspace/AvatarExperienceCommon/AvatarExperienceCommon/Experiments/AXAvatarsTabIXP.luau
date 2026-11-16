local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local IXPUtils = require(parent.IXPUtils)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAvatarsTabIXP = AvatarExperienceFlags.FFlagAXAvatarsTabIXP
local FFlagAXAvatarsTabIXPEnabledForAll = AvatarExperienceFlags.FFlagAXAvatarsTabIXPEnabledForAll

return IXPUtils.defineIXPTest({
	name = "AvatarExperience.UA.MarketplaceView.AvatarsTab",
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p): boolean
		return p.IsAvatarsTabEnabled ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return FFlagAXAvatarsTabIXP
	end,
	getEnabledForAllFlag = function()
		return FFlagAXAvatarsTabIXPEnabledForAll
	end,
	variables = {
		EnabledForUser = function(p, p2)
			return p2 or p.IsAvatarsTabEnabled or false
		end
	}
})
