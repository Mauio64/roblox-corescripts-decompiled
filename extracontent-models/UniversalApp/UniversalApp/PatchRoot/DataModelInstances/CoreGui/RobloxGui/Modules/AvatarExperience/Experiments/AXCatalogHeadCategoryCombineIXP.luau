local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local GetFFlagAXEnableHeadCombineHeadPickerIXPTogether = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableHeadCombineHeadPickerIXPTogether)

game:DefineFastFlag("AXHeadCategoryCombineEnabled4", false)
game:DefineFastFlag("AXHeadCategoryCombineEnabledForAll4", false)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.Catalog.HeadCategoryCombine",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUACustomizeView,
	getIsUserInExperiment = function(p1) -- line: 34
		return p1.enableHeadCategoryCombination ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 38
		return true
	end,
	getEnabledFlag = function() -- line: 42
		-- upvalues: GetFFlagAXEnableHeadCombineHeadPickerIXPTogether (copy)
		return game:GetFastFlag("AXHeadCategoryCombineEnabled4") or GetFFlagAXEnableHeadCombineHeadPickerIXPTogether()
	end,
	getEnabledForAllFlag = function() -- line: 46
		return game:GetFastFlag("AXHeadCategoryCombineEnabledForAll4")
	end,
	variables = {
		EnableHeadCategoryCombination = function(p2, p3) -- line: 52
			return p3 or (p2.enableHeadCategoryCombination or false)
		end
	}
})
