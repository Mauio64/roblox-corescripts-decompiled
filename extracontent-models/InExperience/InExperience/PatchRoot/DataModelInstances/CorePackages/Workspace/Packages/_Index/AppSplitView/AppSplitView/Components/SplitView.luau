local AppSplitView = script:FindFirstAncestor("AppSplitView")
local parent = AppSplitView.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local AppComposition = require(parent.AppComposition)
local Signals = require(parent.Signals)
local Display = require(parent.Display)
local SharedFlags = require(parent.SharedFlags)
local FFlagFixSplitPaneGamepadLayoutJitter = SharedFlags.FFlagFixSplitPaneGamepadLayoutJitter

local PaneResizer = require(AppSplitView.Components.PaneResizer)
local useSplitViewResize = require(AppSplitView.Hooks.useSplitViewResize)
local Enums = require(AppSplitView.Common.Enums)

local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View
local CompositionStyleSheet = AppComposition.CompositionStyleSheet
local CompositionTags = AppComposition.CompositionTags
local getRegionOverrides = AppComposition.getRegionOverrides
local RegionName = AppComposition.RegionName

local function getPlatformScale(p) -- 1 equivalent call inferred from this helper
	local displayStore = Display.GetDisplayStore(p)

	if displayStore.getPlatformScale then
		return (displayStore.getPlatformScale(p))
	end

	return 1
end

local computed = Signals.createComputed(function(p)
	local v

	if getRegionOverrides and RegionName then
		v = getRegionOverrides(RegionName.NavigationRegion)
	end

	return (not (v and v.widthScale) and 0 or v.widthScale) * getPlatformScale(p) -- inferred equivalent call
end)

local computed2 = Signals.createComputed(function(p)
	local v

	if getRegionOverrides and RegionName then
		v = getRegionOverrides(RegionName.SupportRegion)
	end

	local v2 = not (v and v.widthScale) and 0 or v.widthScale

	return Display.GetDisplayStore(p).getViewportSize(p).X * v2
end)

local backgroundStyle = { Transparency = 1 }

local function SplitView(props)
	local navWidth = SignalsReact.useSignalState(computed)
	local supportWidth = SignalsReact.useSignalState(computed2)

	local variant = props.variant or Enums.SplitVariant.SplitRight

	if props.navigationPane then
		if props.navigationPane.width ~= nil then
			navWidth = props.navigationPane.width
		end
	else
		navWidth = 0
	end

	if props.supportPane then
		if props.supportPane.width ~= nil then
			supportWidth = props.supportPane.width
		end
	else
		supportWidth = 0
	end

	local supportPaneMode = props.supportPaneMode or Enums.SupportPaneMode.Normal
	local v = supportPaneMode == Enums.SupportPaneMode.Expanded
	local v2 = supportPaneMode == Enums.SupportPaneMode.Collapsed
	local v3 = supportPaneMode == Enums.SupportPaneMode.Collapsing
	local v4 = v or supportPaneMode == Enums.SupportPaneMode.Expanding

	local interactable = not v
	local v5

	if props.supportPane == nil then
		v5 = false
	else
		v5 = not (v4 or v2 or v3)
	end

	local interactive

	if v5 then
		if props.supportPane == nil or props.supportPane.resizable ~= Enums.PaneResizable.Horizontal then
			interactive = false
		else
			interactive = props.onSupportPaneWidthChanged ~= nil
		end
	else
		interactive = v5
	end

	local hasWidthOverride

	if props.supportPane == nil then
		hasWidthOverride = false
	else
		hasWidthOverride = props.supportPane.width ~= nil
	end

	local v6 = useSplitViewResize({
		navWidth = navWidth,
		supportWidth = supportWidth,
		variant = variant,
		hasWidthOverride = hasWidthOverride,
		onSupportPaneWidthChanged = props.onSupportPaneWidthChanged
	})

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		if not v4 then
			v6.onSupportAbsoluteSizeChanged(p)
		end

		if props.onSupportRegionRectChanged then
			props.onSupportRegionRectChanged(p)
		end
	end, { v4, v6.onSupportAbsoluteSizeChanged, props.onSupportRegionRectChanged })
	local tag

	if v then
		tag = CompositionTags.ContentRegion.Root
	elseif v2 then
		tag = CompositionTags.SupportRegion.Collapsed or CompositionTags.SupportRegion.Root
	else
		tag = CompositionTags.SupportRegion.Root
	end

	local position, size

	if v then
		position = UDim2.fromScale(0, 0)
		size = UDim2.fromScale(1, 1)
	else
		position = v6.supportPosition
		size = v6.supportSize

		if
			FFlagFixSplitPaneGamepadLayoutJitter
			and size == nil
			and supportPaneMode == Enums.SupportPaneMode.Normal
			and supportWidth > 0
		then
			size = UDim2.new(0, supportWidth, 1, 0)
		end
	end

	local supportResizerAbovePane = props.supportResizerAbovePane == true
	local zIndex = v and 4 or v5 and not (interactive or supportResizerAbovePane) and 3 or 1
	local contentPosition = v6.contentPosition
	local contentSize = v6.contentSize

	local createElement = React.createElement
	local fragment = React.Fragment
	local v7 = {
		CompositionStyleSheet = React.createElement(CompositionStyleSheet),
		NavigationPane = 0,
		ContentPane = 0,
		SupportPane = 0,
		SupportResizer = 0
	}
	local navigationPane

	if props.navigationPane then
		navigationPane = React.createElement(View, {
			tag = CompositionTags.NavigationRegion.Root,
			Size = UDim2.new(0, navWidth, 1, 0),
			ZIndex = 1,
			Interactable = interactable,
			backgroundStyle = backgroundStyle
		}, { Slot = props.navigationPane.element })
	end

	v7.NavigationPane = navigationPane

	v7.ContentPane = React.createElement(View, {
		tag = CompositionTags.ContentRegion.Root,
		Position = contentPosition,
		Size = contentSize,
		ZIndex = 1,
		Interactable = interactable,
		backgroundStyle = backgroundStyle,
		onAbsoluteSizeChanged = props.onContentRegionRectChanged,
		onAbsolutePositionChanged = props.onContentRegionRectChanged
	}, props.children)
	local supportPane

	if props.supportPane then
		supportPane = React.createElement(View, {
			tag = tag,
			Position = position,
			Size = size,
			ZIndex = zIndex,
			backgroundStyle = backgroundStyle,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			onAbsolutePositionChanged = props.onSupportRegionRectChanged
		}, { Slot = props.supportPane.element })
	end

	v7.SupportPane = supportPane
	local supportResizer2

	if v5 then
		local createElement2 = React.createElement
		local supportResizer = {
			Name = "SupportResizer",
			interactive = interactive,
			position = v6.resizerPosition,
			hitWidth = v6.resizerHitWidth,
			ZIndex = (interactive or supportResizerAbovePane) and 3 or 2,
			onDrag = 0,
			onDragEnd = 0
		}
		local onDrag

		if interactive then
			onDrag = v6.onResizerDrag
		end

		supportResizer.onDrag = onDrag
		local onDragEnd

		if interactive then
			onDragEnd = v6.onResizerDragEnd
		end

		supportResizer.onDragEnd = onDragEnd
		supportResizer2 = createElement2(PaneResizer, supportResizer)
	end

	v7.SupportResizer = supportResizer2
	return createElement(fragment, nil, v7)
end

return React.memo(SplitView)
