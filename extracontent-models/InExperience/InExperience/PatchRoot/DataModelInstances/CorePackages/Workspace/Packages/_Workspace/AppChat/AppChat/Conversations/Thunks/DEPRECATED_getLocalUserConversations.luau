local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local Promise = require(AppChatParent.Promise)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local processConversations = require(script.Parent.processConversations)

return function(p1, p2) -- line: 10
	-- upvalues: NetworkingChat (copy), RoduxNetworking (copy), Promise (copy), processConversations (copy)
	return function(p3) -- line: 11
		-- upvalues: NetworkingChat (copy), p1 (copy), RoduxNetworking (copy), Promise (copy), p2 (copy), processConversations (copy)
		if NetworkingChat.GetUserConversations.getStatus(p3:getState(), p1) == RoduxNetworking.Enum.NetworkStatus.Fetching then
			return Promise.resolve()
		end

		return p3:dispatch(NetworkingChat.GetUserConversations.API(p1, p2)):andThen(function(p4) -- line: 20
			-- upvalues: p3 (copy), processConversations (copy)
			local responseBody = p4.responseBody

			p3:dispatch(processConversations(responseBody))
		end):catch(function(p5) -- line: 25
			warn("NetworkingChat failure in DEPRECATED_getLocalUserConversations, Status: " .. tostring(p5))
		end)
	end
end
