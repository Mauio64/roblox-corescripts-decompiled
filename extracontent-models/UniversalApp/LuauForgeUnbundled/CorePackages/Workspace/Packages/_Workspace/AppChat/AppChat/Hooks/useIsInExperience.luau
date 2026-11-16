local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

return function()
	return isPlacementInExperience(useChatPlacementContext().chatPlacement)
end
