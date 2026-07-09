local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("AXCombineGetOutfitDispatchesIXP3", false)
game:DefineFastFlag("AXCombineGetOutfitDispatchesIXPForAll3", false)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.CombineGetOutfitDispatches",
	recordExposure = false,
	layer = game:DefineFastString("AXCombineGetOutfitDispatchesIXPLayer3", AppUserLayers.AvatarExperienceUACustomizeView),
	getIsUserInExperiment = function(p1) -- line: 29
		return p1.combineGetOutfitDispatches ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 33
		return true
	end,
	getEnabledFlag = function() -- line: 37
		return game:GetFastFlag("AXCombineGetOutfitDispatchesIXP3")
	end,
	getEnabledForAllFlag = function() -- line: 41
		return game:GetFastFlag("AXCombineGetOutfitDispatchesIXPForAll3")
	end,
	variables = {
		EnabledForUser = function(p2, p3) -- line: 46
			return p3 or (p2.combineGetOutfitDispatches or false)
		end
	}
})
