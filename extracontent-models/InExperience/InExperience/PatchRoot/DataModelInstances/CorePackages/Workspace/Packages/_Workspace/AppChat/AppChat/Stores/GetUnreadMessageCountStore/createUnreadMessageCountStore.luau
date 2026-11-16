local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

require(parent.AppChatNetworking)

local function createUnreadMessageCountStore()
	local sessionScopedSignal, v = createSessionScopedSignal(0)

	return {
		getUnreadMessageCount = sessionScopedSignal,
		receivedConversationMetadata = function(p)
			if p and p.global_unread_message_count then
				v(p.global_unread_message_count)
			end
		end,
		reset = function()
			v(0)
		end
	}
end

return createUnreadMessageCountStore
