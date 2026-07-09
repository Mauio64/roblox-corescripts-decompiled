local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local SponsoredItemsWidgetRow = require(Modules.AvatarExperience.Common.Components.SponsoredItemsWidgetRow)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Cryo = require(CorePackages.Packages.Cryo)

require(Modules.AvatarExperience.Common.Types)

local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Stores = require(Modules.AvatarExperience.Common.Components.WidgetList.Stores)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local FFlagAXHideEmptySponsoredRow = AvatarExperienceFlags.FFlagAXHideEmptySponsoredRow
local selectSponsoredItems = require(Modules.AvatarExperience.Catalog.Selectors.selectSponsoredItems)
local v22 = CatalogUtils.GetSponsoredItemsKey(CatalogConstants.SponsoredItemsCategoryRecommended, CatalogConstants.SponsoredItemsToFetch)

local function useSponsoredItemsLocalWidget(s1: string, b1: boolean?, b2: boolean?) -- line: 38
	-- upvalues: useSelector (copy), PerformFetch (copy), v22 (copy), getUseSelectorDeepEquals (copy), Utils (copy), FFlagAXHideEmptySponsoredRow (copy), selectSponsoredItems (copy), FFlagAXMoveAllTabToWidgetOnly (copy), Stores (copy), useSignalState (copy), React (copy), RetrievalStatus (copy), Cryo (copy), CatalogCategories (copy), Constants (copy), SponsoredItemsWidgetRow (copy)
	local v27 = useSelector(function(p1) -- line: 43
		-- upvalues: PerformFetch (copy), v22 (copy)
		return PerformFetch.GetStatus(p1, v22)
	end, getUseSelectorDeepEquals())
	local v28 = useSelector(function(p2) -- line: 47
		-- upvalues: Utils (copy), s1 (copy), PerformFetch (copy)
		local v37 = Utils.getSearchKey(p2, s1)

		return PerformFetch.GetStatus(p2, v37)
	end, getUseSelectorDeepEquals())
	local v29 = useSelector(function(p3) -- line: 52
		return p3.AvatarExperience.Catalog.SortAndFilters.SelectedTopics
	end, getUseSelectorDeepEquals())
	local v30 = useSelector(function(p4) -- line: 56
		-- upvalues: s1 (copy)
		return p4.SearchesParameters[s1]
	end, getUseSelectorDeepEquals())
	local v31 = if not FFlagAXHideEmptySponsoredRow then nil else useSelector(selectSponsoredItems, getUseSelectorDeepEquals())
	local u32 = nil

	if FFlagAXMoveAllTabToWidgetOnly then
		local v33 = Stores.getFetchMarketplaceStore(false)

		u32 = useSignalState(v33.getFetchingMarketplaceProcessed)
	end

	local v34 = React.useMemo(function() -- line: 73
		-- upvalues: v27 (copy), RetrievalStatus (copy), FFlagAXHideEmptySponsoredRow (copy), v31 (copy), v29 (copy), FFlagAXMoveAllTabToWidgetOnly (copy), v28 (copy), v30 (copy), Cryo (copy), CatalogCategories (copy), u32 (ref), b1 (copy), b2 (copy)
		if v27 ~= RetrievalStatus.Failed then
			if FFlagAXHideEmptySponsoredRow and (not v31 or #v31 == 0) then
				return false
			end

			local v40 = v29 ~= nil and #v29 > 0
			local v41 = if FFlagAXMoveAllTabToWidgetOnly then nil else v28 == RetrievalStatus.Done
			local v42 = not FFlagAXMoveAllTabToWidgetOnly and nil
			local v43 = false

			if v30 and v30.categoryInfo and not Cryo.isEmpty(v30.categoryInfo) then
				local categoryInfo = v30.categoryInfo

				v43 = categoryInfo.ShowSponsored or false

				if FFlagAXMoveAllTabToWidgetOnly then
					v42 = categoryInfo.Id == CatalogCategories.Recommended:rawValue()
				end
			end

			if FFlagAXMoveAllTabToWidgetOnly then
				v41 = v28 == RetrievalStatus.Done or FFlagAXMoveAllTabToWidgetOnly and (u32 and v42)
			end

			return b1 and (v41 and (v43 and (not v40 and not b2)))
		end

		return false
	end, {
		v27,
		v29,
		v28,
		b1,
		v30,
		b2,
		if not FFlagAXMoveAllTabToWidgetOnly then nil else u32,
		if not FFlagAXHideEmptySponsoredRow then nil else v31
	})

	return {
		row = Constants.SponsoredItemsRow,
		component = SponsoredItemsWidgetRow,
		isEnabled = v34
	}
end

return useSponsoredItemsLocalWidget
