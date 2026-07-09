local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)

return function() -- line: 7
	-- upvalues: useSelector (copy), getDeepValue2 (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: getDeepValue2 (copy)
		local v6 = getDeepValue2(p1, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")

		if v6 == nil then
			return true
		end

		return v6
	end)
end
