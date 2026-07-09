local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(CorePackages.Packages.Dash)

local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local NavigateIntoItemDetailsPage = require(Modules.AvatarExperience.Common.Thunks.NavigateIntoItemDetailsPage)

require(Modules.AvatarExperience.Common.Context.WidgetInfoContext)
require(Modules.AvatarExperience.Common.Types)

local selectSearchKeyword = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Selectors.selectSearchKeyword
local GetFFlagAXItemDetailsAnalyticsV2 = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsAnalyticsV2)

return function(t1: {[any]: any}) -- line: 63
	-- upvalues: ArgCheck (copy), NavigationUtils (copy), Utils (copy), GetFFlagAXItemDetailsAnalyticsV2 (copy), selectSearchKeyword (copy), CatalogUtils (copy), NavigateIntoItemDetailsPage (copy)
	ArgCheck.assert(not (t1.mountAsFullView and t1.showFullWithNoPeekView))

	return function(p1) -- line: 67
		-- upvalues: t1 (copy), NavigationUtils (copy), Utils (copy), GetFFlagAXItemDetailsAnalyticsV2 (copy), selectSearchKeyword (copy), CatalogUtils (copy), NavigateIntoItemDetailsPage (copy)
		if t1.closePreviousItemDetails then
			NavigationUtils.closeFiltersAndItemDetails(t1.navigation)
		end

		local t2 = {
			isFirstItemDetails = true,
			itemId = t1.itemId,
			itemType = t1.itemType,
			itemSubType = t1.itemSubType,
			itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
			resultsListRef = t1.resultsListRef,
			mountAsFullView = t1.mountAsFullView,
			showFullWithNoPeekView = t1.showFullWithNoPeekView,
			widgetInfo = t1.widgetInfo,
			onItemDetailsClosed = t1.onItemDetailsClosed
		}

		if t1.showFullWithNoPeekView or t1.mountAsFullView then
			local v13 = Utils.getCurrentScreenIgnoreItemDetails(t1.avatarRoute)

			if GetFFlagAXItemDetailsAnalyticsV2() then
				local v14 = p1:getState()
				local v15 = selectSearchKeyword(v14)
				local v16, v17 = CatalogUtils.getCategoryAndSubcategory(v14)
				local RequestId = v14.AvatarExperience.Common.Widgets.WidgetInfo.RequestId

				t1.catalogAnalytics.openItemDetailsV2(t1.itemId, t1.itemType, t1.priceInRobux, v13, RequestId, v15, v16, v17, v14.AvatarExperience.AnalyticsMetadata)
			else
				t1.catalogAnalytics.openItemDetails(t1.itemId, t1.itemType, t1.priceInRobux, v13)
			end
		end

		p1:dispatch(NavigateIntoItemDetailsPage(t1.navigation, t2))
	end
end
