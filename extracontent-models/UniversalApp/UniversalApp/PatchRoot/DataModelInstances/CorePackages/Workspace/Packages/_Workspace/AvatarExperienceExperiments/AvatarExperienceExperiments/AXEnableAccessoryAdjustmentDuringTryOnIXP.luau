local Parent = script:FindFirstAncestor("AvatarExperienceExperiments").Parent
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local IXPUtils = require(Parent.IXPUtils)

game:DefineFastFlag("AXEnableAccessoryAdjustmentDuringTryOn2", false)
game:DefineFastFlag("AXEnableAccessoryAdjustmentDuringTryOnForAll2", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.EnableAccessoryAdjustmentDuringTryOn2",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAAllViews,
	getIsUserInExperiment = function(p1) -- line: 22
		return p1.enableAccessoryAdjustmentQuickEntryButtonDuringTryOn ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 27
		return true
	end,
	getEnabledFlag = function() -- line: 31
		return game:GetFastFlag("AXEnableAccessoryAdjustmentDuringTryOn2")
	end,
	getEnabledForAllFlag = function() -- line: 35
		return game:GetFastFlag("AXEnableAccessoryAdjustmentDuringTryOnForAll2")
	end,
	variables = {
		EnabledForUser = function(p2, p3) -- line: 40
			return p3 or (p2.enableAccessoryAdjustmentQuickEntryButtonDuringTryOn or false)
		end
	}
})
