local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useRelativeTimestampBinding = require(AppChat.Hooks.useRelativeTimestampBinding)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationViewModelStore = require(AppChat.Stores.GetConversationViewModelStore)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useConversationRowActivation = require(script.Parent.useConversationRowActivation)
local normalizeConversationForTelemetry = require(script.Parent.normalizeConversationForTelemetry)

local function isShowingSquadButton(b1: boolean, b2: boolean, b3: boolean?) -- line: 60
	return b3 == true and (b1 and b2)
end
local function useConversationRowPresentation(t1: {[any]: any}) -- line: 64
	-- upvalues: GetConversationStore (copy), GetConversationViewModelStore (copy), React (copy), Signals (copy), SignalsReact (copy), useChatPagePadding (copy), ChatPlacementContext (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), useRelativeTimestampBinding (copy), useLocalization (copy), useGetOneToOneFriendIdFromConversationId (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), useConversationRowActivation (copy), ReactFocusNavigation (copy), normalizeConversationForTelemetry (copy)
	local v26 = GetConversationStore(false)
	local v27 = GetConversationViewModelStore(false)
	local v28 = React.useMemo(function() -- line: 67
		-- upvalues: v27 (copy), t1 (copy)
		return {
			title = v27.getTitle(t1.conversationId),
			subtitle = v27.getSubtitle(t1.conversationId),
			isSubtitlePending = v27.getIsSubtitlePending(t1.conversationId),
			hasUnreadMessages = v27.getHasUnreadMessages(t1.conversationId),
			hasGroupUp = v27.getHasGroupUp(t1.conversationId),
			shouldShowOSA = v27.getShouldShowOSA(t1.conversationId),
			shouldShowU13ChatOptIn = v27.getShouldShowU13ChatOptIn(t1.conversationId),
			conversationType = v27.getConversationType(t1.conversationId),
			unixTime = v27.getUnixTime(t1.conversationId),
			testId = v27.getTestId(t1.conversationId),
			locatorTitle = v27.getLocatorTitle(t1.conversationId)
		}
	end, {
		v27,
		t1.conversationId
	})
	local v29 = React.useMemo(function() -- line: 82
		-- upvalues: Signals (copy), v26 (copy), t1 (copy)
		return Signals.createComputed(function(p1) -- line: 83
			-- upvalues: v26 (copy), t1 (copy)
			return v26.getConversation(t1.conversationId, p1)
		end)
	end, {
		v26,
		t1.conversationId
	})
	local v30 = SignalsReact.useSignalState(v29)
	local v31 = SignalsReact.useSignalState(v28.title)
	local v32 = SignalsReact.useSignalState(v28.subtitle)
	local v33 = SignalsReact.useSignalState(v28.isSubtitlePending)
	local v34 = SignalsReact.useSignalState(v28.hasUnreadMessages)
	local v35 = SignalsReact.useSignalState(v28.hasGroupUp)
	local v36 = SignalsReact.useSignalState(v28.shouldShowOSA)
	local v37 = SignalsReact.useSignalState(v28.shouldShowU13ChatOptIn)
	local v38 = SignalsReact.useSignalState(v28.conversationType)
	local v39 = SignalsReact.useSignalState(v28.unixTime)
	local v40 = SignalsReact.useSignalState(v28.testId)
	local v41 = SignalsReact.useSignalState(v28.locatorTitle)
	local v42 = v31 ~= nil
	local v43 = useChatPagePadding()
	local v44 = ChatPlacementContext.useChatPlacementContext()
	local v45 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local v46 = useRelativeTimestampBinding(v39)
	local v47 = useLocalization({
		pendingSubtitleText = "Feature.Chat.Message.MessageUnavailable"
	})
	local v48 = useGetOneToOneFriendIdFromConversationId(t1.conversationId)
	local v49 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck then nil else v48)
	local v50 = useConversationRowActivation({
		conversationId = t1.conversationId,
		hasConversation = v42,
		shouldShowOSA = v36,
		shouldShowU13ChatOptIn = v37,
		conversationType = v38,
		onActivated = t1.onActivated,
		onSquadJoinButtonActivated = t1.onSquadJoinButtonActivated,
		fireClickEvent = t1.fireClickEvent,
		telemetry = v45
	})
	local v51 = t1.isSquadEnabled == true and (v42 and v35)
	local v52 = v42 and (v34 and not v33)
	local v53 = if not v42 or not v33 then not v42 and "" or v32 else v47.pendingSubtitleText
	local v54 = React.useRef(nil)
	local v55 = React.useCallback(function() -- line: 131
		-- upvalues: v50 (copy)
		v50.onActivated()
	end, { v50.onActivated })
	local v56 = t1.isWideMode == true
	local v57 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	React.useEffect(function() -- line: 138
		-- upvalues: v56 (copy), v57 (copy), v54 (copy), v55 (copy)
		if not v56 or not v57 then
			return function() -- line: 140
			end
		end

		local v60 = v57.focusedGuiObject:subscribe(function(p2) -- line: 142
			-- upvalues: v54 (copy), v55 (copy)
			if v54.current and p2 == v54.current then
				v55()
			end
		end)

		return function() -- line: 147
			-- upvalues: v60 (copy)
			v60:unsubscribe()
		end
	end, {
		v55,
		v56,
		v57
	})

	local v58 = React.useRef(t1.fireImpressionEvent)
	local v59 = React.useRef(nil)

	v58.current = t1.fireImpressionEvent
	React.useEffect(function() -- line: 156
		-- upvalues: v58 (copy), v42 (copy), v59 (copy), t1 (copy), v26 (copy), normalizeConversationForTelemetry (copy)
		if v58.current == nil or not v42 then
			return
		end

		if v59.current == t1.conversationId then
			return
		end

		local v61 = v26.getConversation(t1.conversationId, false)

		if v61 == nil then
			return
		end

		v59.current = t1.conversationId
		v58.current(normalizeConversationForTelemetry(v61))
	end, {
		t1.conversationId,
		v42,
		v26
	})

	return {
		hasConversation = v42,
		conversationId = t1.conversationId,
		title = v31 or "",
		testId = v40,
		locatorTitle = v41,
		entryHeight = t1.entryHeight or 64,
		pagePaddingLeft = v43.left,
		pagePaddingRight = v43.right,
		timestampText = v46,
		subtitleText = v53,
		showSubscriptionBadge = v49,
		showSquadButton = v51,
		showTimestamp = not v51,
		showUnread = v52,
		squadLocation = v44.chatPlacement,
		participants = if v30 == nil then nil else v30.participants,
		rowRef = v54,
		onRowActivated = v55,
		onSquadActivated = v50.onSquadActivated
	}
end

return useConversationRowPresentation
