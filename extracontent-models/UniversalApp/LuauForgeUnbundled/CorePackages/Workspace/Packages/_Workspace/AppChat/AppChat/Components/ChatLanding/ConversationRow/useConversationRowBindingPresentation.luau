local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground").useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationViewModelStore")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagAppChatUseActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatUseActivationOnFocus
local conversationFocusActivationDelaySeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/conversationFocusActivationDelaySeconds")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatUseBindingConversationFacePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseBindingConversationFacePile")

local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
local useActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").useActivationOnFocus
local useConversationRowActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/useConversationRowActivation")
local useRelativeTimestampSignalBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/useRelativeTimestampSignalBinding")
local normalizeConversationForTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/normalizeConversationForTelemetry")

local function useSubscriptionBadgeVisibility(itemSignal, p2)
	local v5, v6 = React.useBinding(false)
	local v7 = UserProfiles.Stores.UserProfileStore.get()

	React.useLayoutEffect(function()
		if not (fFlagEnableBlackbirdCheck and FFlagAppChatUseBindingConversationFacePile) then
			return
		end

		local v8 = nil
		local v9 = nil
		local v10 = false

		return Signals.createEffect(function(p3)
			local v11 = itemSignal(p3)
			local conversation = p2.getConversation(v11.id, p3)
			local v12 = getOtherParticipants(conversation, v11.presentationSignal(p3).localUserId)
			local v13

			if not (conversation == nil or conversation.type ~= "one_to_one" or #v12 ~= 1) then
				v13 = tostring(v12[1])
			end

			if v13 ~= v8 then
				v8 = v13
				v9 = if v13 ~= nil then v7.fetchNamesByUserIds({ v13 }) else nil
			end

			local v14 = false

			if v9 ~= nil then
				local success, result = pcall(v9, p3)

				if success and result.status == "success" and #result.data > 0 then
					local v15 = result.data[1]
					v14 = not (v15.getHasRobloxSubscription == nil)
						and v15.getHasRobloxSubscription(p3) == true
				end
			end

			if v14 ~= v10 then
				v10 = v14
				v6(v14)
			end
		end)
	end, { p2, itemSignal, v6, v7 })

	return v5
end

local function useConversationRowBindingPresentation(p2)
	local v5 = GetConversationStore(false)
	local v6 = GetConversationViewModelStore(false)
	local pendingSubtitleText = useLocalization({
		pendingSubtitleText = "Feature.Chat.Message.MessageUnavailable"
	}).pendingSubtitleText

	local v7 = React.useMemo(function()
		local function getConversationId(p3)
			return p2.itemSignal(p3).id
		end

		return {
			conversationId = Signals.createComputed(getConversationId),
			presentation = Signals.createComputed(function(p3)
				return p2.itemSignal(p3).presentationSignal(p3)
			end),
			hasConversation = Signals.createComputed(function(p3): boolean
				return v6.getTitle(p2.itemSignal(p3).id)(p3) ~= nil
			end),
			shouldShowOSA = Signals.createComputed(function(p3)
				return v6.getShouldShowOSA(p2.itemSignal(p3).id)(p3)
			end),
			shouldShowU13ChatOptIn = Signals.createComputed(function(p3)
				return v6.getShouldShowU13ChatOptIn(p2.itemSignal(p3).id)(p3)
			end),
			conversationType = Signals.createComputed(function(p3)
				return v6.getConversationType(p2.itemSignal(p3).id)(p3)
			end),
			testId = Signals.createComputed(function(p3)
				if FFlagDebugAppChatEnableDomLocators then
					return (v6.getTestId(p2.itemSignal(p3).id)(p3))
				end

				return nil
			end),
			locatorTitle = Signals.createComputed(function(p3)
				if FFlagDebugAppChatEnableDomLocators then
					return (v6.getLocatorTitle(p2.itemSignal(p3).id)(p3))
				end

				return nil
			end),
			showSquadButton = Signals.createComputed(function(p3): boolean
				local itemSignal = p2.itemSignal(p3)
				return itemSignal.presentationSignal(p3).isSquadEnabled == true
					and v6.getTitle(itemSignal.id)(p3) ~= nil
					and v6.getHasGroupUp(itemSignal.id)(p3) == true
			end)
		}
	end, { v6, p2.itemSignal })

	local v8 = SignalsReact.useSignalState(v7.presentation)
	local v9 = SignalsReact.useSignalState(v7.hasConversation)
	local v10 = SignalsReact.useSignalState(v7.shouldShowOSA)
	local v11 = SignalsReact.useSignalState(v7.shouldShowU13ChatOptIn)
	local v12 = SignalsReact.useSignalState(v7.conversationType)
	local v13 = SignalsReact.useSignalState(v7.testId)
	local v14 = SignalsReact.useSignalState(v7.locatorTitle)
	local v15 = SignalsReact.useSignalState(v7.showSquadButton)

	local v16 = React.useCallback(function(p3, p4)
		return v6.getTitle(p3.id)(p4) or ""
	end, { v6 })
	local v17 = React.useCallback(function(p3, p4)
		local title = v6.getTitle(p3.id)
		local isSubtitlePending = v6.getIsSubtitlePending(p3.id)

		if title(p4) == nil then
			return ""
		end

		if isSubtitlePending(p4) then
			return pendingSubtitleText
		end

		return v6.getSubtitle(p3.id)(p4) or ""
	end, { v6, pendingSubtitleText })
	local v18 = React.useCallback(function(p3, p4): boolean
		return v6.getTitle(p3.id)(p4) ~= nil
			and v6.getHasUnreadMessages(p3.id)(p4) == true
			and not v6.getIsSubtitlePending(p3.id)(p4)
	end, { v6 })
	local v19 = React.useCallback(function(p3, p4)
		return v6.getUnixTime(p3.id)(p4)
	end, { v6 })
	local v20 = React.useCallback(function(p3)
		return p3.id
	end, {})
	local v21 = SignalsReact.useSignalBinding(function(p3)
		return v16(p2.itemSignal(p3), p3)
	end)

	local v22 = SignalsReact.useSignalBinding(function(p3)
		return v17(p2.itemSignal(p3), p3)
	end)

	local v23 = SignalsReact.useSignalBinding(function(p3)
		return v18(p2.itemSignal(p3), p3)
	end)

	local v24 = useRelativeTimestampSignalBinding(p2.itemSignal, v19)

	local v26 = useSubscriptionBadgeVisibility(p2.itemSignal, v5)
	local v27 = SignalsReact.useSignalBinding(function(p3)
		return v20(p2.itemSignal(p3))
	end)

	local v28 = useChatPagePadding()
	local v29 = ChatPlacementContext.useChatPlacementContext()

	local v30 = if FFlagAppThemeHalloween2026ChatBackground then useThemeBackground() ~= nil else false

	local v31 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v32 = React.useCallback(function()
		local itemSignal = p2.itemSignal(false)
		local id = itemSignal.id
		local presentationSignal = itemSignal.presentationSignal(false)
		return {
			conversationId = id,
			hasConversation = v6.getTitle(id)(false) ~= nil,
			shouldShowOSA = v6.getShouldShowOSA(id)(false),
			shouldShowU13ChatOptIn = v6.getShouldShowU13ChatOptIn(id)(false),
			conversationType = v6.getConversationType(id)(false),
			onActivated = presentationSignal.onActivated,
			onSquadJoinButtonActivated = presentationSignal.onSquadJoinButtonActivated,
			fireClickEvent = presentationSignal.fireClickEvent
		}
	end, { v6, p2.itemSignal })

	local v33 = useConversationRowActivation({
		conversationId = v7.conversationId(false),
		hasConversation = v9,
		shouldShowOSA = v10,
		shouldShowU13ChatOptIn = v11,
		conversationType = v12,
		onActivated = v8.onActivated,
		onSquadJoinButtonActivated = v8.onSquadJoinButtonActivated,
		fireClickEvent = v8.fireClickEvent,
		telemetry = v31,
		getCurrentOptions = v32
	})

	local ref = React.useRef(nil)
	local onActivated = v33.onActivated
	local isWideMode = v8.isWideMode == true

	if fFlagAppChatUseActivationOnFocus then
		useActivationOnFocus(isWideMode, ref, onActivated, nil, React.useCallback(function()
			return p2.itemSignal(false).id
		end, { p2.itemSignal }), nil, conversationFocusActivationDelaySeconds)
	else
		local v34 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			if isWideMode and v34 then
				local v35 = v34.focusedGuiObject:subscribe(function(p3)
					if ref.current and p3 == ref.current then
						onActivated()
					end
				end)
				return function()
					v35:unsubscribe()
				end
			end

			return function() end
		end, { onActivated, isWideMode, v34, ref })
	end

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		return Signals.createEffect(function(p3)
			local itemSignal = p2.itemSignal(p3)
			local fireImpressionEvent = itemSignal.presentationSignal(p3).fireImpressionEvent

			if fireImpressionEvent == nil or ref2.current == itemSignal.id then
				return
			end

			local conversation = v5.getConversation(itemSignal.id, p3)

			if conversation == nil then
				return
			end

			ref2.current = itemSignal.id
			fireImpressionEvent(normalizeConversationForTelemetry(conversation))
		end)
	end, { v5, p2.itemSignal })

	local v34 = {
		hasConversation = v9,
		title = v21,
		testId = v13,
		locatorTitle = v14,
		entryHeight = v8.entryHeight or 64,
		pagePaddingLeft = v28.left,
		pagePaddingRight = v28.right,
		timestampText = v24,
		subtitleText = v22,
		showSubscriptionBadge = v26,
		showSquadButton = v15,
		showTimestamp = not v15,
		showUnread = v23,
		squadLocation = v29.chatPlacement,
		rowRef = ref,
		onRowActivated = onActivated,
		onSquadActivated = v33.onSquadActivated,
		showBackground = 0,
		debugCellValue = 0
	}
	local v35 = if v8.showBackground == nil then not (ChatPlacementContext.isPlacementInExperience(v29.chatPlacement) or v30) else v8.showBackground
	v34.showBackground = v35

	if not v8.isDebugEnabled then
		v27 = nil
	end

	v34.debugCellValue = v27
	return v34
end

return useConversationRowBindingPresentation
