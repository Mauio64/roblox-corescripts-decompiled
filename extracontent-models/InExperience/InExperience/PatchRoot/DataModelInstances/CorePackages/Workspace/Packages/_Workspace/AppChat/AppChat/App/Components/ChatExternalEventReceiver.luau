local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatMigrateChatExternalEventReceiver = require(AppChat.Flags.FFlagAppChatMigrateChatExternalEventReceiver)

if FFlagAppChatMigrateChatExternalEventReceiver then
	local ChatExternalEventReceiver2 = require(script.Parent.ChatExternalEventReceiver2)
	return ChatExternalEventReceiver2
end

local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local UserLib = require(parent.UserLib)

local SetUserPresences = UserLib.Thunks.SetUserPresences
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect

local Logger = require(AppChat.Logger)
local v = Logger:new("AppChat.RealtimeExternal")
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

function ChatExternalEventReceiver(p): nil
	local joined = Cryo.Dictionary.join(v3, p)
	local v4 = useDispatch()

	useEffect(function()
		local v5 = joined.robloxEventReceiver:observeEvent("PresenceBulkNotifications", function(p2)
			local mapped = Cryo.List.map(p2, function(p3)
				return (tostring(p3.UserId))
			end)

			if not FFlagAppChatPresenceStoreMigration then
				v4(NetworkingPresence.GetPresencesFromUserIds.API(mapped)):andThen(function(p3)
					v4(SetUserPresences(p3.responseBody.userPresences))
				end):catch(function(p3)
					v:warning("NetworkingPresence failure in ChatExternalEventReceiver->PresenceBulkNotifications, Status: " .. tostring(p3))
				end)

				return
			end

			for _, v5 in mapped do
				v2.RefreshPresenceByUserId(v5)
			end
		end)

		return function()
			if v5 and v5.disconnect then
				v5:disconnect()
			end
		end
	end, { v4, joined.robloxEventReceiver })

	useEffect(function()
		local v5 = joined.robloxEventReceiver:observeEvent("FriendshipNotifications", function(p2)
			local userId2 = tostring(joined.localUserId) == tostring(p2.EventArgs.UserId1)
				and tostring(p2.EventArgs.UserId2)
				or tostring(p2.EventArgs.UserId1)

			if p2.Type == "FriendshipDestroyed" then
				v4(ChatFriendshipDestroyed(userId2))
			elseif p2.Type == "FriendshipCreated" then
				v4(ChatFriendshipCreated(userId2))
			end
		end)

		return function()
			if v5 and v5.disconnect then
				v5:disconnect()
			end
		end
	end, { v4, joined.robloxEventReceiver, joined.localUserId })

	return nil
end

return ChatExternalEventReceiver
