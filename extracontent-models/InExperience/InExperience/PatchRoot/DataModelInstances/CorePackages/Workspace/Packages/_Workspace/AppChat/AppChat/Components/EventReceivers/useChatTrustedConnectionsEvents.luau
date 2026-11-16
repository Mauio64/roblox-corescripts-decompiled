local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local React = require(parent.React)

local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local ConversationChannels = require(AppChat.Models.ConversationChannels)

local refreshConversationUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshConversationUnfilteredThreadsDetails)
local reloadMessagesForConversations = require(AppChat.Conversations.Thunks.reloadMessagesForConversations)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local Constants = require(script.Parent.Constants)
local TrustedConnections = Constants.TrustedConnections
require(script.Parent.TrustedConnectionsNotificationTypes)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local ConversationModerationTypeChanged = require(AppChat.Conversations.Actions.ConversationModerationTypeChanged)
local Cryo = require(parent.Cryo)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags.FFlagAppChatConversationTrustedFriendUpsellBanner

local function useChatTrustedConnectionsEvents(p)
	local v2 = useDispatch()
	local v3 = useSelector(function(p2)
		return p2.ChatAppReducer.Conversations
	end)

	local v4 = useGetConversationFromId(p.activeConversationId)
	local v5 = useIsInExperience()
	local v6 = useLocalUserId()

	local v7 = React.useCallback(function(p2: string)
		if v4 and v4.participants and v4.type == ConversationChannels.Type.OneToOne and p2 then
			for _, participant in v4.participants do
				if participant == p2 then
					v2(refreshConversationUnfilteredThreadsDetails(v4.id, v5))
					return
				end
			end
		end
	end, { v2, v4, v5 })

	local v8 = React.useCallback(function(p2: string, p3: string)
		for _, v8 in v3 do
			if
				v8.type == ConversationChannels.Type.OneToOne
				and v8.participants
				and v8.source == ConversationChannels.Source.Friends
				and Cryo.List.find(v8.participants, p2)
			then
				v2(ConversationModerationTypeChanged(v8.id, p3))
				break
			end
		end
	end, { v2, v3 })

	local v9 = React.useCallback(function(p2: string)
		local ids = {}

		for _, v9 in v3 do
			if v9.participants and Cryo.List.find(v9.participants, p2) then
				table.insert(ids, v9.id)
			end
		end

		if #ids == 0 then
			return
		end

		v2(reloadMessagesForConversations(ids))
	end, { v2, v3 })

	RealtimeDelivery.useRealtimeNamespace(TrustedConnections.Namespace, function(data)
		v:debug("Received Realtime Event " .. TrustedConnections.Namespace .. " -> Actor: " .. tostring(data.Actor) .. ", Target: " .. tostring(data.Target) .. ", EventType: " .. tostring(data.EventType))

		local v10 = tostring(data.Actor)
		local target = tostring(data.Target)

		local eventType = data.EventType

		if
			eventType == TrustedConnections.EventTypes.TrustedConnectionCreated
			or eventType == TrustedConnections.EventTypes.TrustedConnectionDeleted
		then
			if v10 == v6 then
				v10 = target
			end

			if eventType == TrustedConnections.EventTypes.TrustedConnectionCreated then
				v7(v10)
				v8(v10, ConversationChannels.ModerationType.TrustedComms)
			else
				v8(v10, ConversationChannels.ModerationType.Moderated)
			end

			v9(v10)
		elseif eventType == TrustedConnections.EventTypes.TrustedConnectionRequestSent then
			if v10 ~= v6 then
				v7(v10)
			elseif FFlagAppChatConversationTrustedFriendUpsellBanner then
				v7(target)
			end
		else
			v:debug("EventType: " .. tostring(eventType) .. " is not suppoprted.")
		end
	end, { v6, v7, v8, v9 })
end

return useChatTrustedConnectionsEvents
