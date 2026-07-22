local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Navigation = require(BuildExperienceParent.Navigation)
local React = require(BuildExperienceParent.React)
local RoactNavigation = require(BuildExperienceParent.RoactNavigation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FullscreenPageWithSafeArea = require(BuildExperienceParent.AppBlox).FullscreenPageWithSafeArea
local View = Foundation.View
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local useNavigationFocus = Navigation.useNavigationFocus
local IconName = Foundation.Enums.IconName
local BuildPageHeader = require(script.Parent.Components.BuildPageHeader.BuildPageHeader)
local BuildChatPage = require(script.Parent.Components.BuildChatPage.BuildChatPage)
local BuildSearchBar = require(script.Parent.Components.BuildSearchBar.BuildSearchBar)
local SubagentStatus = require(script.Parent.Components.SubagentStatus)
local MyCreationsTab = require(script.Parent.Components.MyCreationsTab.MyCreationsTab)
local BuildOverflowMenuScreens = require(script.Parent.Components.BuildPillMenu.BuildOverflowMenuScreens)
local OverflowMenuPageShell = require(script.Parent.Components.BuildPillMenu.OverflowMenuPageShell)

require(script.Parent.Chat.chatTypes)

local useSessionSummary = require(script.Parent.Chat.useSessionSummary)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(script.Parent.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)

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

	for _, v40 in p1.groups do
		if s1 == v40.name then
			return v40
		end
	end

	return nil
end
local function useLiveSubagentTaskState(p2) -- line: 75
	-- upvalues: BuildNavigationParams (copy), CreatorAgentChat (copy), React (copy), useSessionSummary (copy)
	local v42 = BuildNavigationParams.getTarget(p2)

	assert(v42 ~= nil, "Agent pages require a build target")

	local v43 = CreatorAgentChat.getCreatorAgentChatStore()
	local v44 = React.useMemo(function() -- line: 79
		-- upvalues: v43 (copy), v42 (copy)
		return v43.getSessionForProject(v42.universeId, v42.placeId, v42.sessionId)
	end, {
		v43,
		v42.universeId,
		v42.placeId,
		v42.sessionId
	})

	return useSessionSummary(v44).subagentTaskState or BuildNavigationParams.getSubagentTaskState(p2)
end
local function BuildHomeScreen(p3) -- line: 87
	-- upvalues: useBuildPageLayout (copy), useNavigationFocus (copy), React (copy), resumeBuildChat (copy), FullscreenPageWithSafeArea (copy), View (copy), BuildPageHeader (copy), BuildSearchBar (copy), MyCreationsTab (copy)
	local v46 = p3.screenProps or {}
	local navigation = p3.navigation
	local v48 = useBuildPageLayout()
	local v49 = useNavigationFocus()
	local tokens = v48.tokens
	local v51 = React.useCallback(function(p4) -- line: 94
		-- upvalues: navigation (copy)
		navigation.navigate("BuildChat", {
			target = p4
		})
	end, { navigation })

	React.useEffect(function() -- line: 101
		-- upvalues: resumeBuildChat (copy), v46 (copy), v51 (copy)
		return resumeBuildChat({
			universeId = v46.universeId,
			sessionId = v46.sessionId,
			creatorAgentChatStore = v46.creatorAgentChatStore,
			configurationStore = v46.configurationStore,
			onOpenChat = v51
		})
	end, {
		v51,
		v46.universeId,
		v46.sessionId,
		v46.resumeRequestId,
		v46.creatorAgentChatStore,
		v46.configurationStore
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v48.shouldIncludeBottomBar
	}, {
		Page = React.createElement(View, {
			tag = "col align-x-center size-full bg-surface-0"
		}, {
			Header = React.createElement(BuildPageHeader, {
				LayoutOrder = 1,
				height = v48.topBarHeight
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
						store = v46.searchQueryStore
					})
				}),
				MyCreations = React.createElement(MyCreationsTab, {
					LayoutOrder = 3,
					creatorAgentChatStore = v46.creatorAgentChatStore,
					configurationStore = v46.configurationStore,
					searchQueryStore = v46.searchQueryStore,
					isFocused = v49,
					autoOpenNewGame = v46.universeId == nil and v46.sessionId == nil,
					onOpenChat = v51
				})
			})
		})
	})
end
local function BuildChatScreen(p5) -- line: 162
	-- upvalues: BuildNavigationParams (copy), GetBuildExperienceRefreshStore (copy), useBuildPageLayout (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildOverflowMenuScreens (copy), BuildChatPage (copy), FullscreenPageWithSafeArea (copy)
	local navigation = p5.navigation
	local v54 = BuildNavigationParams.getTarget(navigation)
	local v55 = GetBuildExperienceRefreshStore()
	local v56 = useBuildPageLayout()
	local v57 = useOnScreenKeyboardVisible()
	local v58 = React.useCallback(function() -- line: 169
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v59 = React.useCallback(function(p6) -- line: 173
		-- upvalues: navigation (copy), BuildOverflowMenuScreens (copy), v54 (copy)
		navigation.navigate(BuildOverflowMenuScreens.SCREEN_BY_PAGE[p6], {
			target = v54
		})
	end, {
		navigation,
		v54
	})
	local v60 = React.useCallback(function() -- line: 178
		-- upvalues: navigation (copy), v54 (copy)
		navigation.navigate("BuildAgents", {
			target = v54
		})
	end, {
		navigation,
		v54
	})
	local v61 = React.useCallback(function(p7) -- line: 183
		-- upvalues: navigation (copy), v55 (copy)
		navigation.setParams({
			target = p7
		})
		v55.bumpRefreshTick()
	end, {
		navigation,
		v55
	})
	local v62 = if v54 == nil then nil else React.createElement(BuildChatPage, {
		target = v54,
		onClose = v58,
		onOpenAgentsPage = v60,
		onOpenConfigurationPage = v59,
		onNavigateToResolvedTarget = v61
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v56.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v56.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v56.shouldIncludeBottomBar and not v57
	}, {
		Page = v62
	})
end
local function BuildAgentsScreen(p8) -- line: 210
	-- upvalues: useBuildPageLayout (copy), useLiveSubagentTaskState (copy), React (copy), BuildNavigationParams (copy), SubagentStatus (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p8.navigation
	local v65 = useBuildPageLayout()
	local v66 = useLiveSubagentTaskState(navigation)
	local v67 = React.useCallback(function() -- line: 215
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v68 = React.useCallback(function(p9) -- line: 218
		-- upvalues: navigation (copy), BuildNavigationParams (copy)
		navigation.navigate("BuildAgentDetails", {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskGroupName = p9.name
		})
	end, { navigation })
	local v69 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPage.AgentsList",
		groups = if v66 == nil then {} else v66.groups,
		onAgentActivated = v68
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v65.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v65.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v65.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.AgentsPage",
			title = LocalizationStrings.SUBAGENT_STATUS_AGENTS,
			onClose = v67,
			content = v69,
			closeIcon = IconName.ChevronLargeLeft,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_Agents_Scroll"
		})
	})
end
local function BuildAgentDetailsScreen(p10) -- line: 250
	-- upvalues: useBuildPageLayout (copy), useLiveSubagentTaskState (copy), BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p10.navigation
	local v72 = useBuildPageLayout()
	local v73 = useLiveSubagentTaskState(navigation)
	local v74 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v75, g78

	if v73 == nil or v74 == nil then
		v75 = nil
	else
		g78 = nil
		v75 = nil

		for _, v77 in v73.groups do
			if v74 == v77.name then
				v75 = v77
				g78 = true
			end

			if g78 then
				break
			end
		end

		if not g78 then
			v75 = nil
		end
	end

	g78 = false

	local v79 = React.useCallback(function() -- line: 257
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v80 = if v75 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPage.AgentDetailsList",
		group = v75
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v72.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v72.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v72.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.AgentDetailsPage",
			title = v74 or LocalizationStrings.SUBAGENT_STATUS_AGENTS,
			onClose = v79,
			content = v80,
			closeIcon = IconName.ChevronLargeLeft,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_AgentDetails_Scroll"
		})
	})
end

local v34 = RoactNavigation.createRobloxStackNavigator({
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
local v35 = RoactNavigation.createAppContainer(v34)

local function BuildPage(t1: {[any]: any}?) -- line: 344
	-- upvalues: React (copy), v35 (copy)
	return React.createElement(v35, {
		screenProps = t1 or {}
	})
end

return BuildPage
