local AppChat = script:FindFirstAncestor("AppChat")
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

return function(_: {[any]: any}) -- line: 12
	-- upvalues: useChatPlacementContext (copy), isPlacementInExperience (copy)
	local chatPlacement = useChatPlacementContext().chatPlacement

	if not isPlacementInExperience(chatPlacement) then
		return nil
	end

	return 0
end
