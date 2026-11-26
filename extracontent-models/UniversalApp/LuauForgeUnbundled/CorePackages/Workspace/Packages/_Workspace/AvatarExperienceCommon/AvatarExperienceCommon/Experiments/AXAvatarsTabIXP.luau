local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ExperimentLayers").AppUserLayers
local IXPUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/IXPUtils")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXAvatarsTabIXP = AvatarExperienceFlags.FFlagAXAvatarsTabIXP
local fFlagAXAvatarsTabIXPEnabledForAll = AvatarExperienceFlags.FFlagAXAvatarsTabIXPEnabledForAll

return IXPUtils.defineIXPTest({
	name = "AvatarExperience.UA.MarketplaceView.AvatarsTab",
	layer = appUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.IsAvatarsTabEnabled ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return fFlagAXAvatarsTabIXP
	end,
	getEnabledForAllFlag = function()
		return fFlagAXAvatarsTabIXPEnabledForAll
	end,
	variables = {
		EnabledForUser = function(p2, p3)
			return p3 or p2.IsAvatarsTabEnabled or false
		end
	}
})
