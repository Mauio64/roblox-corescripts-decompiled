local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UserProfiles = require(parent.UserProfiles)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationViewModelStore = require(AppChat.Stores.GetConversationViewModelStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatUseActivationOnFocus = SharedFlags2.FFlagAppChatUseActivationOnFocus
local conversationFocusActivationDelaySeconds = require(AppChat.Flags.conversationFocusActivationDelaySeconds)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatUseBindingConversationFacePile = require(AppChat.Flags.FFlagAppChatUseBindingConversationFacePile)

local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useActivationOnFocus = FocusNavigationUtils.useActivationOnFocus
local useConversationRowActivation = require(script.Parent.useConversationRowActivation)
local useRelativeTimestampSignalBinding = require(script.Parent.useRelativeTimestampSignalBinding)
local normalizeConversationForTelemetry = require(script.Parent.normalizeConversationForTelemetry)

local function useSubscriptionBadgeVisibility(itemSignal, p)
	local v, v2 = React.useBinding(false)
	local v3 = UserProfiles.Stores.UserProfileStore.get()

	React.useLayoutEffect(function()
		if not (FFlagEnableBlackbirdCheck and FFlagAppChatUseBindingConversationFacePile) then
			return
		end

		local v4 = nil
		local v5 = nil
		local v6 = false

		return Signals.createEffect(function(p2)
			local v7 = itemSignal(p2)
			local conversation = p.getConversation(v7.id, p2)
			local otherParticipants = getOtherParticipants(conversation, v7.presentationSignal(p2).localUserId)
			local v8

			if not (conversation == nil or conversation.type ~= "one_to_one" or #otherParticipants ~= 1) then
				v8 = tostring(otherParticipants[1])
			end

			if v8 ~= v4 then
				v4 = v8
				local v9

				if v8 ~= nil then
					v9 = v3.fetchNamesByUserIds({ v8 })
				end

				v5 = v9
			end

			local v9 = false

			if v5 ~= nil then
				local success, result = pcall(v5, p2)

				if success and result.status == "success" and #result.data > 0 then
					local v10 = result.data[1]

					if v10.getHasRobloxSubscription == nil then
						v9 = false
					else
						v9 = v10.getHasRobloxSubscription(p2) == true
					end
				end
			end

			if v9 ~= v6 then
				v6 = v9
				v2(v9)
			end
		end)
	end, { p, itemSignal, v2, v3 })

	return v
end

local function useConversationRowBindingPresentation(p)
	local conversationStore = GetConversationStore(false)
	local conversationViewModelStore = GetConversationViewModelStore(false)
	local pendingSubtitleText = useLocalization({
		pendingSubtitleText = "Feature.Chat.Message.MessageUnavailable"
	}).pendingSubtitleText

	local v = React.useMemo(function()
		local function getConversationId(p2) -- 6 equivalent calls inferred from this helper
			return p.itemSignal(p2).id
		end

		return {
			conversationId = Signals.createComputed(getConversationId),
			presentation = Signals.createComputed(function(p2)
				return p.itemSignal(p2).presentationSignal(p2)
			end),
			hasConversation = Signals.createComputed(function(p2): boolean
				return conversationViewModelStore.getTitle(getConversationId(p2))(p2) ~= nil -- inferred equivalent call
			end),
			shouldShowOSA = Signals.createComputed(function(p2)
				return conversationViewModelStore.getShouldShowOSA(getConversationId(p2))(p2) -- inferred equivalent call
			end),
			shouldShowU13ChatOptIn = Signals.createComputed(function(p2)
				return conversationViewModelStore.getShouldShowU13ChatOptIn(getConversationId(p2))(p2) -- inferred equivalent call
			end),
			conversationType = Signals.createComputed(function(p2)
				return conversationViewModelStore.getConversationType(getConversationId(p2))(p2) -- inferred equivalent call
			end),
			testId = Signals.createComputed(function(p2)
				if FFlagDebugAppChatEnableDomLocators then
					return (conversationViewModelStore.getTestId(getConversationId(p2))(p2)) -- inferred equivalent call
				end

				return nil
			end),
			locatorTitle = Signals.createComputed(function(p2)
				if FFlagDebugAppChatEnableDomLocators then
					return (conversationViewModelStore.getLocatorTitle(getConversationId(p2))(p2)) -- inferred equivalent call
				end

				return nil
			end),
			showSquadButton = Signals.createComputed(function(p2): boolean
				local itemSignal = p.itemSignal(p2)
				return itemSignal.presentationSignal(p2).isSquadEnabled == true
					and conversationViewModelStore.getTitle(itemSignal.id)(p2) ~= nil
					and conversationViewModelStore.getHasGroupUp(itemSignal.id)(p2) == true
			end)
		}
	end, { conversationViewModelStore, p.itemSignal })

	local v2 = SignalsReact.useSignalState(v.presentation)
	local hasConversation = SignalsReact.useSignalState(v.hasConversation)
	local shouldShowOSA = SignalsReact.useSignalState(v.shouldShowOSA)
	local shouldShowU13ChatOptIn = SignalsReact.useSignalState(v.shouldShowU13ChatOptIn)
	local conversationType = SignalsReact.useSignalState(v.conversationType)
	local testId = SignalsReact.useSignalState(v.testId)
	local locatorTitle = SignalsReact.useSignalState(v.locatorTitle)
	local showSquadButton = SignalsReact.useSignalState(v.showSquadButton)

	local v3 = React.useCallback(function(p2, p3)
		return conversationViewModelStore.getTitle(p2.id)(p3) or ""
	end, { conversationViewModelStore })
	local v4 = React.useCallback(function(p2, p3)
		local title = conversationViewModelStore.getTitle(p2.id)
		local isSubtitlePending = conversationViewModelStore.getIsSubtitlePending(p2.id)

		if title(p3) == nil then
			return ""
		end

		if isSubtitlePending(p3) then
			return pendingSubtitleText
		end

		return conversationViewModelStore.getSubtitle(p2.id)(p3) or ""
	end, { conversationViewModelStore, pendingSubtitleText })
	local v5 = React.useCallback(function(p2, p3): boolean
		return conversationViewModelStore.getTitle(p2.id)(p3) ~= nil
			and conversationViewModelStore.getHasUnreadMessages(p2.id)(p3) == true
			and not conversationViewModelStore.getIsSubtitlePending(p2.id)(p3)
	end, { conversationViewModelStore })
	local v6 = React.useCallback(function(p2, p3)
		return conversationViewModelStore.getUnixTime(p2.id)(p3)
	end, { conversationViewModelStore })
	local v7 = React.useCallback(function(p2)
		return p2.id
	end, {})
	local title = SignalsReact.useSignalBinding(function(p2)
		return v3(p.itemSignal(p2), p2)
	end)

	local subtitleText = SignalsReact.useSignalBinding(function(p2)
		return v4(p.itemSignal(p2), p2)
	end)

	local showUnread = SignalsReact.useSignalBinding(function(p2)
		return v5(p.itemSignal(p2), p2)
	end)

	local timestampText = useRelativeTimestampSignalBinding(p.itemSignal, v6)

	local showSubscriptionBadge = useSubscriptionBadgeVisibility(p.itemSignal, conversationStore)
	local debugCellValue = SignalsReact.useSignalBinding(function(p2)
		return v7(p.itemSignal(p2))
	end)

	local v8 = useChatPagePadding()
	local v9 = ChatPlacementContext.useChatPlacementContext()
	local v10

	if FFlagAppThemeHalloween2026ChatBackground then
		v10 = useThemeBackground() ~= nil
	else
		v10 = false
	end

	local telemetry = useTelemetry(ChatLandingTelemetryLayer.Context)
	local getCurrentOptions = React.useCallback(function()
		local itemSignal = p.itemSignal(false)
		local id = itemSignal.id
		local presentationSignal = itemSignal.presentationSignal(false)
		return {
			conversationId = id,
			hasConversation = conversationViewModelStore.getTitle(id)(false) ~= nil,
			shouldShowOSA = conversationViewModelStore.getShouldShowOSA(id)(false),
			shouldShowU13ChatOptIn = conversationViewModelStore.getShouldShowU13ChatOptIn(id)(false),
			conversationType = conversationViewModelStore.getConversationType(id)(false),
			onActivated = presentationSignal.onActivated,
			onSquadJoinButtonActivated = presentationSignal.onSquadJoinButtonActivated,
			fireClickEvent = presentationSignal.fireClickEvent
		}
	end, { conversationViewModelStore, p.itemSignal })

	local v11 = useConversationRowActivation({
		conversationId = v.conversationId(false),
		hasConversation = hasConversation,
		shouldShowOSA = shouldShowOSA,
		shouldShowU13ChatOptIn = shouldShowU13ChatOptIn,
		conversationType = conversationType,
		onActivated = v2.onActivated,
		onSquadJoinButtonActivated = v2.onSquadJoinButtonActivated,
		fireClickEvent = v2.fireClickEvent,
		telemetry = telemetry,
		getCurrentOptions = getCurrentOptions
	})

	local ref = React.useRef(nil)
	local onActivated = v11.onActivated
	local isWideMode = v2.isWideMode == true

	if FFlagAppChatUseActivationOnFocus then
		useActivationOnFocus(isWideMode, ref, onActivated, nil, React.useCallback(function()
			return p.itemSignal(false).id
		end, { p.itemSignal }), nil, conversationFocusActivationDelaySeconds)
	else
		local v12 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			if isWideMode and v12 then
				local v13 = v12.focusedGuiObject:subscribe(function(p2)
					if ref.current and p2 == ref.current then
						onActivated()
					end
				end)
				return function()
					v13:unsubscribe()
				end
			end

			return function() end
		end, { onActivated, isWideMode, v12, ref })
	end

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local itemSignal = p.itemSignal(p2)
			local fireImpressionEvent = itemSignal.presentationSignal(p2).fireImpressionEvent

			if fireImpressionEvent == nil or ref2.current == itemSignal.id then
				return
			end

			local conversation = conversationStore.getConversation(itemSignal.id, p2)

			if conversation == nil then
				return
			end

			ref2.current = itemSignal.id
			fireImpressionEvent(normalizeConversationForTelemetry(conversation))
		end)
	end, { conversationStore, p.itemSignal })

	local v12 = {
		hasConversation = hasConversation,
		title = title,
		testId = testId,
		locatorTitle = locatorTitle,
		entryHeight = v2.entryHeight or 64,
		pagePaddingLeft = v8.left,
		pagePaddingRight = v8.right,
		timestampText = timestampText,
		subtitleText = subtitleText,
		showSubscriptionBadge = showSubscriptionBadge,
		showSquadButton = showSquadButton,
		showTimestamp = not showSquadButton,
		showUnread = showUnread,
		squadLocation = v9.chatPlacement,
		rowRef = ref,
		onRowActivated = onActivated,
		onSquadActivated = v11.onSquadActivated,
		showBackground = 0,
		debugCellValue = 0
	}
	local showBackground

	if v2.showBackground == nil then
		showBackground = not (ChatPlacementContext.isPlacementInExperience(v9.chatPlacement) or v10)
	else
		showBackground = v2.showBackground
	end

	v12.showBackground = showBackground

	if not v2.isDebugEnabled then
		debugCellValue = nil
	end

	v12.debugCellValue = debugCellValue
	return v12
end

return useConversationRowBindingPresentation
