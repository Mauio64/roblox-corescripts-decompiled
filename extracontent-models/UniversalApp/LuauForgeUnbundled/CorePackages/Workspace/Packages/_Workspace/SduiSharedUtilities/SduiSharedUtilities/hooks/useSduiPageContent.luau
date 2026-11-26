local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local AppPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppPageShell")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppCommonLib")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")

local pageContentMode = AppPageShell.PageContentMode
local pageContext = AppPageShell.PageContext
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local fFlagAppPageShellScrollToTopFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppPageShellScrollToTopFocus
local fFlagSduiPageCanvasCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiPageCanvasCollectionLayout

local useComponentConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentConfig")
local useComponentLifecycleTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentLifecycleTiming")
local useMissingRootWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useMissingRootWarning")
local fFlagDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagDataHydrationAccountReset
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")

local function SduiPageWholeContent(props)
	local v5 = React.useContext(pageContext)

	local verticalScrollingFrameRef = v5.verticalScrollingFrameRef
	local useMemo = React.useMemo
	local function fn()
		local v6 = {
			scrollingFrameRef = verticalScrollingFrameRef,
			verticalScrollingFrameRef = verticalScrollingFrameRef,
			scrollViewPositionChangedSignal = v5.scrollViewPositionChangedSignal,
			refreshSignal = props.refreshSignal,
			scrollToSelectionAnimationManagedByParent = true,
			defaultFocusRef = 0,
			disableCollectionLayoutStoreProvider = 0
		}

		local v7 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
		v6.defaultFocusRef = v7
		v6.disableCollectionLayoutStoreProvider = fFlagSduiPageCanvasCollectionLayout and true or nil
		return v6
	end

	local refreshSignal = props.refreshSignal
	local v7 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
	local v8 = useMemo(fn, { v5, refreshSignal, v7, verticalScrollingFrameRef })

	local sduiComponentWrapper = getSduiComponentWrapper(props.config)
	return React.createElement(sduiComponentWrapper, {
		debugName = `{props.debugName}-content`,
		componentConfig = props.config,
		sduiContext = props.sduiContext,
		localAnalyticsData = props.localAnalyticsData,
		extraLocalProps = v8
	})
end

local function buildWholePageContent(p2, props)
	local createElement = React.createElement
	local v6 = {
		config = p2,
		sduiContext = props.sduiContext,
		localAnalyticsData = props.localAnalyticsData,
		debugName = props.debugName,
		refreshSignal = props.refreshSignal,
		defaultFocusRef = 0
	}
	local v7 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
	v6.defaultFocusRef = v7
	return { createElement(SduiPageWholeContent, v6) }
end

local function useSduiPageContent(data)
	local v5 = useComponentConfig(data.configKey, data.contentIdentifier)

	if fFlagDataHydrationAccountReset then
		useMissingRootWarning(data.configKey, v5)
	end

	useComponentLifecycleTiming(data.pageTimer, v5 ~= nil)

	local contentMode = data.contentMode or pageContentMode.Scroll
	return {
		contentMode = contentMode,
		content = {
			contentSlot = React.useMemo(function()
				if v5 == nil then
					return nil
				end

				if contentMode == pageContentMode.Scroll then
				end

				return buildWholePageContent(v5, data)
			end, { v5, data, contentMode })
		}
	}
end

return useSduiPageContent
