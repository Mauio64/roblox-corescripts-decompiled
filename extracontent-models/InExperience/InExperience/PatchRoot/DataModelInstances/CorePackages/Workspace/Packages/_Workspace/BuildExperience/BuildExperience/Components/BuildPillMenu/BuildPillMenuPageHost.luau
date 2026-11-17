local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local SignalsReact = require(parent.SignalsReact)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector
local View = Foundation.View
local OverlayProvider = Foundation.OverlayProvider
local useOverlay = Foundation.Hooks.useOverlay

local BuildOverflowMenuScreens = require(script.Parent.BuildOverflowMenuScreens)
local FFlagBuildExperiencePageImpressions = require(BuildExperience.Flags.FFlagBuildExperiencePageImpressions)
local useBuildPageImpression = require(BuildExperience.Telemetry.useBuildPageImpression)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local PrivateInvitesPickerContainer = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerContainer)

local PrivateInvitesManagementContainer = require(BuildExperience.Components.GameConfigurations.PrivateInvitesManagement.PrivateInvitesManagementContainer)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local CreatorCreditPageContainer = require(BuildExperience.Components.CreatorCreditSheet.CreatorCreditPageContainer)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)
local useSessionSummary = require(BuildExperience.Chat.useSessionSummary)

local CreatorCreditBalanceChipContainer = require(BuildExperience.Components.CreatorCreditSheet.CreatorCreditBalanceChip.CreatorCreditBalanceChipContainer)

local v = {
	Launcher = "BuildPillMenuLauncher",
	BuildAgents = "BuildPillMenuAgents",
	BuildAgentDetails = "BuildPillMenuAgentDetails",
	BuildCreatorCredit = "BuildPillMenuCreatorCredit"
}

local function findGroup(p, subagentTaskGroupName: string?) -- 1 equivalent call inferred from this helper
	if p == nil or subagentTaskGroupName == nil then
		return nil
	end

	for _, group in p.groups do
		if group.name == subagentTaskGroupName then
			return group
		end
	end

	return nil
end

local function LauncherScreen(p): nil
	local navigation = p.navigation
	local screenProps = p.screenProps

	React.useEffect(function()
		if screenProps.initialPage == nil then
			if screenProps.initialScreen ~= nil then
				navigation.navigate(screenProps.initialScreen, {
					target = screenProps.target,
					dismissOnBack = true
				})
			end
		else
			local v2 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[screenProps.initialPage]

			if v2 == nil then
				return
			end

			navigation.navigate(v2, { target = screenProps.target })
		end
	end, { navigation, screenProps.initialPage, screenProps.initialScreen, screenProps.target })

	return nil
end

local function BuildAgentsScreen(p)
	local navigation = p.navigation
	local screenProps = p.screenProps
	local subagentTaskState = screenProps.subagentTaskState
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local onAgentActivated = React.useCallback(function(p2)
		navigation.navigate("BuildPillMenuAgentDetails", {
			target = screenProps.target,
			subagentTaskGroupName = p2.name
		})
	end, { navigation, screenProps.target })

	local element = React.createElement(SubagentStatus.AgentsList, {
		groups = subagentTaskState == nil and {} or subagentTaskState.groups,
		onAgentActivated = onAgentActivated,
		testId = "BuildPillMenu.AgentsList"
	})

	return React.createElement(OverflowMenuPageShell, {
		title = agents,
		onClose = screenProps.onClose,
		content = element,
		scrollPerformanceIntervalName = "LuaApp_Build_Agents_Scroll",
		testId = "BuildPillMenu.AgentsPage"
	})
end

local function BuildAgentDetailsScreen(p)
	local navigation = p.navigation
	local screenProps = p.screenProps
	local v2 = BuildNavigationParams.getSubagentTaskState(navigation) or screenProps.subagentTaskState
	local subagentTaskGroupName = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local group = findGroup(v2, subagentTaskGroupName) -- inferred equivalent call
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local content

	if group == nil then
		content = React.createElement(View, { tag = "size-full" })
	else
		content = React.createElement(SubagentStatus.AgentDetailsList, {
			group = group,
			testId = "BuildPillMenu.AgentDetailsList"
		})
	end

	return React.createElement(OverflowMenuPageShell, {
		title = subagentTaskGroupName or agents,
		onClose = onClose,
		content = content,
		scrollPerformanceIntervalName = "LuaApp_Build_AgentDetails_Scroll",
		testId = "BuildPillMenu.AgentDetailsPage"
	})
end

local function BuildCreatorCreditScreen(p)
	local screenProps = p.screenProps

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("creator-credit-ai-usage", screenProps.target)
	end

	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE }).pageTitle

	local onClose = React.useCallback(function()
		screenProps.onClose()
	end, { screenProps.onClose })

	local element = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(OverflowMenuPageShell, {
		title = pageTitle,
		onClose = onClose,
		content = element,
		headerTrailing = React.createElement(CreatorCreditBalanceChipContainer),
		scrollPerformanceIntervalName = "LuaApp_Build_CreatorCredit_Scroll",
		testId = "BuildPillMenu.CreatorCreditPage"
	})
end

local v2 = {
	{
		BuildPillMenuLauncher = { screen = LauncherScreen }
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
		BuildPillMenuAgents = { screen = BuildAgentsScreen }
	},
	{
		BuildPillMenuAgentDetails = { screen = BuildAgentDetailsScreen }
	},
	{
		BuildPillMenuCreatorCredit = { screen = BuildCreatorCreditScreen }
	}
}

if FFlagBuildExperienceMonetizationNativeUI then
	local v3 = {
		[BuildOverflowMenuScreens.Screens.BuildMonetization] = {
			screen = BuildOverflowMenuScreens.BuildMonetizationScreen
		}
	}
	table.insert(v2, v3)
end

if FFlagBuildExperienceAnalytics then
	local v3 = {
		[BuildOverflowMenuScreens.Screens.BuildStats] = {
			screen = BuildOverflowMenuScreens.BuildStatsScreen
		}
	}
	table.insert(v2, v3)
end

if FFlagMyStatsMediaSelector then
	local v3 = {
		[BuildOverflowMenuScreens.Screens.BuildMediaSelection] = {
			screen = BuildOverflowMenuScreens.BuildMediaSelectionScreen
		}
	}
	table.insert(v2, v3)
end

local appContainer = RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator(v2, {
	initialRouteName = "BuildPillMenuLauncher"
}))

local function getOverlayScreenGui(screenGui) -- 1 equivalent call inferred from this helper
	if screenGui:IsA("ScreenGui") then
		return screenGui
	end

	return screenGui:FindFirstAncestorOfClass("ScreenGui")
end

local function getInitialPage(activePage) -- 1 equivalent call inferred from this helper
	if activePage == nil or activePage.type ~= "overflow" then
		return nil
	end

	return activePage.page
end

local function getInitialScreen(p)
	if p == nil then
		return nil
	end

	if p.type == "agents" then
		return "BuildPillMenuAgents"
	end

	if p.type == "invitePicker" then
		return BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker
	end

	if p.type == "creator-credit" then
		return "BuildPillMenuCreatorCredit"
	end

	return if p.type == "screen" then p.screen else nil
end

local function getScreenTarget(activePage) -- 1 equivalent call inferred from this helper
	if activePage == nil or activePage.type ~= "screen" then
		return nil
	end

	return activePage.target
end

local function BuildPillMenuPageHost(props)
	local privateInvitesPageTitle = useLocalization({
		privateInvitesPageTitle = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE
	}).privateInvitesPageTitle
	local v3 = useOverlay()
	local state, setState = React.useState(nil)
	local initialPage = getInitialPage(props.activePage) -- inferred equivalent call
	local activePage = props.activePage
	local initialScreen

	if activePage ~= nil then
		if activePage.type == "agents" then
			initialScreen = v.BuildAgents
		elseif activePage.type == "invitePicker" then
			initialScreen = BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker
		elseif activePage.type == "creator-credit" then
			initialScreen = v.BuildCreatorCredit
		elseif activePage.type == "screen" then
			initialScreen = activePage.screen
		end
	end

	local screenTarget = getScreenTarget(props.activePage) -- inferred equivalent call
	local v4

	if FFlagBuildExperienceModelPicker then
		v4 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)
	end

	local subagentTaskState = useSessionSummary((React.useMemo(function()
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(
			props.target.universeId,
			props.target.placeId,
			props.target.sessionId
		)
	end, { props.target.universeId, props.target.placeId, props.target.sessionId, v4 }))).subagentTaskState
	local v5

	if v3 ~= nil then
		v5 = getOverlayScreenGui(v3) -- inferred equivalent call
	end

	local v6 = if v5 == nil or v5.Parent == nil then v3 else v5.Parent

	local displayOrder = v5 == nil and 0 or v5.DisplayOrder

	React.useEffect(function()
		if props.activePage == nil then
			setState(nil)
		end
	end, { props.activePage })

	if props.activePage == nil or v3 == nil then
		return nil
	end

	local page

	if props.activePage.type == "invitePicker" then
		page = React.createElement(PrivateInvitesPickerContainer, {
			universeId = props.target.universeId,
			onClose = props.onClose,
			onInvitesSent = props.onInvitesSent or props.onClose
		})
	elseif props.activePage.type == "playtestManagement" then
		page = React.createElement(
			View,
			{
				ZIndex = 10,
				tag = "size-full bg-surface-0",
				testId = "build-pill-menu-playtest-management"
			},
			{
				Content = React.createElement(View, { tag = "size-full margin-top-large" }, {
					Management = React.createElement(OverflowMenuPageShell, {
						title = privateInvitesPageTitle,
						testId = "BuildPillMenu.playtestInviteManagement.Page",
						onClose = props.onClose,
						content = React.createElement(PrivateInvitesManagementContainer, {
							universeId = props.target.universeId,
							onOpenInvitePicker = props.onOpenInvitePicker or props.onClose
						})
					})
				})
			}
		)
	else
		page = React.createElement(
			View,
			{ ZIndex = 10, tag = "size-full bg-surface-0", testId = "build-pill-menu-page-view" },
			{
				Content = React.createElement(View, { tag = "size-full margin-top-large" }, {
					Navigator = React.createElement(appContainer, {
						screenProps = {
							initialPage = initialPage,
							initialScreen = initialScreen,
							target = screenTarget or props.target,
							subagentTaskState = subagentTaskState,
							onClose = props.onClose,
							onOpenChat = props.onOpenChat,
							showPreviewButton = false,
							isPillMenu = true
						}
					})
				})
			}
		)
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v7 = {
		ClipToDeviceSafeArea = false,
		DisplayOrder = displayOrder,
		IgnoreGuiInset = true,
		Name = "BuildExperiencePillMenuPage",
		ref = setState,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local v8 = {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Page = 0
	}

	if state == nil then
		if FFlagBuildExperiencePageImpressions or props.activePage.type == "invitePicker" then
			page = nil
		end
	else
		page = React.createElement(OverlayProvider, { gui = state }, { Page = page })
	end

	v8.Page = page
	return createPortal(createElement("ScreenGui", v7, v8), v6)
end

return React.memo(BuildPillMenuPageHost)
