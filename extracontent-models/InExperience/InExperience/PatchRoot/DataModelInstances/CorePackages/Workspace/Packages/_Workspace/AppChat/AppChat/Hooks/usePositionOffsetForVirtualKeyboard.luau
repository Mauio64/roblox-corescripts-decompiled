local AppChat = script:FindFirstAncestor("AppChat")
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

return function(_): nil | number
	if isPlacementInExperience(useChatPlacementContext().chatPlacement) then
		return 0
	end

	return nil
end
