local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local MessageListV2View = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageListV2View")
local useMessageListV2ViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/useMessageListV2ViewModel")

local function ConversationMessageList(p2)
	local v5 = useMessageListV2ViewModel(p2)
	return React.createElement(MessageListV2View, v5)
end

local function MessageListV2Container(p2)
	local clone = table.clone(p2)
	clone.key = p2.conversationId
	return React.createElement(ConversationMessageList, clone)
end

return React.memo(MessageListV2Container)
