local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

return function(p2): nil | number
	if isPlacementInExperience(useChatPlacementContext().chatPlacement) then
		return 0
	end

	return nil
end
