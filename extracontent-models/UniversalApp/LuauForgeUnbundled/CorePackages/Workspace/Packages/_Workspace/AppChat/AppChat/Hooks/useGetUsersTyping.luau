local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local selectUsersTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Conversations/Selectors/selectUsersTyping")

return function(p2)
	return useSelector(function(p3)
		return selectUsersTyping(p3, p2)
	end)
end
