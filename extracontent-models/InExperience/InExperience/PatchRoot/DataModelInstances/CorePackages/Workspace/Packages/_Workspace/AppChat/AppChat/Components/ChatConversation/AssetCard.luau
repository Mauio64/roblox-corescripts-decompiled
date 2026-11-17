local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ChatBubbleContainer = require(script.Parent.Bubble.ChatBubbleContainer)
local Constants = require(AppChat.Constants)
local Foundation = require(parent.Foundation)
local useScaledValue = Foundation.Hooks.useScaledValue
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local PlaceIdContainer = require(AppChat.Components.ChatConversation.ShareLinkComponents.GameCardComponents.PlaceIdContainer)

local GameCardContainer = require(AppChat.Components.ChatConversation.ShareLinkComponents.GameCardComponents.GameCardContainer)
local ShareLinkContainer = require(AppChat.Components.ChatConversation.ShareLinkComponents.ShareLinkContainer)
local ShareLinkV2Presentation = require(AppChat.Components.ChatConversation.ShareLinkComponents.ShareLinkV2Presentation)

local useShareLinkV2Presentation = require(AppChat.Components.ChatConversation.ShareLinkComponents.useShareLinkV2Presentation)
local PlainText = require(script.Parent.PlainText)
local ChatMessageContainerConstants = require(script.Parent.ChatMessageContainerConstants)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ChatBubbleEnum = require(script.Parent.Bubble.ChatBubbleEnum)
local RepliedToMarker = require(script.Parent.Bubble.RepliedToMarker)
local toMessageGroupShape = require(script.Parent.Grouping.toMessageGroupShape)

local isAssetCardClassification = require(AppChat.Components.ChatConversation.ShareLinkComponents.isAssetCardClassification)
local GetShareLinkV2Store = require(AppChat.Stores.GetShareLinkV2Store)

local FFlagAppChatShareLinkV2Fallbacks = require(AppChat.Flags.FFlagAppChatShareLinkV2Fallbacks)
local FFlagAppChatFullPlaintextBeforeGameCards = require(AppChat.Flags.FFlagAppChatFullPlaintextBeforeGameCards)

local FFlagAppChatIntrinsicAssetCardHeight = require(AppChat.Flags.FFlagAppChatIntrinsicAssetCardHeight)
local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)
local FFlagAppChatPlusReferralAssetCard = require(AppChat.Flags.FFlagAppChatPlusReferralAssetCard)
local FFlagAppChatMomentAssetCard = require(AppChat.Flags.FFlagAppChatMomentAssetCard)
local FFlagAppChatGameAssetCard = require(AppChat.Flags.FFlagAppChatGameAssetCard)

local BUBBLE_PADDING = ChatMessageContainerConstants.BUBBLE_PADDING
local TEXT_BUBBLE_X_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_PADDING
local TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING

local v = {
	additionalProps = {
		shareLink = nil,
		placeId = nil,
		universeId = nil,
		senderUserId = nil,
		onDetailsOpened = function() end,
		openGameDetailsPage = function() end
	},
	hasTail = false,
	innerPadding = 0,
	isIncoming = false,
	isPending = true,
	isUnfiltered = false,
	isLastMessageInMessageGroup = false,
	maxWidth = 0,
	parentWidth = 0,
	wideMode = false
}

local signal = Signals.createSignal(nil)

local function useRendersAssetCardView(shareLink)
	local linkId

	if FFlagAppChatResolveShareLinkV2 and shareLink and shareLink.version == 2 then
		linkId = shareLink.linkId
	else
		linkId = nil
	end

	local shareLinkV2Store = GetShareLinkV2Store(false)
	local v2 = React.useMemo(function()
		if linkId then
			return (shareLinkV2Store.getAndFetchClassification(linkId))
		end

		return nil
	end, { shareLinkV2Store, linkId or "" })
	local useSignalState = SignalsReact.useSignalState
	local v3 = if v2 then v2.data else signal
	local v4 = useSignalState(v3)

	if linkId == nil then
		return FFlagAppChatGameAssetCard
	end

	return isAssetCardClassification(v4)
end

local function renderAssetCardViewRow(props, card)
	local createElement = React.createElement
	local view = Foundation.View

	local layout = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = 0,
		Padding = 0
	}
	local horizontalAlignment

	if props.isIncoming then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	else
		horizontalAlignment = Enum.HorizontalAlignment.Right
	end

	layout.HorizontalAlignment = horizontalAlignment

	layout.Padding = UDim.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
	local v2 = {
		tag = "auto-xy",
		testId = "AssetCardRow",
		layout = layout,
		LayoutOrder = props.LayoutOrder
	}
	local v3 = {
		Card = React.createElement(Foundation.View, { tag = "auto-xy", LayoutOrder = 1 }, {
			Card = card
		}),
		RepliedToMarker = 0
	}
	local repliedToMarker

	if props.isRepliedTo then
		repliedToMarker = React.createElement(RepliedToMarker, {
			isIncoming = props.isIncoming,
			layoutOrder = props.isIncoming and 0 or 2
		})
	end

	v3.RepliedToMarker = repliedToMarker
	return createElement(view, v2, v3)
end

local function AssetCardTemp(p)
	local union = Cryo.Dictionary.union(v, p)

	local union2 = Cryo.Dictionary.union(v.additionalProps, union.additionalProps)
	local v2

	if union2.shareLink then
		v2 = ShareLinkContainer
	else
		v2 = union2.placeId and PlaceIdContainer or GameCardContainer
	end

	local isPending = union.isPending

	local v3 = useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH)
	local v4 = useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT + Constants.GameCard.FOOTER_HEIGHT)
	local v5

	if FFlagAppChatShareLinkV2Fallbacks then
		local shareLink = union2.shareLink
		local v6

		if shareLink and shareLink.version == 2 then
			v6 = shareLink.linkId
		end

		v5 = useShareLinkV2Presentation(v6)
	end

	local v6, groupShape

	if FFlagAppChatPlusReferralAssetCard or FFlagAppChatMomentAssetCard or FFlagAppChatGameAssetCard then
		v6 = useRendersAssetCardView(union2.shareLink)
		groupShape = React.useMemo(function()
			return toMessageGroupShape(
				union.hasTail,
				union.isLastMessageInMessageGroup,
				union.isRepliedTo,
				union.isIncoming
			)
		end, {
			union.hasTail,
			union.isLastMessageInMessageGroup,
			union.isRepliedTo,
			union.isIncoming
		})
	else
		v6 = false
	end

	if v5 == ShareLinkV2Presentation.Fallback then
		local url = union2.shareLink.url

		if FFlagAppChatFullPlaintextBeforeGameCards or url == nil then
			return nil
		end

		local v7 = union.parentWidth - (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2 - (not union.wideMode and 0 or TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING)
		local textSize = GetTextSize(url, union.textSize, union.font, Vector2.new(v7, 10000))
		return Roact.createElement(PlainText, {
			text = url,
			font = union.font,
			textSize = union.textSize,
			innerPadding = union.innerPadding,
			maxWidth = textSize.X + BUBBLE_PADDING * 2,
			hasTail = union.hasTail,
			isIncoming = union.isIncoming,
			isPending = union.isPending,
			isUnfiltered = union.isUnfiltered,
			isRepliedTo = union.isRepliedTo,
			isPressed = union.isPressed,
			isLastMessageInMessageGroup = union.isLastMessageInMessageGroup,
			bubbleRef = union.bubbleRef,
			LayoutOrder = union.LayoutOrder,
			[Roact.Change.AbsoluteSize] = union[Roact.Change.AbsoluteSize]
		})
	else
		union2.isStartOfGroup = union.hasTail
		union2.isIncoming = union.isIncoming
		union2.isUnfiltered = union.isUnfiltered
		union2.isPending = union.isPending
		union2.isRepliedTo = union.isRepliedTo

		if v6 then
			return renderAssetCardViewRow(
				union,
				Roact.createElement(
					v2,
					Cryo.Dictionary.join(union2, {
						groupShape = groupShape,
						mediaRef = union.bubbleRef
					})
				)
			)
		end

		local createElement = Roact.createElement

		local v7 = {
			hasTail = union.hasTail,
			isIncoming = union.isIncoming,
			isPending = isPending,
			isUnfiltered = nil,
			isAssetCard = true,
			LayoutOrder = union.LayoutOrder,
			padding = 0,
			isLastMessageInMessageGroup = union.isLastMessageInMessageGroup or v.isLastMessageInMessageGroup,
			bubbleRef = union.bubbleRef,
			[Roact.Change.AbsoluteSize] = union[Roact.Change.AbsoluteSize]
		}

		local createElement2 = Roact.createElement
		local size

		if FFlagAppChatIntrinsicAssetCardHeight then
			size = UDim2.fromOffset(v3 or 256, 0)
		else
			size = UDim2.fromOffset(v3 or 256, v4 or 208)
		end

		return createElement(ChatBubbleContainer, v7, {
			AssetCard = createElement2(
				"Frame",
				{ BackgroundTransparency = 1, Size = size, AutomaticSize = Enum.AutomaticSize.XY },
				{
					Card = Roact.createElement(v2, union2)
				}
			)
		})
	end
end

return AssetCardTemp
