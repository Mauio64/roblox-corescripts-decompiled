local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local GetFFlagLooksIXPLogging = require(Modules.AvatarExperience.Flags.GetFFlagLooksIXPLogging)
local GetFFlagAXDisableSortsLayerExposure = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableSortsLayerExposure)
local v8 = game:DefineFastString("WidgetLayer", "AvatarMarketplace.WidgetPlatform")

local function dummyTest(s1: string) -- line: 21
	-- upvalues: IxpUtils (copy)
	return IxpUtils.defineIXPTest({
		recordExposure = false,
		name = s1 .. "DummyTest",
		layer = s1,
		getDependentFlagsEnabled = function() -- line: 30
			return true
		end,
		getEnabledFlag = function() -- line: 34
			return true
		end,
		getEnabledForAllFlag = function() -- line: 38
			return false
		end,
		variables = {}
	})
end

return {
	Editor = dummyTest(AppUserLayers.AvatarMarketplaceEditor),
	RelevanceRecommendations = dummyTest("AvatarMarketplace.RelevanceRecommendations"),
	RecommendationsAndSearch = dummyTest(AppUserLayers.AvatarMarketplaceDefaultRecSearchLayer),
	ItemDetailsPage = dummyTest(AppUserLayers.AvatarMarketplaceItemDetailsPage),
	Widgets = dummyTest(v8),
	SearchWidgets = if not GetFFlagLooksIXPLogging() then nil else dummyTest("AvatarMarketplace.SearchPageWidgetPlatform"),
	Sorts = if not GetFFlagLooksIXPLogging() and GetFFlagAXDisableSortsLayerExposure() then nil else dummyTest("AvatarMarketplace.Sorts")
}
