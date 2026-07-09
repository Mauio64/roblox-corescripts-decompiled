local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AddAnalyticsMetadata = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.AddAnalyticsMetadata
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local SendDetailedCatalogAnalytics = require(Modules.AvatarExperience.Catalog.Thunks.SendDetailedCatalogAnalytics)

require(Modules.AvatarExperience.Common.Types)

local function useSendCatalogItemClickAnalytics(t1: {[any]: any}) -- line: 23
	-- upvalues: useDispatch (copy), useRoactService (copy), Analytics (copy), React (copy), AddAnalyticsMetadata (copy), SendDetailedCatalogAnalytics (copy)
	local v11 = useDispatch()
	local v12 = useRoactService(Analytics)
	local analyticsContext = t1.analyticsContext
	local itemId = t1.itemId
	local itemType = t1.itemType
	local index = t1.index
	local analyticsItemCountPerPage = t1.analyticsItemCountPerPage

	return React.useCallback(function() -- line: 34
		-- upvalues: itemId (copy), itemType (copy), v11 (copy), AddAnalyticsMetadata (copy), index (copy), SendDetailedCatalogAnalytics (copy), analyticsContext (copy), v12 (copy), analyticsItemCountPerPage (copy)
		if not itemId or not itemType then
			return
		end

		v11(AddAnalyticsMetadata({
			selectedItemIndex = index
		}))
		v11(SendDetailedCatalogAnalytics(analyticsContext, v12.clickCatalogItem, itemId, itemType, index, analyticsItemCountPerPage, false))
	end, {
		v11,
		v12,
		analyticsContext,
		itemId,
		itemType,
		index,
		analyticsItemCountPerPage
	})
end

return useSendCatalogItemClickAnalytics
