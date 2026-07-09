local AppChat = script:FindFirstAncestor("AppChat")
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

return function() -- line: 7
	-- upvalues: useChatPlacementContext (copy), isPlacementInExperience (copy)
	local chatPlacement = useChatPlacementContext().chatPlacement

	return isPlacementInExperience(chatPlacement)
end
