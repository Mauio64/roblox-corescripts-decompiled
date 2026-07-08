local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local FFlagUseNavigationSelectors = require(Parent.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(Parent.NavigationRodux).Selectors

local function selectCurrentAvatarRoute(p1) -- line: 6
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v6 = if not FFlagUseNavigationSelectors then p1.Navigation and p1.Navigation.currentRoute else p1.Navigation and Selectors.selectCurrentRoactNavigationRoute(p1)
	local v7 = v6 and (v6.params and v6.params.fromAvatarRoute)

	return v7 and v7.current
end

return selectCurrentAvatarRoute
