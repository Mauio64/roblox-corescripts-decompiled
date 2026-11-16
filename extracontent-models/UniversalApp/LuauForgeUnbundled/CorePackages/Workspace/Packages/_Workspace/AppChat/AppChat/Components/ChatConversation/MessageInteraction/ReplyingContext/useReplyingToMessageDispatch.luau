local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReplyingToMessageDispatchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/ReplyingToMessageDispatchContext")

local function useReplyingToMessageDispatch()
	return React.useContext(ReplyingToMessageDispatchContext)
end

return useReplyingToMessageDispatch
