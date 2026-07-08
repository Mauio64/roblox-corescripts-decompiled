local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local t1 = {
	isIncoming = false,
	imageTransparency = 0,
	imageColor = Color3.new(0, 0, 0)
}

function ChatBubbleTail(t2: {[any]: any}) -- line: 38
	-- upvalues: Cryo (copy), t1 (copy), ChatBubbleEnum (copy), React (copy)
	local v7 = Cryo.Dictionary.union(t1, t2)
	local v8 = if not v7.isIncoming then ChatBubbleEnum.SENT_TAIL else ChatBubbleEnum.RECEIVED_TAIL
	local v9 = if not v7.isIncoming then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 0, 0)

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = if not v7.isIncoming then Vector2.new(1, 0) else Vector2.new(0, 0),
		Size = UDim2.new(0, ChatBubbleEnum.TAIL_WIDTH, 0, ChatBubbleEnum.TAIL_WIDTH),
		ImageColor3 = v7.imageColor,
		Position = v9,
		Image = v8,
		ImageTransparency = v7.imageTransparency
	})
end

return React.memo(ChatBubbleTail)
