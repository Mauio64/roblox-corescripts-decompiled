local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ScrollingFrame = require(script.Parent.ScrollingFrame)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useDefaultTags = require(Foundation.Utility.useDefaultTags)
local withDefaults = require(Foundation.Utility.withDefaults)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local Visibility = require(Foundation.Enums.Visibility)
local ControlState = require(Foundation.Enums.ControlState)
local t1 = {
	AutoLocalize = false,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	isDisabled = false,
	testId = "--foundation-scroll-view",
	layout = {
		SortOrder = Enum.SortOrder.LayoutOrder
	},
	scroll = {
		scrollBarVisibility = Visibility.Auto
	}
}

local function ScrollView(p1, p2) -- line: 62
	-- upvalues: withDefaults (copy), t1 (copy), useDefaultTags (copy), useStyleTags (copy), React (copy), ControlState (copy), View (copy), ScrollingFrame (copy)
	local v15 = withDefaults(p1, t1)
	local v16 = useDefaultTags(v15.tag, "gui-object-defaults")
	local v17 = useStyleTags(v16)
	local v18, v19 = React.useState(ControlState.Initialize)
	local v20 = table.clone(v15)

	function v20.onStateChanged(p3) -- line: 74
		-- upvalues: v19 (copy), v15 (copy)
		v19(p3)

		if v15.onStateChanged ~= nil then
			v15.onStateChanged(p3)
		end
	end

	v20.stateLayer = if not v15.onStateChanged and not v15.onActivated then {
		affordance = "None"
	} else v15.stateLayer
	v20.selection = {
		Selectable = false
	}
	v20.ref = p2
	v20[React.Tag] = v17
	v20.scroll = nil
	v20.layout = nil

	local t2 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = v15.layout.FillDirection,
			ItemLineAlignment = v15.layout.ItemLineAlignment,
			HorizontalAlignment = v15.layout.HorizontalAlignment,
			HorizontalFlex = v15.layout.HorizontalFlex,
			VerticalAlignment = v15.layout.VerticalAlignment,
			VerticalFlex = v15.layout.VerticalFlex,
			Padding = v15.layout.Padding,
			SortOrder = v15.layout.SortOrder,
			Wraps = v15.layout.Wraps
		})
	}

	if v15.children and (typeof(v15.children) == "table" and v15.layout ~= nil and v15.layout.FillDirection ~= nil) then
		for v22, v23 in v15.children do
			t2[v22] = v23
		end
	else
		t2 = v15.children
	end

	return React.createElement(View, v20, {
		ScrollingFrame = React.createElement(ScrollingFrame, {
			ClipsDescendants = false,
			controlState = v18,
			selection = v15.selection,
			scrollBarVisibility = v15.scroll.scrollBarVisibility,
			onCanvasPositionChanged = v15.onCanvasPositionChanged,
			onAbsoluteCanvasSizeChanged = v15.onAbsoluteCanvasSizeChanged,
			onAbsoluteWindowSizeChanged = v15.onAbsoluteWindowSizeChanged,
			AutomaticSize = v15.scroll.AutomaticSize,
			AutomaticCanvasSize = v15.scroll.AutomaticCanvasSize,
			CanvasSize = v15.scroll.CanvasSize,
			ScrollingDirection = v15.scroll.ScrollingDirection,
			ScrollingEnabled = v15.scroll.ScrollingEnabled,
			VerticalScrollBarInset = v15.scroll.VerticalScrollBarInset,
			HorizontalScrollBarInset = v15.scroll.HorizontalScrollBarInset,
			ref = v15.scrollingFrameRef
		}, t2)
	})
end

return React.memo(React.forwardRef(ScrollView))
