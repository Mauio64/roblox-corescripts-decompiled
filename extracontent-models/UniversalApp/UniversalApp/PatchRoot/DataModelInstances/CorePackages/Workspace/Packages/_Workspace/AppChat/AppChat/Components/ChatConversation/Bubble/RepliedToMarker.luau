local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local Foundation = require(Parent.Foundation)
local t1 = {
	isIncoming = false
}

function RepliedToMarker(t2: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), React (copy), Foundation (copy), ChatBubbleEnum (copy)
	local v8 = Cryo.Dictionary.union(t1, t2)

	return React.createElement(Foundation.View, {
		tag = "bg-shift-400 self-stretch",
		BorderSizePixel = 0,
		Size = UDim2.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_WIDTH, 0, 0),
		AnchorPoint = if not v8.isIncoming then Vector2.new(1, 0) else Vector2.new(0, 0),
		LayoutOrder = v8.layoutOrder
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end

return React.memo(RepliedToMarker)
