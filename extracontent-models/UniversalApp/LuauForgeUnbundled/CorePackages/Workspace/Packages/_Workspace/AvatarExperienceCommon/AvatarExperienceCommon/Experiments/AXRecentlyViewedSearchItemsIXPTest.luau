local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ExperimentLayers").AppUserLayers
local IXPUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/IXPUtils")

game:DefineFastFlag("AXRecentlyViewedSearchItemsEnabled4", false)

game:DefineFastFlag("AXRecentlyViewedSearchItemsEnabledForAll4", false)

game:DefineFastFlag("AXRecentlyViewedSearchItemsPositionTop4", false)
game:DefineFastFlag("AXRecentlyViewedSearchItemsSaveInCatalog4", false)

return IXPUtils.defineIXPTest({
	name = "AvatarMarketplace.UA.RecentlyViewedSearchItems",
	recordExposure = false,
	layer = appUserLayers.AvatarExperienceUASearchView,
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
		EnabledForUser = function(p2, p3)
			return p3 or p2.enableRecentlyViewedItems
		end,
		EnabledTopVariant = function(p2)
			local recentlyViewedSearchItemsPositionTop = p2.recentlyViewedSearchItemsPositionTop
			return game:GetFastFlag("AXRecentlyViewedSearchItemsPositionTop4")
				or recentlyViewedSearchItemsPositionTop == true
		end,
		EnabledSaveInCatalog = function(p2)
			local recentlyViewedSearchItemsSaveInCatalog = p2.recentlyViewedSearchItemsSaveInCatalog
			return game:GetFastFlag("AXRecentlyViewedSearchItemsSaveInCatalog4")
				or recentlyViewedSearchItemsSaveInCatalog == true
		end
	}
})
