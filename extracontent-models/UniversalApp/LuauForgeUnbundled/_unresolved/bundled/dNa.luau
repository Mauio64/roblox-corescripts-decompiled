local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")

game:DefineFastFlag("AXCombineGetOutfitDispatchesIXP3", false)

game:DefineFastFlag("AXCombineGetOutfitDispatchesIXPForAll3", false)

return module.defineIXPTest({
	name = "AvatarMarketplace.UA.CombineGetOutfitDispatches",
	layer = game:DefineFastString(
		"AXCombineGetOutfitDispatchesIXPLayer3",
		appUserLayers.AvatarExperienceUACustomizeView
	),
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.combineGetOutfitDispatches ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXCombineGetOutfitDispatchesIXP3")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXCombineGetOutfitDispatchesIXPForAll3")
	end,
	variables = {
		EnabledForUser = function(p2, p3)
			return p3 or p2.combineGetOutfitDispatches or false
		end
	}
})
