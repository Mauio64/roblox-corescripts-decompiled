local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dPt").Enums.CatalogCategories
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext

local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore

local module3 = require("@luauforge/bundled/gZG")
local module4 = require("@luauforge/bundled/hah")

local module5 = require("@luauforge/bundled/hai")

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogSduiUseOpaqueRouteForSearch = AvatarExperienceFlags.FFlagAXCatalogSduiUseOpaqueRouteForSearch
local fFlagAXCatalogSduiDisableOnSearchRoute = AvatarExperienceFlags.FFlagAXCatalogSduiDisableOnSearchRoute
local fFlagAXCatalogSduiDisableInSearchResults = AvatarExperienceFlags.FFlagAXCatalogSduiDisableInSearchResults

local set = { [catalogCategories.Recommended:rawValue()] = true }

local function isCatalogSearchSurface(p2): boolean
	return p2 == avatarScreen.CatalogSearch or p2 == avatarScreen.CatalogSearchLanding
end

local function useIsOnCatalogSearchRoute(): boolean
	local v5 = React.useContext(avatarRouteContext)
	local name = v5 and v5.opaque and v5.opaque.name
	return name == avatarScreen.CatalogSearch or name == avatarScreen.CatalogSearchLanding
end

local function useSearchKeywordFromSignals()
	local legacyNavigationStore = getLegacyNavigationStore(false)
	local v6 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			return module5.fromRoute(legacyNavigationStore.getCurrentRoute(p2))
		end, module5.equal)
	end, { legacyNavigationStore })))
	local searchUUID = v6.searchUUID
	local v7 = useSelector(function(p2)
		if searchUUID then
			return p2.Search
				and p2.Search.SearchesInCatalog
				and p2.Search.SearchesInCatalog[searchUUID]
				and p2.Search.SearchesInCatalog[searchUUID].keyword
		end

		return nil
	end)

	local searchKeywordFromParams = v6.searchKeywordFromParams

	if searchKeywordFromParams then
		return searchKeywordFromParams
	end

	return v7
end

local function useSearchKeywordFromOpaqueRoute()
	local v5 = React.useContext(avatarRouteContext)
	local opaque = v5 and v5.opaque
	local v6 = not (opaque == nil) and opaque.name == avatarScreen.CatalogSearch
	local detail = if v6 and opaque and opaque.params then opaque.params.detail else nil

	local v7 = useSelector(function(p2)
		if detail then
			return p2.Search
				and p2.Search.SearchesInCatalog
				and p2.Search.SearchesInCatalog[detail]
				and p2.Search.SearchesInCatalog[detail].keyword
		end

		return nil
	end)
	local searchKeyword

	if v6 and opaque and opaque.params and opaque.params.searchParams then
		searchKeyword = opaque.params.searchParams.searchKeyword
	end

	if searchKeyword then
		return searchKeyword
	end

	return v7
end

local function useResultsAreSduiEnabled(p2): boolean
	local v5, v6 = module3()
	local v7

	if fFlagAXCatalogSduiUseOpaqueRouteForSearch then
		v7 = useSearchKeywordFromOpaqueRoute()
	elseif fFlagSignalsNavP3gAvatarExperience then
		v7 = useSearchKeywordFromSignals()
	else
		v7 = useSelector(selectSearchKeyword)
	end

	local v8 = useSelector(module4)

	if fFlagAXCatalogSduiDisableOnSearchRoute then
		local v9 = React.useContext(avatarRouteContext)
		local name = v9 and v9.opaque and v9.opaque.name

		if name == avatarScreen.CatalogSearch or name == avatarScreen.CatalogSearchLanding then
			return false
		end
	end

	if fFlagAXCatalogSduiDisableInSearchResults and p2 then
		return false
	end

	return v5 ~= nil and set[v5] == true and (v7 == nil or v7 == "") and v8 == 0
end

return useResultsAreSduiEnabled
