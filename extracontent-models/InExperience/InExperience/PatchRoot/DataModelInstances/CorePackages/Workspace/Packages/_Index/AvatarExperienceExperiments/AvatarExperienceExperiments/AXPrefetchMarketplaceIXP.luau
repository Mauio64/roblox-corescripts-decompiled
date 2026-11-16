local parent = script:FindFirstAncestor("AvatarExperienceExperiments").Parent

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local IXPUtils = require(parent.IXPUtils)

local enabledFlag = game:DefineFastFlag("AXPrefetchMarketplaceIXP5", false)

local enabledForAllFlag = game:DefineFastFlag("AXPrefetchMarketplaceIXPEnabledForAll5", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.PrefetchMarketplace",
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p): boolean
		return p.enableMarketplacePrefetch ~= nil
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
		UserIsInExperiment = function(p, p2)
			return p2 or p.enableMarketplacePrefetch ~= nil
		end,
		EnabledForUser = function(p, p2)
			return p2 or p.enableMarketplacePrefetch or false
		end
	}
})
