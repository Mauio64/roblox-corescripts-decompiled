local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module2 = require("@luauforge/bundled/dMx")

game:DefineFastFlag("AXShareButtonOnActionBarIXPEnabled", false)

game:DefineFastFlag("AXShareButtonOnActionBarIXPEnabledForAll", false)

return module.defineIXPTest({
	name = "AvatarMarketplace.ItemDetails.ShareButtonProfileration",
	layer = appUserLayers.AvatarExperienceUAActionBarView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.showShareButtonOnActionBar ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXShareButtonOnActionBarIXPEnabled")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXShareButtonOnActionBarIXPEnabledForAll")
	end,
	variables = {
		ShowShareButtonOnActionBar = function(p2, p3)
			sendAXCounterV2(module2.Counter.ShareButtonProfileration.Experiment, {
				variant = p2.showShareButtonOnActionBar == nil and "nil" or p2.showShareButtonOnActionBar and "treatment" or "control"
			})

			return p3 or p2.showShareButtonOnActionBar
		end
	}
})
