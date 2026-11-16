local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useMemo = React.useMemo
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local useRelativeTimestampBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRelativeTimestampBinding")
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local getBoldTextTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getBoldTextTheme")

local conversationCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells").ConversationCell
local ConversationRelativeTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRelativeTimestamp")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")
local SquadJoinButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadJoinButton")
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadButtonSourceEnum
local SquadComponentAccessWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadComponentAccessWrapper")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local useActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").useActivationOnFocus

local getFFlagDebugAppChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagDebugAppChat")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatTimestampInSubtitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTimestampInSubtitle")
local fFlagAppChatUseActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatUseActivationOnFocus
local conversationFocusActivationDelaySeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/conversationFocusActivationDelaySeconds")
local fFlagAppChatEnableU13ChatOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableU13ChatOptIn

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")

local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local shouldShowOSAForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowOSAForConversation")
local shouldShowU13ChatOptInForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowU13ChatOptInForConversation")

local GetOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore")
local OverlayTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore/OverlayTypes")
local useChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext").useChatPlacementContext

local useCanAccessParty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/useCanAccessParty")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local v5 = {
	entryHeight = 64,
	boldTitle = true,
	onSquadJoinButtonActivated = function() end
}

local function ConversationEntry(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useTextSizeOffset()
	local v9 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local conversation = joined.conversation
	local hasGroupUp = conversation.hasGroupUp

	local v10 = useIsUserPending(conversation)
	local v11 = conversation.hasUnreadMessages and not v10
	local v12 = v11 and not v11

	if v12 then
		v6 = getBoldTextTheme(v6)
	end

	local v13 = useDispatch()
	local v14 = useChatPlacementContext()
	local v15 = useChatPagePadding()

	local captionSubHeader = v6.Font.CaptionSubHeader
	local v16 = v6.Font.BaseSize * captionSubHeader.RelativeSize
	local shortRelativeTime = joined.conversation.shortRelativeTime or ""
	local v17 = useRelativeTimestampBinding(joined.conversation.unixTime)

	local function fn()
		if foundationFontFaceMigration then
			return getTextSize(
				shortRelativeTime,
				v16,
				v7.Typography.CaptionLarge.Font,
				Vector2.new(10000, 10000)
			).X
		end

		return (text.GetTextWidth(shortRelativeTime, captionSubHeader.Font, v16))
	end

	local font = captionSubHeader.Font

	local v20 = if foundationFontFaceMigration then v7.Typography.CaptionLarge.Font else nil
	local v21 = useMemo(fn, { shortRelativeTime, font, v16, v8, v20 })
	local v22 = if FFlagAppChatTimestampInSubtitle then v17 else nil
	local ref = React.useRef(nil)
	local v23 = useNavigation()
	local v24 = false

	if v23.getScreenProps then
		v24 = v23.getScreenProps("wideMode", v24)
	end

	React.useEffect(function()
		joined.fireImpressionEvent(joined.conversation)
	end, {})

	local v25 = GetOverlayStore(false)

	local v26 = React.useCallback(function(p3)
		v23.navigate(EnumScreens.ChatConversation, {
			conversationId = p3,
			isNavigatedFromGroupOSAJoin = true
		})
	end, { v23 })

	local v27 = React.useCallback(function(p3, p4, p5, p6, callback)
		v25.showOverlay(OverlayTypes.GroupOSADialog, {
			conversationId = p3,
			impressionId = p4,
			modalVariant = p5,
			onJoin = function()
				v25.dismissOverlay()

				if callback then
					callback(p3)
				else
					v26(p3)
				end
			end,
			onDecline = function()
				if p3 and p6 == Conversation.Type.MULTI_USER_CONVERSATION then
					v13(RemovedConversation(p3))
				end

				v25.dismissOverlay()
			end
		})
	end, { v26, v13 })

	local v28 = React.useCallback(function(p3)
		local v29 = nil
		local v30 = nil

		if shouldShowU13ChatOptInForConversation(p3) then
			v30 = Constants.OptInVariant.ChatOptInInfoCard
		elseif shouldShowOSAForConversation(p3) then
			v30 = Constants.OptInVariant.OsaContextCard
		end

		if v30 then
			v29 = HttpService:GenerateGUID(false)
			v27(p3.id, v29, v30, p3.conversationType)
		elseif joined.onActivated then
			joined.onActivated(p3)
		end

		joined.fireClickEvent(p3, v9, v29)
	end, { v27, joined.onActivated, joined.fireClickEvent, v9 })

	local onSquadJoinButtonActivated = joined.onSquadJoinButtonActivated
	local v29 = React.useCallback(function(p3)
		local v30 = nil

		if shouldShowOSAForConversation(conversation) then
			v30 = Constants.OptInVariant.OsaContextCard
		elseif
			fFlagAppChatEnableU13ChatOptIn
			and shouldShowU13ChatOptInForConversation(conversation)
			and conversation.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		then
			v30 = Constants.OptInVariant.ChatOptInInfoCard
		end

		if v30 and v27 then
			v27(
				p3,
				HttpService:GenerateGUID(false),
				v30,
				conversation.conversationType,
				onSquadJoinButtonActivated
			)
		elseif onSquadJoinButtonActivated then
			onSquadJoinButtonActivated(p3)
		end
	end, { v27, conversation, onSquadJoinButtonActivated })

	if fFlagAppChatUseActivationOnFocus then
		useActivationOnFocus(v24, ref, function()
			v28(conversation)
		end, function(p3)
			if p3 then
				return p3.cell
			end

			return nil
		end, function()
			return conversation and conversation.id
		end, nil, conversationFocusActivationDelaySeconds)
	else
		local v30 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			if v24 and v28 and v30 then
				local v31 = v30.focusedGuiObject:subscribe(function(p3)
					if ref.current and p3 == ref.current.cell then
						v28(conversation)
					end
				end)
				return function()
					v31:unsubscribe()
				end
			end

			return function() end
		end, { v28, v24, v30 })
	end

	local children = joined.children or {}

	local size_1900 = v7.Size.Size_1900

	local v30 = useCanAccessParty()

	local v31 = not v11 and 0 or v7.Size.Size_200 + v7.Gap.XSmall

	local right = v15.right
	local v32

	if v30 and hasGroupUp then
		v32 = right + size_1900
	else
		v32 = if FFlagAppChatTimestampInSubtitle then not v11 and 0 or v7.Gap.Medium + v7.Size.Size_200 else v21 + v31 + right
	end

	local v33

	if v30 and hasGroupUp and conversation.id then
		local createElement = React.createElement
		local v35 = { parentChannelId = conversation.id }

		local createElement2 = React.createElement
		local v38 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, size_1900, 1, 0),
			LayoutOrder = 2
		}

		local v40 = {
			layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 0)
			}),
			button = 0
		}

		local createElement3 = React.createElement
		local v42 = {
			conversationId = conversation.id,
			isFullWidth = false,
			isInCard = false,
			layoutOrder = 0,
			onActivated = v29,
			Selectable = false,
			shouldAnimate = false,
			squadLocation = v14.chatPlacement,
			squadButtonSource = squadButtonSourceEnum.ConversationEntry,
			testId = 0
		}

		local v43 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingConversationEntrySquadButton(conversation.title) else nil
		v42.testId = v43
		v40.button = createElement3(SquadJoinButton, v42)
		v33 = createElement(SquadComponentAccessWrapper, v35, { createElement2("Frame", v38, {}, v40) })
	end

	local createElement = React.createElement
	local v35 = {
		Size = UDim2.new(1, 0, 0, joined.entryHeight),
		BackgroundTransparency = 1,
		ref = ref
	}

	local createElement2 = React.createElement

	local v38 = {
		Size = UDim2.new(1, 0, 0, joined.entryHeight),
		conversation = joined.conversation,
		childWidth = v32,
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

	local v39 = if getFFlagDebugAppChat() then joined.conversation.id else joined.conversation.lastMessageContent
	v38.subTitleText = v39

	v38.subTitleTimestamp = v22
	v38.onActivated = v28
	v38.style = v6
	v38.boldTitle = v12

	v38.onSquadJoinButtonActivated = joined.onSquadJoinButtonActivated
	v38.paddingLeft = v15.left
	v38.paddingRight = v15.right

	local v40 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingConversationEntry(conversation.title) else nil
	v38.testId = v40

	local join = Cryo.Dictionary.join

	local v42 = if not (v33 or FFlagAppChatTimestampInSubtitle) then React.createElement(ConversationRelativeTimestamp, {
		timestampText = v17,
		hasUnreadMessages = v11
	}) else nil

	local v43 = if FFlagAppChatTimestampInSubtitle and not v33 and v11 then React.createElement(Foundation.View, {
		tag = "size-200-200 radius-circle bg-action-emphasis"
	}) else nil
	return createElement("Frame", v35, {
		cell = createElement2(
			conversationCell,
			v38,
			join(children, { timeStamp = v42, unreadDot = v43, squadButton = v33 })
		)
	})
end

return memo(ConversationEntry)
