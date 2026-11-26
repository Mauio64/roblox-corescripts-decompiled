local NetworkingChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingChat")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")

local processConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/processConversations")

return function(p2, p3)
	return function(object)
		if NetworkingChat.GetUserConversations.getStatus(object:getState(), p2) == RoduxNetworking.Enum.NetworkStatus.Fetching then
			return Promise.resolve()
		end

		return object:dispatch(NetworkingChat.GetUserConversations.API(p2, p3)):andThen(function(p4)
			object:dispatch(processConversations(p4.responseBody))
		end):catch(function(p4)
			warn("NetworkingChat failure in DEPRECATED_getLocalUserConversations, Status: " .. tostring(p4))
		end)
	end
end
