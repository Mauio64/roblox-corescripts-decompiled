local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReplyingToMessageContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/ReplyingToMessageContext")

local function useReplyingToMessage()
	return React.useContext(ReplyingToMessageContext)
end

return useReplyingToMessage
