local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local SharedFlags = require(parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3gAvatarExperience = SharedFlags2.FFlagSignalsNavP3gAvatarExperience
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local NavigationRodux2 = require(parent.NavigationRodux)
local GetLegacyNavigationStore = NavigationRodux2.GetLegacyNavigationStore
local selectCurrentAvatarRoute = require(AvatarExperienceCommon.State.Selectors.selectCurrentAvatarRoute)

local function selectSearchKeyword(p)
	local v

	if FFlagSignalsNavP3gAvatarExperience then
		v = GetLegacyNavigationStore(false).getCurrentRoute(false)
	elseif FFlagUseNavigationSelectors then
		v = p.Navigation and Selectors.selectCurrentRoactNavigationRoute(p)
	else
		v = p.Navigation and p.Navigation.currentRoute
	end

	local searchKeyword = v and v.params and v.params.searchParams and v.params.searchParams.searchKeyword

	if searchKeyword then
		return searchKeyword
	end

	local v2 = selectCurrentAvatarRoute(p)

	if not v2 or v2.name ~= AvatarScreen.CatalogSearch then
		return nil
	end

	local key = v2.key
	return p.Search
		and p.Search.SearchesInCatalog
		and p.Search.SearchesInCatalog[key]
		and p.Search.SearchesInCatalog[key].keyword
end

return selectSearchKeyword
