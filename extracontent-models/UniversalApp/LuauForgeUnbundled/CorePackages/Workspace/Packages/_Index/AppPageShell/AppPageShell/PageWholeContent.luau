local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/React")
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/AppBlox").useAnimateScrollViewToSelection
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/FocusNavigationUtils").useLastInputMode
local collectionLayoutStoreProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/CollectionViews").CollectionLayoutStoreProvider

require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/createPageScrollStore")

local scrollView = Foundation.ScrollView
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags")
local fFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes
local fFlagSduiPageCanvasCollectionLayout = SharedFlags.FFlagSduiPageCanvasCollectionLayout
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local frozen = table.freeze({ Selectable = false })

local function PageWholeContent(props)
	local scrollStore = props.scrollStore
	local slots = props.slots
	local contentTopPadding = props.contentTopPadding
	local contentBottomPadding = props.contentBottomPadding
	local chromeDisplacement = if fFlagSduiFeedScrollBarFixes then props.chromeDisplacement else nil
	local scrollingFrameRef = props.scrollingFrameRef
	local state, setState

	if fFlagSduiPageCanvasCollectionLayout then
		state, setState = React.useState(nil)
	end

	useAnimateScrollViewToSelection(scrollingFrameRef, 0.4)
	local v5 = useLastInputMode() ~= "Cursor"
	local v6 = nil
	local v7 = nil
	local v8 = nil

	if fFlagSduiFeedScrollBarFixes then
		v6 = useTokens()
		v7 = if isSubjectToDesktopPolicies() then 4 else 0
	else
		v8 = React.useMemo(function()
			return table.freeze({
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = not v5
			})
		end, { v5 })
	end

	local v9, v10

	if fFlagSduiFeedScrollBarFixes then
		v10 = nil
	else
		v10 = React.useCallback(function(p2)
			scrollStore.setViewportHeight(p2.AbsoluteWindowSize.Y)
			scrollStore.setContentHeight(p2.AbsoluteCanvasSize.Y)
		end, { scrollStore })

		v9 = React.useCallback(function(p2)
			if v10 ~= nil then
				v10(p2)
			end

			scrollStore.setCanvasPosition(p2.CanvasPosition.Y)
		end, { scrollStore, v10 })
	end

	local v11 = React.useCallback(function(current)
		scrollStore.setScrollingFrame(current)
		scrollingFrameRef.current = current
	end, { scrollStore, scrollingFrameRef })

	local v12 = React.useMemo(function()
		if slots == nil then
			return nil
		end

		local slots2 = {}

		for k, slot in slots do
			slots2[`Content{k}`] = slot
		end

		return slots2
	end, { slots })
	local v13

	if fFlagSduiFeedScrollBarFixes then
		v13 = React.useMemo(function()
			if chromeDisplacement == nil then
				return UDim2.new(1, 0, 0, contentTopPadding or 0)
			end

			return chromeDisplacement:map(function(p2)
				return UDim2.new(1, 0, 0, (contentTopPadding or 0) + p2)
			end)
		end, { chromeDisplacement, contentTopPadding })
	end

	local v15

	if contentTopPadding and contentTopPadding > 0 or chromeDisplacement ~= nil then
		local createElement = React.createElement

		if not fFlagSduiFeedScrollBarFixes then
			v13 = UDim2.new(1, 0, 0, contentTopPadding)
		end

		v15 = createElement("Frame", {
			Size = v13,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		})
	end

	local v14 = {
		TopSpacer = v15,
		Content = React.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 2
		}, v12),
		BottomSpacer = 0
	}

	local v16 = if contentBottomPadding and contentBottomPadding > 0 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, contentBottomPadding),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3
	}) else nil
	v14.BottomSpacer = v16

	if fFlagSduiPageCanvasCollectionLayout then
		v14 = React.createElement(collectionLayoutStoreProvider, { container = state }, v14)
	end

	local createElement = React.createElement
	local v19 = {
		tag = `col size-full-0 auto-y {props.tag or ""}`,
		ref = 0
	}

	if not fFlagSduiPageCanvasCollectionLayout then
		setState = nil
	end

	v19.ref = setState
	local v17 = { Canvas = createElement(view, v19, v14) }

	if not fFlagSduiFeedScrollBarFixes then
		return React.createElement(scrollView, {
			scrollingFrameRef = v11,
			selection = frozen,
			scroll = v8,
			onCanvasPositionChanged = v9,
			onAbsoluteCanvasSizeChanged = v10,
			onAbsoluteWindowSizeChanged = v10,
			tag = props.containerTag or "size-full",
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			ClipsDescendants = false
		}, v17)
	end

	local createElement2 = React.createElement
	local v21 = {
		Size = props.size or UDim2.fromScale(1, 1),
		LayoutOrder = props.layoutOrder,
		ZIndex = props.zIndex,
		AutoLocalize = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = not v5,
		Selectable = false,
		ClipsDescendants = true,
		ScrollBarThickness = v7,
		ScrollBarImageColor3 = v6.Color.Shift.Shift_400.Color3,
		ScrollBarImageTransparency = 0,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		[React.Change.CanvasPosition] = scrollStore.setCanvasPositionFromScrollingFrame,
		[React.Change.AbsoluteCanvasSize] = scrollStore.setExtentsFromScrollingFrame,
		[React.Change.AbsoluteWindowSize] = scrollStore.setExtentsFromScrollingFrame,
		ref = v11
	}

	local v23 = if props.flexMode ~= nil then React.createElement("UIFlexItem", {
		FlexMode = props.flexMode
	}) else nil
	return createElement2("ScrollingFrame", v21, { FlexItem = v23, Canvas = v17.Canvas })
end

return React.memo(PageWholeContent)
