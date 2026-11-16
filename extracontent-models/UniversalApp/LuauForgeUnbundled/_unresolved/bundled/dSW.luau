local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")

game:DefineFastFlag("AXCatalogPerfReduxReductionIXPEnabledForAll2", false)

return module.defineIXPTest({
	name = "AvatarExperience.UA.MarketplaceView.CatalogPerfReduxReduction",
	layer = appUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.reduceCatalogDispatches ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function(): boolean
		return true
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXCatalogPerfReduxReductionIXPEnabledForAll2")
	end,
	variables = {
		EnabledForUser = function(p2, p3)
			return p3 or p2.reduceCatalogDispatches or false
		end
	}
})
