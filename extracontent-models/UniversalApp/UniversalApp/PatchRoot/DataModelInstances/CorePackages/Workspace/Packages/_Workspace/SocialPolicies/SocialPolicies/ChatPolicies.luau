local function ChatPolicies(p1) -- line: 1
	return {
		getChatConversationHeaderGroupDetails = function() -- line: 3
			-- upvalues: p1 (copy)
			return p1.ChatConversationHeaderGroupDetails or false
		end,
		getChatHeaderSearch = function() -- line: 6
			-- upvalues: p1 (copy)
			return p1.ChatHeaderSearch or false
		end,
		getChatHeaderCreateChatGroup = function() -- line: 9
			-- upvalues: p1 (copy)
			return p1.ChatHeaderCreateChatGroup or false
		end,
		getChatHeaderHomeButton = function() -- line: 12
			-- upvalues: p1 (copy)
			return p1.ChatHeaderHomeButton or false
		end,
		getChatHeaderNotifications = function() -- line: 15
			-- upvalues: p1 (copy)
			return p1.ChatHeaderNotifications or false
		end,
		getChatPlayTogether = function() -- line: 18
			-- upvalues: p1 (copy)
			return p1.ChatPlayTogether or false
		end,
		getChatShareGameToChatFromChat = function() -- line: 21
			-- upvalues: p1 (copy)
			return p1.ChatShareGameToChatFromChat or false
		end,
		getChatTapConversationThumbnail = function() -- line: 24
			-- upvalues: p1 (copy)
			return p1.ChatTapConversationThumbnail or false
		end,
		getChatReportingDisabled = function() -- line: 27
			-- upvalues: p1 (copy)
			return p1.ChatReportingDisabled or false
		end,
		getChatViewProfileOption = function() -- line: 30
			-- upvalues: p1 (copy)
			return p1.ChatViewProfileOption or false
		end,
		getContactImporterEnabled = function() -- line: 33
			-- upvalues: p1 (copy)
			return p1.ContactImporterEnabled or false
		end
	}
end

return ChatPolicies
