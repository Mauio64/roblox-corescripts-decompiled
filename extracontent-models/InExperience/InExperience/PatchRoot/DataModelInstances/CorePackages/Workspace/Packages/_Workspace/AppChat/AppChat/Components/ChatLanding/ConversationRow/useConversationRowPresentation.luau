local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)
local useRelativeTimestampBinding = require(AppChat.Hooks.useRelativeTimestampBinding)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationViewModelStore = require(AppChat.Stores.GetConversationViewModelStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatUseActivationOnFocus = SharedFlags2.FFlagAppChatUseActivationOnFocus
local conversationFocusActivationDelaySeconds = require(AppChat.Flags.conversationFocusActivationDelaySeconds)
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useActivationOnFocus = FocusNavigationUtils.useActivationOnFocus
local useConversationRowActivation = require(script.Parent.useConversationRowActivation)
local normalizeConversationForTelemetry = require(script.Parent.normalizeConversationForTelemetry)

local function isShowingSquadButton(flag: boolean, flag2: boolean, isSquadEnabled: boolean?) -- 1 equivalent call inferred from this helper
	return isSquadEnabled == true and flag and flag2
end

local function useConversationRowPresentation(data)
	local conversationStore = GetConversationStore(false)
	local conversationViewModelStore = GetConversationViewModelStore(false)
	local v = React.useMemo(function()
		return {
			title = conversationViewModelStore.getTitle(data.conversationId),
			subtitle = conversationViewModelStore.getSubtitle(data.conversationId),
			isSubtitlePending = conversationViewModelStore.getIsSubtitlePending(data.conversationId),
			hasUnreadMessages = conversationViewModelStore.getHasUnreadMessages(data.conversationId),
			hasGroupUp = conversationViewModelStore.getHasGroupUp(data.conversationId),
			shouldShowOSA = conversationViewModelStore.getShouldShowOSA(data.conversationId),
			shouldShowU13ChatOptIn = conversationViewModelStore.getShouldShowU13ChatOptIn(data.conversationId),
			conversationType = conversationViewModelStore.getConversationType(data.conversationId),
			unixTime = conversationViewModelStore.getUnixTime(data.conversationId),
			testId = conversationViewModelStore.getTestId(data.conversationId),
			locatorTitle = conversationViewModelStore.getLocatorTitle(data.conversationId)
		}
	end, { conversationViewModelStore, data.conversationId })
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return conversationStore.getConversation(data.conversationId, p)
		end)
	end, { conversationStore, data.conversationId })
	local v3 = SignalsReact.useSignalState(v2)
	local v4 = SignalsReact.useSignalState(v.title)
	local v5 = SignalsReact.useSignalState(v.subtitle)
	local v6 = SignalsReact.useSignalState(v.isSubtitlePending)
	local v7 = SignalsReact.useSignalState(v.hasUnreadMessages)
	local v8 = SignalsReact.useSignalState(v.hasGroupUp)
	local shouldShowOSA = SignalsReact.useSignalState(v.shouldShowOSA)
	local shouldShowU13ChatOptIn = SignalsReact.useSignalState(v.shouldShowU13ChatOptIn)
	local conversationType = SignalsReact.useSignalState(v.conversationType)
	local v9 = SignalsReact.useSignalState(v.unixTime)
	local testId = SignalsReact.useSignalState(v.testId)
	local locatorTitle = SignalsReact.useSignalState(v.locatorTitle)
	local hasConversation = v4 ~= nil
	local v10 = useChatPagePadding()
	local v11 = ChatPlacementContext.useChatPlacementContext()
	local v12

	if FFlagAppThemeHalloween2026ChatBackground then
		v12 = useThemeBackground() ~= nil
	else
		v12 = false
	end

	local telemetry = useTelemetry(ChatLandingTelemetryLayer.Context)
	local timestampText = useRelativeTimestampBinding(v9)
	local v13 = useLocalization({ pendingSubtitleText = "Feature.Chat.Message.MessageUnavailable" })

	local v14 = useGetOneToOneFriendIdFromConversationId(data.conversationId)

	if not FFlagEnableBlackbirdCheck then
		v14 = nil
	end

	local showSubscriptionBadge = useIsRobloxSubscriber(v14)

	local v15 = useConversationRowActivation({
		conversationId = data.conversationId,
		hasConversation = hasConversation,
		shouldShowOSA = shouldShowOSA,
		shouldShowU13ChatOptIn = shouldShowU13ChatOptIn,
		conversationType = conversationType,
		onActivated = data.onActivated,
		onSquadJoinButtonActivated = data.onSquadJoinButtonActivated,
		fireClickEvent = data.fireClickEvent,
		telemetry = telemetry
	})

	local showingSquadButton = isShowingSquadButton(hasConversation, v8, data.isSquadEnabled) -- inferred equivalent call
	local subtitleText

	if hasConversation and v6 then
		subtitleText = v13.pendingSubtitleText
	else
		subtitleText = not hasConversation and "" or v5
	end

	local ref = React.useRef(nil)
	local onRowActivated = React.useCallback(function()
		v15.onActivated()
	end, { v15.onActivated })

	local isWideMode = data.isWideMode == true

	if FFlagAppChatUseActivationOnFocus then
		useActivationOnFocus(isWideMode, ref, onRowActivated, nil, React.useCallback(function()
			return data.conversationId
		end, { data.conversationId }), nil, conversationFocusActivationDelaySeconds)
	else
		local v16 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			if isWideMode and v16 then
				local v17 = v16.focusedGuiObject:subscribe(function(p)
					if ref.current and p == ref.current then
						onRowActivated()
					end
				end)
				return function()
					v17:unsubscribe()
				end
			end

			return function() end
		end, { onRowActivated, isWideMode, v16 })
	end

	local ref2 = React.useRef(data.fireImpressionEvent)
	local ref3 = React.useRef(nil)
	ref2.current = data.fireImpressionEvent

	React.useEffect(function()
		if ref2.current == nil or not hasConversation or ref3.current == data.conversationId then
			return
		end

		local conversation = conversationStore.getConversation(data.conversationId, false)

		if conversation == nil then
			return
		end

		ref3.current = data.conversationId
		ref2.current(normalizeConversationForTelemetry(conversation))
	end, { data.conversationId, hasConversation, conversationStore })

	local v16 = {
		hasConversation = hasConversation,
		conversationId = data.conversationId,
		title = v4 or "",
		testId = testId,
		locatorTitle = locatorTitle,
		entryHeight = data.entryHeight or 64,
		pagePaddingLeft = v10.left,
		pagePaddingRight = v10.right,
		timestampText = timestampText,
		subtitleText = subtitleText,
		showSubscriptionBadge = showSubscriptionBadge,
		showSquadButton = showingSquadButton,
		showTimestamp = not showingSquadButton,
		showUnread = hasConversation and v7 and not v6,
		showBackground = 0,
		squadLocation = 0,
		participants = 0,
		rowRef = 0,
		onRowActivated = 0,
		onSquadActivated = 0
	}
	local showBackground

	if data.showBackground == nil then
		showBackground = not (ChatPlacementContext.isPlacementInExperience(v11.chatPlacement) or v12)
	else
		showBackground = data.showBackground
	end

	v16.showBackground = showBackground

	v16.squadLocation = v11.chatPlacement
	local participants

	if v3 ~= nil then
		participants = v3.participants
	end

	v16.participants = participants
	v16.rowRef = ref
	v16.onRowActivated = onRowActivated
	v16.onSquadActivated = v15.onSquadActivated
	return v16
end

return useConversationRowPresentation
