local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

local MessageListV2View = require(script.Parent.MessageListV2View)
local useMessageListV2ViewModel = require(script.Parent.useMessageListV2ViewModel)

local function ConversationMessageList(p)
	local v = useMessageListV2ViewModel(p)
	return React.createElement(MessageListV2View, v)
end

local function MessageListV2Container(p)
	local clone = table.clone(p)
	clone.key = p.conversationId
	return React.createElement(ConversationMessageList, clone)
end

return React.memo(MessageListV2Container)
