local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local refreshConversationUnfilteredThreadsDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/refreshConversationUnfilteredThreadsDetails")
local reloadMessagesForConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/reloadMessagesForConversations")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local trustedConnections = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/Constants").TrustedConnections
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/TrustedConnectionsNotificationTypes")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local ConversationModerationTypeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ConversationModerationTypeChanged")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("useChatTrustedConnectionsEvents")

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner

local function useChatTrustedConnectionsEvents(p2)
	local v6 = useDispatch()
	local v7 = useSelector(function(p3)
		return p3.ChatAppReducer.Conversations
	end)

	local v8 = useGetConversationFromId(p2.activeConversationId)
	local v9 = useIsInExperience()
	local v10 = useLocalUserId()

	local v11 = React.useCallback(function(p3)
		if v8 and v8.participants and v8.type == ConversationChannels.Type.OneToOne and p3 then
			for k, participant in v8.participants do
				if participant == p3 then
					v6(refreshConversationUnfilteredThreadsDetails(v8.id, v9))
					return
				end
			end
		end
	end, { v6, v8, v9 })

	local v12 = React.useCallback(function(p3, p4)
		for k, v13 in v7 do
			if
				v13.type == ConversationChannels.Type.OneToOne
				and v13.participants
				and v13.source == ConversationChannels.Source.Friends
				and Cryo.List.find(v13.participants, p3)
			then
				v6(ConversationModerationTypeChanged(v13.id, p4))
				break
			end
		end
	end, { v6, v7 })

	local v13 = React.useCallback(function(p3)
		local ids = {}

		for k, v14 in v7 do
			if v14.participants and Cryo.List.find(v14.participants, p3) then
				table.insert(ids, v14.id)
			end
		end

		if #ids == 0 then
			return
		end

		v6(reloadMessagesForConversations(ids))
	end, { v6, v7 })

	RealtimeDelivery.useRealtimeNamespace(trustedConnections.Namespace, function(data)
		v5:debug("Received Realtime Event " .. trustedConnections.Namespace .. " -> Actor: " .. tostring(data.Actor) .. ", Target: " .. tostring(data.Target) .. ", EventType: " .. tostring(data.EventType))

		local v14 = tostring(data.Actor)
		local target = tostring(data.Target)

		local eventType = data.EventType

		if
			eventType == trustedConnections.EventTypes.TrustedConnectionCreated
			or eventType == trustedConnections.EventTypes.TrustedConnectionDeleted
		then
			if v14 == v10 then
				v14 = target
			end

			if eventType == trustedConnections.EventTypes.TrustedConnectionCreated then
				v11(v14)
				v12(v14, ConversationChannels.ModerationType.TrustedComms)
			else
				v12(v14, ConversationChannels.ModerationType.Moderated)
			end

			v13(v14)
		elseif eventType == trustedConnections.EventTypes.TrustedConnectionRequestSent then
			if v14 ~= v10 then
				v11(v14)
			elseif fFlagAppChatConversationTrustedFriendUpsellBanner then
				v11(target)
			end
		else
			v5:debug("EventType: " .. tostring(eventType) .. " is not suppoprted.")
		end
	end, { v10, v11, v12, v13 })
end

return useChatTrustedConnectionsEvents
