local ParentParent = script:FindFirstAncestor("Components").Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local InlineSpanElement = require(InlineLayoutElements.InlineSpanElement)
local HoverContext = require(InlineLayoutElements.HoverContext)

require(InlineLayoutElements.RenderableInlineElement)

local t1 = {}

function HoverContextWrapper(p1) -- line: 25
	-- upvalues: HoverContext (copy), React (copy), Foundation (copy), useTokens (copy)
	local v10, v11 = HoverContext.useHoverContext(p1.id)
	local v12 = React.useCallback(function(p2) -- line: 27
		-- upvalues: v11 (copy), Foundation (copy)
		v11(p2 == Foundation.Enums.ControlState.Hover)
	end, { v11 })
	local Hover = useTokens().Color.State.Hover

	return React.createElement(Foundation.View, {
		tag = "size-0-0 auto-xy row",
		LayoutOrder = p1.LayoutOrder,
		onActivated = p1.onActivated,
		backgroundStyle = if not v10 then nil else Hover,
		onStateChanged = v12,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		}
	}, p1.children)
end
function t1.new(t2: {[any]: any}, t3: {[any]: any}) -- line: 45
	-- upvalues: InlineSpanElement (copy)
	return InlineSpanElement.new(HoverContextWrapper, t3, t2)
end

return t1
