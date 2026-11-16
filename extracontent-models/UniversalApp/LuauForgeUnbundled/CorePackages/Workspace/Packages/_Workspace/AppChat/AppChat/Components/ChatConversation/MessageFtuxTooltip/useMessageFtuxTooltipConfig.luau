local UserInputService = game:GetService("UserInputService")

local function useRepliesTooltipConfig()
	return {
		textKey = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and "Feature.Chat.Label.SwipeToReplyTooltip" or "Feature.Chat.Label.HoverToReplyTooltip",
		storageKey = "AppChatEnableRepliesUIFtuxTooltip"
	}
end

local useRepliesTooltipConfigsByReplies = {
	[require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/MessageFtuxTooltipVariant").Replies] = useRepliesTooltipConfig
}

return function(p2)
	return useRepliesTooltipConfigsByReplies[p2]()
end
