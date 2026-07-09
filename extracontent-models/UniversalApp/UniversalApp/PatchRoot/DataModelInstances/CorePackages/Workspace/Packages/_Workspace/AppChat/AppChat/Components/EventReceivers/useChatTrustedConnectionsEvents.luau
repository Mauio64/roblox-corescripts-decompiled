local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RealtimeDelivery = require(AppChatParent.RealtimeDelivery)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(AppChatParent.React)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local refreshConversationUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshConversationUnfilteredThreadsDetails)
local reloadMessagesForConversations = require(AppChat.Conversations.Thunks.reloadMessagesForConversations)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local TrustedConnections = require(script.Parent.Constants).TrustedConnections

require(script.Parent.TrustedConnectionsNotificationTypes)

local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local ConversationModerationTypeChanged = require(AppChat.Conversations.Actions.ConversationModerationTypeChanged)
local Cryo = require(AppChatParent.Cryo)
local v16 = require(AppChat.Logger):new(script.Name)

local function useChatTrustedConnectionsEvents(t1: {[any]: any}) -- line: 25
	-- upvalues: useDispatch (copy), useSelector (copy), useGetConversationFromId (copy), useIsInExperience (copy), useLocalUserId (copy), React (copy), ConversationChannels (copy), refreshConversationUnfilteredThreadsDetails (copy), Cryo (copy), ConversationModerationTypeChanged (copy), reloadMessagesForConversations (copy), RealtimeDelivery (copy), TrustedConnections (copy), v16 (copy)
	local v19 = useDispatch()
	local v20 = useSelector(function(p1) -- line: 27
		return p1.ChatAppReducer.Conversations
	end)
	local v21 = useGetConversationFromId(t1.activeConversationId)
	local v22 = useIsInExperience()
	local v23 = useLocalUserId()
	local v24 = React.useCallback(function(s1: string) -- line: 35
		-- upvalues: v21 (copy), ConversationChannels (copy), v19 (copy), refreshConversationUnfilteredThreadsDetails (copy), v22 (copy)
		if v21 and (v21.participants and v21.type == ConversationChannels.Type.OneToOne and s1) then
			for _, v30 in v21.participants do
				if v30 == s1 then
					v19(refreshConversationUnfilteredThreadsDetails(v21.id, v22))

					return
				end
			end
		end
	end, {
		v19,
		v21,
		v22
	})
	local v25 = React.useCallback(function(s2: string, s3: string) -- line: 53
		-- upvalues: v20 (copy), ConversationChannels (copy), Cryo (copy), v19 (copy), ConversationModerationTypeChanged (copy)
		for _, v34 in v20 do
			if v34.type == ConversationChannels.Type.OneToOne and v34.participants and v34.source == ConversationChannels.Source.Friends and Cryo.List.find(v34.participants, s2) then
				v19(ConversationModerationTypeChanged(v34.id, s3))

				return
			end
		end
	end, {
		v19,
		v20
	})
	local v26 = React.useCallback(function(s4: string) -- line: 68
		-- upvalues: v20 (copy), Cryo (copy), v19 (copy), reloadMessagesForConversations (copy)
		local t2 = {}

		for _, v38 in v20 do
			if v38.participants and Cryo.List.find(v38.participants, s4) then
				table.insert(t2, v38.id)
			end
		end

		if #t2 == 0 then
			return
		end

		v19(reloadMessagesForConversations(t2))
	end, {
		v19,
		v20
	})

	RealtimeDelivery.useRealtimeNamespace(TrustedConnections.Namespace, function(p2) -- line: 84
		-- upvalues: v16 (copy), TrustedConnections (copy), v23 (copy), v24 (copy), v25 (copy), ConversationChannels (copy), v26 (copy)
		v16:debug("Received Realtime Event " .. TrustedConnections.Namespace .. " -> Actor: " .. tostring(p2.Actor) .. ", Target: " .. tostring(p2.Target) .. ", EventType: " .. tostring(p2.EventType))

		local str = tostring(p2.Actor)
		local str2 = tostring(p2.Target)
		local EventType = p2.EventType

		if EventType == TrustedConnections.EventTypes.TrustedConnectionCreated or EventType == TrustedConnections.EventTypes.TrustedConnectionDeleted then
			local v43 = if str ~= v23 then str else str2

			if EventType == TrustedConnections.EventTypes.TrustedConnectionCreated then
				v24(v43)
				v25(v43, ConversationChannels.ModerationType.TrustedComms)
			else
				v25(v43, ConversationChannels.ModerationType.Moderated)
			end

			v26(v43)

			return
		end

		if EventType == TrustedConnections.EventTypes.TrustedConnectionRequestSent then
			if str ~= v23 then
				v24(str)

				return
			end
		else
			v16:debug("EventType: " .. tostring(EventType) .. " is not suppoprted.")
		end
	end, {
		v23,
		v24,
		v25,
		v26
	})
end

return useChatTrustedConnectionsEvents
