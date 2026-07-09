local Parent = script:FindFirstAncestor("AvatarExperienceExperiments").Parent
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local IXPUtils = require(Parent.IXPUtils)
local v4 = game:DefineFastFlag("AXCatalogRealTimeRecommendationsIXPV2", false)
local v5 = game:DefineFastFlag("AXCatalogRealTimeRecommendationsIXPEnabledForAllV2", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.PerfCatalogRealTimeRecommendations",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	getIsUserInExperiment = function(p1) -- line: 26
		return p1.catalogRealTimeRecommendations ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 30
		return true
	end,
	getEnabledFlag = function() -- line: 34
		-- upvalues: v4 (copy)
		return v4
	end,
	getEnabledForAllFlag = function() -- line: 38
		-- upvalues: v5 (copy)
		return v5
	end,
	variables = {
		UserIsInExperiment = function(p2, p3) -- line: 43
			return p3 or p2.catalogRealTimeRecommendations ~= nil
		end,
		EnabledForUser = function(p4, p5) -- line: 46
			return p5 or (p4.catalogRealTimeRecommendations or false)
		end
	}
})
