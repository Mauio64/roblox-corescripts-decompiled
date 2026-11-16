local parent = script:FindFirstAncestor("Components").Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local InlineSpanElement = require(InlineLayoutElements.InlineSpanElement)
local HoverContext = require(InlineLayoutElements.HoverContext)
require(InlineLayoutElements.RenderableInlineElement)

local LinkElement = {}

function HoverContextWrapper(props)
	local v, v2 = HoverContext.useHoverContext(props.id)
	local onStateChanged = React.useCallback(function(p)
		v2(p == Foundation.Enums.ControlState.Hover)
	end, { v2 })
	local hover = useTokens().Color.State.Hover

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		tag = "size-0-0 auto-xy row",
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		backgroundStyle = 0,
		onStateChanged = 0,
		stateLayer = 0
	}

	if not v then
		hover = nil
	end

	v3.backgroundStyle = hover
	v3.onStateChanged = onStateChanged
	v3.stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	return createElement(view, v3, props.children)
end

function LinkElement.new(p, p2)
	return InlineSpanElement.new(HoverContextWrapper, p2, p)
end

return LinkElement
