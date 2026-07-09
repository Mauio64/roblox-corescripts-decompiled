local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("AXItemDetails3DPreviewEnabled", false)
game:DefineFastFlag("AXItemDetails3DPreviewEnabledForAll", false)
game:DefineFastString("AXItemDetails3DPreviewIXPLayer", AppUserLayers.AvatarExperienceUAItemDetailsView)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.AXItemDetails3DPreview",
	recordExposure = false,
	layer = game:GetFastString("AXItemDetails3DPreviewIXPLayer"),
	getIsUserInExperiment = function(p1) -- line: 30
		return p1.enableItemDetails3DPreview ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 34
		return true
	end,
	getEnabledFlag = function() -- line: 38
		return game:GetFastFlag("AXItemDetails3DPreviewEnabled")
	end,
	getEnabledForAllFlag = function() -- line: 42
		return game:GetFastFlag("AXItemDetails3DPreviewEnabledForAll")
	end,
	variables = {
		EnableItemDetails3DPreview = function(p2, p3) -- line: 47
			return p3 or (p2.enableItemDetails3DPreview or false)
		end
	}
})
