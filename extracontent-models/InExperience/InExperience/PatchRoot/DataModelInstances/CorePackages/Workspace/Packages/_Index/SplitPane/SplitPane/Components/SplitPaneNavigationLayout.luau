local Parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(Parent.React)
local AppSplitView = require(Parent.AppSplitView)
local SplitView = AppSplitView.SplitView
local Enums = AppSplitView.Enums
local useSplitPaneRender = require(script.Parent.Parent.Hooks.useSplitPaneRender)

local function SplitPaneNavigationLayout(t1: {[any]: any}) -- line: 19
	-- upvalues: useSplitPaneRender (copy), React (copy), Enums (copy), SplitView (copy)
	local v9 = useSplitPaneRender(t1.screens, t1.cards, t1.paneIndices, t1.isRouteActiveOnPane)

	if not v9.isBreakpointEnabled then
		return React.createElement(React.Fragment, nil, v9.primarySlotChildren)
	end

	local supportPaneMode = v9.supportPaneMode
	local v11 = if v9.renderSupportContent == nil then React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, v9.supportSlotChildren) else v9.renderSupportContent(v9.supportContentProps, v9.supportSlotChildren)
	local t2 = {
		width = v9.supportWidth,
		minWidth = v9.supportMinWidth,
		maxWidth = v9.supportMaxWidth,
		resizable = if supportPaneMode ~= Enums.SupportPaneMode.Normal or not v9.supportPaneResizable then Enums.PaneResizable.None else Enums.PaneResizable.Horizontal,
		element = v11
	}

	return React.createElement(SplitView, {
		supportPane = t2,
		supportPaneMode = supportPaneMode,
		onSupportPaneWidthChanged = v9.onSupportPaneWidthChanged,
		onContentRegionRectChanged = v9.onContentRegionRectChanged
	}, v9.primarySlotChildren)
end

return SplitPaneNavigationLayout
