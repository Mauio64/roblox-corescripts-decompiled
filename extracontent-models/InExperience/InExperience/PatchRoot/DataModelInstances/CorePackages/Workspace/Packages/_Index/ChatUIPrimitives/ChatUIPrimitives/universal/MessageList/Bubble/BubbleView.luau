local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(script.Parent.Types)
local Sizing = require(script.Parent.Parent.Parent.Sizing)

local indexBindable = Foundation.Utility.indexBindable

local function BubbleView(props, ref)
	local bubble = Sizing.useSizing().bubble
	local paddingX = bubble.paddingX
	local paddingY = bubble.paddingY
	local minHeight = bubble.minHeight
	local contentMaxWidth = bubble.contentMaxWidth
	local cornerRadii = props.cornerRadii

	local cornerRadius = React.useMemo(function()
		return {
			topLeft = indexBindable(cornerRadii, "topLeft"),
			topRight = indexBindable(cornerRadii, "topRight"),
			bottomLeft = indexBindable(cornerRadii, "bottomLeft"),
			bottomRight = indexBindable(cornerRadii, "bottomRight")
		}
	end, { cornerRadii })

	local padding = React.useMemo(function()
		return {
			top = UDim.new(0, paddingY),
			bottom = UDim.new(0, paddingY),
			left = UDim.new(0, paddingX),
			right = UDim.new(0, paddingX)
		}
	end, { paddingX, paddingY })

	local sizeConstraint = React.useMemo(function()
		return {
			MinSize = Vector2.new(0, (math.max(0, minHeight - paddingY * 2))),
			MaxSize = Vector2.new(contentMaxWidth, 1e999)
		}
	end, { minHeight, paddingY, contentMaxWidth })

	return React.createElement(Foundation.View, {
		tag = "col align-y-center auto-xy",
		backgroundStyle = props.backgroundStyle,
		cornerRadius = cornerRadius,
		padding = padding,
		sizeConstraint = sizeConstraint,
		LayoutOrder = props.LayoutOrder,
		Visible = props.Visible,
		testId = props.testId,
		ref = ref
	}, props.children)
end

return React.forwardRef(BubbleView)
