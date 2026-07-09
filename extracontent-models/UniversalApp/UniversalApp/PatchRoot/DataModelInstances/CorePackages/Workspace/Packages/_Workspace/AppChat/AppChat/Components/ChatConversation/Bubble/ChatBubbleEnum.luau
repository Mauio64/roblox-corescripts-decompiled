local rect = Rect.new(10, 10, 11, 11)
local t1 = {
	BUBBLE_TOP = "chat_bubble/chat-bubble-self-top",
	BUBBLE_MIDDLE = "chat_bubble/chat-bubble-self-middle",
	BUBBLE_BOTTOM = "chat_bubble/chat-bubble-self-bottom"
}
local t2 = {
	BUBBLE_TOP = "chat_bubble/chat-bubble-top",
	BUBBLE_MIDDLE = "chat_bubble/chat-bubble-middle",
	BUBBLE_BOTTOM = "chat_bubble/chat-bubble-bottom"
}
local rect2 = Rect.new(20, 20, 21, 21)
local t3 = {
	SINGLE = "single",
	TOP = "top",
	MIDDLE = "middle",
	BOTTOM = "bottom"
}

return {
	BUBBLE = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self2.png",
	RECEIVED_BUBBLE_WITH_TAIL = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble.png",
	SENT_BUBBLE_WITH_TAIL = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self.png",
	TAIL_WIDTH = 6,
	SENT_TAIL = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self-tip.png",
	RECEIVED_TAIL = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-tip.png",
	REPLIED_TO_MARKER_WIDTH = 4,
	REPLIED_TO_MARKER_GAP = 10,
	GROUPED_BUBBLE_SINGLE = "chat_bubble/chat-bubble-single",
	SLIDE_CENTER = rect,
	GROUPED_OUTGOING_BUBBLES = t1,
	GROUPED_RECEIVED_BUBBLES = t2,
	GROUPED_BUBBLE_SLICE_CENTER = rect2,
	BUBBLE_VARIANTS = t3
}
