local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")

game:DefineFastFlag("PostPurchaseIXPEnabled", false)
game:DefineFastFlag("PostPurchaseIXPEnabledForAll", false)

return module.defineIXPTest({
	name = "PostPurchase",
	layer = appUserLayers.PostPurchaseLayer,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.redirect_enabled ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("PostPurchaseIXPEnabled")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("PostPurchaseIXPEnabledForAll")
	end,
	variables = {
		EnabledForUser = function(p2, p3)
			return p3 or p2.redirect_enabled == true
		end
	}
})
