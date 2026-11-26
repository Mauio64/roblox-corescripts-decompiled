local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsPage")
local fFlagEnableGroupOverviewPane = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags").FFlagEnableGroupOverviewPane
local v5 = if fFlagEnableGroupOverviewPane then require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Navigation/GroupsNavigator") else nil
local v6 = if fFlagEnableGroupOverviewPane then require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Navigation/GroupsRoutes") else nil
local v7 = if fFlagEnableGroupOverviewPane then require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks/useIsCompactTouch") else nil
local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")
local initializeGroupsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/initializeGroupsAnalytics")
local GroupsAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/GroupsAnalyticsContext")

local function GroupsWithContext(p2)
	local v8 = useGroupsWrapperContext()

	if fFlagEnableGroupOverviewPane then
		local v9 = v7()
		local ref = React.useRef(nil)
		React.useEffect(function()
			if v8.groupId == nil then
				ref.current = nil
			elseif p2.navigation and v9 and ref.current ~= v8.groupId then
				ref.current = v8.groupId
				p2.navigation.navigate(v6.GroupOverviewPane, {
					groupId = v8.groupId,
					source = v8.groupOverviewPaneSource
				})
			end
		end, { v8.groupId, v8.groupOverviewPaneSource, p2.navigation, v9 })
	end

	local v9 = React.useMemo(function()
		local v10 = initializeGroupsAnalytics()
		v10.updateInfoForAllEvents({ userId = v8.userId })

		return v10
	end, { v8.userId })

	local v10 = if fFlagEnableGroupOverviewPane then {
		GroupsContent = React.createElement(v5, p2)
	} else {
		GroupsPage = React.createElement(module2, p2)
	}

	return React.createElement(GroupsAnalyticsContext.Provider, { value = v9 }, v10)
end

if not fFlagEnableGroupOverviewPane then
	return GroupsWithContext
end

local extended = React.PureComponent:extend("GroupsNavigatorWithProviders")

function extended.render(p2)
	return React.createElement(GroupsWithContext, p2.props)
end

extended.router = v5.router

return extended
