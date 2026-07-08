local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local FullscreenPageWithSafeArea = require(Parent.AppBlox).FullscreenPageWithSafeArea
local View = Foundation.View

require(Parent.DataHydration.CreatorAgentChat)

local IconName = Foundation.Enums.IconName
local BuildPageHeader = require(script.Parent.Components.BuildPageHeader.BuildPageHeader)
local BuildChatPage = require(script.Parent.Components.BuildChatPage.BuildChatPage)
local BuildSearchBar = require(script.Parent.Components.BuildSearchBar.BuildSearchBar)
local SubagentStatus = require(script.Parent.Components.SubagentStatus)
local MyCreationsTab = require(script.Parent.Components.MyCreationsTab.MyCreationsTab)
local BuildOverflowMenuScreens = require(script.Parent.Components.BuildPillMenu.BuildOverflowMenuScreens)
local OverflowMenuPageShell = require(script.Parent.Components.BuildPillMenu.OverflowMenuPageShell)
local PublishSheet = require(script.Parent.Components.PublishSheet.PublishSheet)

require(script.Parent.Chat.chatTypes)
require(script.Parent.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
require(script.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)

local BuildNavigationParams = require(script.Parent.utils.BuildNavigationParams)
local useBuildPageLayout = require(script.Parent.utils.useBuildPageLayout)
local useOnScreenKeyboardVisible = require(script.Parent.utils.useOnScreenKeyboardVisible)
local _ = {
	BuildHome = "BuildHome",
	BuildChat = "BuildChat",
	BuildAgents = "BuildAgents",
	BuildAgentDetails = "BuildAgentDetails"
}

local function findGroup(p1, s1: string?) -- line: 59
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v31 in p1.groups do
		if s1 == v31.name then
			return v31
		end
	end

	return nil
end
local function BuildHomeScreen(p2) -- line: 73
	-- upvalues: useBuildPageLayout (copy), React (copy), FullscreenPageWithSafeArea (copy), View (copy), BuildPageHeader (copy), BuildSearchBar (copy), MyCreationsTab (copy), PublishSheet (copy)
	local v33 = p2.screenProps or {}
	local navigation = p2.navigation
	local v35 = useBuildPageLayout()
	local tokens = v35.tokens
	local v37, v38 = React.useState(false)
	local v39, v40 = React.useState(nil)
	local v41 = React.useCallback(function(p3) -- line: 83
		-- upvalues: navigation (copy)
		navigation.navigate("BuildChat", {
			target = p3
		})
	end, { navigation })

	React.useEffect(function() -- line: 89
		-- upvalues: v33 (copy), v41 (copy)
		if v33.universeId == nil and (v33.sessionId == nil or v33.sessionId == "") then
			return
		end

		v41({
			experienceName = "Build Assistant",
			universeId = v33.universeId or 0,
			sessionId = v33.sessionId
		})
	end, {
		v41,
		v33.universeId,
		v33.sessionId
	})

	local v42 = React.useCallback(function(s2: string, s3: string) -- line: 101
		-- upvalues: v40 (copy), v38 (copy)
		v40({
			experienceName = s2,
			gameIcon = s3
		})
		v38(true)
	end, {})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v35.shouldIncludeBottomBar
	}, {
		Page = React.createElement(View, {
			tag = "col align-x-center size-full bg-surface-0"
		}, {
			Header = React.createElement(BuildPageHeader, {
				LayoutOrder = 1,
				height = v35.topBarHeight
			}),
			Content = React.createElement(View, {
				LayoutOrder = 2,
				ZIndex = 4,
				tag = "col align-x-center fill gap-small size-full-0"
			}, {
				SearchBarContainer = React.createElement(View, {
					LayoutOrder = 1,
					ZIndex = 2,
					tag = "composition-content-header size-full-0 auto-y bg-surface-0",
					testId = "BuildPage.SearchBarContainer"
				}, {
					SearchBar = React.createElement(BuildSearchBar, {
						store = v33.searchQueryStore
					})
				}),
				MyCreations = React.createElement(MyCreationsTab, {
					LayoutOrder = 3,
					creatorAgentChatStore = v33.creatorAgentChatStore,
					createStore = v33.createStore,
					configurationStore = v33.configurationStore,
					searchQueryStore = v33.searchQueryStore,
					onOpenChat = v41,
					onPublishExperience = v42
				})
			}),
			PublishSheet = React.createElement(PublishSheet, {
				isOpen = v37,
				experienceName = if not v39 then nil else v39.experienceName,
				gameIcon = if not v39 then nil else v39.gameIcon,
				onClose = function() -- line: 151
					-- upvalues: v38 (copy)
					v38(false)
				end
			})
		})
	})
end
local function BuildChatScreen(p4) -- line: 159
	-- upvalues: BuildNavigationParams (copy), useBuildPageLayout (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildOverflowMenuScreens (copy), BuildChatPage (copy), FullscreenPageWithSafeArea (copy)
	local navigation = p4.navigation
	local v45 = BuildNavigationParams.getTarget(navigation)
	local v46 = useBuildPageLayout()
	local v47 = useOnScreenKeyboardVisible()
	local v48 = React.useCallback(function() -- line: 165
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v49 = React.useCallback(function(p5) -- line: 169
		-- upvalues: navigation (copy), BuildOverflowMenuScreens (copy), v45 (copy)
		navigation.navigate(BuildOverflowMenuScreens.SCREEN_BY_PAGE[p5], {
			target = v45
		})
	end, {
		navigation,
		v45
	})
	local v50 = React.useCallback(function(p6) -- line: 174
		-- upvalues: navigation (copy), v45 (copy)
		navigation.navigate("BuildAgents", {
			target = v45,
			subagentTaskState = p6
		})
	end, {
		navigation,
		v45
	})
	local v51 = if v45 == nil then nil else React.createElement(BuildChatPage, {
		target = v45,
		onClose = v48,
		onOpenAgentsPage = v50,
		onOpenConfigurationPage = v49
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v46.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v46.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v46.shouldIncludeBottomBar and not v47
	}, {
		Page = v51
	})
end
local function BuildAgentsScreen(p7) -- line: 200
	-- upvalues: useBuildPageLayout (copy), BuildNavigationParams (copy), React (copy), SubagentStatus (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), IconName (copy)
	local navigation = p7.navigation
	local v54 = useBuildPageLayout()
	local v55 = BuildNavigationParams.getSubagentTaskState(navigation)
	local v56 = React.useCallback(function() -- line: 205
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v57 = React.useCallback(function(p8) -- line: 208
		-- upvalues: navigation (copy), BuildNavigationParams (copy), v55 (copy)
		navigation.navigate("BuildAgentDetails", {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskState = v55,
			subagentTaskGroupName = p8.name
		})
	end, {
		navigation,
		v55
	})
	local v58 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPage.AgentsList",
		groups = if v55 == nil then {} else v55.groups,
		onAgentActivated = v57
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v54.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v54.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v54.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			title = "Agents",
			testId = "BuildPage.AgentsPage",
			onClose = v56,
			content = v58,
			closeIcon = IconName.ChevronLargeLeft
		})
	})
end
local function BuildAgentDetailsScreen(p9) -- line: 238
	-- upvalues: useBuildPageLayout (copy), BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), IconName (copy)
	local navigation = p9.navigation
	local v61 = useBuildPageLayout()
	local v62 = BuildNavigationParams.getSubagentTaskState(navigation)
	local v63 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v64, g67

	if v62 == nil or v63 == nil then
		v64 = nil
	else
		g67 = nil
		v64 = nil

		for _, v66 in v62.groups do
			if v63 == v66.name then
				v64 = v66
				g67 = true
			end

			if g67 then
				break
			end
		end

		if not g67 then
			v64 = nil
		end
	end

	g67 = false

	local v68 = React.useCallback(function() -- line: 245
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v69 = if v64 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPage.AgentDetailsList",
		group = v64
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v61.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v61.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v61.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.AgentDetailsPage",
			title = v63 or "Agents",
			onClose = v68,
			content = v69,
			closeIcon = IconName.ChevronLargeLeft
		})
	})
end

local v25 = RoactNavigation.createRobloxStackNavigator({
	{
		BuildHome = {
			screen = BuildHomeScreen
		}
	},
	{
		BuildChat = {
			screen = BuildChatScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildPublish] = {
			screen = BuildOverflowMenuScreens.BuildPublishScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildSettings] = {
			screen = BuildOverflowMenuScreens.BuildSettingsScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildAudience] = {
			screen = BuildOverflowMenuScreens.BuildAudienceScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildTitleDescription] = {
			screen = BuildOverflowMenuScreens.BuildTitleDescriptionScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildMediaSelection] = {
			screen = BuildOverflowMenuScreens.BuildMediaSelectionScreen
		}
	},
	{
		BuildAgents = {
			screen = BuildAgentsScreen
		}
	},
	{
		BuildAgentDetails = {
			screen = BuildAgentDetailsScreen
		}
	}
}, {
	initialRouteName = "BuildHome"
})
local v26 = RoactNavigation.createAppContainer(v25)

local function BuildPage(t1: {[any]: any}?) -- line: 329
	-- upvalues: React (copy), v26 (copy)
	return React.createElement(v26, {
		screenProps = t1 or {}
	})
end

return BuildPage
