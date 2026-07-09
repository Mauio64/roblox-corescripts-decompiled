local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

return function() -- line: 8
	-- upvalues: useSelector (copy), AppChatNetworking (copy), RoduxNetworking (copy)
	return useSelector(function(p1) -- line: 9
		-- upvalues: AppChatNetworking (copy), RoduxNetworking (copy)
		return AppChatNetworking.rodux.GetUserConversations.getStatus(p1, 1) == RoduxNetworking.Enum.NetworkStatus.Fetching
	end)
end
