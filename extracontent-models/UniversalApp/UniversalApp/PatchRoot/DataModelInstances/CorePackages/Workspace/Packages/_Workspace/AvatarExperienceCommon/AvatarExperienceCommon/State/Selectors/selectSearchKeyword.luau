local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarScreen = require(AvatarExperienceCommonParent.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagUseNavigationSelectors = require(AvatarExperienceCommonParent.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(AvatarExperienceCommonParent.NavigationRodux).Selectors
local selectCurrentAvatarRoute = require(AvatarExperienceCommon.State.Selectors.selectCurrentAvatarRoute)

local function selectSearchKeyword(p1) -- line: 8
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), selectCurrentAvatarRoute (copy), AvatarScreen (copy)
	local v9 = if not FFlagUseNavigationSelectors then p1.Navigation and p1.Navigation.currentRoute else p1.Navigation and Selectors.selectCurrentRoactNavigationRoute(p1)
	local v10 = v9 and (v9.params and (v9.params.searchParams and v9.params.searchParams.searchKeyword))

	if v10 then
		return v10
	end

	local v11 = selectCurrentAvatarRoute(p1)

	if v11 and v11.name == AvatarScreen.CatalogSearch then
		local key = v11.key

		return p1.Search and (p1.Search.SearchesInCatalog and (p1.Search.SearchesInCatalog[key] and p1.Search.SearchesInCatalog[key].keyword))
	end

	return nil
end

return selectSearchKeyword
