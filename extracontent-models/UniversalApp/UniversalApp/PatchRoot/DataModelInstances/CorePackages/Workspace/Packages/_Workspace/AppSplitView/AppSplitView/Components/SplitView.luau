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
	local v26 = (not v25 or not v25.width) and 0 or v25.width
	local v27 = Display.GetDisplayStore(p2)

	return v26 * (not v27.getPlatformScale and 1 or v27.getPlatformScale(p2))
end)
local v19 = Signals.createComputed(function(p3) -- line: 37
	-- upvalues: getRegionOverrides (copy), RegionName (copy), Display (copy)
	local v29 = if not getRegionOverrides or not RegionName then nil else getRegionOverrides(RegionName.SupportRegion)
	local v30 = (not v29 or not v29.width) and 0 or v29.width
	local v31 = Display.GetDisplayStore(p3)

	return v30 * (not v31.getPlatformScale and 1 or v31.getPlatformScale(p3))
end)
local t1 = {
	Transparency = 1
}

local function SplitView(t2: {[any]: any}) -- line: 71
	-- upvalues: SignalsReact (copy), v18 (copy), v19 (copy), Enums (copy), useSplitViewResize (copy), React (copy), CompositionTags (copy), CompositionStyleSheet (copy), View (copy), t1 (copy), PaneResizer (copy)
	local v33 = SignalsReact.useSignalState(v18)
	local v34 = SignalsReact.useSignalState(v19)
	local v35 = t2.variant or Enums.SplitVariant.SplitRight
	local v36 = not t2.navigationPane and 0 or if t2.navigationPane.width == nil then v33 else t2.navigationPane.width
	local v37 = not t2.supportPane and 0 or if t2.supportPane.width == nil then v34 else t2.supportPane.width
	local v38 = t2.supportPaneMode or Enums.SupportPaneMode.Normal
	local v39 = v38 ~= Enums.SupportPaneMode.Normal
	local v40 = t2.supportPane ~= nil and (t2.supportPane.resizable == Enums.PaneResizable.Horizontal and (t2.onSupportPaneWidthChanged ~= nil and not v39))
	local t3 = {
		navWidth = v36,
		supportWidth = v37,
		variant = v35,
		onSupportPaneWidthChanged = t2.onSupportPaneWidthChanged
	}
	local v42 = useSplitViewResize(t3)
	local v43 = React.useCallback(function(p4) -- line: 101
		-- upvalues: v39 (copy), v42 (copy), t2 (copy)
		if not v39 then
			v42.onSupportAbsoluteSizeChanged(p4)
		end

		if t2.onSupportRegionRectChanged then
			t2.onSupportRegionRectChanged(p4)
		end
	end, {
		v39,
		v42.onSupportAbsoluteSizeChanged,
		t2.onSupportRegionRectChanged
	})
	local v44 = if v38 ~= Enums.SupportPaneMode.Expanded then CompositionTags.SupportRegion.Root else CompositionTags.ContentRegion.Root
	local v45 = if not v39 then v42.supportPosition else UDim2.fromScale(0, 0)
	local v46 = if not v39 then v42.supportSize else UDim2.fromScale(1, 1)
	local v47 = not v39 and 1 or 4

	return React.createElement(React.Fragment, nil, {
		CompositionStyleSheet = React.createElement(CompositionStyleSheet),
		NavigationPane = if not t2.navigationPane then nil else React.createElement(View, {
			ZIndex = 1,
			tag = CompositionTags.NavigationRegion.Root,
			Size = UDim2.new(0, v36, 1, 0),
			Interactable = not v39,
			backgroundStyle = t1
		}, {
			Slot = t2.navigationPane.element
		}),
		ContentPane = React.createElement(View, {
			ZIndex = 1,
			tag = CompositionTags.ContentRegion.Root,
			Position = v42.contentPosition,
			Size = v42.contentSize,
			Interactable = not v39,
			backgroundStyle = t1,
			onAbsoluteSizeChanged = t2.onContentRegionRectChanged,
			onAbsolutePositionChanged = t2.onContentRegionRectChanged
		}, t2.children),
		SupportPane = if not t2.supportPane then nil else React.createElement(View, {
			tag = v44,
			Position = v45,
			Size = v46,
			ZIndex = v47,
			backgroundStyle = t1,
			onAbsoluteSizeChanged = v43,
			onAbsolutePositionChanged = t2.onSupportRegionRectChanged
		}, {
			Slot = t2.supportPane.element
		}),
		SupportResizer = if not v40 then nil else React.createElement(PaneResizer, {
			ZIndex = 3,
			position = v42.resizerPosition,
			hitWidth = v42.resizerHitWidth,
			onDrag = v42.onResizerDrag,
			onDragEnd = v42.onResizerDragEnd
		})
	})
end

return React.memo(SplitView)
