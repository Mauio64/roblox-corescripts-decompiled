local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(
	script.Name,
	function(conversationId, messages, shouldMarkConversationUnread, exclusiveStartMessageId)
		return {
			conversationId = conversationId,
			messages = messages,
			shouldMarkConversationUnread = shouldMarkConversationUnread,
			exclusiveStartMessageId = exclusiveStartMessageId
		}
	end
)
