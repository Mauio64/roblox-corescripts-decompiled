local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent
local React = require(parent.React)
local GroupsAnalyticsContext = require(Groups.Analytics.GroupsAnalyticsContext)

local function useGroupsAnalytics()
	return React.useContext(GroupsAnalyticsContext)
end

return useGroupsAnalytics
