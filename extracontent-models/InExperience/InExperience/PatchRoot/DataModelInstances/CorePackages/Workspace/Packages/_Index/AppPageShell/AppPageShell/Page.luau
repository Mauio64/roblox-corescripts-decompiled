local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local Signals = require(parent.Signals)

local View = Foundation.View
local useDeviceInsets = Responsive.useDeviceInsets

local PageConstants = require(AppPageShell.PageConstants)
local PageContext = require(AppPageShell.PageContext)
local PageStickyHeader = require(AppPageShell.PageStickyHeader)
require(AppPageShell.PageTypes)
local PageWholeContent = require(AppPageShell.PageWholeContent)
local PullToRefreshSpinner = require(AppPageShell.PullToRefreshSpinner)
local createFeedContextAdapter = require(AppPageShell.createFeedContextAdapter)
local createPageScrollStore = require(AppPageShell.createPageScrollStore)
local resolveCompositionTags = require(AppPageShell.resolveCompositionTags)
local computeStickyOffset = require(AppPageShell.computeStickyOffset)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes

local PageContentMode = PageConstants.PageContentMode

local frozen = table.freeze({ contentMode = PageContentMode.Scroll, content = table.freeze({}) })

local function buildTag(p: string, p2: string?)
	if p2 then
		return `{p} {p2}`
	end

	return p
end

local function Page(props, ref)
	local contentConfig = props.contentConfig or frozen
	local contentMode = contentConfig.contentMode
	local onScrollToEnd = props.onScrollToEnd
	local onScrollToEndThreshold = props.onScrollToEndThreshold
	local composition = props.composition
	local chrome = props.chrome
	local stickyHeaderSlot = props.stickyHeaderSlot

	local v = not chrome and 0 or chrome.height
	local chromeHeight = not chrome and 0 or chrome.scrollAwayHeight or chrome.height
	local liveHeightBinding

	if chrome then
		liveHeightBinding = chrome.liveHeightBinding
	else
		liveHeightBinding = nil
	end

	local v2

	if FFlagSduiFeedScrollBarFixes then
		local top = useDeviceInsets().top
		v2 = React.useMemo(function()
			if liveHeightBinding == nil or v <= 0 then
				return nil
			end

			return liveHeightBinding:map(function(p: number)
				return (math.clamp(-computeStickyOffset(p, chromeHeight, top), 0, v))
			end)
		end, { liveHeightBinding, v, chromeHeight, top })
	else
		v2 = nil
	end

	local ref2 = React.useRef(onScrollToEnd)
	ref2.current = onScrollToEnd

	local scrollStore = React.useMemo(createPageScrollStore, {})

	local ref3 = React.useRef(nil)

	local v3 = React.useMemo(function()
		return createFeedContextAdapter(scrollStore, ref3)
	end, { scrollStore, ref3 })

	React.useEffect(function()
		return function()
			v3.destroy()
		end
	end, { v3 })

	React.useEffect(function()
		scrollStore.setEndReachedThreshold(onScrollToEndThreshold)
	end, { scrollStore, onScrollToEndThreshold })

	React.useEffect(function()
		return Signals.createEffect(function(p)
			if scrollStore.getIsEndReached(p) and ref2.current ~= nil then
				ref2.current()
			end
		end)
	end, { scrollStore })

	local padding = React.useMemo(function()
		if v <= 0 then
			return nil
		end

		if FFlagSduiFeedScrollBarFixes and v2 ~= nil then
			return table.freeze({
				top = v2:map(function(p: number)
					return UDim.new(0, v - p)
				end)
			})
		end

		return table.freeze({ top = UDim.new(0, v) })
	end, { v, v2 })

	local v4 = React.useMemo(function()
		return {
			scrollViewPositionChangedSignal = v3.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = v3.verticalScrollingFrameRef,
			scrollStore = scrollStore,
			contentMode = contentMode
		}
	end, { scrollStore, v3, contentMode })

	local v5 = React.useMemo(function()
		return resolveCompositionTags(composition)
	end, { composition })

	local content = contentConfig.content
	local createElement = React.createElement
	local v6 = {
		scrollStore = scrollStore,
		scrollingFrameRef = ref3,
		slots = content.contentSlot,
		contentTopPadding = props.contentTopPadding,
		contentBottomPadding = props.contentBottomPadding,
		chromeDisplacement = 0,
		tag = 0,
		containerTag = 0,
		size = 0,
		flexMode = 0,
		layoutOrder = 3,
		zIndex = 1
	}
	local chromeDisplacement

	if FFlagSduiFeedScrollBarFixes then
		chromeDisplacement = v2
	end

	v6.chromeDisplacement = chromeDisplacement
	v6.tag = v5.body

	v6.containerTag = not FFlagSduiFeedScrollBarFixes and "fill size-full-0" or nil
	local size

	if FFlagSduiFeedScrollBarFixes then
		size = UDim2.new(1, 0, 0, 0)
	end

	v6.size = size
	local flexMode

	if FFlagSduiFeedScrollBarFixes then
		flexMode = Enum.UIFlexMode.Fill
	end

	v6.flexMode = flexMode
	local element = createElement(PageWholeContent, v6)

	local onRefresh = props.onRefresh
	local refresh

	if onRefresh ~= nil then
		refresh = React.createElement(PullToRefreshSpinner, {
			onRefresh = onRefresh,
			scrollingFrameRef = ref3,
			appEventName = props.appEventName,
			LayoutOrder = 2
		})
	end

	local v7

	if stickyHeaderSlot == nil then
		v7 = false
	else
		v7 = next(stickyHeaderSlot) ~= nil
	end

	local createElement2 = React.createElement
	local provider = PageContext.Provider

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local root = v5.root
	local v8 = {
		tag = not root and "col size-full" or `col size-full {root}`,
		ref = ref
	}
	local sticky

	if v7 then
		local createElement5 = React.createElement
		local v9 = {
			slots = stickyHeaderSlot,
			chromeHeight = chromeHeight,
			liveChromeHeightBinding = nil,
			backgroundStyle = 0,
			tag = 0,
			topPadding = 0
		}
		local liveChromeHeightBinding

		if not FFlagSduiFeedScrollBarFixes then
			liveChromeHeightBinding = liveHeightBinding
		end

		v9.liveChromeHeightBinding = liveChromeHeightBinding
		v9.backgroundStyle = props.stickyBackgroundStyle
		local header = v5.header
		v9.tag = not header and "col size-full-0 auto-y" or `col size-full-0 auto-y {header}`
		v9.topPadding = props.stickyTopPadding
		sticky = createElement5(PageStickyHeader, v9)
	end

	return createElement2(provider, { value = v4 }, {
		ChromeInset = createElement3(View, { tag = "col size-full", padding = padding }, {
			Root = createElement4(View, v8, {
				Sticky = sticky,
				Refresh = refresh,
				Content = element
			})
		})
	})
end

return React.memo(React.forwardRef(Page))
