local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local useIsCompactTouch

if FFlagEnableGroupOverviewPane then
	useIsCompactTouch = require(Groups.Hooks.useIsCompactTouch)
else
	useIsCompactTouch = nil
end

local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local GroupOverviewPane

if FFlagEnableGroupOverviewPane then
	GroupOverviewPane = require(Groups.Components.GroupOverviewPane)
else
	GroupOverviewPane = nil
end

local GroupsList = require(Groups.Components.GroupsList)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local Hooks = require(Groups.Hooks)
local useGroupsListData = Hooks.useGroupsListData

local useGroupsAnalytics = require(Groups.Hooks.useGroupsAnalytics)
local EventNames = require(Groups.Analytics.EventNames)

local function GroupsPage(_)
	local v = useGroupsWrapperContext()
	local v2 = useTokens()
	local v3 = useGroupsListData(v.userId)
	local v4 = useGroupsAnalytics()
	local v5

	if FFlagEnableGroupOverviewPane then
		v5 = useIsCompactTouch()
	else
		v5 = false
	end

	useEffectOnce(function()
		v4.fireAnalyticsEvent(EventNames.GroupsListPageExposure)
	end, not (v3.isLoading or v3.loadFailure))

	local element = React.createElement(GroupsList, {
		layoutOrder = 1,
		groupsList = v3.groupsList,
		canCreateGroup = v3.canCreateGroup,
		isLoading = v3.isLoading,
		loadFailure = v3.loadFailure
	})
	local groupsPageContent

	if FFlagEnableGroupOverviewPane and not v5 then
		groupsPageContent = React.createElement(
			View,
			{ testId = "GroupsPage.DesktopLayout", tag = "row size-full-full" },
			{
				Sidebar = React.createElement(
					View,
					{
						LayoutOrder = 1,
						Size = UDim2.new(0, 327, 1, 0),
						tag = "col padding-xlarge",
						testId = "GroupsPage.Sidebar"
					},
					{ GroupsList = element }
				),
				Divider = React.createElement(View, {
					LayoutOrder = 2,
					Size = UDim2.new(0, 1, 1, 0),
					backgroundStyle = v2.Color.Surface.Surface_300,
					testId = "GroupsPage.Divider"
				}),
				MainPage = React.createElement(
					View,
					{
						LayoutOrder = 3,
						tag = "fill size-0-full clip",
						testId = "GroupsPage.Overview"
					},
					{
						GroupOverviewPane = React.createElement(GroupOverviewPane, {
							groupId = v.groupId,
							source = v.groupOverviewPaneSource
						})
					}
				)
			}
		)
	else
		groupsPageContent = React.createElement(
			View,
			{
				tag = "col size-full-full padding-x-xlarge padding-y-xxlarge",
				testId = "GroupsPage.SinglePane"
			},
			{ Content = element }
		)
	end

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			includeStatusBar = true,
			BackgroundColor3 = v2.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v2.Color.Surface.Surface_0.Transparency
		},
		{ GroupsPageContent = groupsPageContent }
	)
end

return GroupsPage
