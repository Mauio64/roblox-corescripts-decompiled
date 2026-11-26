local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceNavigation").Enums.AvatarScreen
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/NavigationRodux").Selectors
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/NavigationRodux").GetLegacyNavigationStore
local selectCurrentAvatarRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectCurrentAvatarRoute")

local function selectSearchKeyword(p2)
	local v5

	if fFlagSignalsNavP3gAvatarExperience then
		v5 = getLegacyNavigationStore(false).getCurrentRoute(false)
	elseif fFlagUseNavigationSelectors then
		v5 = p2.Navigation and selectors.selectCurrentRoactNavigationRoute(p2)
	else
		v5 = p2.Navigation and p2.Navigation.currentRoute
	end

	local searchKeyword = v5
		and v5.params
		and v5.params.searchParams
		and v5.params.searchParams.searchKeyword

	if searchKeyword then
		return searchKeyword
	end

	local v6 = selectCurrentAvatarRoute(p2)

	if not v6 or v6.name ~= avatarScreen.CatalogSearch then
		return nil
	end

	local key = v6.key
	return p2.Search
		and p2.Search.SearchesInCatalog
		and p2.Search.SearchesInCatalog[key]
		and p2.Search.SearchesInCatalog[key].keyword
end

return selectSearchKeyword
