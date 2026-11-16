local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local fFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local fFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector
local view = Foundation.View
local overlayProvider = Foundation.OverlayProvider
local useOverlay = Foundation.Hooks.useOverlay

local BuildOverflowMenuScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildOverflowMenuScreens")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local PrivateInvitesPickerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerContainer")

local PrivateInvitesManagementContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PrivateInvitesManagement/PrivateInvitesManagementContainer")
local OverflowMenuPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/OverflowMenuPageShell")
local BuildExperienceCompositionStyleSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildExperienceCompositionStyleSheet")
local CreatorCreditPageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditPageContainer")
local SubagentStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local BuildNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/BuildNavigationParams")
local useSessionSummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useSessionSummary")

local CreatorCreditBalanceChipContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditBalanceChip/CreatorCreditBalanceChipContainer")

local v5 = {
	Launcher = "BuildPillMenuLauncher",
	BuildAgents = "BuildPillMenuAgents",
	BuildAgentDetails = "BuildPillMenuAgentDetails",
	BuildCreatorCredit = "BuildPillMenuCreatorCredit"
}

local function findGroup(p2, p3)
	if p2 == nil or p3 == nil then
		return nil
	end

	for k, group in p2.groups do
		if group.name == p3 then
			return group
		end
	end

	return nil
end

local function LauncherScreen(p2): nil
	local navigation = p2.navigation
	local screenProps = p2.screenProps

	React.useEffect(function()
		if screenProps.initialPage == nil then
			if screenProps.initialScreen ~= nil then
				navigation.navigate(screenProps.initialScreen, {
					target = screenProps.target,
					dismissOnBack = true
				})
			end
		else
			local v6 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[screenProps.initialPage]

			if v6 == nil then
				return
			end

			navigation.navigate(v6, { target = screenProps.target })
		end
	end, {
		navigation,
		screenProps.initialPage,
		screenProps.initialScreen,
		screenProps.target
	})

	return nil
end

local function BuildAgentsScreen(p2)
	local navigation = p2.navigation
	local screenProps = p2.screenProps
	local subagentTaskState = screenProps.subagentTaskState
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local v6 = React.useCallback(function(p3)
		navigation.navigate("BuildPillMenuAgentDetails", {
			target = screenProps.target,
			subagentTaskGroupName = p3.name
		})
	end, { navigation, screenProps.target })

	local element = React.createElement(SubagentStatus.AgentsList, {
		groups = subagentTaskState == nil and {} or subagentTaskState.groups,
		onAgentActivated = v6,
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

local function BuildAgentDetailsScreen(p2)
	local navigation = p2.navigation
	local screenProps = p2.screenProps
	local v6 = BuildNavigationParams.getSubagentTaskState(navigation) or screenProps.subagentTaskState
	local subagentTaskGroupName = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v7

	if not (v6 == nil or subagentTaskGroupName == nil) then
		for k, group in v6.groups do
			if group.name == subagentTaskGroupName then
				v7 = group
				break
			end
		end
	end

	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local v8 = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local v9 = if v7 == nil then React.createElement(view, { tag = "size-full" }) else React.createElement(SubagentStatus.AgentDetailsList, {
		group = v7,
		testId = "BuildPillMenu.AgentDetailsList"
	})

	return React.createElement(OverflowMenuPageShell, {
		title = subagentTaskGroupName or agents,
		onClose = v8,
		content = v9,
		scrollPerformanceIntervalName = "LuaApp_Build_AgentDetails_Scroll",
		testId = "BuildPillMenu.AgentDetailsPage"
	})
end

local function BuildCreatorCreditScreen(p2)
	local screenProps = p2.screenProps
	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE }).pageTitle

	local v6 = React.useCallback(function()
		screenProps.onClose()
	end, { screenProps.onClose })

	local element = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(OverflowMenuPageShell, {
		title = pageTitle,
		onClose = v6,
		content = element,
		headerTrailing = React.createElement(CreatorCreditBalanceChipContainer),
		scrollPerformanceIntervalName = "LuaApp_Build_CreatorCredit_Scroll",
		testId = "BuildPillMenu.CreatorCreditPage"
	})
end

local v13 = {
	{
		BuildPillMenuLauncher = { screen = LauncherScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildPublish] = { screen = BuildOverflowMenuScreens.BuildPublishScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildSettings] = { screen = BuildOverflowMenuScreens.BuildSettingsScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildAudience] = { screen = BuildOverflowMenuScreens.BuildAudienceScreen }
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
	local v14 = {
		[BuildOverflowMenuScreens.Screens.BuildMonetization] = {
			screen = BuildOverflowMenuScreens.BuildMonetizationScreen
		}
	}
	table.insert(v13, v14)
end

if fFlagBuildExperienceAnalytics then
	local v14 = {
		[BuildOverflowMenuScreens.Screens.BuildStats] = { screen = BuildOverflowMenuScreens.BuildStatsScreen }
	}
	table.insert(v13, v14)
end

if fFlagMyStatsMediaSelector then
	local v14 = {
		[BuildOverflowMenuScreens.Screens.BuildMediaSelection] = {
			screen = BuildOverflowMenuScreens.BuildMediaSelectionScreen
		}
	}
	table.insert(v13, v14)
end

local appContainer = RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator(v13, {
	initialRouteName = "BuildPillMenuLauncher"
}))

local function getOverlayScreenGui(screenGui)
	if screenGui:IsA("ScreenGui") then
		return screenGui
	end

	return screenGui:FindFirstAncestorOfClass("ScreenGui")
end

local function getInitialPage(p2)
	if p2 == nil or p2.type ~= "overflow" then
		return nil
	end

	return p2.page
end

local function getInitialScreen(p2)
	if p2 == nil then
		return nil
	end

	if p2.type == "agents" then
		return "BuildPillMenuAgents"
	end

	if p2.type == "invitePicker" then
		return BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker
	end

	if p2.type == "creator-credit" then
		return "BuildPillMenuCreatorCredit"
	end

	if p2.type == "screen" then
		return p2.screen
	end

	return nil
end

local function getScreenTarget(p2)
	if p2 == nil or p2.type ~= "screen" then
		return nil
	end

	return p2.target
end

local function BuildPillMenuPageHost(props)
	local privateInvitesPageTitle = useLocalization({
		privateInvitesPageTitle = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE
	}).privateInvitesPageTitle
	local screenGui = useOverlay()
	local state, setState = React.useState(nil)
	local activePage = props.activePage
	local page = if not (activePage == nil or activePage.type ~= "overflow") then activePage.page else nil

	local activePage2 = props.activePage
	local v14

	if activePage2 ~= nil then
		if activePage2.type == "agents" then
			v14 = v5.BuildAgents
		elseif activePage2.type == "invitePicker" then
			v14 = BuildOverflowMenuScreens.Screens.BuildPrivateInvitesPicker
		elseif activePage2.type == "creator-credit" then
			v14 = v5.BuildCreatorCredit
		elseif activePage2.type == "screen" then
			v14 = activePage2.screen
		end
	end

	local activePage3 = props.activePage
	local target

	if not (activePage3 == nil or activePage3.type ~= "screen") then
		target = activePage3.target
	end

	local v15 = if FFlagBuildExperienceModelPicker then SignalsReact.useSignalState(localUserIdStore.getCurrentUserId) else nil

	local subagentTaskState = useSessionSummary((React.useMemo(function()
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(
			props.target.universeId,
			props.target.placeId,
			props.target.sessionId
		)
	end, { props.target.universeId, props.target.placeId, props.target.sessionId, v15 }))).subagentTaskState
	local v17

	if screenGui ~= nil then
		if screenGui:IsA("ScreenGui") then
			v17 = screenGui
		else
			v17 = screenGui:FindFirstAncestorOfClass("ScreenGui")
		end
	end

	local v18 = if v17 == nil or v17.Parent == nil then screenGui else v17.Parent

	local v19 = v17 == nil and 0 or v17.DisplayOrder

	React.useEffect(function()
		if props.activePage == nil then
			setState(nil)
		end
	end, { props.activePage })

	if props.activePage == nil or screenGui == nil then
		return nil
	end

	local v20

	if props.activePage.type == "invitePicker" then
		v20 = React.createElement(PrivateInvitesPickerContainer, {
			universeId = props.target.universeId,
			onClose = props.onClose,
			onInvitesSent = props.onInvitesSent or props.onClose
		})
	elseif props.activePage.type == "playtestManagement" then
		v20 = React.createElement(
			view,
			{
				ZIndex = 10,
				tag = "size-full bg-surface-0",
				testId = "build-pill-menu-playtest-management"
			},
			{
				Content = React.createElement(view, {
					tag = "size-full margin-top-large"
				}, {
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
		v20 = React.createElement(
			view,
			{
				ZIndex = 10,
				tag = "size-full bg-surface-0",
				testId = "build-pill-menu-page-view"
			},
			{
				Content = React.createElement(view, {
					tag = "size-full margin-top-large"
				}, {
					Navigator = React.createElement(appContainer, {
						screenProps = {
							initialPage = page,
							initialScreen = v14,
							target = target or props.target,
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
	local v22 = {
		ClipToDeviceSafeArea = false,
		DisplayOrder = v19,
		IgnoreGuiInset = true,
		Name = "BuildExperiencePillMenuPage",
		ref = setState,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local v23 = {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Page = 0
	}

	if state == nil then
		if props.activePage.type == "invitePicker" then
			v20 = nil
		end
	else
		v20 = React.createElement(overlayProvider, { gui = state }, { Page = v20 })
	end

	v23.Page = v20
	return createPortal(createElement("ScreenGui", v22, v23), v18)
end

return React.memo(BuildPillMenuPageHost)
