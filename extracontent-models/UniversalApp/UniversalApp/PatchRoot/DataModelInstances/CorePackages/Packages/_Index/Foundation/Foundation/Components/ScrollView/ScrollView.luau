local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local ScrollingFrame = require(script.Parent.ScrollingFrame)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useDefaultTags = require(Foundation.Utility.useDefaultTags)
local withDefaults = require(Foundation.Utility.withDefaults)

local useStyleTags = require(Foundation.Providers.Style.useStyleTags)

local Visibility = require(Foundation.Enums.Visibility)

local ControlState = require(Foundation.Enums.ControlState)

local v = {
	layout = { SortOrder = Enum.SortOrder.LayoutOrder },
	scroll = { scrollBarVisibility = Visibility.Auto },
	AutoLocalize = false,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	isDisabled = false,
	testId = "--foundation-scroll-view"
}

local function ScrollView(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = useStyleTags((useDefaultTags(v2.tag, "gui-object-defaults")))

	local state, setState = React.useState(ControlState.Initialize)

	local clone = table.clone(v2)

	function clone.onStateChanged(p2)
		setState(p2)

		if v2.onStateChanged ~= nil then
			v2.onStateChanged(p2)
		end
	end
	clone.stateLayer = not (v2.onStateChanged or v2.onActivated) and { affordance = "None" } or v2.stateLayer
	clone.selection = { Selectable = false }

	clone.ref = ref
	clone[React.Tag] = v3
	clone.scroll = nil
	clone.layout = nil

	local children = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = v2.layout.FillDirection,
			ItemLineAlignment = v2.layout.ItemLineAlignment,
			HorizontalAlignment = v2.layout.HorizontalAlignment,
			HorizontalFlex = v2.layout.HorizontalFlex,
			VerticalAlignment = v2.layout.VerticalAlignment,
			VerticalFlex = v2.layout.VerticalFlex,
			Padding = v2.layout.Padding,
			SortOrder = v2.layout.SortOrder,
			Wraps = v2.layout.Wraps
		})
	}

	if v2.children and typeof(v2.children) == "table" and v2.layout ~= nil and v2.layout.FillDirection ~= nil then
		for k, child in v2.children do
			children[k] = child
		end
	else
		children = v2.children
	end

	return React.createElement(View, clone, {
		ScrollingFrame = React.createElement(ScrollingFrame, {
			controlState = state,
			selection = v2.selection,
			scrollBarVisibility = v2.scroll.scrollBarVisibility,
			onCanvasPositionChanged = v2.onCanvasPositionChanged,
			onAbsoluteCanvasSizeChanged = v2.onAbsoluteCanvasSizeChanged,
			onAbsoluteWindowSizeChanged = v2.onAbsoluteWindowSizeChanged,
			AutomaticSize = v2.scroll.AutomaticSize,
			AutomaticCanvasSize = v2.scroll.AutomaticCanvasSize,
			CanvasSize = v2.scroll.CanvasSize,
			ClipsDescendants = false,
			ScrollingDirection = v2.scroll.ScrollingDirection,
			ScrollingEnabled = v2.scroll.ScrollingEnabled,
			VerticalScrollBarInset = v2.scroll.VerticalScrollBarInset,
			HorizontalScrollBarInset = v2.scroll.HorizontalScrollBarInset,
			ref = v2.scrollingFrameRef
		}, children)
	})
end

return React.memo(React.forwardRef(ScrollView))
