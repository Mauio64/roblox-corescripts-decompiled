local UserInputService = game:GetService("UserInputService")
local AppChat = script:FindFirstAncestor("AppChat")
local MessageFtuxTooltipVariant = require(script.Parent.MessageFtuxTooltipVariant)
local FFlagAppChatUseSwipeForReplies = require(AppChat.Flags.FFlagAppChatUseSwipeForReplies)

local function useRepliesTooltipConfig() -- line: 18
	-- upvalues: UserInputService (copy), FFlagAppChatUseSwipeForReplies (copy)
	return {
		storageKey = "AppChatEnableRepliesUIFtuxTooltip",
		textKey = (not UserInputService.TouchEnabled or UserInputService.MouseEnabled) and "Feature.Chat.Label.HoverToReplyTooltip" or (not FFlagAppChatUseSwipeForReplies and "Feature.Chat.Label.LongPressToReplyTooltip" or "Feature.Chat.Label.SwipeToReplyTooltip")
	}
end

local t1 = {
	[MessageFtuxTooltipVariant.Replies] = useRepliesTooltipConfig
}

return function(p1) -- line: 31
	-- upvalues: t1 (copy)
	return t1[p1]()
end
