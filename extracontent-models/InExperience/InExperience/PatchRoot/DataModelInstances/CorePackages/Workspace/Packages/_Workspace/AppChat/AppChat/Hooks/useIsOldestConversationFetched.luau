local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function()
	return useSelector(function(p)
		return getDeepValue(p, "ChatAppReducer.ConversationsAsync.oldestConversationIsFetched")
	end)
end
