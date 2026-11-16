return require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React").createContext({
	navigateTo = {
		previousView = nil,
		webView = function() end,
		groupDetails = function() end,
		seeAllGroups = function() end,
		createGroup = function() end
	},
	userId = "",
	groupId = nil,
	groupOverviewPaneSource = nil
})
