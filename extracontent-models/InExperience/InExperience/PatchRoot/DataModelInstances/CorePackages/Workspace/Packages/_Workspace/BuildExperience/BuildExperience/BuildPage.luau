local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Navigation = require(BuildExperienceParent.Navigation)
local React = require(BuildExperienceParent.React)
local RoactNavigation = require(BuildExperienceParent.RoactNavigation)
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FullscreenPageWithSafeArea = require(BuildExperienceParent.AppBlox).FullscreenPageWithSafeArea
local Loading = Foundation.Loading
local View = Foundation.View
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local useNavigationFocus = Navigation.useNavigationFocus
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local BuildPageHeader = require(script.Parent.Components.BuildPageHeader.BuildPageHeader)
local BuildChatPage = require(script.Parent.Components.BuildChatPage.BuildChatPage)
local BuildSearchBar = require(script.Parent.Components.BuildSearchBar.BuildSearchBar)
local SubagentStatus = require(script.Parent.Components.SubagentStatus)
local MyCreationsTab = require(script.Parent.Components.MyCreationsTab.MyCreationsTab)
local BuildOverflowMenuScreens = require(script.Parent.Components.BuildPillMenu.BuildOverflowMenuScreens)
local OverflowMenuPageShell = require(script.Parent.Components.BuildPillMenu.OverflowMenuPageShell)
local PrivateInvitesPickerHost = require(script.Parent.Components.PrivateInvitesPicker.PrivateInvitesPickerHost)
local CreatorCreditPageContainer = require(script.Parent.Components.CreatorCreditSheet.CreatorCreditPageContainer)
local CreatorCreditBalanceChipContainer = require(script.Parent.Components.CreatorCreditSheet.CreatorCreditBalanceChip.CreatorCreditBalanceChipContainer)

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
local v33 = not SharedFlags.FFlagEnableBuildTabOverride
local BuildEligibilityDialog = require(script.Parent.Components.BuildEligibilityDialog)
local useBuildPageEligibility = require(script.Parent.useBuildPageEligibility)
local _ = {
	BuildHome = "BuildHome",
	BuildChat = "BuildChat",
	BuildAgents = "BuildAgents",
	BuildAgentDetails = "BuildAgentDetails",
	BuildCreatorCredit = "BuildCreatorCredit"
}

local function findGroup(p1, s1: string?) -- line: 74
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v50 in p1.groups do
		if s1 == v50.name then
			return v50
		end
	end

	return nil
end
local function useLiveSubagentTaskState(p2) -- line: 88
	-- upvalues: BuildNavigationParams (copy), CreatorAgentChat (copy), React (copy), useSessionSummary (copy)
	local v52 = BuildNavigationParams.getTarget(p2)

	assert(v52 ~= nil, "Agent pages require a build target")

	local v53 = CreatorAgentChat.getCreatorAgentChatStore()
	local v54 = React.useMemo(function() -- line: 92
		-- upvalues: v53 (copy), v52 (copy)
		return v53.getSessionForProject(v52.universeId, v52.placeId, v52.sessionId)
	end, {
		v53,
		v52.universeId,
		v52.placeId,
		v52.sessionId
	})

	return useSessionSummary(v54).subagentTaskState or BuildNavigationParams.getSubagentTaskState(p2)
end
local function BuildHomeScreen(p3) -- line: 100
	-- upvalues: useBuildPageLayout (copy), useNavigationFocus (copy), React (copy), resumeBuildChat (copy), FullscreenPageWithSafeArea (copy), View (copy), BuildPageHeader (copy), BuildSearchBar (copy), MyCreationsTab (copy)
	local v56 = p3.screenProps or {}
	local navigation = p3.navigation
	local v58 = useBuildPageLayout()
	local v59 = useNavigationFocus()
	local tokens = v58.tokens
	local v61 = React.useCallback(function(p4) -- line: 107
		-- upvalues: navigation (copy)
		navigation.navigate("BuildChat", {
			target = p4
		})
	end, { navigation })

	React.useEffect(function() -- line: 114
		-- upvalues: resumeBuildChat (copy), v56 (copy), v61 (copy)
		return resumeBuildChat({
			universeId = v56.universeId,
			sessionId = v56.sessionId,
			creatorAgentChatStore = v56.creatorAgentChatStore,
			configurationStore = v56.configurationStore,
			onOpenChat = v61
		})
	end, {
		v61,
		v56.universeId,
		v56.sessionId,
		v56.resumeRequestId,
		v56.creatorAgentChatStore,
		v56.configurationStore
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v58.shouldIncludeBottomBar
	}, {
		Page = React.createElement(View, {
			tag = "col align-x-center size-full bg-surface-0"
		}, {
			Header = React.createElement(BuildPageHeader, {
				LayoutOrder = 1,
				height = v58.topBarHeight
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
						store = v56.searchQueryStore
					})
				}),
				MyCreations = React.createElement(MyCreationsTab, {
					LayoutOrder = 3,
					creatorAgentChatStore = v56.creatorAgentChatStore,
					configurationStore = v56.configurationStore,
					searchQueryStore = v56.searchQueryStore,
					isFocused = v59,
					autoOpenNewGame = v56.universeId == nil and v56.sessionId == nil,
					onOpenChat = v61
				})
			})
		})
	})
end
local function BuildChatScreen(p5) -- line: 175
	-- upvalues: BuildNavigationParams (copy), GetBuildExperienceRefreshStore (copy), useBuildPageLayout (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildOverflowMenuScreens (copy), BuildChatPage (copy), FullscreenPageWithSafeArea (copy), PrivateInvitesPickerHost (copy)
	local navigation = p5.navigation
	local v64 = BuildNavigationParams.getTarget(navigation)
	local v65 = GetBuildExperienceRefreshStore()
	local v66 = useBuildPageLayout()
	local v67 = useOnScreenKeyboardVisible()
	local v68, v69 = React.useState(false)
	local v70 = React.useCallback(function() -- line: 183
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v71 = React.useCallback(function(p6) -- line: 187
		-- upvalues: navigation (copy), BuildOverflowMenuScreens (copy), v64 (copy)
		navigation.navigate(BuildOverflowMenuScreens.SCREEN_BY_PAGE[p6], {
			target = v64
		})
	end, {
		navigation,
		v64
	})
	local v72 = React.useCallback(function() -- line: 195
		-- upvalues: v69 (copy)
		v69(true)
	end, {})
	local v73 = React.useCallback(function() -- line: 198
		-- upvalues: v69 (copy)
		v69(false)
	end, {})
	local v74 = React.useCallback(function() -- line: 203
		-- upvalues: v69 (copy), navigation (copy), BuildOverflowMenuScreens (copy), v64 (copy)
		v69(false)
		navigation.navigate(BuildOverflowMenuScreens.Screens.BuildPlaytestInviteManagement, {
			target = v64
		})
	end, {
		navigation,
		v64
	})
	local v75 = React.useCallback(function() -- line: 209
		-- upvalues: navigation (copy), v64 (copy)
		navigation.navigate("BuildAgents", {
			target = v64
		})
	end, {
		navigation,
		v64
	})
	local v76 = React.useCallback(function() -- line: 214
		-- upvalues: navigation (copy), v64 (copy)
		navigation.navigate("BuildCreatorCredit", {
			target = v64
		})
	end, {
		navigation,
		v64
	})
	local v77 = React.useCallback(function(p7) -- line: 219
		-- upvalues: navigation (copy), v65 (copy)
		navigation.setParams({
			target = p7
		})
		v65.bumpRefreshTick()
	end, {
		navigation,
		v65
	})
	local v78 = if v64 == nil then nil else React.createElement(BuildChatPage, {
		target = v64,
		onClose = v70,
		onOpenAgentsPage = v75,
		onOpenCreatorCreditPage = v76,
		onOpenConfigurationPage = v71,
		onOpenInvitePicker = v72,
		onNavigateToResolvedTarget = v77
	})
	local v79 = if v64 == nil then nil else v64.universeId

	return React.createElement(React.Fragment, nil, {
		Page = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v66.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v66.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v66.shouldIncludeBottomBar and not v67
		}, {
			Page = v78
		}),
		Picker = if not v68 or v79 == nil then nil else React.createElement(PrivateInvitesPickerHost, {
			universeId = v79,
			onClose = v73,
			onInvitesSent = v74
		})
	})
end
local function BuildAgentsScreen(p8) -- line: 261
	-- upvalues: useBuildPageLayout (copy), useLiveSubagentTaskState (copy), React (copy), BuildNavigationParams (copy), SubagentStatus (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p8.navigation
	local v82 = useBuildPageLayout()
	local v83 = useLiveSubagentTaskState(navigation)
	local v84 = React.useCallback(function() -- line: 266
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v85 = React.useCallback(function(p9) -- line: 269
		-- upvalues: navigation (copy), BuildNavigationParams (copy)
		navigation.navigate("BuildAgentDetails", {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskGroupName = p9.name
		})
	end, { navigation })
	local v86 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPage.AgentsList",
		groups = if v83 == nil then {} else v83.groups,
		onAgentActivated = v85
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v82.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v82.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v82.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.AgentsPage",
			title = LocalizationStrings.SUBAGENT_STATUS_AGENTS,
			onClose = v84,
			content = v86,
			closeIcon = IconName.ChevronLargeLeft,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_Agents_Scroll"
		})
	})
end
local function BuildAgentDetailsScreen(p10) -- line: 301
	-- upvalues: useBuildPageLayout (copy), useLiveSubagentTaskState (copy), BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p10.navigation
	local v89 = useBuildPageLayout()
	local v90 = useLiveSubagentTaskState(navigation)
	local v91 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v92, g95

	if v90 == nil or v91 == nil then
		v92 = nil
	else
		g95 = nil
		v92 = nil

		for _, v94 in v90.groups do
			if v91 == v94.name then
				v92 = v94
				g95 = true
			end

			if g95 then
				break
			end
		end

		if not g95 then
			v92 = nil
		end
	end

	g95 = false

	local v96 = React.useCallback(function() -- line: 308
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v97 = if v92 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPage.AgentDetailsList",
		group = v92
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v89.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v89.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v89.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.AgentDetailsPage",
			title = v91 or LocalizationStrings.SUBAGENT_STATUS_AGENTS,
			onClose = v96,
			content = v97,
			closeIcon = IconName.ChevronLargeLeft,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_AgentDetails_Scroll"
		})
	})
end
local function BuildCreatorCreditScreen(p11) -- line: 340
	-- upvalues: useBuildPageLayout (copy), React (copy), CreatorCreditPageContainer (copy), FullscreenPageWithSafeArea (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), CreatorCreditBalanceChipContainer (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p11.navigation
	local v100 = useBuildPageLayout()
	local v101 = React.useCallback(function() -- line: 344
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v102 = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v100.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v100.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v100.shouldIncludeBottomBar
	}, {
		Page = React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.CreatorCreditPage",
			title = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE,
			onClose = v101,
			content = v102,
			headerTrailing = React.createElement(CreatorCreditBalanceChipContainer),
			closeIcon = IconName.ChevronLargeLeft,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_CreatorCredit_Scroll"
		})
	})
end

local v44 = RoactNavigation.createRobloxStackNavigator({
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
		[BuildOverflowMenuScreens.Screens.BuildPlaytestInviteManagement] = {
			screen = BuildOverflowMenuScreens.BuildPlaytestInviteManagementScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildTitleDescription] = {
			screen = BuildOverflowMenuScreens.BuildTitleDescriptionScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildVersionTitleDescription] = {
			screen = BuildOverflowMenuScreens.BuildVersionTitleDescriptionScreen
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
	},
	{
		BuildCreatorCredit = {
			screen = BuildCreatorCreditScreen
		}
	}
}, {
	initialRouteName = "BuildHome"
})
local v45 = RoactNavigation.createAppContainer(v44)

local function BuildPage(t1: {[any]: any}?) -- line: 440
	-- upvalues: useBuildPageEligibility (copy), v33 (copy), React (copy), v45 (copy), BuildEligibilityDialog (copy), View (copy), Loading (copy), IconSize (copy)
	local v104 = useBuildPageEligibility.useBuildPageEligibility(v33)

	if v104.canEnterBuild then
		return React.createElement(v45, {
			screenProps = t1 or {}
		})
	end

	if v104.status == useBuildPageEligibility.Status.Ineligible then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Ineligible,
			onDismiss = v104.onDialogDismiss
		})
	end

	if v104.status == useBuildPageEligibility.Status.Error then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Error,
			onDismiss = v104.onDialogDismiss
		})
	end

	if v104.status == useBuildPageEligibility.Status.Refreshing then
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full",
			testId = "BuildPage.EligibilityLoading"
		}, {
			Spinner = React.createElement(Loading, {
				size = IconSize.Large
			})
		})
	end

	return React.createElement(View, {
		tag = "size-full",
		testId = "BuildPage.EligibilityPrompting"
	})
end

return BuildPage
