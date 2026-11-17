local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local ChatHeaderView = require(script.Parent.ChatHeaderView)
local useChatHeaderViewModel = require(script.Parent.useChatHeaderViewModel)

local function ChatHeaderContainer(p)
	local v = useChatHeaderViewModel(p)
	return React.createElement(ChatHeaderView, v)
end

return ChatHeaderContainer
