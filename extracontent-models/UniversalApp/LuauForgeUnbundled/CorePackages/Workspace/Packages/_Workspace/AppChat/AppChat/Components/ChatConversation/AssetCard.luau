local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ChatBubbleContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleContainer")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useScaledValue = Foundation.Hooks.useScaledValue
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize

local PlaceIdContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/PlaceIdContainer")

local GameCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardContainer")
local ShareLinkContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/ShareLinkContainer")
local ShareLinkV2Presentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/ShareLinkV2Presentation")

local useShareLinkV2Presentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/useShareLinkV2Presentation")
local PlainText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PlainText")
local ChatMessageContainerConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessageContainerConstants")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local ChatBubbleEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleEnum")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/RepliedToMarker")
local toMessageGroupShape = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/toMessageGroupShape")

local isAssetCardClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/isAssetCardClassification")
local GetShareLinkV2Store = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkV2Store")

local FFlagAppChatShareLinkV2Fallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatShareLinkV2Fallbacks")
local FFlagAppChatFullPlaintextBeforeGameCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFullPlaintextBeforeGameCards")

local FFlagAppChatIntrinsicAssetCardHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIntrinsicAssetCardHeight")
local FFlagAppChatResolveShareLinkV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatResolveShareLinkV2")
local FFlagAppChatPlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralAssetCard")
local FFlagAppChatMomentAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentAssetCard")
local FFlagAppChatGameAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGameAssetCard")

local BUBBLE_PADDING = ChatMessageContainerConstants.BUBBLE_PADDING
local TEXT_BUBBLE_X_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_PADDING
local TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING

local v5 = {
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
	local linkId = if FFlagAppChatResolveShareLinkV2 and shareLink and shareLink.version == 2 then shareLink.linkId else nil

	local v6 = GetShareLinkV2Store(false)
	local v7 = React.useMemo(function()
		if linkId then
			return (v6.getAndFetchClassification(linkId))
		end

		return nil
	end, { v6, linkId or "" })
	local useSignalState = SignalsReact.useSignalState
	local v8 = if v7 then v7.data else signal
	local v9 = useSignalState(v8)

	if linkId == nil then
		return FFlagAppChatGameAssetCard
	end

	return isAssetCardClassification(v9)
end

local function renderAssetCardViewRow(props, p2)
	local createElement = React.createElement
	local view = Foundation.View

	local v7 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = 0,
		Padding = 0
	}
	local v8 = if props.isIncoming then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Right
	v7.HorizontalAlignment = v8

	v7.Padding = UDim.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
	local v6 = {
		tag = "auto-xy",
		testId = "AssetCardRow",
		layout = v7,
		LayoutOrder = props.LayoutOrder
	}
	local v9 = {
		Card = React.createElement(Foundation.View, { tag = "auto-xy", LayoutOrder = 1 }, {
			Card = p2
		}),
		RepliedToMarker = 0
	}

	local v10 = if props.isRepliedTo then React.createElement(module17, {
		isIncoming = props.isIncoming,
		layoutOrder = props.isIncoming and 0 or 2
	}) else nil
	v9.RepliedToMarker = v10
	return createElement(view, v6, v9)
end

local function AssetCardTemp(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local union2 = Cryo.Dictionary.union(v5.additionalProps, union.additionalProps)

	local v6 = if union2.shareLink then ShareLinkContainer else union2.placeId and PlaceIdContainer or GameCardContainer

	local isPending = union.isPending

	local v7 = useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH)
	local v8 = useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT + Constants.GameCard.FOOTER_HEIGHT)
	local v9

	if FFlagAppChatShareLinkV2Fallbacks then
		local shareLink = union2.shareLink

		local v11 = if shareLink and shareLink.version == 2 then shareLink.linkId else nil
		v9 = useShareLinkV2Presentation(v11)
	end

	local v10, v11

	if FFlagAppChatPlusReferralAssetCard or FFlagAppChatMomentAssetCard or FFlagAppChatGameAssetCard then
		v10 = useRendersAssetCardView(union2.shareLink)
		v11 = React.useMemo(function()
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
		v10 = false
	end

	if v9 == ShareLinkV2Presentation.Fallback then
		local url = union2.shareLink.url

		if FFlagAppChatFullPlaintextBeforeGameCards or url == nil then
			return nil
		end

		local v12 = union.parentWidth - (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2 - (not union.wideMode and 0 or TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING)
		local textSize = getTextSize(url, union.textSize, union.font, Vector2.new(v12, 10000))
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

		if v10 then
			return renderAssetCardViewRow(
				union,
				Roact.createElement(
					v6,
					Cryo.Dictionary.join(union2, {
						groupShape = v11,
						mediaRef = union.bubbleRef
					})
				)
			)
		end

		local createElement = Roact.createElement

		local v13 = {
			hasTail = union.hasTail,
			isIncoming = union.isIncoming,
			isPending = isPending,
			isUnfiltered = nil,
			isAssetCard = true,
			LayoutOrder = union.LayoutOrder,
			padding = 0,
			isLastMessageInMessageGroup = union.isLastMessageInMessageGroup or v5.isLastMessageInMessageGroup,
			bubbleRef = union.bubbleRef,
			[Roact.Change.AbsoluteSize] = union[Roact.Change.AbsoluteSize]
		}

		local createElement2 = Roact.createElement

		local v17 = if FFlagAppChatIntrinsicAssetCardHeight then UDim2.fromOffset(v7 or 256, 0) else UDim2.fromOffset(v7 or 256, v8 or 208)
		return createElement(ChatBubbleContainer, v13, {
			AssetCard = createElement2(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = v17,
					AutomaticSize = Enum.AutomaticSize.XY
				},
				{
					Card = Roact.createElement(v6, union2)
				}
			)
		})
	end
end

return AssetCardTemp
