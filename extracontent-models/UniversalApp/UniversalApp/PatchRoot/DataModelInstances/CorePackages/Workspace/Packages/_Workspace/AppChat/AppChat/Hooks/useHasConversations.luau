local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue = require(AppChat.Utils.getDeepValue)
local Cryo = require(AppChatParent.Cryo)

return function() -- line: 8
	-- upvalues: useSelector (copy), Cryo (copy), getDeepValue (copy)
	return useSelector(function(p1) -- line: 9
		-- upvalues: Cryo (copy), getDeepValue (copy)
		return not Cryo.isEmpty(getDeepValue(p1, "ChatAppReducer.Conversations") or {})
	end)
end
