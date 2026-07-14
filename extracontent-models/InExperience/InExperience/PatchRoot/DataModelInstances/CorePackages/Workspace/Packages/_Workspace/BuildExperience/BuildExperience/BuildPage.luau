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

local GetBuildExperienceRefreshStore = require(script.Parent.Stores.GetBuildExperienceRefreshStore)

require(script.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)

local BuildNavigationParams = require(script.Parent.utils.BuildNavigationParams)
local resumeBuildChat = require(script.Parent.utils.resumeBuildChat)
local useBuildPageLayout = require(script.Parent.utils.useBuildPageLayout)
local useOnScreenKeyboardVisible = require(script.Parent.utils.useOnScreenKeyboardVisible)
local _ = {
	BuildHome = "BuildHome",
	BuildChat = "BuildChat",
	BuildAgents = "BuildAgents",
	BuildAgentDetails = "BuildAgentDetails"
}

local function findGroup(p1, s1: string?) -- line: 61
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v33 in p1.groups do
		if s1 == v33.name then
			return v33
		end
	end

	return nil
end
local function BuildHomeScreen(p2) -- line: 75
	-- upvalues: useBuildPageLayout (copy), React (copy), resumeBuildChat (copy), FullscreenPageWithSafeArea (copy), View (copy), BuildPageHeader (copy), BuildSearchBar (copy), MyCreationsTab (copy), PublishSheet (copy)
	local v35 = p2.screenProps or {}
	local navigation = p2.navigation
	local v37 = useBuildPageLayout()
	local tokens = v37.tokens
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState(nil)
	local v43 = React.useCallback(function(p3) -- line: 85
		-- upvalues: navigation (copy)
		navigation.navigate("BuildChat", {
			target = p3
		})
	end, { navigation })

	React.useEffect(function() -- line: 92
		-- upvalues: resumeBuildChat (copy), v35 (copy), v43 (copy)
		return resumeBuildChat({
			universeId = v35.universeId,
			sessionId = v35.sessionId,
			creatorAgentChatStore = v35.creatorAgentChatStore,
			configurationStore = v35.configurationStore,
			onOpenChat = v43
		})
	end, {
		v43,
		v35.universeId,
		v35.sessionId,
		v35.resumeRequestId,
		v35.creatorAgentChatStore,
		v35.configurationStore
	})

	local v44 = React.useCallback(function(s2: string, s3: string) -- line: 111
		-- upvalues: v42 (copy), v40 (copy)
		v42({
			experienceName = s2,
			gameIcon = s3
		})
		v40(true)
	end, {})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v37.shouldIncludeBottomBar
	}, {
		Page = React.createElement(View, {
			tag = "col align-x-center size-full bg-surface-0"
		}, {
			Header = React.createElement(BuildPageHeader, {
				LayoutOrder = 1,
				height = v37.topBarHeight
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
						store = v35.searchQueryStore
					})
				}),
				MyCreations = React.createElement(MyCreationsTab, {
					LayoutOrder = 3,
					creatorAgentChatStore = v35.creatorAgentChatStore,
					configurationStore = v35.configurationStore,
					searchQueryStore = v35.searchQueryStore,
					onOpenChat = v43,
					onPublishExperience = v44
				})
			}),
			PublishSheet = React.createElement(PublishSheet, {
				isOpen = v39,
				experienceName = if not v41 then nil else v41.experienceName,
				gameIcon = if not v41 then nil else v41.gameIcon,
				onClose = function() -- line: 160
					-- upvalues: v40 (copy)
					v40(false)
				end
			})
		})
	})
end
local function BuildChatScreen(p4) -- line: 168
	-- upvalues: BuildNavigationParams (copy), GetBuildExperienceRefreshStore (copy), useBuildPageLayout (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildOverflowMenuScreens (copy), BuildChatPage (copy), FullscreenPageWithSafeArea (copy)
	local navigation = p4.navigation
	local v47 = BuildNavigationParams.getTarget(navigation)
	local v48 = GetBuildExperienceRefreshStore()
	local v49 = useBuildPageLayout()
	local v50 = useOnScreenKeyboardVisible()
	local v51 = React.useCallback(function() -- line: 175
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v52 = React.useCallback(function(p5) -- line: 179
		-- upvalues: navigation (copy), BuildOverflowMenuScreens (copy), v47 (copy)
		navigation.navigate(BuildOverflowMenuScreens.SCREEN_BY_PAGE[p5], {
			target = v47
		})
	end, {
		navigation,
		v47
	})
	local v53 = React.useCallback(function(p6) -- line: 184
		-- upvalues: navigation (copy), v47 (copy)
		navigation.navigate("BuildAgents", {
			target = v47,
			subagentTaskState = p6
		})
	end, {
		navigation,
		v47
	})
	local v54 = React.useCallback(function(p7) -- line: 190
		-- upvalues: navigation (copy), v48 (copy)
		navigation.setParams({
			target = p7
		})
		v48.bumpRefreshTick()
	end, {
		navigation,
		v48
	})
	local v55 = if v47 == nil then nil else React.createElement(BuildChatPage, {
		target = v47,
		onClose = v51,
		onOpenAgentsPage = v53,
		onOpenConfigurationPage = v52,
		onNavigateToResolvedTarget = v54
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v49.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v49.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v49.shouldIncludeBottomBar and not v50
	}, {
		Page = v55
	})
end
local function BuildAgentsScreen(p8) -- line: 217
	-- upvalues: useBuildPageLayout (copy), BuildNavigationParams (copy), React (copy), SubagentStatus (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), IconName (copy)
	local navigation = p8.navigation
	local v58 = useBuildPageLayout()
	local v59 = BuildNavigationParams.getSubagentTaskState(navigation)
	local v60 = React.useCallback(function() -- line: 222
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v61 = React.useCallback(function(p9) -- line: 225
		-- upvalues: navigation (copy), BuildNavigationParams (copy), v59 (copy)
		navigation.navigate("BuildAgentDetails", {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskState = v59,
			subagentTaskGroupName = p9.name
		})
	end, {
		navigation,
		v59
	})
	local v62 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPage.AgentsList",
		groups = if v59 == nil then {} else v59.groups,
		onAgentActivated = v61
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v58.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v58.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v58.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			title = "Agents",
			testId = "BuildPage.AgentsPage",
			onClose = v60,
			content = v62,
			closeIcon = IconName.ChevronLargeLeft
		})
	})
end
local function BuildAgentDetailsScreen(p10) -- line: 255
	-- upvalues: useBuildPageLayout (copy), BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), IconName (copy)
	local navigation = p10.navigation
	local v65 = useBuildPageLayout()
	local v66 = BuildNavigationParams.getSubagentTaskState(navigation)
	local v67 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v68, g71

	if v66 == nil or v67 == nil then
		v68 = nil
	else
		g71 = nil
		v68 = nil

		for _, v70 in v66.groups do
			if v67 == v70.name then
				v68 = v70
				g71 = true
			end

			if g71 then
				break
			end
		end

		if not g71 then
			v68 = nil
		end
	end

	g71 = false

	local v72 = React.useCallback(function() -- line: 262
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v73 = if v68 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPage.AgentDetailsList",
		group = v68
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v65.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v65.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v65.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.AgentDetailsPage",
			title = v67 or "Agents",
			onClose = v72,
			content = v73,
			closeIcon = IconName.ChevronLargeLeft
		})
	})
end

local v27 = RoactNavigation.createRobloxStackNavigator({
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
local v28 = RoactNavigation.createAppContainer(v27)

local function BuildPage(t1: {[any]: any}?) -- line: 346
	-- upvalues: React (copy), v28 (copy)
	return React.createElement(v28, {
		screenProps = t1 or {}
	})
end

return BuildPage
