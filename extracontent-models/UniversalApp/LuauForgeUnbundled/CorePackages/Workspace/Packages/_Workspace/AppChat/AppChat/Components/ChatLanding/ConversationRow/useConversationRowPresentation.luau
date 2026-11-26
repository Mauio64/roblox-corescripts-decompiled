local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground").useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")
local useRelativeTimestampBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRelativeTimestampBinding")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationViewModelStore")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagAppChatUseActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatUseActivationOnFocus
local conversationFocusActivationDelaySeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/conversationFocusActivationDelaySeconds")
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles").Hooks.useIsRobloxSubscriber

local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")
local useActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").useActivationOnFocus
local useConversationRowActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/useConversationRowActivation")
local normalizeConversationForTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/normalizeConversationForTelemetry")

local function isShowingSquadButton(p2, p3, p4)
	return p4 == true and p2 and p3
end

local function useConversationRowPresentation(data)
	local v5 = GetConversationStore(false)
	local v6 = GetConversationViewModelStore(false)
	local v7 = React.useMemo(function()
		return {
			title = v6.getTitle(data.conversationId),
			subtitle = v6.getSubtitle(data.conversationId),
			isSubtitlePending = v6.getIsSubtitlePending(data.conversationId),
			hasUnreadMessages = v6.getHasUnreadMessages(data.conversationId),
			hasGroupUp = v6.getHasGroupUp(data.conversationId),
			shouldShowOSA = v6.getShouldShowOSA(data.conversationId),
			shouldShowU13ChatOptIn = v6.getShouldShowU13ChatOptIn(data.conversationId),
			conversationType = v6.getConversationType(data.conversationId),
			unixTime = v6.getUnixTime(data.conversationId),
			testId = v6.getTestId(data.conversationId),
			locatorTitle = v6.getLocatorTitle(data.conversationId)
		}
	end, { v6, data.conversationId })
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return v5.getConversation(data.conversationId, p2)
		end)
	end, { v5, data.conversationId })
	local v9 = SignalsReact.useSignalState(v8)
	local v10 = SignalsReact.useSignalState(v7.title)
	local v11 = SignalsReact.useSignalState(v7.subtitle)
	local v12 = SignalsReact.useSignalState(v7.isSubtitlePending)
	local v13 = SignalsReact.useSignalState(v7.hasUnreadMessages)
	local v14 = SignalsReact.useSignalState(v7.hasGroupUp)
	local v15 = SignalsReact.useSignalState(v7.shouldShowOSA)
	local v16 = SignalsReact.useSignalState(v7.shouldShowU13ChatOptIn)
	local v17 = SignalsReact.useSignalState(v7.conversationType)
	local v18 = SignalsReact.useSignalState(v7.unixTime)
	local v19 = SignalsReact.useSignalState(v7.testId)
	local v20 = SignalsReact.useSignalState(v7.locatorTitle)
	local v21 = v10 ~= nil
	local v22 = useChatPagePadding()
	local v23 = ChatPlacementContext.useChatPlacementContext()

	local v24 = if FFlagAppThemeHalloween2026ChatBackground then useThemeBackground() ~= nil else false

	local v25 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v26 = useRelativeTimestampBinding(v18)
	local v27 = useLocalization({
		pendingSubtitleText = "Feature.Chat.Message.MessageUnavailable"
	})

	local v28 = useGetOneToOneFriendIdFromConversationId(data.conversationId)

	if not fFlagEnableBlackbirdCheck then
		v28 = nil
	end

	local v30 = useIsRobloxSubscriber(v28)

	local v31 = useConversationRowActivation({
		conversationId = data.conversationId,
		hasConversation = v21,
		shouldShowOSA = v15,
		shouldShowU13ChatOptIn = v16,
		conversationType = v17,
		onActivated = data.onActivated,
		onSquadJoinButtonActivated = data.onSquadJoinButtonActivated,
		fireClickEvent = data.fireClickEvent,
		telemetry = v25
	})
	local v32 = data.isSquadEnabled == true and (v21 and v14)

	local v35 = if v21 and v12 then v27.pendingSubtitleText else not v21 and "" or v11

	local ref = React.useRef(nil)
	local v36 = React.useCallback(function()
		v31.onActivated()
	end, { v31.onActivated })

	local isWideMode = data.isWideMode == true

	if fFlagAppChatUseActivationOnFocus then
		useActivationOnFocus(isWideMode, ref, v36, nil, React.useCallback(function()
			return data.conversationId
		end, { data.conversationId }), nil, conversationFocusActivationDelaySeconds)
	else
		local v37 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			if isWideMode and v37 then
				local v38 = v37.focusedGuiObject:subscribe(function(p2)
					if ref.current and p2 == ref.current then
						v36()
					end
				end)
				return function()
					v38:unsubscribe()
				end
			end

			return function() end
		end, { v36, isWideMode, v37 })
	end

	local ref2 = React.useRef(data.fireImpressionEvent)
	local ref3 = React.useRef(nil)
	ref2.current = data.fireImpressionEvent

	React.useEffect(function()
		if ref2.current == nil or not v21 or ref3.current == data.conversationId then
			return
		end

		local conversation = v5.getConversation(data.conversationId, false)

		if conversation == nil then
			return
		end

		ref3.current = data.conversationId
		ref2.current(normalizeConversationForTelemetry(conversation))
	end, { data.conversationId, v21, v5 })

	local v37 = {
		hasConversation = v21,
		conversationId = data.conversationId,
		title = v10 or "",
		testId = v19,
		locatorTitle = v20,
		entryHeight = data.entryHeight or 64,
		pagePaddingLeft = v22.left,
		pagePaddingRight = v22.right,
		timestampText = v26,
		subtitleText = v35,
		showSubscriptionBadge = v30,
		showSquadButton = v32,
		showTimestamp = not v32,
		showUnread = v21 and v13 and not v12,
		showBackground = 0,
		squadLocation = 0,
		participants = 0,
		rowRef = 0,
		onRowActivated = 0,
		onSquadActivated = 0
	}

	local v38 = if data.showBackground == nil then not (ChatPlacementContext.isPlacementInExperience(v23.chatPlacement) or v24) else data.showBackground
	v37.showBackground = v38

	v37.squadLocation = v23.chatPlacement
	local v39 = if v9 ~= nil then v9.participants else nil
	v37.participants = v39
	v37.rowRef = ref
	v37.onRowActivated = v36
	v37.onSquadActivated = v31.onSquadActivated
	return v37
end

return useConversationRowPresentation
