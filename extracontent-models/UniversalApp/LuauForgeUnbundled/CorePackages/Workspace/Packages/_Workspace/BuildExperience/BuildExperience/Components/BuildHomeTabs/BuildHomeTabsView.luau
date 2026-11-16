local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactUtils")

local FFlagBuildExperienceFoundationTabs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFoundationTabs")
local fFlagSubTabSizeSmall = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagSubTabSizeSmall

local BuildTabStrip = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildTabStrip/BuildTabStrip")
local createBuildHomeTabStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildHomeTabStore/createBuildHomeTabStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildHomeTabs/useBuildHomeTabsViewModel")

local view = Foundation.View

local createNextOrder = ReactUtils.createNextOrder

local BUILD_HOME_TAB = createBuildHomeTabStore.BUILD_HOME_TAB

local function isPageShown(p2, p3, p4)
	return p4 or math.abs(p2 - p3) < 1
end

local function BuildHomeTabsView(props)
	local tabOrder = props.tabOrder
	local pageOffset = props.pageOffset

	local nextOrder = createNextOrder()

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col fill size-full",
		testId = "BuildHomeTabs"
	}
	local v8

	if props.showTabs then
		local createElement2 = React.createElement
		local v10 = {
			LayoutOrder = nextOrder(),
			tag = "composition-layout-detail size-full-0 auto-y"
		}

		local createElement3 = React.createElement
		local v15

		if FFlagBuildExperienceFoundationTabs then
			local createElement4 = React.createElement
			local tabs = Foundation.Tabs
			local v16 = {
				activeTabId = props.activeTab,
				onActivated = props.onTabActivated,
				tabs = props.tabs,
				size = 0,
				fillBehavior = 0,
				testId = "BuildHomeTabs.Tabs"
			}

			local v17 = if fFlagSubTabSizeSmall then Foundation.Enums.InputSize.Small else Foundation.Enums.InputSize.Medium
			v16.size = v17

			v16.fillBehavior = props.tabsFillBehavior
			v15 = createElement4(tabs, v16)
		else
			v15 = React.createElement(BuildTabStrip, {
				activeTabId = props.activeTab,
				activeOffset = pageOffset,
				onActivated = props.onTabActivated,
				tabs = props.tabs,
				testId = "BuildHomeTabs.Tabs"
			})
		end

		v8 = createElement2(view, v10, {
			TabsBody = createElement3(view, {
				tag = "composition-content-body col size-full-0 auto-y"
			}, {
				Tabs = v15
			})
		})
	end

	return createElement(view, v6, {
		TabsLayout = v8,
		Panes = React.createElement(
			view,
			{
				LayoutOrder = nextOrder(),
				tag = "fill size-full clip",
				testId = "BuildHomeTabs.Panes"
			},
			{
				GamesPage = React.createElement(view, {
					Position = pageOffset:map(function(p2)
						return UDim2.fromScale(tabOrder[BUILD_HOME_TAB.Games] - p2, 0)
					end),
					tag = "size-full",
					testId = "BuildHomeTabs.GamesPage"
				}, {
					Content = React.createElement(view, {
						Visible = pageOffset:map(function(p2): boolean
							local v9 = tabOrder[BUILD_HOME_TAB.Games]
							return props.activeTab == BUILD_HOME_TAB.Games or math.abs(v9 - p2) < 1
						end),
						tag = "size-full",
						testId = "BuildHomeTabs.GamesContent"
					}, { Content = props.gamesContent })
				}),
				PreviewsPage = React.createElement(view, {
					Position = pageOffset:map(function(p2)
						return UDim2.fromScale(tabOrder[BUILD_HOME_TAB.Previews] - p2, 0)
					end),
					tag = "size-full",
					testId = "BuildHomeTabs.PreviewsPage"
				}, {
					Content = React.createElement(view, {
						Visible = pageOffset:map(function(p2): boolean
							local v9 = tabOrder[BUILD_HOME_TAB.Previews]
							return props.activeTab == BUILD_HOME_TAB.Previews or math.abs(v9 - p2) < 1
						end),
						tag = "size-full",
						testId = "BuildHomeTabs.PreviewsContent"
					}, { Content = props.previewsContent })
				})
			}
		)
	})
end

return BuildHomeTabsView
