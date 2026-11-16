local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3gAvatarExperience = SharedFlags2.FFlagSignalsNavP3gAvatarExperience
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local NavigationRodux2 = require(parent.NavigationRodux)
local GetLegacyNavigationStore = NavigationRodux2.GetLegacyNavigationStore

local function selectCurrentAvatarRoute(p)
	local v

	if FFlagSignalsNavP3gAvatarExperience then
		v = GetLegacyNavigationStore(false).getCurrentRoute(false)
	elseif FFlagUseNavigationSelectors then
		v = p.Navigation and Selectors.selectCurrentRoactNavigationRoute(p)
	else
		v = p.Navigation and p.Navigation.currentRoute
	end

	local fromAvatarRoute = v and v.params and v.params.fromAvatarRoute
	return fromAvatarRoute and fromAvatarRoute.current
end

return selectCurrentAvatarRoute
