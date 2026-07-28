local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local DataHydration = require(AppChatParent.DataHydration)
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local SetUserPresences = require(AppChatParent.UserLib).Thunks.SetUserPresences
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local v10 = require(AppChat.Logger):new("AppChat.RealtimeExternal")
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local ChatFriendshipDestroyed = require(AppChat.App.Thunks.ChatFriendshipDestroyed)
local ChatFriendshipCreated = require(AppChat.App.Thunks.ChatFriendshipCreated)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local v15 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceStore.get()
local t1 = {
	localUserId = 0
}

function ChatExternalEventReceiver(t2: {[any]: any}) -- line: 37
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), useEffect (copy), FFlagAppChatPresenceStoreMigration (copy), v15 (copy), NetworkingPresence (copy), SetUserPresences (copy), v10 (copy), ChatFriendshipDestroyed (copy), ChatFriendshipCreated (copy)
	local v18 = Cryo.Dictionary.join(t1, t2)
	local v19 = useDispatch()

	useEffect(function() -- line: 42
		-- upvalues: v18 (copy), Cryo (copy), FFlagAppChatPresenceStoreMigration (copy), v15 (copy), v19 (copy), NetworkingPresence (copy), SetUserPresences (copy), v10 (copy)
		local v20 = v18.robloxEventReceiver:observeEvent("PresenceBulkNotifications", function(p1) -- line: 43
			-- upvalues: Cryo (copy), FFlagAppChatPresenceStoreMigration (copy), v15 (copy), v19 (copy), NetworkingPresence (copy), SetUserPresences (copy), v10 (copy)
			local v23 = Cryo.List.map(p1, function(p2) -- line: 44
				return (tostring(p2.UserId))
			end)

			if FFlagAppChatPresenceStoreMigration then
				for _, v25 in v23 do
					v15.RefreshPresenceByUserId(v25)
				end

				return
			end

			v19(NetworkingPresence.GetPresencesFromUserIds.API(v23)):andThen(function(p3) -- line: 53
				-- upvalues: v19 (copy), SetUserPresences (copy)
				v19(SetUserPresences(p3.responseBody.userPresences))
			end):catch(function(p4) -- line: 56
				-- upvalues: v10 (copy)
				v10:warning("NetworkingPresence failure in ChatExternalEventReceiver->PresenceBulkNotifications, Status: " .. tostring(p4))
			end)
		end)

		return function() -- line: 65
			-- upvalues: v20 (copy)
			if v20 and v20.disconnect then
				v20:disconnect()
			end
		end
	end, {
		v19,
		v18.robloxEventReceiver
	})
	useEffect(function() -- line: 73
		-- upvalues: v18 (copy), v19 (copy), ChatFriendshipDestroyed (copy), ChatFriendshipCreated (copy)
		local v21 = v18.robloxEventReceiver:observeEvent("FriendshipNotifications", function(p5) -- line: 74
			-- upvalues: v18 (copy), v19 (copy), ChatFriendshipDestroyed (copy), ChatFriendshipCreated (copy)
			local v27 = tostring(v18.localUserId) == tostring(p5.EventArgs.UserId1) and tostring(p5.EventArgs.UserId2) or tostring(p5.EventArgs.UserId1)

			if p5.Type == "FriendshipDestroyed" then
				v19(ChatFriendshipDestroyed(v27))

				return
			end

			if p5.Type == "FriendshipCreated" then
				v19(ChatFriendshipCreated(v27))
			end
		end)

		return function() -- line: 86
			-- upvalues: v21 (copy)
			if v21 and v21.disconnect then
				v21:disconnect()
			end
		end
	end, {
		v19,
		v18.robloxEventReceiver,
		v18.localUserId
	})

	return nil
end

return ChatExternalEventReceiver
