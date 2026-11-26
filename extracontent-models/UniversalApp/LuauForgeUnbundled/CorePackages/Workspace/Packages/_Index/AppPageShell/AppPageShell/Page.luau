local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Responsive")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Signals")

local view = Foundation.View
local useDeviceInsets = Responsive.useDeviceInsets

local PageConstants = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageConstants")
local PageContext = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageContext")
local PageStickyHeader = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageStickyHeader")
require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageTypes")
local PageWholeContent = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageWholeContent")
local PullToRefreshSpinner = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PullToRefreshSpinner")
local createFeedContextAdapter = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/createFeedContextAdapter")
local createPageScrollStore = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/createPageScrollStore")
local resolveCompositionTags = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/resolveCompositionTags")
local computeStickyOffset = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/computeStickyOffset")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags")
local fFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes
local fFlagAppPageShellScrollTelemetry = SharedFlags.FFlagAppPageShellScrollTelemetry

local pageContentMode = PageConstants.PageContentMode

local frozen = table.freeze({
	contentMode = pageContentMode.Scroll,
	content = table.freeze({})
})

local function buildTag(p2, p3)
	if p3 then
		return `{p2} {p3}`
	end

	return p2
end

local function Page(props, ref)
	local contentConfig = props.contentConfig or frozen
	local contentMode = contentConfig.contentMode
	local onScrollToEnd = props.onScrollToEnd
	local onScrollToEndThreshold = props.onScrollToEndThreshold
	local composition = props.composition
	local chrome = props.chrome
	local stickyHeaderSlot = props.stickyHeaderSlot

	local v5 = not chrome and 0 or chrome.height
	local v6 = not chrome and 0 or chrome.scrollAwayHeight or chrome.height
	local liveHeightBinding = if chrome then chrome.liveHeightBinding else nil
	local v7

	if fFlagSduiFeedScrollBarFixes then
		local top = useDeviceInsets().top
		v7 = React.useMemo(function()
			if liveHeightBinding == nil or v5 <= 0 then
				return nil
			end

			return liveHeightBinding:map(function(p2)
				return (math.clamp(-computeStickyOffset(p2, v6, top), 0, v5))
			end)
		end, { liveHeightBinding, v5, v6, top })
	else
		v7 = nil
	end

	local ref2 = React.useRef(onScrollToEnd)
	ref2.current = onScrollToEnd

	local scrollPerformanceIntervalName = props.scrollPerformanceIntervalName

	local v8 = React.useMemo(function()
		return createPageScrollStore(if fFlagAppPageShellScrollTelemetry then scrollPerformanceIntervalName else nil)
	end, {})

	local ref3 = React.useRef(nil)

	local v9 = React.useMemo(function()
		return createFeedContextAdapter(v8, ref3)
	end, { v8, ref3 })

	React.useEffect(function()
		return function()
			v9.destroy()
		end
	end, { v9 })

	React.useEffect(function()
		v8.setEndReachedThreshold(onScrollToEndThreshold)
	end, { v8, onScrollToEndThreshold })

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			if v8.getIsEndReached(p2) and ref2.current ~= nil then
				ref2.current()
			end
		end)
	end, { v8 })

	local v10 = React.useMemo(function()
		if v5 <= 0 then
			return nil
		end

		if fFlagSduiFeedScrollBarFixes and v7 ~= nil then
			return table.freeze({
				top = v7:map(function(p2)
					return UDim.new(0, v5 - p2)
				end)
			})
		end

		return table.freeze({ top = UDim.new(0, v5) })
	end, { v5, v7 })

	local v11 = React.useMemo(function()
		return {
			scrollViewPositionChangedSignal = v9.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = v9.verticalScrollingFrameRef,
			scrollStore = v8,
			contentMode = contentMode
		}
	end, { v8, v9, contentMode })

	local v12 = React.useMemo(function()
		return resolveCompositionTags(composition)
	end, { composition })

	local content = contentConfig.content
	local createElement = React.createElement
	local v14 = {
		scrollStore = v8,
		scrollingFrameRef = ref3,
		slots = content.contentSlot,
		contentTopPadding = props.contentTopPadding,
		contentBottomPadding = props.contentBottomPadding,
		chromeDisplacement = if fFlagSduiFeedScrollBarFixes then v7 else nil,
		tag = v12.body,
		containerTag = not fFlagSduiFeedScrollBarFixes and "fill size-full-0" or nil,
		size = 0,
		flexMode = 0,
		layoutOrder = 3,
		zIndex = 1
	}

	local v16 = if fFlagSduiFeedScrollBarFixes then UDim2.new(1, 0, 0, 0) else nil
	v14.size = v16
	local v17 = if fFlagSduiFeedScrollBarFixes then Enum.UIFlexMode.Fill else nil
	v14.flexMode = v17
	local element = createElement(PageWholeContent, v14)

	local onRefresh = props.onRefresh
	local v18

	if onRefresh ~= nil then
		v18 = React.createElement(PullToRefreshSpinner, {
			onRefresh = onRefresh,
			scrollingFrameRef = ref3,
			appEventName = props.appEventName,
			LayoutOrder = 2
		})
	end

	local v19 = not (stickyHeaderSlot == nil) and next(stickyHeaderSlot) ~= nil

	local createElement2 = React.createElement
	local provider = PageContext.Provider

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local root = v12.root
	local v26 = {
		tag = not root and "col size-full" or `col size-full {root}`,
		ref = ref
	}
	local v28

	if v19 then
		local createElement5 = React.createElement
		local v30 = {
			slots = stickyHeaderSlot,
			chromeHeight = v6,
			liveChromeHeightBinding = if not fFlagSduiFeedScrollBarFixes then liveHeightBinding else nil,
			backgroundStyle = props.stickyBackgroundStyle,
			tag = 0,
			topPadding = 0
		}
		local header = v12.header
		v30.tag = not header and "col size-full-0 auto-y" or `col size-full-0 auto-y {header}`
		v30.topPadding = props.stickyTopPadding
		v28 = createElement5(PageStickyHeader, v30)
	end

	return createElement2(provider, { value = v11 }, {
		ChromeInset = createElement3(view, { tag = "col size-full", padding = v10 }, {
			Root = createElement4(view, v26, {
				Sticky = v28,
				Refresh = v18,
				Content = element
			})
		})
	})
end

return React.memo(React.forwardRef(Page))
