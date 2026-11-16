local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local Foundation = require(parent.Foundation)

local v = { isIncoming = false }

function RepliedToMarker(p)
	local union = Cryo.Dictionary.union(v, p)

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "bg-shift-400 self-stretch",
		Size = UDim2.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_WIDTH, 0, 0),
		BorderSizePixel = 0,
		AnchorPoint = 0,
		LayoutOrder = 0
	}
	local anchorPoint

	if union.isIncoming then
		anchorPoint = Vector2.new(0, 0)
	else
		anchorPoint = Vector2.new(1, 0)
	end

	v2.AnchorPoint = anchorPoint
	v2.LayoutOrder = union.layoutOrder
	return createElement(view, v2, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end

return React.memo(RepliedToMarker)
