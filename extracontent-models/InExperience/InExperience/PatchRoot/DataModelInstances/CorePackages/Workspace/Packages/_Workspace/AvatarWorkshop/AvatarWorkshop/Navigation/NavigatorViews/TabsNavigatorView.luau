local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

require(parent.Foundation)
local Localization = require(parent.Localization)
local RoactNavigation = require(parent.RoactNavigation)
local React = require(parent.React)

require(AvatarWorkshop.Navigation.NavigationTypes)
local TabsLayout = require(AvatarWorkshop.Components.Layouts.TabsLayout)
local getActiveRoute = require(AvatarWorkshop.Navigation.getActiveRoute)
local ScreenTitles = require(AvatarWorkshop.Constants.ScreenTitles)

local useLocalization = Localization.Hooks.useLocalization

local function TabsNavigatorView(p)
	local activeRoute = getActiveRoute(p.navigation)

	local routes = p.navigation.state.routes
	local v = useLocalization(ScreenTitles)
	local tabs = {}

	for _, route in routes do
		table.insert(tabs, {
			id = route.key,
			text = v[route.routeName] or route.routeName
		})
	end

	local onTabActivated = React.useCallback(function(p2)
		for _, route in routes do
			if route.key == p2 then
				p.navigation.navigate(route.routeName)
				break
			end
		end
	end, { p.navigation, routes })

	local key = p.navigation.state.key
	local testId = not key and "--avatar-workshop-tabs" or `--avatar-workshop-tabs-{key}`

	return React.createElement(
		TabsLayout,
		{
			tabs = tabs,
			activeTabId = activeRoute.key,
			onTabActivated = onTabActivated,
			testId = testId
		},
		{
			Content = React.createElement(RoactNavigation.RobloxSwitchView, p)
		}
	)
end

return TabsNavigatorView
