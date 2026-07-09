local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local SetUserPresences = require(AppChatParent.UserLib).Thunks.SetUserPresences
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local v9 = require(AppChat.Logger):new("AppChat.RealtimeExternal")
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local ChatFriendshipDestroyed = require(AppChat.App.Thunks.ChatFriendshipDestroyed)
local ChatFriendshipCreated = require(AppChat.App.Thunks.ChatFriendshipCreated)
local t1 = {
	localUserId = 0
}

function ChatExternalEventReceiver(t2: {[any]: any}) -- line: 31
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), useEffect (copy), NetworkingPresence (copy), SetUserPresences (copy), v9 (copy), ChatFriendshipDestroyed (copy), ChatFriendshipCreated (copy)
	local v15 = Cryo.Dictionary.join(t1, t2)
	local v16 = useDispatch()

	useEffect(function() -- line: 36
		-- upvalues: v15 (copy), Cryo (copy), v16 (copy), NetworkingPresence (copy), SetUserPresences (copy), v9 (copy)
		local v17 = v15.robloxEventReceiver:observeEvent("PresenceBulkNotifications", function(p1) -- line: 37
			-- upvalues: Cryo (copy), v16 (copy), NetworkingPresence (copy), SetUserPresences (copy), v9 (copy)
			local v20 = Cryo.List.map(p1, function(p2) -- line: 38
				return (tostring(p2.UserId))
			end)

			v16(NetworkingPresence.GetPresencesFromUserIds.API(v20)):andThen(function(p3) -- line: 43
				-- upvalues: v16 (copy), SetUserPresences (copy)
				v16(SetUserPresences(p3.responseBody.userPresences))
			end):catch(function(p4) -- line: 46
				-- upvalues: v9 (copy)
				v9:warning("NetworkingPresence failure in ChatExternalEventReceiver->PresenceBulkNotifications, Status: " .. tostring(p4))
			end)
		end)

		return function() -- line: 54
			-- upvalues: v17 (copy)
			if v17 and v17.disconnect then
				v17:disconnect()
			end
		end
	end, {
		v16,
		v15.robloxEventReceiver
	})
	useEffect(function() -- line: 62
		-- upvalues: v15 (copy), v16 (copy), ChatFriendshipDestroyed (copy), ChatFriendshipCreated (copy)
		local v18 = v15.robloxEventReceiver:observeEvent("FriendshipNotifications", function(p5) -- line: 63
			-- upvalues: v15 (copy), v16 (copy), ChatFriendshipDestroyed (copy), ChatFriendshipCreated (copy)
			local v22 = tostring(v15.localUserId) == tostring(p5.EventArgs.UserId1) and tostring(p5.EventArgs.UserId2) or tostring(p5.EventArgs.UserId1)

			if p5.Type == "FriendshipDestroyed" then
				v16(ChatFriendshipDestroyed(v22))

				return
			end

			if p5.Type == "FriendshipCreated" then
				v16(ChatFriendshipCreated(v22))
			end
		end)

		return function() -- line: 75
			-- upvalues: v18 (copy)
			if v18 and v18.disconnect then
				v18:disconnect()
			end
		end
	end, {
		v16,
		v15.robloxEventReceiver,
		v15.localUserId
	})

	return nil
end

return ChatExternalEventReceiver
