local parent = script:FindFirstAncestor("AvatarExperienceExperiments").Parent

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local IXPUtils = require(parent.IXPUtils)

local enabledFlag = game:DefineFastFlag("AXCatalogRealTimeRecommendationsIXPV2", false)

local enabledForAllFlag = game:DefineFastFlag("AXCatalogRealTimeRecommendationsIXPEnabledForAllV2", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.PerfCatalogRealTimeRecommendations",
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p): boolean
		return p.catalogRealTimeRecommendations ~= nil
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
			return p2 or p.catalogRealTimeRecommendations ~= nil
		end,
		EnabledForUser = function(p, p2)
			return p2 or p.catalogRealTimeRecommendations or false
		end
	}
})
