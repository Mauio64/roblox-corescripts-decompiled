local parent = script:FindFirstAncestor("Groups").Parent
local React = require(parent.React)

return React.createContext({
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
