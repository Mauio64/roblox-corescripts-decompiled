local AppChat = script:FindFirstAncestor("AppChat")
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

return function()
	return isPlacementInExperience(useChatPlacementContext().chatPlacement)
end
