local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local HttpService = game:GetService("HttpService")
local React = require(AppChatParent.React)
local memo = React.memo
local useMemo = React.useMemo
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useRelativeTimestampBinding = require(AppChat.Hooks.useRelativeTimestampBinding)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Text = require(AppChatParent.AppCommonLib).Text
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local getBoldTextTheme = require(script.Parent.Utils.getBoldTextTheme)
local ConversationCell = require(AppChat.Components.Cells).ConversationCell
local ConversationRelativeTimestamp = require(script.Parent.ConversationRelativeTimestamp)
local DomLocators = require(AppChat.Utils.DomLocators)
local SquadJoinButton = require(AppChatParent.Squads.SquadJoinButton)
local SquadButtonSourceEnum = require(AppChatParent.Squads.Enums).SquadButtonSourceEnum
local SquadComponentAccessWrapper = require(AppChatParent.Squads.SquadComponentAccessWrapper)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(AppChatParent.Navigation).useNavigation
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
local FFlagAppChatSquadJoinButtonU13OSA = require(AppChat.Flags.FFlagAppChatSquadJoinButtonU13OSA)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatTimestampInSubtitle = require(AppChat.Flags.FFlagAppChatTimestampInSubtitle)
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
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext
local useCanAccessParty = require(AppChatParent.Squads.useCanAccessParty)

require(AppChat.types)

local t1 = {
	entryHeight = 64,
	boldTitle = true,
	onSquadJoinButtonActivated = function() -- line: 73
	end
}

local function ConversationEntry(t2: {[any]: any}) -- line: 77
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useTokens (copy), useTextSizeOffset (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), useIsUserPending (copy), getBoldTextTheme (copy), useDispatch (copy), useChatPlacementContext (copy), useChatPagePadding (copy), useRelativeTimestampBinding (copy), useMemo (copy), Text (copy), FFlagAppChatTimestampInSubtitle (copy), React (copy), useNavigation (copy), GetOverlayStore (copy), EnumScreens (copy), OverlayTypes (copy), Conversation (copy), RemovedConversation (copy), shouldShowU13ChatOptInForConversation (copy), Constants (copy), shouldShowOSAForConversation (copy), HttpService (copy), FFlagAppChatSquadJoinButtonU13OSA (copy), ReactFocusNavigation (copy), useCanAccessParty (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ConversationCell (copy), getFFlagDebugAppChat (copy), ConversationRelativeTimestamp (copy), Foundation (copy)
	local v46 = Cryo.Dictionary.join(t1, t2)
	local v47 = useStyle()
	local v48 = useTokens()
	local v49 = useTextSizeOffset()
	local v50 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local conversation = v46.conversation
	local hasGroupUp = conversation.hasGroupUp
	local v53 = useIsUserPending(conversation)
	local v54 = conversation.hasUnreadMessages and not v53
	local v55 = v54 and not v54
	local v56 = if not v55 then v47 else getBoldTextTheme(v47)
	local v57 = useDispatch()
	local v58 = useChatPlacementContext()
	local v59 = useChatPagePadding()
	local CaptionSubHeader = v56.Font.CaptionSubHeader
	local v61 = v56.Font.BaseSize * CaptionSubHeader.RelativeSize
	local v62 = v46.conversation.shortRelativeTime or ""
	local v63 = useRelativeTimestampBinding(v46.conversation.unixTime)
	local v64 = useMemo(function() -- line: 102
		-- upvalues: Text (copy), v62 (copy), CaptionSubHeader (copy), v61 (copy)
		return Text.GetTextWidth(v62, CaptionSubHeader.Font, v61)
	end, {
		v62,
		CaptionSubHeader.Font,
		v61,
		v49
	})
	local v65 = if not FFlagAppChatTimestampInSubtitle then nil else v63
	local v66 = React.useRef(nil)
	local v67 = useNavigation()
	local u68 = false

	if v67.getScreenProps then
		u68 = v67.getScreenProps("wideMode", u68)
	end

	React.useEffect(function() -- line: 113
		-- upvalues: v46 (copy)
		v46.fireImpressionEvent(v46.conversation)
	end, {})

	local v69 = GetOverlayStore(false)
	local v70 = React.useCallback(function(s1: string) -- line: 121
		-- upvalues: v67 (copy), EnumScreens (copy)
		v67.navigate(EnumScreens.ChatConversation, {
			isNavigatedFromGroupOSAJoin = true,
			conversationId = s1
		})
	end, { v67 })
	local u71 = React.useCallback(function(s2: string, s3: string?, s4: string?, s5: string?, p1: ((...any) -> ...any)?) -- line: 129
		-- upvalues: v69 (copy), OverlayTypes (copy), v70 (copy), Conversation (copy), v57 (copy), RemovedConversation (copy)
		v69.showOverlay(OverlayTypes.GroupOSADialog, {
			conversationId = s2,
			impressionId = s3,
			modalVariant = s4,
			onJoin = function() -- line: 140
				-- upvalues: v69 (copy), p1 (copy), s2 (copy), v70 (copy)
				v69.dismissOverlay()

				if p1 then
					p1(s2)

					return
				end

				v70(s2)
			end,
			onDecline = function() -- line: 148
				-- upvalues: s2 (copy), s5 (copy), Conversation (copy), v57 (copy), RemovedConversation (copy), v69 (copy)
				if s2 and s5 == Conversation.Type.MULTI_USER_CONVERSATION then
					v57(RemovedConversation(s2))
				end

				v69.dismissOverlay()
			end
		})
	end, {
		v70,
		v57
	})
	local v72 = React.useCallback(function(p2) -- line: 163
		-- upvalues: shouldShowU13ChatOptInForConversation (copy), Constants (copy), shouldShowOSAForConversation (copy), HttpService (copy), u71 (ref), v46 (copy), v50 (copy)
		local guid = nil
		local ChatOptInInfoCard = nil

		if shouldShowU13ChatOptInForConversation(p2) then
			ChatOptInInfoCard = Constants.OptInVariant.ChatOptInInfoCard
		elseif shouldShowOSAForConversation(p2) then
			ChatOptInInfoCard = Constants.OptInVariant.OsaContextCard
		end

		if ChatOptInInfoCard then
			guid = HttpService:GenerateGUID(false)
			u71(p2.id, guid, ChatOptInInfoCard, p2.conversationType)
		elseif v46.onActivated then
			v46.onActivated(p2)
		end

		v46.fireClickEvent(p2, v50, guid)
	end, {
		u71,
		v46.onActivated,
		v46.fireClickEvent,
		v50
	})
	local onSquadJoinButtonActivated = v46.onSquadJoinButtonActivated
	local v74 = React.useCallback(function(s6: string) -- line: 192
		-- upvalues: shouldShowOSAForConversation (copy), conversation (copy), Constants (copy), FFlagAppChatSquadJoinButtonU13OSA (copy), shouldShowU13ChatOptInForConversation (copy), Conversation (copy), u71 (ref), HttpService (copy), onSquadJoinButtonActivated (copy)
		local OsaContextCard = nil

		if shouldShowOSAForConversation(conversation) then
			OsaContextCard = Constants.OptInVariant.OsaContextCard
		elseif FFlagAppChatSquadJoinButtonU13OSA and shouldShowU13ChatOptInForConversation(conversation) and conversation.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			OsaContextCard = Constants.OptInVariant.ChatOptInInfoCard
		end

		if OsaContextCard and u71 then
			local guid = HttpService:GenerateGUID(false)

			u71(s6, guid, OsaContextCard, conversation.conversationType, onSquadJoinButtonActivated)

			return
		end

		if onSquadJoinButtonActivated then
			onSquadJoinButtonActivated(s6)
		end
	end, {
		u71,
		conversation,
		onSquadJoinButtonActivated
	})
	local v75 = v72
	local v76 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	React.useEffect(function() -- line: 226
		-- upvalues: u68 (ref), v75 (copy), v76 (copy), v66 (copy), conversation (copy)
		if u68 and (v75 and v76) then
			local v96 = v76.focusedGuiObject:subscribe(function(p3) -- line: 228
				-- upvalues: v66 (copy), v75 (copy), conversation (copy)
				if v66.current and p3 == v66.current.cell then
					v75(conversation)
				end
			end)

			return function() -- line: 233
				-- upvalues: v96 (copy)
				v96:unsubscribe()
			end
		end

		return function() -- line: 237
		end
	end, {
		v75,
		u68,
		v76
	})

	local v77 = v46.children or {}
	local Size_1900 = v48.Size.Size_1900
	local v79 = useCanAccessParty()
	local v80 = not v54 and 0 or v48.Size.Size_200 + v48.Gap.XSmall
	local right = v59.right
	local v82 = if not v79 or not hasGroupUp then if not FFlagAppChatTimestampInSubtitle then v64 + v80 + right else not v54 and 0 or v48.Gap.Medium + v48.Size.Size_200 else right + Size_1900
	local v83 = if not v79 or (not hasGroupUp or not conversation.id) then nil else React.createElement(SquadComponentAccessWrapper, {
		parentChannelId = conversation.id
	}, { React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(0, Size_1900, 1, 0)
	}, {}, {
		layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		padding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 0)
		}),
		button = React.createElement(SquadJoinButton, {
			isFullWidth = false,
			isInCard = false,
			layoutOrder = 0,
			Selectable = false,
			shouldAnimate = false,
			conversationId = conversation.id,
			onActivated = v74,
			squadLocation = v58.chatPlacement,
			squadButtonSource = SquadButtonSourceEnum.ConversationEntry,
			testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingConversationEntrySquadButton(conversation.title)
		})
	}) })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v46.entryHeight),
		ref = v66
	}, {
		cell = React.createElement(ConversationCell, {
			hideLeftAvatarPadding = true,
			Size = UDim2.new(1, 0, 0, v46.entryHeight),
			conversation = v46.conversation,
			childWidth = v82,
			subTitleText = if not getFFlagDebugAppChat() then v46.conversation.lastMessageContent else v46.conversation.id,
			subTitleTimestamp = v65,
			onActivated = v75,
			style = v56,
			boldTitle = v55,
			onSquadJoinButtonActivated = v46.onSquadJoinButtonActivated,
			paddingLeft = v59.left,
			paddingRight = v59.right,
			testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingConversationEntry(conversation.title)
		}, Cryo.Dictionary.join(v77, {
			timeStamp = if not v83 and not FFlagAppChatTimestampInSubtitle then React.createElement(ConversationRelativeTimestamp, {
				timestampText = v63,
				hasUnreadMessages = v54
			}) else nil,
			unreadDot = if not FFlagAppChatTimestampInSubtitle or (v83 or not v54) then nil else React.createElement(Foundation.View, {
				tag = "size-200-200 radius-circle bg-action-emphasis"
			}),
			squadButton = v83
		}))
	})
end

return memo(ConversationEntry)
