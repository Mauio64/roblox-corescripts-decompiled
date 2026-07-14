local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarScreen = require(AvatarExperienceCommonParent.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagUseNavigationSelectors = require(AvatarExperienceCommonParent.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(AvatarExperienceCommonParent.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local Selectors = require(AvatarExperienceCommonParent.NavigationRodux).Selectors
local GetLegacyNavigationStore = require(AvatarExperienceCommonParent.NavigationRodux).GetLegacyNavigationStore
local selectCurrentAvatarRoute = require(AvatarExperienceCommon.State.Selectors.selectCurrentAvatarRoute)

local function selectSearchKeyword(p1) -- line: 10
	-- upvalues: FFlagSignalsNavP3gAvatarExperience (copy), GetLegacyNavigationStore (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), selectCurrentAvatarRoute (copy), AvatarScreen (copy)
	local v11 = if not FFlagSignalsNavP3gAvatarExperience then if not FFlagUseNavigationSelectors then p1.Navigation and p1.Navigation.currentRoute else p1.Navigation and Selectors.selectCurrentRoactNavigationRoute(p1) else GetLegacyNavigationStore(false).getCurrentRoute(false)
	local v12 = v11 and (v11.params and (v11.params.searchParams and v11.params.searchParams.searchKeyword))

	if v12 then
		return v12
	end

	local v13 = selectCurrentAvatarRoute(p1)

	if v13 and v13.name == AvatarScreen.CatalogSearch then
		local key = v13.key

		return p1.Search and (p1.Search.SearchesInCatalog and (p1.Search.SearchesInCatalog[key] and p1.Search.SearchesInCatalog[key].keyword))
	end

	return nil
end

return selectSearchKeyword
