local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function() -- line: 7
	-- upvalues: useSelector (copy), getDeepValue (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p1, "ChatAppReducer.ChatSettings.chatEnabled") or false
	end)
end
