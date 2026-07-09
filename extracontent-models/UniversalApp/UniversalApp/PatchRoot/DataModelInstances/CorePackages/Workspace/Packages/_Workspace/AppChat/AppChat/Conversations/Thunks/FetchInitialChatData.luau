local AppChat = script:FindFirstAncestor("AppChat")
local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)
local FetchChatSettings = require(AppChat.Conversations.Thunks.FetchChatSettings)
local NetworkingUsers = require(AppChat.Http.NetworkingUsers)

return function(p1) -- line: 11
	-- upvalues: NetworkingUsers (copy), FetchChatSettings (copy), SetAppLoaded (copy)
	p1:dispatch(function(p2) -- line: 12
		-- upvalues: NetworkingUsers (copy)
		return p2:dispatch(NetworkingUsers.GetUserV2FromUserId.API(p2:getState().LocalUserId))
	end)

	return p1:dispatch(FetchChatSettings.API()):andThen(function() -- line: 18
		-- upvalues: p1 (copy), SetAppLoaded (copy)
		p1:dispatch(SetAppLoaded(true))
	end):catch(function(p3) -- line: 21
		warn("AppChat.Conversations.Thunks.FetchInitialChatData with error: ", (tostring(p3)))
	end)
end
