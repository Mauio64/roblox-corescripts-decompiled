local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local React = require(parent.React)
local AppPageShell = require(parent.AppPageShell)
require(parent.AppCommonLib)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local PageContentMode = AppPageShell.PageContentMode
local PageContext = AppPageShell.PageContext
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SharedFlags = require(parent.SharedFlags)
local FFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiPageCanvasCollectionLayout = SharedFlags2.FFlagSduiPageCanvasCollectionLayout

local useComponentConfig = require(SduiSharedUtilities.hooks.useComponentConfig)
local useComponentLifecycleTiming = require(SduiSharedUtilities.hooks.useComponentLifecycleTiming)
local useMissingRootWarning = require(SduiSharedUtilities.hooks.useMissingRootWarning)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagDataHydrationAccountReset = SharedFlags3.FFlagDataHydrationAccountReset
require(SduiSharedUtilities.SduiLoadTimer)

local function SduiPageWholeContent(props)
	local v = React.useContext(PageContext)

	local verticalScrollingFrameRef = v.verticalScrollingFrameRef
	local useMemo = React.useMemo
	local function fn()
		local v2 = {
			scrollingFrameRef = verticalScrollingFrameRef,
			verticalScrollingFrameRef = verticalScrollingFrameRef,
			scrollViewPositionChangedSignal = v.scrollViewPositionChangedSignal,
			refreshSignal = props.refreshSignal,
			scrollToSelectionAnimationManagedByParent = true,
			defaultFocusRef = 0,
			disableCollectionLayoutStoreProvider = 0
		}
		local defaultFocusRef

		if FFlagAppPageShellScrollToTopFocus then
			defaultFocusRef = props.defaultFocusRef
		end

		v2.defaultFocusRef = defaultFocusRef
		v2.disableCollectionLayoutStoreProvider = FFlagSduiPageCanvasCollectionLayout and true or nil
		return v2
	end

	local refreshSignal = props.refreshSignal
	local v2

	if FFlagAppPageShellScrollToTopFocus then
		v2 = props.defaultFocusRef
	end

	local extraLocalProps = useMemo(fn, { v, refreshSignal, v2, verticalScrollingFrameRef })

	local sduiComponentWrapper = getSduiComponentWrapper(props.config)
	return React.createElement(sduiComponentWrapper, {
		debugName = `{props.debugName}-content`,
		componentConfig = props.config,
		sduiContext = props.sduiContext,
		localAnalyticsData = props.localAnalyticsData,
		extraLocalProps = extraLocalProps
	})
end

local function buildWholePageContent(config, props)
	local createElement = React.createElement
	local v = {
		config = config,
		sduiContext = props.sduiContext,
		localAnalyticsData = props.localAnalyticsData,
		debugName = props.debugName,
		refreshSignal = props.refreshSignal,
		defaultFocusRef = 0
	}
	local defaultFocusRef

	if FFlagAppPageShellScrollToTopFocus then
		defaultFocusRef = props.defaultFocusRef
	end

	v.defaultFocusRef = defaultFocusRef
	return { createElement(SduiPageWholeContent, v) }
end

local function useSduiPageContent(data)
	local config = useComponentConfig(data.configKey, data.contentIdentifier)

	if FFlagDataHydrationAccountReset then
		useMissingRootWarning(data.configKey, config)
	end

	useComponentLifecycleTiming(data.pageTimer, config ~= nil)

	local contentMode = data.contentMode or PageContentMode.Scroll
	return {
		contentMode = contentMode,
		content = {
			contentSlot = React.useMemo(function()
				if config == nil then
					return nil
				end

				if contentMode == PageContentMode.Scroll then
				end

				return buildWholePageContent(config, data)
			end, { config, data, contentMode })
		}
	}
end

return useSduiPageContent
