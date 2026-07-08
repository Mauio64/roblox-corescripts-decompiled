local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local GroupsPage = require(Groups.Components.GroupsPage)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local initializeGroupsAnalytics = require(Groups.Analytics.initializeGroupsAnalytics)
local GroupsAnalyticsContext = require(Groups.Analytics.GroupsAnalyticsContext)

local function GroupsWithContext(p1) -- line: 19
	-- upvalues: useGroupsWrapperContext (copy), React (copy), initializeGroupsAnalytics (copy), GroupsAnalyticsContext (copy), GroupsPage (copy)
	local v10 = useGroupsWrapperContext()
	local v11 = React.useMemo(function() -- line: 22
		-- upvalues: initializeGroupsAnalytics (copy), v10 (copy)
		local v12 = initializeGroupsAnalytics()

		v12.updateInfoForAllEvents({
			userId = v10.userId
		})

		return v12
	end, { v10.userId })

	return React.createElement(GroupsAnalyticsContext.Provider, {
		value = v11
	}, {
		GroupsPage = React.createElement(GroupsPage, p1)
	})
end

return GroupsWithContext
