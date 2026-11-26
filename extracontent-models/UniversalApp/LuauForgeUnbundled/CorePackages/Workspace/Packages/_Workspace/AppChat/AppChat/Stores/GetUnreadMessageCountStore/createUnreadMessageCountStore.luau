require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createSessionScopedSignal

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local function createUnreadMessageCountStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(0)

	return {
		getUnreadMessageCount = sessionScopedSignal,
		receivedConversationMetadata = function(p2)
			if p2 and p2.global_unread_message_count then
				v5(p2.global_unread_message_count)
			end
		end,
		reset = function()
			v5(0)
		end
	}
end

return createUnreadMessageCountStore
