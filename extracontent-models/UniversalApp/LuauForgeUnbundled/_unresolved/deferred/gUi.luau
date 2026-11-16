local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")

game:DefineFastFlag("AXHighResolutionTallTilesEnabled", false)

game:DefineFastFlag("AXHighResolutionTallTilesEnabledForAll", false)

game:DefineFastString("AXHighResolutionTallTilesIXPLayer", appUserLayers.AvatarExperienceUAMarketplaceView)

return module.defineIXPTest({
	name = "AvatarMarketplace.UA.AXHighResolutionTallTiles",
	layer = game:GetFastString("AXHighResolutionTallTilesIXPLayer"),
	getIsUserInExperiment = function(p2): boolean
		return p2.enableHighResolutionTallTiles ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXHighResolutionTallTilesEnabled")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXHighResolutionTallTilesEnabledForAll")
	end,
	variables = {
		EnableHighResolutionTallTiles = function(p2, p3)
			return p3 or p2.enableHighResolutionTallTiles or false
		end
	}
})
