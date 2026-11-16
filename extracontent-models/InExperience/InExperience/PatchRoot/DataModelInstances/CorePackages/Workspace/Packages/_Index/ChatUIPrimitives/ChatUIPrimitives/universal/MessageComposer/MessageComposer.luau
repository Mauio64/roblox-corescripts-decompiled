local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)

local ChatInputBarView = require(ChatUIPrimitives.Components.ChatInputBar.ChatInputBarView)
local useMessageComposerViewModel = require(script.Parent.useMessageComposerViewModel)

local function MessageComposer(p)
	local v = useMessageComposerViewModel(p)
	return React.createElement(ChatInputBarView, v)
end

return MessageComposer
