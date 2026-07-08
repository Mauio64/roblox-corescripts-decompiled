local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local IXPUtils = require(Parent.IXPUtils)

game:DefineFastFlag("AXRecentlyViewedSearchItemsEnabled4", false)
game:DefineFastFlag("AXRecentlyViewedSearchItemsEnabledForAll4", false)
game:DefineFastFlag("AXRecentlyViewedSearchItemsPositionTop4", false)
game:DefineFastFlag("AXRecentlyViewedSearchItemsSaveInCatalog4", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.RecentlyViewedSearchItems",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUASearchView,
	getIsUserInExperiment = function(p1) -- line: 25
		return p1.enableRecentlyViewedItems ~= nil and (p1.recentlyViewedSearchItemsPositionTop ~= nil and p1.recentlyViewedSearchItemsSaveInCatalog ~= nil)
	end,
	getDependentFlagsEnabled = function() -- line: 31
		return true
	end,
	getEnabledFlag = function() -- line: 35
		return game:GetFastFlag("AXRecentlyViewedSearchItemsEnabled4")
	end,
	getEnabledForAllFlag = function() -- line: 39
		return game:GetFastFlag("AXRecentlyViewedSearchItemsEnabledForAll4")
	end,
	variables = {
		EnabledForUser = function(p2, p3) -- line: 45
			return p3 or p2.enableRecentlyViewedItems
		end,
		EnabledTopVariant = function(p4) -- line: 48
			local recentlyViewedSearchItemsPositionTop = p4.recentlyViewedSearchItemsPositionTop

			return game:GetFastFlag("AXRecentlyViewedSearchItemsPositionTop4") or (recentlyViewedSearchItemsPositionTop == true or false)
		end,
		EnabledSaveInCatalog = function(p5) -- line: 52
			local recentlyViewedSearchItemsSaveInCatalog = p5.recentlyViewedSearchItemsSaveInCatalog

			return game:GetFastFlag("AXRecentlyViewedSearchItemsSaveInCatalog4") or (recentlyViewedSearchItemsSaveInCatalog == true or false)
		end
	}
})
