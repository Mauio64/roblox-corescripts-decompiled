local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("AXDisableAlwaysRenderedScreensIXP2", false)
game:DefineFastFlag("AXDisableAlwaysRenderedScreensIXPEnabledForAll2", false)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.All.DisableAlwaysRenderedScreens",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAMarketplaceView,
	getIsUserInExperiment = function(p1) -- line: 28
		return p1.disableAlwaysRenderedScreens ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 32
		return true
	end,
	getEnabledFlag = function() -- line: 36
		return game:GetFastFlag("AXDisableAlwaysRenderedScreensIXP2")
	end,
	getEnabledForAllFlag = function() -- line: 40
		return game:GetFastFlag("AXDisableAlwaysRenderedScreensIXPEnabledForAll2")
	end,
	variables = {
		DisableAlwaysRenderedScreen = function(p2, p3) -- line: 46
			return p3 or (p2.disableAlwaysRenderedScreens or false)
		end
	}
})
