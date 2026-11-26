local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module = require("@luauforge/bundled/dPR")

game:DefineFastFlag("AXItemDetails3DPreviewEnabled", false)

game:DefineFastFlag("AXItemDetails3DPreviewEnabledForAll", false)

game:DefineFastString("AXItemDetails3DPreviewIXPLayer", appUserLayers.AvatarExperienceUAItemDetailsView)

return module.defineIXPTest({
	name = "AvatarMarketplace.UA.AXItemDetails3DPreview",
	layer = game:GetFastString("AXItemDetails3DPreviewIXPLayer"),
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.enableItemDetails3DPreview ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXItemDetails3DPreviewEnabled")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXItemDetails3DPreviewEnabledForAll")
	end,
	variables = {
		EnableItemDetails3DPreview = function(p2, p3)
			return p3 or p2.enableItemDetails3DPreview or false
		end
	}
})
