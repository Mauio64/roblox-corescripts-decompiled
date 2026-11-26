local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/NavigationRodux").Selectors
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/NavigationRodux").GetLegacyNavigationStore

local function selectCurrentAvatarRoute(p2)
	local v5

	if fFlagSignalsNavP3gAvatarExperience then
		v5 = getLegacyNavigationStore(false).getCurrentRoute(false)
	elseif fFlagUseNavigationSelectors then
		v5 = p2.Navigation and selectors.selectCurrentRoactNavigationRoute(p2)
	else
		v5 = p2.Navigation and p2.Navigation.currentRoute
	end

	local fromAvatarRoute = v5 and v5.params and v5.params.fromAvatarRoute
	return fromAvatarRoute and fromAvatarRoute.current
end

return selectCurrentAvatarRoute
