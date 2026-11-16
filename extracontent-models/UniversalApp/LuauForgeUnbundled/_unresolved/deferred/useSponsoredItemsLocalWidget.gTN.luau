local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/dME")
local module3 = require("@luauforge/bundled/dRQ")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dMd").Enums.CatalogCategories
local module5 = require("@luauforge/deferred/gTO")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module6 = require("@luauforge/bundled/dxy")
local module7 = require("@luauforge/bundled/fuD")
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dMc")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module8 = require("@luauforge/bundled/gNx")
local fFlagAXMoveAllTabToWidgetOnly = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMoveAllTabToWidgetOnly

local module9 = require("@luauforge/deferred/gTR")

local sponsoredItemsKey = module3.GetSponsoredItemsKey(
	module2.SponsoredItemsCategoryRecommended,
	module2.SponsoredItemsToFetch
)

local function useSponsoredItemsLocalWidget(p2, p3, p4)
	local v5 = useSelector(function(p5)
		return performFetch.GetStatus(p5, sponsoredItemsKey)
	end, getUseSelectorDeepEquals())

	local v6 = useSelector(function(p5)
		local searchKey = module7.getSearchKey(p5, p2)
		return performFetch.GetStatus(p5, searchKey)
	end, getUseSelectorDeepEquals())

	local v7 = useSelector(function(p5)
		return p5.AvatarExperience.Catalog.SortAndFilters.SelectedTopics
	end, getUseSelectorDeepEquals())

	local v8 = useSelector(function(p5)
		return p5.SearchesParameters[p2]
	end, getUseSelectorDeepEquals())

	local v9 = useSelector(module9, getUseSelectorDeepEquals())
	local v10

	if fFlagAXMoveAllTabToWidgetOnly then
		v10 = useSignalState(module8.getFetchMarketplaceStore(false).getFetchingMarketplaceProcessed)
	else
		v10 = nil
	end

	local function fn()
		if v5 == module6.Failed or (not v9 or #v9 == 0) then
			return false
		end

		local v11 = not (v7 == nil) and #v7 > 0
		local v12 = if not fFlagAXMoveAllTabToWidgetOnly then v6 == module6.Done else nil
		local v13 = if fFlagAXMoveAllTabToWidgetOnly then false else nil
		local v14

		if v8 and v8.categoryInfo and not Cryo.isEmpty(v8.categoryInfo) then
			local categoryInfo = v8.categoryInfo
			v14 = categoryInfo.ShowSponsored or false

			if fFlagAXMoveAllTabToWidgetOnly then
				v13 = categoryInfo.Id == catalogCategories.Recommended:rawValue()
			end
		else
			v14 = false
		end

		if fFlagAXMoveAllTabToWidgetOnly then
			v12 = v6 == module6.Done or fFlagAXMoveAllTabToWidgetOnly and v10 and v13
		end

		return p3 and v12 and v14 and not (v11 or p4)
	end

	local v13 = React.useMemo(fn, {
		v5,
		v7,
		v6,
		p3,
		v8,
		p4,
		if fFlagAXMoveAllTabToWidgetOnly then v10 else nil,
		v9
	})

	return { row = module.SponsoredItemsRow, component = module5, isEnabled = v13 }
end

return useSponsoredItemsLocalWidget
