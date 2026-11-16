local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local IXPUtils = require(parent.IXPUtils)

game:DefineFastFlag("AXRecentlyViewedSearchItemsEnabled4", false)

game:DefineFastFlag("AXRecentlyViewedSearchItemsEnabledForAll4", false)

game:DefineFastFlag("AXRecentlyViewedSearchItemsPositionTop4", false)
game:DefineFastFlag("AXRecentlyViewedSearchItemsSaveInCatalog4", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.RecentlyViewedSearchItems",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUASearchView,
	getIsUserInExperiment = function(data)
		local isUserInExperiment

		if data.enableRecentlyViewedItems == nil or data.recentlyViewedSearchItemsPositionTop == nil then
			isUserInExperiment = false
		else
			isUserInExperiment = data.recentlyViewedSearchItemsSaveInCatalog ~= nil
		end

		return isUserInExperiment
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXRecentlyViewedSearchItemsEnabled4")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXRecentlyViewedSearchItemsEnabledForAll4")
	end,
	variables = {
		EnabledForUser = function(p, p2)
			return p2 or p.enableRecentlyViewedItems
		end,
		EnabledTopVariant = function(p)
			local recentlyViewedSearchItemsPositionTop = p.recentlyViewedSearchItemsPositionTop
			return game:GetFastFlag("AXRecentlyViewedSearchItemsPositionTop4")
				or recentlyViewedSearchItemsPositionTop == true
		end,
		EnabledSaveInCatalog = function(p)
			local recentlyViewedSearchItemsSaveInCatalog = p.recentlyViewedSearchItemsSaveInCatalog
			return game:GetFastFlag("AXRecentlyViewedSearchItemsSaveInCatalog4")
				or recentlyViewedSearchItemsSaveInCatalog == true
		end
	}
})
