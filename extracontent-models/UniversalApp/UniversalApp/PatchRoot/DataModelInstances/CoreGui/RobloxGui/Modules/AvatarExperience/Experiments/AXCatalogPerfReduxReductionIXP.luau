local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("AXCatalogPerfReduxReductionIXP2", false)
game:DefineFastFlag("AXCatalogPerfReduxReductionIXPEnabledForAll2", false)

return IxpUtils.defineIXPTest({
	name = "AvatarExperience.UA.MarketplaceView.CatalogPerfReduxReduction",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	getIsUserInExperiment = function(p1) -- line: 28
		return p1.reduceCatalogDispatches ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 32
		return true
	end,
	getEnabledFlag = function() -- line: 36
		return game:GetFastFlag("AXCatalogPerfReduxReductionIXP2")
	end,
	getEnabledForAllFlag = function() -- line: 40
		return game:GetFastFlag("AXCatalogPerfReduxReductionIXPEnabledForAll2")
	end,
	variables = {
		EnabledForUser = function(p2, p3) -- line: 46
			return p3 or (p2.reduceCatalogDispatches or false)
		end
	}
})
