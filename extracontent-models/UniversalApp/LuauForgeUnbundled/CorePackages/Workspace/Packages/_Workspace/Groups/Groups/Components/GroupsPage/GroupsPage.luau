local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RoactUtils").Hooks.useEffectOnce

local fFlagEnableGroupOverviewPane = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags").FFlagEnableGroupOverviewPane
local v5 = if fFlagEnableGroupOverviewPane then require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks/useIsCompactTouch") else nil

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/AppBlox").FullscreenPageWithSafeArea

local v6 = if fFlagEnableGroupOverviewPane then require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupOverviewPane") else nil

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList")
local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")
local useGroupsListData = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks").useGroupsListData

local useGroupsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks/useGroupsAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/EventNames")

local function GroupsPage(p2)
	local v7 = useGroupsWrapperContext()
	local v8 = useTokens()
	local v9 = useGroupsListData(v7.userId)
	local v10 = useGroupsAnalytics()

	local v11 = if fFlagEnableGroupOverviewPane then v5() else false

	useEffectOnce(function()
		v10.fireAnalyticsEvent(EventNames.GroupsListPageExposure)
	end, not (v9.isLoading or v9.loadFailure))

	local element = React.createElement(module3, {
		layoutOrder = 1,
		groupsList = v9.groupsList,
		canCreateGroup = v9.canCreateGroup,
		isLoading = v9.isLoading,
		loadFailure = v9.loadFailure
	})
	local v12

	if fFlagEnableGroupOverviewPane and not v11 then
		v12 = React.createElement(
			view,
			{ testId = "GroupsPage.DesktopLayout", tag = "row size-full-full" },
			{
				Sidebar = React.createElement(
					view,
					{
						LayoutOrder = 1,
						Size = UDim2.new(0, 327, 1, 0),
						tag = "col padding-xlarge",
						testId = "GroupsPage.Sidebar"
					},
					{ GroupsList = element }
				),
				Divider = React.createElement(view, {
					LayoutOrder = 2,
					Size = UDim2.new(0, 1, 1, 0),
					backgroundStyle = v8.Color.Surface.Surface_300,
					testId = "GroupsPage.Divider"
				}),
				MainPage = React.createElement(
					view,
					{
						LayoutOrder = 3,
						tag = "fill size-0-full clip",
						testId = "GroupsPage.Overview"
					},
					{
						GroupOverviewPane = React.createElement(v6, {
							groupId = v7.groupId,
							source = v7.groupOverviewPaneSource
						})
					}
				)
			}
		)
	else
		v12 = React.createElement(
			view,
			{
				tag = "col size-full-full padding-x-xlarge padding-y-xxlarge",
				testId = "GroupsPage.SinglePane"
			},
			{ Content = element }
		)
	end

	return React.createElement(
		fullscreenPageWithSafeArea,
		{
			includeStatusBar = true,
			BackgroundColor3 = v8.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v8.Color.Surface.Surface_0.Transparency
		},
		{ GroupsPageContent = v12 }
	)
end

return GroupsPage
