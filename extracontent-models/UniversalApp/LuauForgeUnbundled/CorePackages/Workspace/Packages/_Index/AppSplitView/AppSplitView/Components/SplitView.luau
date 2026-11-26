local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/Foundation")

local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/AppComposition")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/Signals")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/Display")
local fFlagFixSplitPaneGamepadLayoutJitter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/SharedFlags").FFlagFixSplitPaneGamepadLayoutJitter

local PaneResizer = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Components/PaneResizer")
local useSplitViewResize = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Hooks/useSplitViewResize")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Common/Enums")

local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/SignalsReact")

local view = Foundation.View
local compositionStyleSheet = AppComposition.CompositionStyleSheet
local compositionTags = AppComposition.CompositionTags
local getRegionOverrides = AppComposition.getRegionOverrides
local regionName = AppComposition.RegionName

local function getPlatformScale(p2)
	local displayStore = Display.GetDisplayStore(p2)

	if displayStore.getPlatformScale then
		return (displayStore.getPlatformScale(p2))
	end

	return 1
end

local computed = Signals.createComputed(function(p2)
	local v5

	if getRegionOverrides and regionName then
		v5 = getRegionOverrides(regionName.NavigationRegion)
	end

	local v6 = not (v5 and v5.widthScale) and 0 or v5.widthScale
	local displayStore = Display.GetDisplayStore(p2)
	return v6 * (not displayStore.getPlatformScale and 1 or displayStore.getPlatformScale(p2))
end)

local computed2 = Signals.createComputed(function(p2)
	local v5

	if getRegionOverrides and regionName then
		v5 = getRegionOverrides(regionName.SupportRegion)
	end

	local v6 = not (v5 and v5.widthScale) and 0 or v5.widthScale

	return Display.GetDisplayStore(p2).getViewportSize(p2).X * v6
end)

local v5 = { Transparency = 1 }

local function SplitView(props)
	local v6 = SignalsReact.useSignalState(computed)
	local v7 = SignalsReact.useSignalState(computed2)

	local variant = props.variant or Enums.SplitVariant.SplitRight

	if props.navigationPane then
		if props.navigationPane.width ~= nil then
			v6 = props.navigationPane.width
		end
	else
		v6 = 0
	end

	if props.supportPane then
		if props.supportPane.width ~= nil then
			v7 = props.supportPane.width
		end
	else
		v7 = 0
	end

	local supportPaneMode = props.supportPaneMode or Enums.SupportPaneMode.Normal
	local v8 = supportPaneMode == Enums.SupportPaneMode.Expanded
	local v9 = supportPaneMode == Enums.SupportPaneMode.Collapsed
	local v10 = supportPaneMode == Enums.SupportPaneMode.Collapsing
	local v11 = v8 or supportPaneMode == Enums.SupportPaneMode.Expanding

	local v12 = not v8

	local v13 = not (props.supportPane == nil) and not (v11 or v9 or v10)
	local v14

	if v13 then
		if props.supportPane == nil or props.supportPane.resizable ~= Enums.PaneResizable.Horizontal then
			v14 = false
		else
			v14 = props.onSupportPaneWidthChanged ~= nil
		end
	else
		v14 = v13
	end

	local v15 = not (props.supportPane == nil) and props.supportPane.width ~= nil

	local v17 = useSplitViewResize({
		navWidth = v6,
		supportWidth = v7,
		variant = variant,
		hasWidthOverride = v15,
		onSupportPaneWidthChanged = props.onSupportPaneWidthChanged
	})

	local v18 = React.useCallback(function(p2)
		if not v11 then
			v17.onSupportAbsoluteSizeChanged(p2)
		end

		if props.onSupportRegionRectChanged then
			props.onSupportRegionRectChanged(p2)
		end
	end, { v11, v17.onSupportAbsoluteSizeChanged, props.onSupportRegionRectChanged })
	local v19

	if v8 then
		v19 = compositionTags.ContentRegion.Root
	elseif v9 then
		v19 = compositionTags.SupportRegion.Collapsed or compositionTags.SupportRegion.Root
	else
		v19 = compositionTags.SupportRegion.Root
	end

	local v20, v21

	if v8 then
		v20 = UDim2.fromScale(0, 0)
		v21 = UDim2.fromScale(1, 1)
	else
		v20 = v17.supportPosition
		v21 = v17.supportSize

		if
			fFlagFixSplitPaneGamepadLayoutJitter
			and v21 == nil
			and supportPaneMode == Enums.SupportPaneMode.Normal
			and v7 > 0
		then
			v21 = UDim2.new(0, v7, 1, 0)
		end
	end

	local supportResizerAbovePane = props.supportResizerAbovePane == true

	local contentPosition = v17.contentPosition
	local contentSize = v17.contentSize

	local createElement = React.createElement
	local fragment = React.Fragment
	local v24 = {
		CompositionStyleSheet = React.createElement(compositionStyleSheet),
		NavigationPane = 0,
		ContentPane = 0,
		SupportPane = 0,
		SupportResizer = 0
	}

	local v25 = if props.navigationPane then React.createElement(view, {
		tag = compositionTags.NavigationRegion.Root,
		Size = UDim2.new(0, v6, 1, 0),
		ZIndex = 1,
		Interactable = v12,
		backgroundStyle = v5
	}, { Slot = props.navigationPane.element }) else nil
	v24.NavigationPane = v25

	v24.ContentPane = React.createElement(view, {
		tag = compositionTags.ContentRegion.Root,
		Position = contentPosition,
		Size = contentSize,
		ZIndex = 1,
		Interactable = v12,
		backgroundStyle = v5,
		onAbsoluteSizeChanged = props.onContentRegionRectChanged,
		onAbsolutePositionChanged = props.onContentRegionRectChanged
	}, props.children)

	local v26 = if props.supportPane then React.createElement(view, {
		tag = v19,
		Position = v20,
		Size = v21,
		ZIndex = v8 and 4 or v13 and not (v14 or supportResizerAbovePane) and 3 or 1,
		backgroundStyle = v5,
		onAbsoluteSizeChanged = v18,
		onAbsolutePositionChanged = props.onSupportRegionRectChanged
	}, { Slot = props.supportPane.element }) else nil
	v24.SupportPane = v26
	local v27

	if v13 then
		local createElement2 = React.createElement
		local supportResizer = {
			Name = "SupportResizer",
			interactive = v14,
			position = v17.resizerPosition,
			hitWidth = v17.resizerHitWidth,
			ZIndex = (v14 or supportResizerAbovePane) and 3 or 2,
			onDrag = 0,
			onDragEnd = 0
		}

		local v29 = if v14 then v17.onResizerDrag else nil
		supportResizer.onDrag = v29
		local v30 = if v14 then v17.onResizerDragEnd else nil
		supportResizer.onDragEnd = v30
		v27 = createElement2(PaneResizer, supportResizer)
	end

	v24.SupportResizer = v27
	return createElement(fragment, nil, v24)
end

return React.memo(SplitView)
