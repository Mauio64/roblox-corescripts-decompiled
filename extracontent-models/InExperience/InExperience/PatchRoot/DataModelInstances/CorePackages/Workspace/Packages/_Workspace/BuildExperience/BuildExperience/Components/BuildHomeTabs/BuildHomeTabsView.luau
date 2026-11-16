local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local FFlagBuildExperienceFoundationTabs = require(BuildExperience.Flags.FFlagBuildExperienceFoundationTabs)
local SharedFlags = require(parent.SharedFlags)
local FFlagSubTabSizeSmall = SharedFlags.FFlagSubTabSizeSmall

local BuildTabStrip = require(BuildExperience.Components.BuildTabStrip.BuildTabStrip)
local createBuildHomeTabStore = require(BuildExperience.Stores.GetBuildHomeTabStore.createBuildHomeTabStore)
require(script.Parent.useBuildHomeTabsViewModel)

local View = Foundation.View

local createNextOrder = ReactUtils.createNextOrder

local BUILD_HOME_TAB = createBuildHomeTabStore.BUILD_HOME_TAB

local function isPageShown(p: number, p2: number, flag: boolean) -- 2 equivalent calls inferred from this helper
	return flag or math.abs(p - p2) < 1
end

local function BuildHomeTabsView(props)
	local tabOrder = props.tabOrder
	local pageOffset = props.pageOffset

	local nextOrder = createNextOrder()

	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		tag = "col fill size-full",
		testId = "BuildHomeTabs"
	}
	local tabsLayout

	if props.showTabs then
		local createElement2 = React.createElement
		local v2 = {
			LayoutOrder = nextOrder(),
			tag = "composition-layout-detail size-full-0 auto-y"
		}

		local createElement3 = React.createElement
		local tabs2

		if FFlagBuildExperienceFoundationTabs then
			local createElement4 = React.createElement
			local tabs = Foundation.Tabs
			local v3 = {
				activeTabId = props.activeTab,
				onActivated = props.onTabActivated,
				tabs = props.tabs,
				size = 0,
				fillBehavior = 0,
				testId = "BuildHomeTabs.Tabs"
			}
			local size

			if FFlagSubTabSizeSmall then
				size = Foundation.Enums.InputSize.Small
			else
				size = Foundation.Enums.InputSize.Medium
			end

			v3.size = size

			v3.fillBehavior = props.tabsFillBehavior
			tabs2 = createElement4(tabs, v3)
		else
			tabs2 = React.createElement(BuildTabStrip, {
				activeTabId = props.activeTab,
				activeOffset = pageOffset,
				onActivated = props.onTabActivated,
				tabs = props.tabs,
				testId = "BuildHomeTabs.Tabs"
			})
		end

		tabsLayout = createElement2(View, v2, {
			TabsBody = createElement3(View, {
				tag = "composition-content-body col size-full-0 auto-y"
			}, {
				Tabs = tabs2
			})
		})
	end

	return createElement(View, v, {
		TabsLayout = tabsLayout,
		Panes = React.createElement(
			View,
			{
				LayoutOrder = nextOrder(),
				tag = "fill size-full clip",
				testId = "BuildHomeTabs.Panes"
			},
			{
				GamesPage = React.createElement(View, {
					Position = pageOffset:map(function(p: number)
						return UDim2.fromScale(tabOrder[BUILD_HOME_TAB.Games] - p, 0)
					end),
					tag = "size-full",
					testId = "BuildHomeTabs.GamesPage"
				}, {
					Content = React.createElement(View, {
						Visible = pageOffset:map(function(p: number)
							return isPageShown( -- inferred equivalent call
								tabOrder[BUILD_HOME_TAB.Games],
								p,
								props.activeTab == BUILD_HOME_TAB.Games
							)
						end),
						tag = "size-full",
						testId = "BuildHomeTabs.GamesContent"
					}, { Content = props.gamesContent })
				}),
				PreviewsPage = React.createElement(View, {
					Position = pageOffset:map(function(p: number)
						return UDim2.fromScale(tabOrder[BUILD_HOME_TAB.Previews] - p, 0)
					end),
					tag = "size-full",
					testId = "BuildHomeTabs.PreviewsPage"
				}, {
					Content = React.createElement(View, {
						Visible = pageOffset:map(function(p: number)
							return isPageShown( -- inferred equivalent call
								tabOrder[BUILD_HOME_TAB.Previews],
								p,
								props.activeTab == BUILD_HOME_TAB.Previews
							)
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
