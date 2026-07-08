local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local getDeepValue = require(AppChat.Utils.getDeepValue)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector

require(AppChatParent.AppChatNetworking)

return function(s1: string?) -- line: 9
	-- upvalues: useSelector (copy), getDeepValue (copy)
	return useSelector(function(p1) -- line: 13
		-- upvalues: s1 (copy), getDeepValue (copy)
		if not s1 then
			return nil
		end

		return (getDeepValue(p1, "ChatAppReducer.Modals.conversationTopModals") or {})[s1]
	end)
end
