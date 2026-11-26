return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("ReceivedMessages", function(p2, p3, p4, p5)
	return {
		conversationId = p2,
		messages = p3,
		shouldMarkConversationUnread = p4,
		exclusiveStartMessageId = p5
	}
end)
