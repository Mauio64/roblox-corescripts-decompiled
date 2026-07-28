local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local RoactNavigation = require(BuildExperienceParent.RoactNavigation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local View = Foundation.View
local OverlayProvider = Foundation.OverlayProvider
local useOverlay = Foundation.Hooks.useOverlay
local IconName = Foundation.Enums.IconName
local BuildOverflowMenuScreens = require(script.Parent.BuildOverflowMenuScreens)
local PrivateInvitesPickerContainer = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerContainer)
local PrivateInvitesManagementContainer = require(BuildExperience.Components.GameConfigurations.PrivateInvitesManagement.PrivateInvitesManagementContainer)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local CreatorCreditPageContainer = require(BuildExperience.Components.CreatorCreditSheet.CreatorCreditPageContainer)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)
local useSessionSummary = require(BuildExperience.Chat.useSessionSummary)
local CreatorCreditBalanceChipContainer = require(BuildExperience.Components.CreatorCreditSheet.CreatorCreditBalanceChip.CreatorCreditBalanceChipContainer)
local t1 = {
	Launcher = "BuildPillMenuLauncher",
	BuildAgents = "BuildPillMenuAgents",
	BuildAgentDetails = "BuildPillMenuAgentDetails",
	BuildCreatorCredit = "BuildPillMenuCreatorCredit"
}

local function findGroup(p1, s1: string?) -- line: 80
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v38 in p1.groups do
		if s1 == v38.name then
			return v38
		end
	end

	return nil
end
local function LauncherScreen(p2) -- line: 94
	-- upvalues: React (copy), BuildOverflowMenuScreens (copy)
	local navigation = p2.navigation
	local screenProps = p2.screenProps

	React.useEffect(function() -- line: 98
		-- upvalues: screenProps (copy), navigation (copy), BuildOverflowMenuScreens (copy)
		if screenProps.initialPage ~= nil then
			navigation.navigate(BuildOverflowMenuScreens.SCREEN_BY_PAGE[screenProps.initialPage], {
				target = screenProps.target
			})

			return
		end

		if screenProps.initialScreen ~= nil then
			navigation.navigate(screenProps.initialScreen, {
				target = screenProps.target
			})
		end
	end, {
		navigation,
		screenProps.initialPage,
		screenProps.initialScreen,
		screenProps.target
	})

	return nil
end
local function BuildAgentsScreen(p3) -- line: 113
	-- upvalues: React (copy), SubagentStatus (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p3.navigation
	local screenProps = p3.screenProps
	local subagentTaskState = screenProps.subagentTaskState
	local v46 = React.useCallback(function(p4) -- line: 118
		-- upvalues: navigation (copy), screenProps (copy)
		navigation.navigate("BuildPillMenuAgentDetails", {
			target = screenProps.target,
			subagentTaskGroupName = p4.name
		})
	end, {
		navigation,
		screenProps.target
	})
	local v47 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPillMenu.AgentsList",
		groups = if subagentTaskState == nil then {} else subagentTaskState.groups,
		onAgentActivated = v46
	})

	return React.createElement(OverflowMenuPageShell, {
		testId = "BuildPillMenu.AgentsPage",
		title = LocalizationStrings.SUBAGENT_STATUS_AGENTS,
		onClose = screenProps.onClose,
		content = v47,
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_Agents_Scroll"
	})
end
local function BuildAgentDetailsScreen(p5) -- line: 142
	-- upvalues: BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p5.navigation
	local screenProps = p5.screenProps
	local v51 = BuildNavigationParams.getSubagentTaskState(navigation) or screenProps.subagentTaskState
	local v52 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v53, g56

	if v51 == nil or v52 == nil then
		v53 = nil
	else
		g56 = nil
		v53 = nil

		for _, v55 in v51.groups do
			if v52 == v55.name then
				v53 = v55
				g56 = true
			end

			if g56 then
				break
			end
		end

		if not g56 then
			v53 = nil
		end
	end

	g56 = false

	local v57 = React.useCallback(function() -- line: 149
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v58 = if v53 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPillMenu.AgentDetailsList",
		group = v53
	})

	return React.createElement(OverflowMenuPageShell, {
		testId = "BuildPillMenu.AgentDetailsPage",
		title = v52 or LocalizationStrings.SUBAGENT_STATUS_AGENTS,
		onClose = v57,
		content = v58,
		closeIcon = IconName.ChevronLargeLeft,
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_AgentDetails_Scroll"
	})
end
local function BuildCreatorCreditScreen(p6) -- line: 174
	-- upvalues: React (copy), CreatorCreditPageContainer (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), CreatorCreditBalanceChipContainer (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local screenProps = p6.screenProps
	local v61 = React.useCallback(function() -- line: 177
		-- upvalues: screenProps (copy)
		screenProps.onClose()
	end, { screenProps.onClose })
	local v62 = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(OverflowMenuPageShell, {
		testId = "BuildPillMenu.CreatorCreditPage",
		title = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE,
		onClose = v61,
		content = v62,
		headerTrailing = React.createElement(CreatorCreditBalanceChipContainer),
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_CreatorCredit_Scroll"
	})
end

local v30 = RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator({
	{
		BuildPillMenuLauncher = {
			screen = LauncherScreen
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
		[BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker] = {
			screen = BuildOverflowMenuScreens.BuildPrivateInvitesPickerScreen
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
		BuildPillMenuAgents = {
			screen = BuildAgentsScreen
		}
	},
	{
		BuildPillMenuAgentDetails = {
			screen = BuildAgentDetailsScreen
		}
	},
	{
		BuildPillMenuCreatorCredit = {
			screen = BuildCreatorCreditScreen
		}
	}
}, {
	initialRouteName = "BuildPillMenuLauncher"
}))

local function getOverlayScreenGui(p7) -- line: 258
	if p7:IsA("ScreenGui") then
		return p7
	end

	return p7:FindFirstAncestorOfClass("ScreenGui")
end
local function getInitialPage(t2: {[any]: any}?) -- line: 266
	if t2 ~= nil and t2.type == "overflow" then
		return t2.page
	end

	return nil
end
local function getInitialScreen(t3: {[any]: any}?) -- line: 270
	-- upvalues: BuildOverflowMenuScreens (copy)
	if t3 == nil then
		return nil
	end

	if t3.type == "agents" then
		return "BuildPillMenuAgents"
	end

	if t3.type == "invitePicker" then
		return BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker
	end

	if t3.type == "creator-credit" then
		return "BuildPillMenuCreatorCredit"
	end

	return nil
end
local function BuildPillMenuPageHost(t4: {[any]: any}) -- line: 286
	-- upvalues: useOverlay (copy), React (copy), t1 (copy), BuildOverflowMenuScreens (copy), CreatorAgentChat (copy), useSessionSummary (copy), PrivateInvitesPickerContainer (copy), View (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), PrivateInvitesManagementContainer (copy), v30 (copy), ReactRoblox (copy), BuildExperienceCompositionStyleSheet (copy), OverlayProvider (copy)
	local v67 = useOverlay()
	local v68, v69 = React.useState(nil)
	local activePage = t4.activePage
	local v71 = if activePage == nil or activePage.type ~= "overflow" then nil else activePage.page
	local activePage2 = t4.activePage
	local v73 = if activePage2 ~= nil then if activePage2.type ~= "agents" then if activePage2.type ~= "invitePicker" then if activePage2.type ~= "creator-credit" then nil else t1.BuildCreatorCredit else BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker else t1.BuildAgents else nil
	local v74 = React.useMemo(function() -- line: 291
		-- upvalues: CreatorAgentChat (copy), t4 (copy)
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(t4.target.universeId, t4.target.placeId, t4.target.sessionId)
	end, {
		t4.target.universeId,
		t4.target.placeId,
		t4.target.sessionId
	})
	local subagentTaskState = useSessionSummary(v74).subagentTaskState
	local v76 = if v67 == nil then nil else if not v67:IsA("ScreenGui") then v67:FindFirstAncestorOfClass("ScreenGui") else v67
	local v77 = if v76 == nil or v76.Parent == nil then v67 else v76.Parent
	local v78 = v76 == nil and 0 or v76.DisplayOrder

	React.useEffect(function() -- line: 302
		-- upvalues: t4 (copy), v69 (copy)
		if t4.activePage == nil then
			v69(nil)
		end
	end, { t4.activePage })

	if t4.activePage == nil or v67 == nil then
		return nil
	end

	local v79 = if t4.activePage.type ~= "invitePicker" then if t4.activePage.type ~= "playtestManagement" then React.createElement(View, {
		ZIndex = 10,
		tag = "size-full bg-surface-0",
		testId = "build-pill-menu-page-view"
	}, {
		Content = React.createElement(View, {
			tag = "size-full margin-top-large"
		}, {
			Navigator = React.createElement(v30, {
				screenProps = {
					showPreviewButton = false,
					initialPage = v71,
					initialScreen = v73,
					target = t4.target,
					subagentTaskState = subagentTaskState,
					onClose = t4.onClose
				}
			})
		})
	}) else React.createElement(View, {
		ZIndex = 10,
		tag = "size-full bg-surface-0",
		testId = "build-pill-menu-playtest-management"
	}, {
		Content = React.createElement(View, {
			tag = "size-full margin-top-large"
		}, {
			Management = React.createElement(OverflowMenuPageShell, {
				testId = "BuildPillMenu.playtestInviteManagement.Page",
				title = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE,
				closeIcon = IconName.ChevronLargeLeft,
				onClose = t4.onClose,
				content = React.createElement(PrivateInvitesManagementContainer, {
					universeId = t4.target.universeId,
					onOpenInvitePicker = t4.onOpenInvitePicker or t4.onClose
				})
			})
		})
	}) else React.createElement(PrivateInvitesPickerContainer, {
		universeId = t4.target.universeId,
		onClose = t4.onClose,
		onInvitesSent = t4.onInvitesSent or t4.onClose
	})

	return ReactRoblox.createPortal(React.createElement("ScreenGui", {
		ClipToDeviceSafeArea = false,
		IgnoreGuiInset = true,
		Name = "BuildExperiencePillMenuPage",
		DisplayOrder = v78,
		ref = v69,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Page = if v68 == nil then if t4.activePage.type ~= "invitePicker" then v79 else nil else React.createElement(OverlayProvider, {
			gui = v68
		}, {
			Page = v79
		})
	}), v77)
end

return React.memo(BuildPillMenuPageHost)
