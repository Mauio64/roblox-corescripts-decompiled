local function ChatPolicies(data)
	return {
		getChatConversationHeaderGroupDetails = function()
			return data.ChatConversationHeaderGroupDetails or false
		end,
		getChatHeaderSearch = function()
			return data.ChatHeaderSearch or false
		end,
		getChatHeaderCreateChatGroup = function()
			return data.ChatHeaderCreateChatGroup or false
		end,
		getChatHeaderHomeButton = function()
			return data.ChatHeaderHomeButton or false
		end,
		getChatHeaderNotifications = function()
			return data.ChatHeaderNotifications or false
		end,
		getChatPlayTogether = function()
			return data.ChatPlayTogether or false
		end,
		getChatShareGameToChatFromChat = function()
			return data.ChatShareGameToChatFromChat or false
		end,
		getChatTapConversationThumbnail = function()
			return data.ChatTapConversationThumbnail or false
		end,
		getChatReportingDisabled = function()
			return data.ChatReportingDisabled or false
		end,
		getChatViewProfileOption = function()
			return data.ChatViewProfileOption or false
		end,
		getContactImporterEnabled = function()
			return data.ContactImporterEnabled or false
		end
	}
end

return ChatPolicies
