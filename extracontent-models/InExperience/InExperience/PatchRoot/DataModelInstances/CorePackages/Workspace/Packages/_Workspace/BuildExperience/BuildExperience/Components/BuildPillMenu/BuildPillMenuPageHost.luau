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
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)
local useSessionSummary = require(BuildExperience.Chat.useSessionSummary)
local t1 = {
	Launcher = "BuildPillMenuLauncher",
	BuildAgents = "BuildPillMenuAgents",
	BuildAgentDetails = "BuildPillMenuAgentDetails"
}

local function findGroup(p1, s1: string?) -- line: 63
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
local function LauncherScreen(p2) -- line: 77
	-- upvalues: React (copy), BuildOverflowMenuScreens (copy)
	local navigation = p2.navigation
	local screenProps = p2.screenProps

	React.useEffect(function() -- line: 81
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
local function BuildAgentsScreen(p3) -- line: 96
	-- upvalues: React (copy), SubagentStatus (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p3.navigation
	local screenProps = p3.screenProps
	local subagentTaskState = screenProps.subagentTaskState
	local v41 = React.useCallback(function(p4) -- line: 101
		-- upvalues: navigation (copy), screenProps (copy)
		navigation.navigate("BuildPillMenuAgentDetails", {
			target = screenProps.target,
			subagentTaskGroupName = p4.name
		})
	end, {
		navigation,
		screenProps.target
	})
	local v42 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPillMenu.AgentsList",
		groups = if subagentTaskState == nil then {} else subagentTaskState.groups,
		onAgentActivated = v41
	})

	return React.createElement(OverflowMenuPageShell, {
		testId = "BuildPillMenu.AgentsPage",
		title = LocalizationStrings.SUBAGENT_STATUS_AGENTS,
		onClose = screenProps.onClose,
		content = v42,
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_Agents_Scroll"
	})
end
local function BuildAgentDetailsScreen(p5) -- line: 125
	-- upvalues: BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy)
	local navigation = p5.navigation
	local screenProps = p5.screenProps
	local v46 = BuildNavigationParams.getSubagentTaskState(navigation) or screenProps.subagentTaskState
	local v47 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v48, g51

	if v46 == nil or v47 == nil then
		v48 = nil
	else
		g51 = nil
		v48 = nil

		for _, v50 in v46.groups do
			if v47 == v50.name then
				v48 = v50
				g51 = true
			end

			if g51 then
				break
			end
		end

		if not g51 then
			v48 = nil
		end
	end

	g51 = false

	local v52 = React.useCallback(function() -- line: 132
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v53 = if v48 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPillMenu.AgentDetailsList",
		group = v48
	})

	return React.createElement(OverflowMenuPageShell, {
		testId = "BuildPillMenu.AgentDetailsPage",
		title = v47 or LocalizationStrings.SUBAGENT_STATUS_AGENTS,
		onClose = v52,
		content = v53,
		closeIcon = IconName.ChevronLargeLeft,
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_AgentDetails_Scroll"
	})
end

local v25 = RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator({
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
		[BuildOverflowMenuScreens.Screens.BuildTitleDescription] = {
			screen = BuildOverflowMenuScreens.BuildTitleDescriptionScreen
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
	}
}, {
	initialRouteName = "BuildPillMenuLauncher"
}))

local function getOverlayScreenGui(p6) -- line: 200
	if p6:IsA("ScreenGui") then
		return p6
	end

	return p6:FindFirstAncestorOfClass("ScreenGui")
end
local function getInitialPage(t2: {[any]: any}?) -- line: 208
	if t2 ~= nil and t2.type == "overflow" then
		return t2.page
	end

	return nil
end
local function getInitialScreen(t3: {[any]: any}?) -- line: 212
	if t3 ~= nil and t3.type == "agents" then
		return "BuildPillMenuAgents"
	end

	return nil
end
local function BuildPillMenuPageHost(t4: {[any]: any}) -- line: 216
	-- upvalues: useOverlay (copy), React (copy), t1 (copy), CreatorAgentChat (copy), useSessionSummary (copy), View (copy), v25 (copy), ReactRoblox (copy), BuildExperienceCompositionStyleSheet (copy), OverlayProvider (copy)
	local v58 = useOverlay()
	local v59, v60 = React.useState(nil)
	local activePage = t4.activePage
	local v62 = if activePage == nil or activePage.type ~= "overflow" then nil else activePage.page
	local activePage2 = t4.activePage
	local v64 = if activePage2 == nil or activePage2.type ~= "agents" then nil else t1.BuildAgents
	local v65 = React.useMemo(function() -- line: 221
		-- upvalues: CreatorAgentChat (copy), t4 (copy)
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(t4.target.universeId, t4.target.placeId, t4.target.sessionId)
	end, {
		t4.target.universeId,
		t4.target.placeId,
		t4.target.sessionId
	})
	local subagentTaskState = useSessionSummary(v65).subagentTaskState
	local v67 = if v58 == nil then nil else if not v58:IsA("ScreenGui") then v58:FindFirstAncestorOfClass("ScreenGui") else v58
	local v68 = if v67 == nil or v67.Parent == nil then v58 else v67.Parent
	local v69 = v67 == nil and 0 or v67.DisplayOrder

	React.useEffect(function() -- line: 232
		-- upvalues: t4 (copy), v60 (copy)
		if t4.activePage == nil then
			v60(nil)
		end
	end, { t4.activePage })

	if t4.activePage == nil or v58 == nil then
		return nil
	end

	local v70 = React.createElement(View, {
		ZIndex = 10,
		tag = "size-full bg-surface-0",
		testId = "build-pill-menu-page-view"
	}, {
		Content = React.createElement(View, {
			tag = "size-full margin-top-large"
		}, {
			Navigator = React.createElement(v25, {
				screenProps = {
					showPreviewButton = false,
					initialPage = v62,
					initialScreen = v64,
					target = t4.target,
					subagentTaskState = subagentTaskState,
					onClose = t4.onClose
				}
			})
		})
	})

	return ReactRoblox.createPortal(React.createElement("ScreenGui", {
		ClipToDeviceSafeArea = false,
		IgnoreGuiInset = true,
		Name = "BuildExperiencePillMenuPage",
		DisplayOrder = v69,
		ref = v60,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Page = if v59 == nil then v70 else React.createElement(OverlayProvider, {
			gui = v59
		}, {
			Page = v70
		})
	}), v68)
end

return React.memo(BuildPillMenuPageHost)
