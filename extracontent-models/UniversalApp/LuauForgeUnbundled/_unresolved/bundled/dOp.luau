local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")

local module2 = require("@luauforge/bundled/dOq")

game:DefineFastFlag("AXHeadCategoryCombineEnabled4", false)

game:DefineFastFlag("AXHeadCategoryCombineEnabledForAll4", false)

return module.defineIXPTest({
	name = "AvatarMarketplace.Catalog.HeadCategoryCombine",
	layer = appUserLayers.AvatarExperienceUACustomizeView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.enableHeadCategoryCombination ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXHeadCategoryCombineEnabled4") or module2()
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXHeadCategoryCombineEnabledForAll4")
	end,
	variables = {
		EnableHeadCategoryCombination = function(p2, p3)
			return p3 or p2.enableHeadCategoryCombination or false
		end
	}
})
