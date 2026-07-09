local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("AXHighResolutionTallTilesEnabled", false)
game:DefineFastFlag("AXHighResolutionTallTilesEnabledForAll", false)
game:DefineFastString("AXHighResolutionTallTilesIXPLayer", AppUserLayers.AvatarExperienceUAMarketplaceView)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.AXHighResolutionTallTiles",
	layer = game:GetFastString("AXHighResolutionTallTilesIXPLayer"),
	getIsUserInExperiment = function(p1) -- line: 27
		return p1.enableHighResolutionTallTiles ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 31
		return true
	end,
	getEnabledFlag = function() -- line: 35
		return game:GetFastFlag("AXHighResolutionTallTilesEnabled")
	end,
	getEnabledForAllFlag = function() -- line: 39
		return game:GetFastFlag("AXHighResolutionTallTilesEnabledForAll")
	end,
	variables = {
		EnableHighResolutionTallTiles = function(p2, p3) -- line: 44
			return p3 or (p2.enableHighResolutionTallTiles or false)
		end
	}
})
