local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)

game:DefineFastFlag("AXShareButtonOnActionBarIXPEnabled", false)
game:DefineFastFlag("AXShareButtonOnActionBarIXPEnabledForAll", false)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.ItemDetails.ShareButtonProfileration",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUAActionBarView,
	getIsUserInExperiment = function(p1) -- line: 31
		return p1.showShareButtonOnActionBar ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 35
		return true
	end,
	getEnabledFlag = function() -- line: 39
		return game:GetFastFlag("AXShareButtonOnActionBarIXPEnabled")
	end,
	getEnabledForAllFlag = function() -- line: 43
		return game:GetFastFlag("AXShareButtonOnActionBarIXPEnabledForAll")
	end,
	variables = {
		ShowShareButtonOnActionBar = function(p2, p3) -- line: 48
			-- upvalues: sendAXCounterV2 (copy), Constants (copy)
			sendAXCounterV2(Constants.Counter.ShareButtonProfileration.Experiment, {
				variant = if p2.showShareButtonOnActionBar ~= nil then not p2.showShareButtonOnActionBar and "control" or "treatment" else "nil"
			})

			return p3 or p2.showShareButtonOnActionBar
		end
	}
})
