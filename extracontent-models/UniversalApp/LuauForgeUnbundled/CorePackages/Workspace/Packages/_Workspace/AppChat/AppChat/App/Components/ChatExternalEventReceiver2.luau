local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local setUserPresences = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Thunks.SetUserPresences
local dependencyArray = RoactUtils.Hooks.dependencyArray
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChat.Realtime.ChatExternalEventReceiver2")
local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingPresence")
local ChatFriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Thunks/ChatFriendshipDestroyed")
local ChatFriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Thunks/ChatFriendshipCreated")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local v6 = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil

local v7 = { localUserId = 0 }

function LUAUFORGE_MODULE_GLOBALS_ikh_ChatExternalEventReceiver2(p2): nil
	local joined = Cryo.Dictionary.join(v7, p2)
	local v8 = useDispatch()

	RealtimeDelivery.useRealtimeNamespace("PresenceBulkNotifications", function(p3)
		local mapped = Cryo.List.map(p3, function(p4)
			return (tostring(p4.UserId))
		end)

		v5:info("Received PresenceBulkNotifications, user count: {}.", #mapped)

		if mapped == nil or #mapped == 0 then
			return
		end

		if FFlagAppChatPresenceStoreMigration then
			for k, v9 in mapped do
				v6.RefreshPresenceByUserId(v9)
			end
		else
			v5:info("\tfetching user presence with a coroutine..")
			task.spawn(function()
				v8(NetworkingPresence.GetPresencesFromUserIds.API(mapped)):andThen(function(p4)
					v5:info("\tfetched user presence, storing response..")
					v8(setUserPresences(p4.responseBody.userPresences))
				end):catch(function(p4)
					v5:warning("NetworkingPresence failure in PresenceBulkNotifications->GetPresencesFromUserIds, Status: " .. tostring(p4))
				end)
			end)
		end
	end, dependencyArray(v8))

	RealtimeDelivery.useRealtimeNamespace("FriendshipNotifications", function(p3)
		local v9

		if tostring(joined.localUserId) == tostring(p3.EventArgs.UserId1) then
			v9 = tostring(p3.EventArgs.UserId2)
		else
			v9 = tostring(p3.EventArgs.UserId1)
		end

		v5:info("Received FriendshipNotifications: {}, otherUserId: {}.", p3.Type, v9)

		if p3.Type == "FriendshipDestroyed" then
			v8(ChatFriendshipDestroyed(v9))
		elseif p3.Type == "FriendshipCreated" then
			v8(ChatFriendshipCreated(v9))
		end
	end, dependencyArray(v8, joined.localUserId))

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_ikh_ChatExternalEventReceiver2
