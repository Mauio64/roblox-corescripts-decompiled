local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local DataHydration = require(parent.DataHydration)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RoactUtils = require(parent.RoactUtils)
local UserLib = require(parent.UserLib)

local SetUserPresences = UserLib.Thunks.SetUserPresences
local dependencyArray = RoactUtils.Hooks.dependencyArray
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local Logger = require(AppChat.Logger)
local v = Logger:new("AppChat.Realtime.ChatExternalEventReceiver2")
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local ChatFriendshipDestroyed = require(AppChat.App.Thunks.ChatFriendshipDestroyed)
local ChatFriendshipCreated = require(AppChat.App.Thunks.ChatFriendshipCreated)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local v2

if FFlagAppChatPresenceStoreMigration then
	v2 = DataHydration.Presence.PresenceStore.get()
else
	v2 = nil
end

local v3 = { localUserId = 0 }

function ChatExternalEventReceiver2(p): nil
	local joined = Cryo.Dictionary.join(v3, p)
	local v4 = useDispatch()

	RealtimeDelivery.useRealtimeNamespace("PresenceBulkNotifications", function(p2)
		local mapped = Cryo.List.map(p2, function(p3)
			return (tostring(p3.UserId))
		end)

		v:info("Received PresenceBulkNotifications, user count: {}.", #mapped)

		if mapped == nil or #mapped == 0 then
			return
		end

		if FFlagAppChatPresenceStoreMigration then
			for _, v5 in mapped do
				v2.RefreshPresenceByUserId(v5)
			end
		else
			v:info("\tfetching user presence with a coroutine..")
			task.spawn(function()
				v4(NetworkingPresence.GetPresencesFromUserIds.API(mapped)):andThen(function(p3)
					v:info("\tfetched user presence, storing response..")
					v4(SetUserPresences(p3.responseBody.userPresences))
				end):catch(function(p3)
					v:warning("NetworkingPresence failure in PresenceBulkNotifications->GetPresencesFromUserIds, Status: " .. tostring(p3))
				end)
			end)
		end
	end, dependencyArray(v4))

	RealtimeDelivery.useRealtimeNamespace("FriendshipNotifications", function(p2)
		local v5

		if tostring(joined.localUserId) == tostring(p2.EventArgs.UserId1) then
			v5 = tostring(p2.EventArgs.UserId2)
		else
			v5 = tostring(p2.EventArgs.UserId1)
		end

		v:info("Received FriendshipNotifications: {}, otherUserId: {}.", p2.Type, v5)

		if p2.Type == "FriendshipDestroyed" then
			v4(ChatFriendshipDestroyed(v5))
		elseif p2.Type == "FriendshipCreated" then
			v4(ChatFriendshipCreated(v5))
		end
	end, dependencyArray(v4, joined.localUserId))

	return nil
end

return ChatExternalEventReceiver2
