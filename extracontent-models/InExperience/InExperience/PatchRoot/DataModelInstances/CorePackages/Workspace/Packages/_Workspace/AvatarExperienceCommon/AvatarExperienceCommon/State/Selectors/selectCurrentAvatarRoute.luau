local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local FFlagUseNavigationSelectors = require(Parent.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(Parent.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local Selectors = require(Parent.NavigationRodux).Selectors
local GetLegacyNavigationStore = require(Parent.NavigationRodux).GetLegacyNavigationStore

local function selectCurrentAvatarRoute(p1) -- line: 8
	-- upvalues: FFlagSignalsNavP3gAvatarExperience (copy), GetLegacyNavigationStore (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v8 = if not FFlagSignalsNavP3gAvatarExperience then if not FFlagUseNavigationSelectors then p1.Navigation and p1.Navigation.currentRoute else p1.Navigation and Selectors.selectCurrentRoactNavigationRoute(p1) else GetLegacyNavigationStore(false).getCurrentRoute(false)
	local v9 = v8 and (v8.params and v8.params.fromAvatarRoute)

	return v9 and v9.current
end

return selectCurrentAvatarRoute
