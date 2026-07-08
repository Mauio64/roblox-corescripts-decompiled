local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local GroupsAnalyticsContext = require(Groups.Analytics.GroupsAnalyticsContext)

local function useGroupsAnalytics() -- line: 13
	-- upvalues: React (copy), GroupsAnalyticsContext (copy)
	return React.useContext(GroupsAnalyticsContext)
end

return useGroupsAnalytics
