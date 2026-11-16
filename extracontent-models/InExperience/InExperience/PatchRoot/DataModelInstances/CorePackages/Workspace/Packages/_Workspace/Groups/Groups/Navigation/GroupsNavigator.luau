local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

require(parent.Navigation)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local GroupOverviewPane = require(Groups.Components.GroupOverviewPane)
local GroupsPage = require(Groups.Components.GroupsPage)
local GroupsRoutes = require(script.Parent.GroupsRoutes)

local function renderGroupsPage(_)
	return React.createElement(GroupsPage)
end

local function renderGroupOverviewPane(p)
	return React.createElement(GroupOverviewPane, { navigation = p.navigation })
end

local v = {
	[GroupsRoutes.GroupsPage] = { screen = renderGroupsPage }
}

local v2 = {
	[GroupsRoutes.GroupOverviewPane] = {
		screen = renderGroupOverviewPane,
		navigationOptions = { disableBackButton = false }
	}
}
return RoactNavigation.createRobloxStackNavigator({ v, v2 }, {
	initialRouteName = GroupsRoutes.GroupsPage,
	keepVisitedScreensMounted = false,
	backBehavior = RoactNavigation.BackBehavior.History
})
