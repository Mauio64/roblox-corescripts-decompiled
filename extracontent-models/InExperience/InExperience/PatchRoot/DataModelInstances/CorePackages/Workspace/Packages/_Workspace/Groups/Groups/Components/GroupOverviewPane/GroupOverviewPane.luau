local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local getGroupOverviewPaneConfig = require(Groups.Common.getGroupOverviewPaneConfig)
local fetchGroupOverviewPane = require(Groups.Common.fetchGroupOverviewPane)

local View = Foundation.View
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiPageNavigationHeader = SduiSharedUtilities.SduiPageNavigationHeader
local SduiPageAnalytics = SduiSharedUtilities.SduiPageAnalytics
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local UiStatus = SduiSharedUtilities.UiStatus
local useComponentConfig = SduiSharedUtilities.useComponentConfig
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local useUiStatus = SduiSharedUtilities.useUiStatus

local function createPageTimer(config, page: string)
	local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
		config.configKey,
		{
			eventName = "GroupOverviewPane_SurfaceLoadTime",
			metadata = { page = page }
		},
		function(p)
			local clone = table.clone(p)
			clone.pageKey = config.surfaceKey
			SduiPageAnalytics.sendLoadTimerEvent(clone)
		end
	)
	loadTimerWithSurfaceLoadTime.start(page)
	return loadTimerWithSurfaceLoadTime
end

local function useFinishPageTimerWhenEmpty(configKey: string, p)
	local v = useUiStatus(configKey)
	local v2 = useComponentConfig(configKey, nil) ~= nil
	local v3

	if v == UiStatus.Resolved then
		v3 = not v2
	else
		v3 = false
	end

	React.useEffect(function()
		if v3 then
			p.logComponentReady()
		end
	end, { p, v3 })
end

local function GroupOverviewPaneContent(props)
	local config = props.config
	local routeName = Navigation.useRouteName()
	usePageScopeRef(config.configKey)
	local v = React.useMemo(function()
		return createPageTimer(config, "mount")
	end, { config })

	local state, setState = React.useState(nil)
	local pageTimer2 = state or v

	React.useEffect(function()
		fetchGroupOverviewPane(config, v)
	end, { config, v })

	local refresh = React.useCallback(function()
		local pageTimer = createPageTimer(config, "refresh")
		setState(pageTimer)
		fetchGroupOverviewPane(config, pageTimer, true)
	end, { config })

	useFinishPageTimerWhenEmpty(config.configKey, pageTimer2)

	local additionalAnalyticsData = React.useMemo(function()
		return { source = props.source }
	end, { props.source })

	return React.createElement(SduiPageEntryPoint, {
		appPage = AppPage.Groups,
		routeName = routeName,
		configKey = config.configKey,
		pageTimer = pageTimer2,
		includeNavigationHeaderBar = props.includeNavigationHeaderBar,
		onCloseActivated = props.onCloseActivated,
		refresh = refresh,
		disableRootPadding = true,
		additionalAnalyticsData = additionalAnalyticsData
	})
end

local function GroupOverviewPaneEmpty(p)
	local createElement = React.createElement
	local header

	if p.onBackActivated then
		header = React.createElement(SduiPageNavigationHeader, {
			contentTag = CompositionTags.ContentRegion.Header,
			layoutOrder = 1,
			navButtonType = "back",
			closeCallback = p.onBackActivated
		})
	end

	return createElement(View, { testId = "GroupOverviewPane.Empty", tag = "col size-full" }, {
		Header = header
	})
end

local function GroupOverviewPane(props)
	local navigation = props.navigation
	local v

	if props.groupId == nil then
		if navigation then
			v = navigation.getParam("groupId", nil)
		else
			v = nil
		end
	else
		v = props.groupId
	end

	local source

	if props.source == nil then
		if navigation then
			source = navigation.getParam("source", nil)
		end
	else
		source = props.source
	end

	local goBack

	if navigation then
		goBack = navigation.goBack
	end

	local v2 = useGroupsWrapperContext()
	local config = React.useMemo(function()
		return getGroupOverviewPaneConfig(v2.userId, v)
	end, { v2.userId, v })

	local createElement = React.createElement
	local content

	if config then
		content = React.createElement(GroupOverviewPaneContent, {
			key = config.configKey,
			config = config,
			includeNavigationHeaderBar = navigation ~= nil,
			onCloseActivated = goBack,
			source = source
		})
	else
		content = React.createElement(GroupOverviewPaneEmpty, { onBackActivated = goBack })
	end

	return createElement(View, { testId = "GroupOverviewPane", tag = "size-full clip bg-surface-0" }, {
		Content = content
	})
end

return React.memo(GroupOverviewPane)
