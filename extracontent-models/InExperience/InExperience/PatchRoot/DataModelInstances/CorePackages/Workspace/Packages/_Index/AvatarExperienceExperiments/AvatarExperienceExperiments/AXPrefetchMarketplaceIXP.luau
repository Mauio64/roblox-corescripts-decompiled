local Parent = script:FindFirstAncestor("AvatarExperienceExperiments").Parent
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local IXPUtils = require(Parent.IXPUtils)
local v4 = game:DefineFastFlag("AXPrefetchMarketplaceIXP5", false)
local v5 = game:DefineFastFlag("AXPrefetchMarketplaceIXPEnabledForAll5", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.PrefetchMarketplace",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	getIsUserInExperiment = function(p1) -- line: 24
		return p1.enableMarketplacePrefetch ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 28
		return true
	end,
	getEnabledFlag = function() -- line: 32
		-- upvalues: v4 (copy)
		return v4
	end,
	getEnabledForAllFlag = function() -- line: 36
		-- upvalues: v5 (copy)
		return v5
	end,
	variables = {
		UserIsInExperiment = function(p2, p3) -- line: 41
			return p3 or p2.enableMarketplacePrefetch ~= nil
		end,
		EnabledForUser = function(p4, p5) -- line: 44
			return p5 or (p4.enableMarketplacePrefetch or false)
		end
	}
})
