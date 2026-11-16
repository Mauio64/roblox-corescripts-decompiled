local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module = require("@luauforge/bundled/dMB")

local module2 = require("@luauforge/deferred/gmD")
local module3 = require("@luauforge/deferred/gmE")

local defineFastString = game:DefineFastString("WidgetLayer", "AvatarMarketplace.WidgetPlatform")

local function dummyTest(p2)
	return module.defineIXPTest({
		name = p2 .. "DummyTest",
		layer = p2,
		recordExposure = false,
		getDependentFlagsEnabled = function(): boolean
			return true
		end,
		getEnabledFlag = function(): boolean
			return true
		end,
		getEnabledForAllFlag = function(): boolean
			return false
		end,
		variables = {}
	})
end

local v5 = {
	Editor = dummyTest(appUserLayers.AvatarMarketplaceEditor),
	RelevanceRecommendations = dummyTest("AvatarMarketplace.RelevanceRecommendations"),
	RecommendationsAndSearch = dummyTest(appUserLayers.AvatarMarketplaceDefaultRecSearchLayer),
	ItemDetailsPage = dummyTest(appUserLayers.AvatarMarketplaceItemDetailsPage),
	Widgets = dummyTest(defineFastString),
	SearchWidgets = 0,
	Sorts = 0
}
local v6 = if module2() then dummyTest("AvatarMarketplace.SearchPageWidgetPlatform") else nil
v5.SearchWidgets = v6

local v7 = if module2() or not module3() then dummyTest("AvatarMarketplace.Sorts") else nil
v5.Sorts = v7

return v5
