local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module = require("@luauforge/bundled/dPR")

game:DefineFastFlag("AXDisableAlwaysRenderedScreensIXP2", false)

game:DefineFastFlag("AXDisableAlwaysRenderedScreensIXPEnabledForAll2", false)

return module.defineIXPTest({
	name = "AvatarMarketplace.All.DisableAlwaysRenderedScreens",
	layer = appUserLayers.AvatarExperienceUAMarketplaceView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.disableAlwaysRenderedScreens ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXDisableAlwaysRenderedScreensIXP2")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXDisableAlwaysRenderedScreensIXPEnabledForAll2")
	end,
	variables = {
		DisableAlwaysRenderedScreen = function(p2, p3)
			return p3 or p2.disableAlwaysRenderedScreens or false
		end
	}
})
