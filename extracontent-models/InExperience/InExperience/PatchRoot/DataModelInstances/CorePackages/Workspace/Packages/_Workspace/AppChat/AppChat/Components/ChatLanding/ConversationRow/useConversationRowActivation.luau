local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(AppChatParent.Navigation).useNavigation
local Constants = require(AppChat.Constants)
local Conversation = require(AppChat.Models.Conversation)
local EnumScreens = require(AppChat.EnumScreens)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local FFlagAppChatSquadJoinButtonU13OSA = require(AppChat.Flags.FFlagAppChatSquadJoinButtonU13OSA)
local normalizeConversationForTelemetry = require(script.Parent.normalizeConversationForTelemetry)

local function deriveModalVariant(b1: boolean, b2: boolean) -- line: 48
	-- upvalues: Constants (copy)
	if b1 then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	if b2 then
		return Constants.OptInVariant.OsaContextCard
	end

	return nil
end
local function deriveSquadModalVariant(b3: boolean, b4: boolean, s1: string?) -- line: 57
	-- upvalues: Constants (copy), FFlagAppChatSquadJoinButtonU13OSA (copy), Conversation (copy)
	if b3 then
		return Constants.OptInVariant.OsaContextCard
	end

	if FFlagAppChatSquadJoinButtonU13OSA and b4 and s1 == Conversation.Type.MULTI_USER_CONVERSATION then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	return nil
end
local function showOsaOverlay(s2: string, s3: string?, s4: string?, s5: string?, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any), p3) -- line: 75
	-- upvalues: GetOverlayStore (copy), OverlayTypes (copy), EnumScreens (copy), Conversation (copy), GetConversationStore (copy), RemovedConversation (copy)
	local v32 = GetOverlayStore(false)

	v32.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = s2,
		impressionId = s3,
		modalVariant = s4,
		onJoin = function() -- line: 90
			-- upvalues: v32 (copy), p1 (copy), s2 (copy), p3 (copy), EnumScreens (copy)
			v32.dismissOverlay()

			if p1 then
				p1(s2)

				return
			end

			p3.navigate(EnumScreens.ChatConversation, {
				isNavigatedFromGroupOSAJoin = true,
				conversationId = s2
			})
		end,
		onDecline = function() -- line: 101
			-- upvalues: s2 (copy), s5 (copy), Conversation (copy), GetConversationStore (copy), p2 (copy), RemovedConversation (copy), v32 (copy)
			if s2 and s5 == Conversation.Type.MULTI_USER_CONVERSATION then
				GetConversationStore(false).removeConversation(s2)
				p2(RemovedConversation(s2))
			end

			v32.dismissOverlay()
		end
	})
end
local function useConversationRowActivation(t1: {[any]: any}) -- line: 111
	-- upvalues: React (copy), useNavigation (copy), useDispatch (copy), GetConversationStore (copy), Constants (copy), HttpService (copy), showOsaOverlay (copy), normalizeConversationForTelemetry (copy), FFlagAppChatSquadJoinButtonU13OSA (copy), Conversation (copy)
	local conversationId = t1.conversationId
	local hasConversation = t1.hasConversation
	local shouldShowOSA = t1.shouldShowOSA
	local shouldShowU13ChatOptIn = t1.shouldShowU13ChatOptIn
	local conversationType = t1.conversationType
	local onActivated = t1.onActivated
	local onSquadJoinButtonActivated = t1.onSquadJoinButtonActivated
	local fireClickEvent = t1.fireClickEvent
	local telemetry = t1.telemetry
	local v43 = React.useRef(telemetry)

	v43.current = telemetry

	local v44 = useNavigation()
	local v45 = useDispatch()
	local v46 = GetConversationStore(false)
	local v47 = React.useCallback(function() -- line: 129
		-- upvalues: hasConversation (copy), v46 (copy), conversationId (copy), shouldShowU13ChatOptIn (copy), shouldShowOSA (copy), Constants (copy), HttpService (copy), showOsaOverlay (copy), conversationType (copy), onActivated (copy), v45 (copy), v44 (copy), fireClickEvent (copy), normalizeConversationForTelemetry (copy), v43 (copy)
		if not hasConversation then
			return
		end

		local v49 = v46.getConversation(conversationId, false)

		if v49 == nil then
			return
		end

		local guid = nil
		local v51 = shouldShowU13ChatOptIn
		local v52 = shouldShowOSA
		local v53 = if not v51 then if not v52 then nil else Constants.OptInVariant.OsaContextCard else Constants.OptInVariant.ChatOptInInfoCard

		if v53 then
			guid = HttpService:GenerateGUID(false)
			showOsaOverlay(conversationId, guid, v53, conversationType, if not onActivated then nil else function(s6: string) -- line: 150
				-- upvalues: v46 (copy), onActivated (copy)
				local v61 = v46.getConversation(s6, false)

				if v61 then
					onActivated(v61)
				end
			end, v45, v44)
		elseif onActivated then
			onActivated(v49)
		end

		if fireClickEvent then
			fireClickEvent(normalizeConversationForTelemetry(v49), v43.current, guid)
		end
	end, {
		hasConversation,
		conversationId,
		conversationType,
		shouldShowOSA,
		shouldShowU13ChatOptIn,
		onActivated,
		fireClickEvent,
		v45,
		v44,
		v46
	})
	local v48 = React.useCallback(function(s7: string) -- line: 184
		-- upvalues: hasConversation (copy), onSquadJoinButtonActivated (copy), shouldShowOSA (copy), shouldShowU13ChatOptIn (copy), conversationType (copy), Constants (copy), FFlagAppChatSquadJoinButtonU13OSA (copy), Conversation (copy), HttpService (copy), showOsaOverlay (copy), v45 (copy), v44 (copy)
		if not hasConversation then
			if onSquadJoinButtonActivated then
				onSquadJoinButtonActivated(s7)
			end

			return
		end

		local v55 = shouldShowOSA
		local v56 = shouldShowU13ChatOptIn
		local v57 = conversationType
		local v58 = if not v55 then if not FFlagAppChatSquadJoinButtonU13OSA or (not v56 or v57 ~= Conversation.Type.MULTI_USER_CONVERSATION) then nil else Constants.OptInVariant.ChatOptInInfoCard else Constants.OptInVariant.OsaContextCard

		if v58 then
			local guid = HttpService:GenerateGUID(false)

			showOsaOverlay(s7, guid, v58, conversationType, onSquadJoinButtonActivated, v45, v44)

			return
		end

		if onSquadJoinButtonActivated then
			onSquadJoinButtonActivated(s7)
		end
	end, {
		hasConversation,
		conversationId,
		conversationType,
		shouldShowOSA,
		shouldShowU13ChatOptIn,
		onSquadJoinButtonActivated,
		v45,
		v44,
		v46.getConversation
	})

	return {
		onActivated = v47,
		onSquadActivated = v48
	}
end

return useConversationRowActivation
