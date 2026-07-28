local AppSplitView = script:FindFirstAncestor("AppSplitView")
local AppSplitViewParent = AppSplitView.Parent
local React = require(AppSplitViewParent.React)
local Foundation = require(AppSplitViewParent.Foundation)
local AppComposition = require(AppSplitViewParent.AppComposition)
local Signals = require(AppSplitViewParent.Signals)
local Display = require(AppSplitViewParent.Display)
local PaneResizer = require(AppSplitView.Components.PaneResizer)
local useSplitViewResize = require(AppSplitView.Hooks.useSplitViewResize)
local Enums = require(AppSplitView.Common.Enums)
local SignalsReact = require(AppSplitViewParent.SignalsReact)
local View = Foundation.View
local CompositionStyleSheet = AppComposition.CompositionStyleSheet
local CompositionTags = AppComposition.CompositionTags
local getRegionOverrides = AppComposition.getRegionOverrides
local RegionName = AppComposition.RegionName

local function getPlatformScale(p1) -- line: 23
	-- upvalues: Display (copy)
	local v23 = Display.GetDisplayStore(p1)

	if v23.getPlatformScale then
		return (v23.getPlatformScale(p1))
	end

	return 1
end

local v18 = Signals.createComputed(function(p2) -- line: 29
	-- upvalues: getRegionOverrides (copy), RegionName (copy), Display (copy)
	local v25 = if not getRegionOverrides or not RegionName then nil else getRegionOverrides(RegionName.NavigationRegion)
	local v26 = (not v25 or not v25.widthScale) and 0 or v25.widthScale
	local v27 = Display.GetDisplayStore(p2)

	return v26 * (not v27.getPlatformScale and 1 or v27.getPlatformScale(p2))
end)
local v19 = Signals.createComputed(function(p3) -- line: 37
	-- upvalues: getRegionOverrides (copy), RegionName (copy), Display (copy)
	local v29 = if not getRegionOverrides or not RegionName then nil else getRegionOverrides(RegionName.SupportRegion)
	local v30 = (not v29 or not v29.widthScale) and 0 or v29.widthScale

	return Display.GetDisplayStore(p3).getViewportSize(p3).X * v30
end)
local t1 = {
	Transparency = 1
}

local function SplitView(t2: {[any]: any}) -- line: 75
	-- upvalues: SignalsReact (copy), v18 (copy), v19 (copy), Enums (copy), useSplitViewResize (copy), React (copy), CompositionTags (copy), CompositionStyleSheet (copy), View (copy), t1 (copy), PaneResizer (copy)
	local v32 = SignalsReact.useSignalState(v18)
	local v33 = SignalsReact.useSignalState(v19)
	local v34 = t2.variant or Enums.SplitVariant.SplitRight
	local v35 = not t2.navigationPane and 0 or if t2.navigationPane.width == nil then v32 else t2.navigationPane.width
	local v36 = not t2.supportPane and 0 or if t2.supportPane.width == nil then v33 else t2.supportPane.width
	local v37 = t2.supportPaneMode or Enums.SupportPaneMode.Normal
	local v38 = v37 == Enums.SupportPaneMode.Expanded
	local v39 = v37 == Enums.SupportPaneMode.Collapsed
	local v40 = v38 or v37 == Enums.SupportPaneMode.Expanding
	local v41 = not v38
	local v42 = t2.supportPane ~= nil and (t2.supportPane.resizable == Enums.PaneResizable.Horizontal and (t2.onSupportPaneWidthChanged ~= nil and (not v40 and not v39)))
	local v43 = t2.supportPane ~= nil and t2.supportPane.width ~= nil
	local t3 = {
		navWidth = v35,
		supportWidth = v36,
		variant = v34,
		hasWidthOverride = v43,
		onSupportPaneWidthChanged = t2.onSupportPaneWidthChanged
	}
	local v45 = useSplitViewResize(t3)
	local v46 = React.useCallback(function(p4) -- line: 113
		-- upvalues: v40 (copy), v45 (copy), t2 (copy)
		if not v40 then
			v45.onSupportAbsoluteSizeChanged(p4)
		end

		if t2.onSupportRegionRectChanged then
			t2.onSupportRegionRectChanged(p4)
		end
	end, {
		v40,
		v45.onSupportAbsoluteSizeChanged,
		t2.onSupportRegionRectChanged
	})
	local v47 = if not v38 then if not v39 then CompositionTags.SupportRegion.Root else CompositionTags.SupportRegion.Collapsed or CompositionTags.SupportRegion.Root else CompositionTags.ContentRegion.Root
	local uDim2, uDim2_2

	if v38 then
		uDim2 = UDim2.fromScale(0, 0)
		uDim2_2 = UDim2.fromScale(1, 1)
	else
		uDim2 = v45.supportPosition
		uDim2_2 = v45.supportSize
	end

	local v50 = not v38 and 1 or 4
	local contentPosition = v45.contentPosition
	local contentSize = v45.contentSize

	return React.createElement(React.Fragment, nil, {
		CompositionStyleSheet = React.createElement(CompositionStyleSheet),
		NavigationPane = if not t2.navigationPane then nil else React.createElement(View, {
			ZIndex = 1,
			tag = CompositionTags.NavigationRegion.Root,
			Size = UDim2.new(0, v35, 1, 0),
			Interactable = v41,
			backgroundStyle = t1
		}, {
			Slot = t2.navigationPane.element
		}),
		ContentPane = React.createElement(View, {
			ZIndex = 1,
			tag = CompositionTags.ContentRegion.Root,
			Position = contentPosition,
			Size = contentSize,
			Interactable = v41,
			backgroundStyle = t1,
			onAbsoluteSizeChanged = t2.onContentRegionRectChanged,
			onAbsolutePositionChanged = t2.onContentRegionRectChanged
		}, t2.children),
		SupportPane = if not t2.supportPane then nil else React.createElement(View, {
			tag = v47,
			Position = uDim2,
			Size = uDim2_2,
			ZIndex = v50,
			backgroundStyle = t1,
			onAbsoluteSizeChanged = v46,
			onAbsolutePositionChanged = t2.onSupportRegionRectChanged
		}, {
			Slot = t2.supportPane.element
		}),
		SupportResizer = if not v42 then nil else React.createElement(PaneResizer, {
			ZIndex = 3,
			position = v45.resizerPosition,
			hitWidth = v45.resizerHitWidth,
			onDrag = v45.onResizerDrag,
			onDragEnd = v45.onResizerDragEnd
		})
	})
end

return React.memo(SplitView)
