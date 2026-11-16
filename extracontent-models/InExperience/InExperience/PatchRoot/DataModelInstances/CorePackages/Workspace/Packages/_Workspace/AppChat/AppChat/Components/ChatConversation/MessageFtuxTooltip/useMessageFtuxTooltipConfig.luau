local UserInputService = game:GetService("UserInputService")

local MessageFtuxTooltipVariant = require(script.Parent.MessageFtuxTooltipVariant)

local function useRepliesTooltipConfig()
	return {
		textKey = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and "Feature.Chat.Label.SwipeToReplyTooltip" or "Feature.Chat.Label.HoverToReplyTooltip",
		storageKey = "AppChatEnableRepliesUIFtuxTooltip"
	}
end

local useRepliesTooltipConfigsByReplies = {
	[MessageFtuxTooltipVariant.Replies] = useRepliesTooltipConfig
}

return function(p)
	return useRepliesTooltipConfigsByReplies[p]()
end
