local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local AppBlox = require(parent.AppBlox)
local useAnimateScrollViewToSelection = AppBlox.useAnimateScrollViewToSelection
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local CollectionViews = require(parent.CollectionViews)
local CollectionLayoutStoreProvider = CollectionViews.CollectionLayoutStoreProvider

require(AppPageShell.PageTypes)
require(AppPageShell.createPageScrollStore)

local ScrollView = Foundation.ScrollView
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes
local FFlagSduiPageCanvasCollectionLayout = SharedFlags.FFlagSduiPageCanvasCollectionLayout
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local frozen = table.freeze({ Selectable = false })

local function PageWholeContent(props)
	local scrollStore = props.scrollStore
	local slots = props.slots
	local contentTopPadding = props.contentTopPadding
	local contentBottomPadding = props.contentBottomPadding
	local chromeDisplacement

	if FFlagSduiFeedScrollBarFixes then
		chromeDisplacement = props.chromeDisplacement
	else
		chromeDisplacement = nil
	end

	local scrollingFrameRef = props.scrollingFrameRef
	local state, setState

	if FFlagSduiPageCanvasCollectionLayout then
		state, setState = React.useState(nil)
	end

	useAnimateScrollViewToSelection(scrollingFrameRef, 0.4)
	local v = useLastInputMode() ~= "Cursor"
	local v2 = nil
	local scrollBarThickness = nil
	local scroll = nil

	if FFlagSduiFeedScrollBarFixes then
		v2 = useTokens()

		if isSubjectToDesktopPolicies() then
			scrollBarThickness = 4
		else
			scrollBarThickness = 0
		end
	else
		scroll = React.useMemo(function()
			return table.freeze({
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = not v
			})
		end, { v })
	end

	local onCanvasPositionChanged, v3

	if FFlagSduiFeedScrollBarFixes then
		v3 = nil
	else
		v3 = React.useCallback(function(p)
			scrollStore.setViewportHeight(p.AbsoluteWindowSize.Y)
			scrollStore.setContentHeight(p.AbsoluteCanvasSize.Y)
		end, { scrollStore })

		onCanvasPositionChanged = React.useCallback(function(p)
			if v3 ~= nil then
				v3(p)
			end

			scrollStore.setCanvasPosition(p.CanvasPosition.Y)
		end, { scrollStore, v3 })
	end

	local v4 = React.useCallback(function(current)
		scrollStore.setScrollingFrame(current)
		scrollingFrameRef.current = current
	end, { scrollStore, scrollingFrameRef })

	local v5 = React.useMemo(function()
		if slots == nil then
			return nil
		end

		local slots2 = {}

		for k, slot in slots do
			slots2[`Content{k}`] = slot
		end

		return slots2
	end, { slots })
	local size

	if FFlagSduiFeedScrollBarFixes then
		size = React.useMemo(function()
			if chromeDisplacement == nil then
				return UDim2.new(1, 0, 0, contentTopPadding or 0)
			end

			return chromeDisplacement:map(function(p: number)
				return UDim2.new(1, 0, 0, (contentTopPadding or 0) + p)
			end)
		end, { chromeDisplacement, contentTopPadding })
	end

	local topSpacer

	if contentTopPadding and contentTopPadding > 0 or chromeDisplacement ~= nil then
		local createElement = React.createElement

		if not FFlagSduiFeedScrollBarFixes then
			size = UDim2.new(1, 0, 0, contentTopPadding)
		end

		topSpacer = createElement("Frame", {
			Size = size,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		})
	end

	local v6 = {
		TopSpacer = topSpacer,
		Content = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, v5),
		BottomSpacer = 0
	}
	local bottomSpacer

	if contentBottomPadding and contentBottomPadding > 0 then
		bottomSpacer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, contentBottomPadding),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3
		})
	end

	v6.BottomSpacer = bottomSpacer

	if FFlagSduiPageCanvasCollectionLayout then
		v6 = React.createElement(CollectionLayoutStoreProvider, { container = state }, v6)
	end

	local createElement = React.createElement
	local v7 = {
		tag = `col size-full-0 auto-y {props.tag or ""}`,
		ref = 0
	}

	if not FFlagSduiPageCanvasCollectionLayout then
		setState = nil
	end

	v7.ref = setState
	local v8 = { Canvas = createElement(View, v7, v6) }

	if not FFlagSduiFeedScrollBarFixes then
		return React.createElement(ScrollView, {
			scrollingFrameRef = v4,
			selection = frozen,
			scroll = scroll,
			onCanvasPositionChanged = onCanvasPositionChanged,
			onAbsoluteCanvasSizeChanged = v3,
			onAbsoluteWindowSizeChanged = v3,
			tag = props.containerTag or "size-full",
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			ClipsDescendants = false
		}, v8)
	end

	local createElement2 = React.createElement
	local v9 = {
		Size = props.size or UDim2.fromScale(1, 1),
		LayoutOrder = props.layoutOrder,
		ZIndex = props.zIndex,
		AutoLocalize = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = not v,
		Selectable = false,
		ClipsDescendants = true,
		ScrollBarThickness = scrollBarThickness,
		ScrollBarImageColor3 = v2.Color.Shift.Shift_400.Color3,
		ScrollBarImageTransparency = 0,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		[React.Change.CanvasPosition] = scrollStore.setCanvasPositionFromScrollingFrame,
		[React.Change.AbsoluteCanvasSize] = scrollStore.setExtentsFromScrollingFrame,
		[React.Change.AbsoluteWindowSize] = scrollStore.setExtentsFromScrollingFrame,
		ref = v4
	}
	local flexItem

	if props.flexMode ~= nil then
		flexItem = React.createElement("UIFlexItem", { FlexMode = props.flexMode })
	end

	return createElement2("ScrollingFrame", v9, { FlexItem = flexItem, Canvas = v8.Canvas })
end

return React.memo(PageWholeContent)
