local Players = game:GetService("Players")

local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local AppChatNetworking = require(parent.AppChatNetworking)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local SharedFlags = require(parent.SharedFlags)

require(parent.AppChat.ConversationChannels)
local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)
local GetConversationStore = require(parent.AppChat.GetConversationStore)

local FFlagDebugFriendsChat = require(script.Parent.Parent.Flags.FFlagDebugFriendsChat)
local FFlagFriendsChatBubbleMessages = require(script.Parent.Parent.Flags.FFlagFriendsChatBubbleMessages)
local FFlagFriendsChatMessageListHeaderFade = require(script.Parent.Parent.Flags.FFlagFriendsChatMessageListHeaderFade)
local FFlagFriendsChatPaginateOlderMessages = require(script.Parent.Parent.Flags.FFlagFriendsChatPaginateOlderMessages)
local FIntFriendsChatBubbleMaxMessages = require(script.Parent.Parent.Flags.FIntFriendsChatBubbleMaxMessages)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav
local FStringDebugFriendsChatConversationId = require(script.Parent.Parent.Flags.FStringDebugFriendsChatConversationId)

local useInterpolatedClientSettings = require(parent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(parent.ExpChatIntegration.useChatWindowSettings)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local FriendsChatConversationHeaderBar = require(script.Parent.Parent.HeaderBar.FriendsChatConversationHeaderBar)
local FriendsChatBubbleMessageListContainer = require(script.Parent.FriendsChatBubbleMessageListContainer)
local FriendsChatChatWindowSlot = require(script.Parent.FriendsChatChatWindowSlot)
local FriendsChatInputBarHost = require(script.Parent.FriendsChatInputBarHost)
local useFocusInputBarOnWindowEnter = require(script.Parent.useFocusInputBarOnWindowEnter)
local FriendsChatOsaAcknowledgement = require(script.Parent.FriendsChatOsaAcknowledgement)
local useConversationHeaderFadeLayout = require(script.Parent.useConversationHeaderFadeLayout)
local useConversationHeaderProps = require(script.Parent.useConversationHeaderProps)
local useConversationModerationType = require(script.Parent.useConversationModerationType)
local useFetchAllOlderMessages = require(script.Parent.useFetchAllOlderMessages)
local useFetchNewestMessagePage = require(script.Parent.useFetchNewestMessagePage)
local resolveFade = require(script.Parent.Parent.Utils.resolveFade)
local LayoutConstants = require(FriendsChat.LayoutConstants)

local useFriendsChatConversationTelemetry = require(script.Parent.Parent.Telemetry.ChatConversation.useFriendsChatConversationTelemetry)

local function FriendsChatConversationWindow(props)
	local v = useChatWindowSettings()
	local v2 = React.useMemo(function()
		return {
			BackgroundColor3 = v.ChatWindowBackgroundColor3,
			BackgroundTransparency = v.ChatWindowBackgroundTransparency
		}
	end, { v })
	local chatWindowSettings = props.chatWindowSettings or v2
	local v3 = useInterpolatedClientSettings(chatWindowSettings)

	local conversationId = props.conversationId or ""

	if conversationId == "" and FFlagDebugFriendsChat then
		conversationId = FStringDebugFriendsChatConversationId
	end

	local hasConversationId = conversationId ~= ""
	local localPlayer = Players.LocalPlayer
	local localUserId = not localPlayer and 0 or localPlayer.UserId

	local friendPlaceholder = ExpChatConversationListAdapter.isFriendPlaceholder(conversationId)
	local isRealConversation = hasConversationId and not friendPlaceholder
	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local conversation = GetConversationStore(p).getConversation(conversationId, p)

			if conversation then
				return conversation.osaAcknowledgementStatus
			end

			return nil
		end)
	end, { conversationId })
	local shouldOpenToOsaSystemMessage

	if SignalsReact.useSignalState(v4) == AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Unacknowledged then
		shouldOpenToOsaSystemMessage = not FriendsChatOsaAcknowledgement.hasSubmitted(conversationId)
	else
		shouldOpenToOsaSystemMessage = false
	end

	local v5 = useConversationHeaderProps({
		conversationId = conversationId,
		hasConversationId = hasConversationId,
		localUserId = localUserId
	})

	local conversationModerationType = useConversationModerationType({
		conversationId = conversationId,
		hasConversationId = hasConversationId
	})

	React.useEffect(function()
		if hasConversationId then
			ExpChatConversationListAdapter.markConversationRead(conversationId)
		end
	end, { conversationId, hasConversationId })

	local v6 = useFetchNewestMessagePage(conversationId, isRealConversation, FFlagFriendsChatBubbleMessages)

	local v7 = FFlagFriendsChatPaginateOlderMessages and FFlagFriendsChatBubbleMessages

	if v7 then
		if FIntFriendsChatBubbleMaxMessages == 0 then
			v7 = isRealConversation and shouldOpenToOsaSystemMessage
		else
			v7 = false
		end
	end

	local v8 = not FFlagFriendsChatPaginateOlderMessages or useFetchAllOlderMessages(conversationId, v7 and v6)

	local v9 = useFriendsChatConversationTelemetry({
		conversationId = conversationId,
		getLoadedMessageCount = React.useCallback(function()
			if hasConversationId then
				return #GetConversationMessageListStore(false).getOrderedIds(conversationId, false)
			end

			return 0
		end, { conversationId, hasConversationId })
	})

	local parentLayoutOrder = props.parentLayoutOrder or 1

	local onOpenDetails = props.onOpenDetails
	local fireInfoButtonClicked = v9.fireInfoButtonClicked
	local onActivated = React.useCallback(function()
		fireInfoButtonClicked()
		onOpenDetails(conversationId)
	end, { fireInfoButtonClicked, onOpenDetails, conversationId })

	local fadeLayout = useConversationHeaderFadeLayout({
		transparencyValue = props.transparencyValue,
		conversationId = conversationId
	})

	local ref = React.useRef(nil)

	if not FFlagFriendsChatConversationListFocusNav then
		ref = nil
	end

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4

	if FFlagFriendsChatConversationListFocusNav then
		ref4 = ref2
	end

	local rootRef

	if FFlagFriendsChatConversationListFocusNav then
		rootRef = ref3
	end

	useFocusInputBarOnWindowEnter(ref2, ref3)

	local createElement = React.createElement
	local participantUserIds

	if v5 then
		participantUserIds = v5.participantUserIds
	end

	local titleText

	if v5 then
		titleText = v5.titleText
	end

	local v10 = {
		layoutOrder = 1,
		backButtonRef = ref,
		localUserId = localUserId,
		participantUserIds = participantUserIds,
		titleText = titleText,
		chatWindowSettings = chatWindowSettings,
		suppressBackground = true,
		transparencyValue = props.transparencyValue,
		onHovered = props.onHovered,
		onUnhovered = props.onUnhovered,
		onBack = props.onBack,
		onActivated = 0,
		onAbsoluteSizeChanged = 0,
		interactable = 0,
		zIndex = 2
	}

	if not (props.onOpenDetails and isRealConversation) then
		onActivated = nil
	end

	v10.onActivated = onActivated
	v10.onAbsoluteSizeChanged = fadeLayout.onHeaderAbsoluteSizeChanged
	v10.interactable = fadeLayout.headerInteractable
	local element = createElement(FriendsChatConversationHeaderBar, v10)
	local windowSlot

	if FFlagFriendsChatBubbleMessages then
		local createElement2 = React.createElement
		local v11 = {
			layoutOrder = 2,
			conversationId = conversationId,
			hasConversationId = hasConversationId,
			isRealConversation = isRealConversation,
			hasLoadedNewestPage = v6 and v8,
			shouldOpenToOsaSystemMessage = shouldOpenToOsaSystemMessage,
			topInset = 0,
			chatWindowSettings = 0,
			isSpatialUIEnabled = 0,
			textTransparency = 0,
			onHovered = 0,
			onUnhovered = 0,
			onAbsoluteSizeChanged = 0,
			onAbsolutePositionChanged = 0
		}
		local topInset

		if FFlagFriendsChatMessageListHeaderFade and ChatUIPrimitives.Flags.FFlagExpChatMessageListScrollParity then
			topInset = fadeLayout.headerVisibleHeight
		else
			topInset = fadeLayout.headerHeight
		end

		v11.topInset = topInset

		v11.chatWindowSettings = chatWindowSettings
		v11.isSpatialUIEnabled = props.isSpatialUIEnabled
		v11.textTransparency = props.textTransparency
		v11.onHovered = props.onHovered
		v11.onUnhovered = props.onUnhovered
		v11.onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
		v11.onAbsolutePositionChanged = props.onAbsolutePositionChanged
		windowSlot = createElement2(FriendsChatBubbleMessageListContainer, v11)
	else
		windowSlot = React.createElement(FriendsChatChatWindowSlot, {
			layoutOrder = 2,
			conversationId = conversationId,
			hasConversationId = hasConversationId,
			fadeLayout = fadeLayout,
			hostChatWindowSettings = props.chatWindowSettings,
			chatWindowSettings = chatWindowSettings,
			transparencyValue = props.transparencyValue,
			textTransparency = props.textTransparency,
			isSpatialUIEnabled = props.isSpatialUIEnabled,
			isChannelBarVisible = props.isChannelBarVisible,
			shouldOpenToOsaSystemMessage = shouldOpenToOsaSystemMessage,
			onHovered = props.onHovered,
			onUnhovered = props.onUnhovered,
			onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = props.onAbsolutePositionChanged
		})
	end

	return React.createElement(React.Fragment, nil, {
		friendsChatHeaderWindow = React.createElement("Frame", {
			Name = "FriendsChatHeaderWindow",
			LayoutOrder = parentLayoutOrder,
			BackgroundColor3 = v3.BackgroundColor3 or v3.BackgroundColor or v.ChatWindowBackgroundColor3,
			BackgroundTransparency = resolveFade(v3.BackgroundTransparency, props.transparencyValue),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight),
			ref = ref4
		}, {
			layout = React.createElement("UIListLayout", {
				Name = "FriendsChatHeaderWindowLayout",
				FillDirection = Enum.FillDirection.Vertical,
				Padding = fadeLayout.headerLayoutPadding,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			header = element,
			windowSlot = windowSlot
		}),
		friendsChatInput = React.createElement(FriendsChatInputBarHost, {
			LayoutOrder = parentLayoutOrder + 1,
			conversationId = conversationId,
			conversationModerationType = conversationModerationType,
			onFriendPlaceholderConversationCreated = props.onFriendPlaceholderConversationCreated,
			chatWindowSettings = props.chatWindowSettings,
			transparencyValue = props.transparencyValue,
			isSpatialUIEnabled = props.isSpatialUIEnabled,
			onHovered = props.onHovered,
			onUnhovered = props.onUnhovered,
			backButtonRef = ref,
			rootRef = rootRef
		})
	})
end

return FriendsChatConversationWindow
