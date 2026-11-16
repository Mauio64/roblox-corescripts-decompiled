if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMigrateChatExternalEventReceiver") then
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Components/ChatExternalEventReceiver2")
end

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local setUserPresences = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Thunks.SetUserPresences
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChat.RealtimeExternal")
local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingPresence")
local ChatFriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Thunks/ChatFriendshipDestroyed")
local ChatFriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Thunks/ChatFriendshipCreated")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local v6 = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil

local v7 = { localUserId = 0 }

function LUAUFORGE_MODULE_GLOBALS_ikf_ChatExternalEventReceiver(p2): nil
	local joined = Cryo.Dictionary.join(v7, p2)
	local v8 = useDispatch()

	useEffect(function()
		local v9 = joined.robloxEventReceiver:observeEvent("PresenceBulkNotifications", function(p3)
			local mapped = Cryo.List.map(p3, function(p4)
				return (tostring(p4.UserId))
			end)

			if not FFlagAppChatPresenceStoreMigration then
				v8(NetworkingPresence.GetPresencesFromUserIds.API(mapped)):andThen(function(p4)
					v8(setUserPresences(p4.responseBody.userPresences))
				end):catch(function(p4)
					v5:warning("NetworkingPresence failure in ChatExternalEventReceiver->PresenceBulkNotifications, Status: " .. tostring(p4))
				end)

				return
			end

			for k, v10 in mapped do
				v6.RefreshPresenceByUserId(v10)
			end
		end)

		return function()
			if v9 and v9.disconnect then
				v9:disconnect()
			end
		end
	end, { v8, joined.robloxEventReceiver })

	useEffect(function()
		local v9 = joined.robloxEventReceiver:observeEvent("FriendshipNotifications", function(p3)
			local userId2 = tostring(joined.localUserId) == tostring(p3.EventArgs.UserId1)
				and tostring(p3.EventArgs.UserId2)
				or tostring(p3.EventArgs.UserId1)

			if p3.Type == "FriendshipDestroyed" then
				v8(ChatFriendshipDestroyed(userId2))
			elseif p3.Type == "FriendshipCreated" then
				v8(ChatFriendshipCreated(userId2))
			end
		end)

		return function()
			if v9 and v9.disconnect then
				v9:disconnect()
			end
		end
	end, { v8, joined.robloxEventReceiver, joined.localUserId })

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_ikf_ChatExternalEventReceiver
