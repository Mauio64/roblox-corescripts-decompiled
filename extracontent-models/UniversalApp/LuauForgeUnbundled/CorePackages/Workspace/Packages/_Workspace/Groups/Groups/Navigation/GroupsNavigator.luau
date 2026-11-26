require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RoactNavigation")

local GroupOverviewPane = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupOverviewPane")
local GroupsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsPage")
local GroupsRoutes = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Navigation/GroupsRoutes")

local function renderGroupsPage(p2)
	return React.createElement(GroupsPage)
end

local function renderGroupOverviewPane(p2)
	return React.createElement(GroupOverviewPane, { navigation = p2.navigation })
end

local v5 = {
	[GroupsRoutes.GroupsPage] = { screen = renderGroupsPage }
}

local v6 = {
	[GroupsRoutes.GroupOverviewPane] = {
		screen = renderGroupOverviewPane,
		navigationOptions = { disableBackButton = false }
	}
}
return RoactNavigation.createRobloxStackNavigator({ v5, v6 }, {
	initialRouteName = GroupsRoutes.GroupsPage,
	keepVisitedScreensMounted = false,
	backBehavior = RoactNavigation.BackBehavior.History
})
