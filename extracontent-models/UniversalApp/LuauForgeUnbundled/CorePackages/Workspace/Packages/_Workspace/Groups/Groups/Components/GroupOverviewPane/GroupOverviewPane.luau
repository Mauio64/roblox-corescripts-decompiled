local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RobloxAppEnums").AppPage
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/AppComposition").CompositionTags
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SduiSharedUtilities")

local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")
local getGroupOverviewPaneConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/getGroupOverviewPaneConfig")
local fetchGroupOverviewPane = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/fetchGroupOverviewPane")

local view = Foundation.View
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local sduiPageNavigationHeader = SduiSharedUtilities.SduiPageNavigationHeader
local sduiPageAnalytics = SduiSharedUtilities.SduiPageAnalytics
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local uiStatus = SduiSharedUtilities.UiStatus
local useComponentConfig = SduiSharedUtilities.useComponentConfig
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local useUiStatus = SduiSharedUtilities.useUiStatus

local function createPageTimer(config, p2)
	local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
		config.configKey,
		{
			eventName = "GroupOverviewPane_SurfaceLoadTime",
			metadata = { page = p2 }
		},
		function(p3)
			local clone = table.clone(p3)
			clone.pageKey = config.surfaceKey
			sduiPageAnalytics.sendLoadTimerEvent(clone)
		end
	)
	loadTimerWithSurfaceLoadTime.start(p2)
	return loadTimerWithSurfaceLoadTime
end

local function useFinishPageTimerWhenEmpty(configKey, p2)
	local v5 = useUiStatus(configKey)
	local v6 = useComponentConfig(configKey, nil) ~= nil
	local v7 = v5 == uiStatus.Resolved and not v6

	React.useEffect(function()
		if v7 then
			p2.logComponentReady()
		end
	end, { p2, v7 })
end

local function GroupOverviewPaneContent(props)
	local config = props.config
	local v5 = Navigation.useRouteName()
	usePageScopeRef(config.configKey)
	local v6 = React.useMemo(function()
		return createPageTimer(config, "mount")
	end, { config })

	local state, setState = React.useState(nil)
	local v7 = state or v6

	React.useEffect(function()
		fetchGroupOverviewPane(config, v6)
	end, { config, v6 })

	local v8 = React.useCallback(function()
		local pageTimer = createPageTimer(config, "refresh")
		setState(pageTimer)
		fetchGroupOverviewPane(config, pageTimer, true)
	end, { config })

	useFinishPageTimerWhenEmpty(config.configKey, v7)

	local v9 = React.useMemo(function()
		return { source = props.source }
	end, { props.source })

	return React.createElement(sduiPageEntryPoint, {
		appPage = appPage.Groups,
		routeName = v5,
		configKey = config.configKey,
		pageTimer = v7,
		includeNavigationHeaderBar = props.includeNavigationHeaderBar,
		onCloseActivated = props.onCloseActivated,
		refresh = v8,
		disableRootPadding = true,
		additionalAnalyticsData = v9
	})
end

local function GroupOverviewPaneEmpty(p2)
	local createElement = React.createElement

	local v8 = if p2.onBackActivated then React.createElement(sduiPageNavigationHeader, {
		contentTag = compositionTags.ContentRegion.Header,
		layoutOrder = 1,
		navButtonType = "back",
		closeCallback = p2.onBackActivated
	}) else nil
	return createElement(view, {
		testId = "GroupOverviewPane.Empty",
		tag = "col size-full"
	}, {
		Header = v8
	})
end

local function GroupOverviewPane(props)
	local navigation = props.navigation
	local v5

	if props.groupId == nil then
		v5 = if navigation then navigation.getParam("groupId", nil) else nil
	else
		v5 = props.groupId
	end

	local v6

	if props.source == nil then
		if navigation then
			v6 = navigation.getParam("source", nil)
		end
	else
		v6 = props.source
	end

	local goBack = if navigation then navigation.goBack else nil

	local v7 = useGroupsWrapperContext()
	local v8 = React.useMemo(function()
		return getGroupOverviewPaneConfig(v7.userId, v5)
	end, { v7.userId, v5 })

	local createElement = React.createElement

	local v12 = if v8 then React.createElement(GroupOverviewPaneContent, {
		key = v8.configKey,
		config = v8,
		includeNavigationHeaderBar = navigation ~= nil,
		onCloseActivated = goBack,
		source = v6
	}) else React.createElement(GroupOverviewPaneEmpty, { onBackActivated = goBack })
	return createElement(view, {
		testId = "GroupOverviewPane",
		tag = "size-full clip bg-surface-0"
	}, {
		Content = v12
	})
end

return React.memo(GroupOverviewPane)
