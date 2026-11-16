local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceExperiments/ExperimentLayers").AppUserLayers
local IXPUtils = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceExperiments/IXPUtils")

local enabledFlag = game:DefineFastFlag("AXPrefetchMarketplaceIXP5", false)

local enabledForAllFlag = game:DefineFastFlag("AXPrefetchMarketplaceIXPEnabledForAll5", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.PrefetchMarketplace",
	layer = appUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.enableMarketplacePrefetch ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return enabledFlag
	end,
	getEnabledForAllFlag = function()
		return enabledForAllFlag
	end,
	variables = {
		UserIsInExperiment = function(p2, p3)
			return p3 or p2.enableMarketplacePrefetch ~= nil
		end,
		EnabledForUser = function(p2, p3)
			return p3 or p2.enableMarketplacePrefetch or false
		end
	}
})
