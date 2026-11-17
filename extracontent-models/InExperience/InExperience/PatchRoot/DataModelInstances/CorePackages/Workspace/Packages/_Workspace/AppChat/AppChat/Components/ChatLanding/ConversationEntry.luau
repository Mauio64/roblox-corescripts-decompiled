local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local memo = React.memo
local useMemo = React.useMemo
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useRelativeTimestampBinding = require(AppChat.Hooks.useRelativeTimestampBinding)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Cryo = require(parent.Cryo)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local getBoldTextTheme = require(script.Parent.Utils.getBoldTextTheme)

local Cells = require(AppChat.Components.Cells)
local ConversationCell = Cells.ConversationCell
local ConversationRelativeTimestamp = require(script.Parent.ConversationRelativeTimestamp)
local DomLocators = require(AppChat.Utils.DomLocators)
local SquadJoinButton = require(parent.Squads.SquadJoinButton)
local Enums = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums.SquadButtonSourceEnum
local SquadComponentAccessWrapper = require(parent.Squads.SquadComponentAccessWrapper)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useActivationOnFocus = FocusNavigationUtils.useActivationOnFocus

local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatTimestampInSubtitle = require(AppChat.Flags.FFlagAppChatTimestampInSubtitle)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatUseActivationOnFocus = SharedFlags.FFlagAppChatUseActivationOnFocus
local conversationFocusActivationDelaySeconds = require(AppChat.Flags.conversationFocusActivationDelaySeconds)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatEnableU13ChatOptIn = SharedFlags2.FFlagAppChatEnableU13ChatOptIn

local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)

local Constants = require(AppChat.Constants)

local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)

local EnumScreens = require(AppChat.EnumScreens)
local Conversation = require(AppChat.Models.Conversation)
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)

local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext

local useCanAccessParty = require(parent.Squads.useCanAccessParty)

require(AppChat.types)

local v = {
	entryHeight = 64,
	boldTitle = true,
	onSquadJoinButtonActivated = function() end
}

local function ConversationEntry(p)
	local joined = Cryo.Dictionary.join(v, p)
	local style = useStyle()
	local v2 = useTokens()
	local v3 = useTextSizeOffset()
	local v4 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local conversation = joined.conversation
	local hasGroupUp = conversation.hasGroupUp

	local v5 = useIsUserPending(conversation)
	local hasUnreadMessages = conversation.hasUnreadMessages and not v5
	local boldTitle = hasUnreadMessages and not hasUnreadMessages

	if boldTitle then
		style = getBoldTextTheme(style)
	end

	local v6 = useDispatch()
	local v7 = useChatPlacementContext()
	local v8 = useChatPagePadding()

	local captionSubHeader = style.Font.CaptionSubHeader
	local v9 = style.Font.BaseSize * captionSubHeader.RelativeSize
	local shortRelativeTime = joined.conversation.shortRelativeTime or ""
	local timestampText = useRelativeTimestampBinding(joined.conversation.unixTime)

	local v10 = useMemo(function()
		return GetTextSize(shortRelativeTime, v9, v2.Typography.CaptionLarge.Font, Vector2.new(10000, 10000)).X
	end, { shortRelativeTime, captionSubHeader.Font, v9, v3, v2.Typography.CaptionLarge.Font })
	local subTitleTimestamp

	if FFlagAppChatTimestampInSubtitle then
		subTitleTimestamp = timestampText
	end

	local ref = React.useRef(nil)
	local v11 = useNavigation()
	local v12 = false

	if v11.getScreenProps then
		v12 = v11.getScreenProps("wideMode", v12)
	end

	React.useEffect(function()
		joined.fireImpressionEvent(joined.conversation)
	end, {})

	local overlayStore = GetOverlayStore(false)

	local v13 = React.useCallback(function(conversationId: string)
		v11.navigate(EnumScreens.ChatConversation, {
			conversationId = conversationId,
			isNavigatedFromGroupOSAJoin = true
		})
	end, { v11 })

	local v14 = React.useCallback(
		function(conversationId: string, impressionId: string?, modalVariant: string?, p2: string?, callback)
			overlayStore.showOverlay(OverlayTypes.GroupOSADialog, {
				conversationId = conversationId,
				impressionId = impressionId,
				modalVariant = modalVariant,
				onJoin = function()
					overlayStore.dismissOverlay()

					if callback then
						callback(conversationId)
					else
						v13(conversationId)
					end
				end,
				onDecline = function()
					if conversationId and p2 == Conversation.Type.MULTI_USER_CONVERSATION then
						v6(RemovedConversation(conversationId))
					end

					overlayStore.dismissOverlay()
				end
			})
		end,
		{ v13, v6 }
	)

	local onActivated = React.useCallback(function(p2)
		local v15 = nil
		local v16 = nil

		if shouldShowU13ChatOptInForConversation(p2) then
			v16 = Constants.OptInVariant.ChatOptInInfoCard
		elseif shouldShowOSAForConversation(p2) then
			v16 = Constants.OptInVariant.OsaContextCard
		end

		if v16 then
			v15 = HttpService:GenerateGUID(false)
			v14(p2.id, v15, v16, p2.conversationType)
		elseif joined.onActivated then
			joined.onActivated(p2)
		end

		joined.fireClickEvent(p2, v4, v15)
	end, { v14, joined.onActivated, joined.fireClickEvent, v4 })

	local onSquadJoinButtonActivated = joined.onSquadJoinButtonActivated
	local onActivated2 = React.useCallback(function(p2: string)
		local v15 = nil

		if shouldShowOSAForConversation(conversation) then
			v15 = Constants.OptInVariant.OsaContextCard
		elseif
			FFlagAppChatEnableU13ChatOptIn
			and shouldShowU13ChatOptInForConversation(conversation)
			and conversation.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		then
			v15 = Constants.OptInVariant.ChatOptInInfoCard
		end

		if v15 and v14 then
			v14(p2, HttpService:GenerateGUID(false), v15, conversation.conversationType, onSquadJoinButtonActivated)
		elseif onSquadJoinButtonActivated then
			onSquadJoinButtonActivated(p2)
		end
	end, { v14, conversation, onSquadJoinButtonActivated })

	if FFlagAppChatUseActivationOnFocus then
		useActivationOnFocus(v12, ref, function()
			onActivated(conversation)
		end, function(p2)
			return if p2 then p2.cell else nil
		end, function()
			return conversation and conversation.id
		end, nil, conversationFocusActivationDelaySeconds)
	else
		local v15 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			if v12 and onActivated and v15 then
				local v16 = v15.focusedGuiObject:subscribe(function(p2)
					if ref.current and p2 == ref.current.cell then
						onActivated(conversation)
					end
				end)
				return function()
					v16:unsubscribe()
				end
			end

			return function() end
		end, { onActivated, v12, v15 })
	end

	local children = joined.children or {}

	local size_1900 = v2.Size.Size_1900

	local v15 = useCanAccessParty()

	local v16 = not hasUnreadMessages and 0 or v2.Size.Size_200 + v2.Gap.XSmall

	local right = v8.right
	local childWidth

	if v15 and hasGroupUp then
		childWidth = right + size_1900
	elseif FFlagAppChatTimestampInSubtitle then
		childWidth = not hasUnreadMessages and 0 or v2.Gap.Medium + v2.Size.Size_200
	else
		childWidth = v10 + v16 + right
	end

	local squadButton

	if v15 and hasGroupUp and conversation.id then
		local createElement = React.createElement
		local v17 = { parentChannelId = conversation.id }

		local createElement2 = React.createElement
		local v18 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, size_1900, 1, 0),
			LayoutOrder = 2
		}

		local v19 = {
			layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			padding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, 0) }),
			button = 0
		}

		local createElement3 = React.createElement
		local v20 = {
			conversationId = conversation.id,
			isFullWidth = false,
			isInCard = false,
			layoutOrder = 0,
			onActivated = onActivated2,
			Selectable = false,
			shouldAnimate = false,
			squadLocation = v7.chatPlacement,
			squadButtonSource = SquadButtonSourceEnum.ConversationEntry,
			testId = 0
		}
		local testId

		if FFlagDebugAppChatEnableDomLocators then
			testId = DomLocators.chatLandingConversationEntrySquadButton(conversation.title)
		end

		v20.testId = testId
		v19.button = createElement3(SquadJoinButton, v20)
		squadButton = createElement(SquadComponentAccessWrapper, v17, { createElement2("Frame", v18, {}, v19) })
	end

	local createElement = React.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 0, joined.entryHeight),
		BackgroundTransparency = 1,
		ref = ref
	}

	local createElement2 = React.createElement

	local v18 = {
		Size = UDim2.new(1, 0, 0, joined.entryHeight),
		conversation = joined.conversation,
		childWidth = childWidth,
		subTitleText = 0,
		subTitleTimestamp = 0,
		onActivated = 0,
		style = 0,
		boldTitle = 0,
		hideLeftAvatarPadding = true,
		onSquadJoinButtonActivated = 0,
		paddingLeft = 0,
		paddingRight = 0,
		testId = 0
	}
	local subTitleText

	if getFFlagDebugAppChat() then
		subTitleText = joined.conversation.id
	else
		subTitleText = joined.conversation.lastMessageContent
	end

	v18.subTitleText = subTitleText

	v18.subTitleTimestamp = subTitleTimestamp
	v18.onActivated = onActivated
	v18.style = style
	v18.boldTitle = boldTitle

	v18.onSquadJoinButtonActivated = joined.onSquadJoinButtonActivated
	v18.paddingLeft = v8.left
	v18.paddingRight = v8.right
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatLandingConversationEntry(conversation.title)
	end

	v18.testId = testId

	local join = Cryo.Dictionary.join
	local timeStamp

	if not (squadButton or FFlagAppChatTimestampInSubtitle) then
		timeStamp = React.createElement(ConversationRelativeTimestamp, {
			timestampText = timestampText,
			hasUnreadMessages = hasUnreadMessages
		})
	end

	local unreadDot

	if FFlagAppChatTimestampInSubtitle and not squadButton and hasUnreadMessages then
		unreadDot = React.createElement(Foundation.View, {
			tag = "size-200-200 radius-circle bg-action-emphasis"
		})
	end

	return createElement("Frame", v17, {
		cell = createElement2(
			ConversationCell,
			v18,
			join(children, {
				timeStamp = timeStamp,
				unreadDot = unreadDot,
				squadButton = squadButton
			})
		)
	})
end

return memo(ConversationEntry)
