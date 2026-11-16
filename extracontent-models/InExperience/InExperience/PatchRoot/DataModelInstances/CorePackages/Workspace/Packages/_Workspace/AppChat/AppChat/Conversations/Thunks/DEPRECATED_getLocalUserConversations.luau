local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local NetworkingChat = require(AppChat.Http.NetworkingChat)
local Promise = require(parent.Promise)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)

local processConversations = require(script.Parent.processConversations)

return function(p, p2)
	return function(object)
		if NetworkingChat.GetUserConversations.getStatus(object:getState(), p) == RoduxNetworking.Enum.NetworkStatus.Fetching then
			return Promise.resolve()
		end

		return object:dispatch(NetworkingChat.GetUserConversations.API(p, p2)):andThen(function(p3)
			object:dispatch(processConversations(p3.responseBody))
		end):catch(function(p3)
			warn("NetworkingChat failure in DEPRECATED_getLocalUserConversations, Status: " .. tostring(p3))
		end)
	end
end
