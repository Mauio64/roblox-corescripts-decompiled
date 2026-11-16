local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local selectConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Conversations/Selectors/selectConversations")

return function()
	return useSelector(function(p2)
		return selectConversations(p2)
	end)
end
