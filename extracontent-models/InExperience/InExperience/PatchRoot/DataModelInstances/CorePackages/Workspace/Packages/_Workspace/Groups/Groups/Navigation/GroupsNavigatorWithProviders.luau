local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)

local GroupsPage = require(Groups.Components.GroupsPage)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local GroupsNavigator

if FFlagEnableGroupOverviewPane then
	GroupsNavigator = require(script.Parent.GroupsNavigator)
else
	GroupsNavigator = nil
end

local GroupsRoutes

if FFlagEnableGroupOverviewPane then
	GroupsRoutes = require(script.Parent.GroupsRoutes)
else
	GroupsRoutes = nil
end

local useIsCompactTouch

if FFlagEnableGroupOverviewPane then
	useIsCompactTouch = require(Groups.Hooks.useIsCompactTouch)
else
	useIsCompactTouch = nil
end

local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local initializeGroupsAnalytics = require(Groups.Analytics.initializeGroupsAnalytics)
local GroupsAnalyticsContext = require(Groups.Analytics.GroupsAnalyticsContext)

local function GroupsWithContext(p)
	local v = useGroupsWrapperContext()

	if FFlagEnableGroupOverviewPane then
		local v2 = useIsCompactTouch()
		local ref = React.useRef(nil)
		React.useEffect(function()
			if v.groupId == nil then
				ref.current = nil
			elseif p.navigation and v2 and ref.current ~= v.groupId then
				ref.current = v.groupId
				p.navigation.navigate(GroupsRoutes.GroupOverviewPane, {
					groupId = v.groupId,
					source = v.groupOverviewPaneSource
				})
			end
		end, { v.groupId, v.groupOverviewPaneSource, p.navigation, v2 })
	end

	local v2 = React.useMemo(function()
		local v2 = initializeGroupsAnalytics()
		v2.updateInfoForAllEvents({ userId = v.userId })

		return v2
	end, { v.userId })
	local v3

	if FFlagEnableGroupOverviewPane then
		v3 = {
			GroupsContent = React.createElement(GroupsNavigator, p)
		}
	else
		v3 = {
			GroupsPage = React.createElement(GroupsPage, p)
		}
	end

	return React.createElement(GroupsAnalyticsContext.Provider, { value = v2 }, v3)
end

if not FFlagEnableGroupOverviewPane then
	return GroupsWithContext
end

local extended = React.PureComponent:extend("GroupsNavigatorWithProviders")

function extended.render(p)
	return React.createElement(GroupsWithContext, p.props)
end

extended.router = GroupsNavigator.router

return extended
