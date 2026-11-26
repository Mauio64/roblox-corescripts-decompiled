local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")

return function()
	return useSelector(function(p2)
		return getDeepValue(p2, "ChatAppReducer.ConversationsAsync.oldestConversationIsFetched")
	end)
end
