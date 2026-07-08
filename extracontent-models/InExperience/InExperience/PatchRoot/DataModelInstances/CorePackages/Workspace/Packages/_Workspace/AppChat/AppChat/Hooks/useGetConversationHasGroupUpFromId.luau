local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(s1: string) -- line: 7
	-- upvalues: useSelector (copy), getDeepValue (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: getDeepValue (copy), s1 (copy)
		return getDeepValue(p1, `ChatAppReducer.Conversations.{ s1 }.hasGroupUp`)
	end)
end
