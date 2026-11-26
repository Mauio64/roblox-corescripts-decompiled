local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

return function()
	return useSelector(function(p2): boolean
		return AppChatNetworking.rodux.GetUserConversations.getStatus(p2, 1) == RoduxNetworking.Enum.NetworkStatus.Fetching
	end)
end
