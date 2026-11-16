local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")

require(AvatarWorkshop.Navigation.NavigationTypes)

local function getActiveRoute(p)
	return p.state.routes[p.state.index]
end

return getActiveRoute
