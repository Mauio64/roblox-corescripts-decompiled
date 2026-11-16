local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local AppChatNetworking = require(parent.AppChatNetworking)

return function()
	return useSelector(function(p): boolean
		return AppChatNetworking.rodux.GetUserConversations.getStatus(p, 1) == RoduxNetworking.Enum.NetworkStatus.Fetching
	end)
end
