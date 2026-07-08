local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local RoactNavigation = require(BuildExperienceParent.RoactNavigation)
local View = Foundation.View
local OverlayProvider = Foundation.OverlayProvider
local useOverlay = Foundation.Hooks.useOverlay
local useStyleSheet = Foundation.Hooks.useStyleSheet
local IconName = Foundation.Enums.IconName

require(script.Parent.BuildOverflowMenuButton)

local BuildOverflowMenuScreens = require(script.Parent.BuildOverflowMenuScreens)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)
local useSessionSummary = require(BuildExperience.Chat.useSessionSummary)
local t1 = {
	Launcher = "BuildPillMenuLauncher",
	BuildAgents = "BuildPillMenuAgents",
	BuildAgentDetails = "BuildPillMenuAgentDetails"
}

local function findGroup(p1, s1: string?) -- line: 54
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
local function LauncherScreen(p2) -- line: 68
	-- upvalues: React (copy), BuildOverflowMenuScreens (copy)
	local navigation = p2.navigation
	local screenProps = p2.screenProps

	React.useEffect(function() -- line: 72
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
local function BuildAgentsScreen(p3) -- line: 87
	-- upvalues: React (copy), SubagentStatus (copy), OverflowMenuPageShell (copy)
	local navigation = p3.navigation
	local screenProps = p3.screenProps
	local subagentTaskState = screenProps.subagentTaskState
	local v39 = React.useCallback(function(p4) -- line: 92
		-- upvalues: navigation (copy), screenProps (copy)
		navigation.navigate("BuildPillMenuAgentDetails", {
			target = screenProps.target,
			subagentTaskGroupName = p4.name
		})
	end, {
		navigation,
		screenProps.target
	})
	local v40 = React.createElement(SubagentStatus.AgentsList, {
		testId = "BuildPillMenu.AgentsList",
		groups = if subagentTaskState == nil then {} else subagentTaskState.groups,
		onAgentActivated = v39
	})

	return React.createElement(OverflowMenuPageShell, {
		title = "Agents",
		testId = "BuildPillMenu.AgentsPage",
		onClose = screenProps.onClose,
		content = v40
	})
end
local function BuildAgentDetailsScreen(p5) -- line: 113
	-- upvalues: BuildNavigationParams (copy), React (copy), SubagentStatus (copy), View (copy), OverflowMenuPageShell (copy), IconName (copy)
	local navigation = p5.navigation
	local screenProps = p5.screenProps
	local v44 = BuildNavigationParams.getSubagentTaskState(navigation) or screenProps.subagentTaskState
	local v45 = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v46, g49

	if v44 == nil or v45 == nil then
		v46 = nil
	else
		g49 = nil
		v46 = nil

		for _, v48 in v44.groups do
			if v45 == v48.name then
				v46 = v48
				g49 = true
			end

			if g49 then
				break
			end
		end

		if not g49 then
			v46 = nil
		end
	end

	g49 = false

	local v50 = React.useCallback(function() -- line: 120
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })
	local v51 = if v46 == nil then React.createElement(View, {
		tag = "size-full"
	}) else React.createElement(SubagentStatus.AgentDetailsList, {
		testId = "BuildPillMenu.AgentDetailsList",
		group = v46
	})

	return React.createElement(OverflowMenuPageShell, {
		testId = "BuildPillMenu.AgentDetailsPage",
		title = v45 or "Agents",
		onClose = v50,
		content = v51,
		closeIcon = IconName.ChevronLargeLeft
	})
end

local v23 = RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator({
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

local function getOverlayScreenGui(p6) -- line: 185
	if p6:IsA("ScreenGui") then
		return p6
	end

	return p6:FindFirstAncestorOfClass("ScreenGui")
end
local function getInitialPage(t2: {[any]: any}?) -- line: 193
	if t2 ~= nil and t2.type == "overflow" then
		return t2.page
	end

	return nil
end
local function getInitialScreen(t3: {[any]: any}?) -- line: 197
	if t3 ~= nil and t3.type == "agents" then
		return "BuildPillMenuAgents"
	end

	return nil
end
local function BuildPillMenuPageHost(t4: {[any]: any}) -- line: 201
	-- upvalues: useOverlay (copy), useStyleSheet (copy), React (copy), t1 (copy), CreatorAgentChat (copy), useSessionSummary (copy), View (copy), v23 (copy), ReactRoblox (copy), OverlayProvider (copy)
	local v56 = useOverlay()
	local v57 = useStyleSheet()
	local v58, v59 = React.useState(nil)
	local activePage = t4.activePage
	local v61 = if activePage == nil or activePage.type ~= "overflow" then nil else activePage.page
	local activePage2 = t4.activePage
	local v63 = if activePage2 == nil or activePage2.type ~= "agents" then nil else t1.BuildAgents
	local v64 = if v56 == nil then nil else if not v56:IsA("ScreenGui") then v56:FindFirstAncestorOfClass("ScreenGui") else v56
	local v65 = if v64 == nil or v64.Parent == nil then v56 else v64.Parent
	local v66 = v64 == nil and 0 or v64.DisplayOrder
	local v67 = React.useMemo(function() -- line: 212
		-- upvalues: CreatorAgentChat (copy), t4 (copy)
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(t4.target.universeId, t4.target.placeId, t4.target.sessionId)
	end, {
		t4.target.universeId,
		t4.target.placeId,
		t4.target.sessionId
	})
	local subagentTaskState = useSessionSummary(v67).subagentTaskState

	React.useEffect(function() -- line: 218
		-- upvalues: t4 (copy), v59 (copy)
		if t4.activePage == nil then
			v59(nil)
		end
	end, { t4.activePage })

	if t4.activePage == nil or v56 == nil then
		return nil
	end

	local v69 = React.createElement(View, {
		ZIndex = 10,
		tag = "bg-surface-0",
		testId = "build-pill-menu-page-view",
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1)
	}, {
		Content = React.createElement(View, {
			tag = "size-full margin-top-large"
		}, {
			Navigator = React.createElement(v23, {
				screenProps = {
					showPreviewButton = false,
					initialPage = v61,
					initialScreen = v63,
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
		DisplayOrder = v66,
		ref = v59,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		StyleLink = React.createElement("StyleLink", {
			StyleSheet = v57
		}),
		Page = if v58 == nil then v69 else React.createElement(OverlayProvider, {
			gui = v58
		}, {
			Page = v69
		})
	}), v65)
end

return React.memo(BuildPillMenuPageHost)
