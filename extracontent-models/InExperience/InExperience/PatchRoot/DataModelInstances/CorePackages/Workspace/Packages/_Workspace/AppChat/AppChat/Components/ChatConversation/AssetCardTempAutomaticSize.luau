local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local Cryo = require(AppChatParent.Cryo)
local ChatBubbleContainerAutomaticSize = require(script.Parent.Bubble.ChatBubbleContainerAutomaticSize)
local Constants = require(AppChat.Constants)
local useScaledValue = require(AppChatParent.Foundation).Hooks.useScaledValue
local PlaceIdContainer = require(AppChat.Components.ChatConversation.ShareLinkComponents.GameCardComponents.PlaceIdContainer)
local GameCardContainer = require(AppChat.Components.ChatConversation.ShareLinkComponents.GameCardComponents.GameCardContainer)
local ShareLinkContainer = require(AppChat.Components.ChatConversation.ShareLinkComponents.ShareLinkContainer)
local t1 = {
	hasTail = false,
	innerPadding = 0,
	isIncoming = false,
	isPending = true,
	isUnfiltered = false,
	isLastMessageInMessageGroup = false,
	maxWidth = 0,
	parentWidth = 0,
	wideMode = false,
	additionalProps = {
		shareLink = nil,
		placeId = nil,
		universeId = nil,
		senderUserId = nil,
		onDetailsOpened = function() -- line: 26
		end,
		openGameDetailsPage = function() -- line: 27
		end
	}
}

local function AssetCardTemp(p1) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), ShareLinkContainer (copy), PlaceIdContainer (copy), GameCardContainer (copy), useScaledValue (copy), Constants (copy), Roact (copy), ChatBubbleContainerAutomaticSize (copy)
	local v14 = Cryo.Dictionary.union(t1, p1)
	local v15 = Cryo.Dictionary.union(t1.additionalProps, v14.additionalProps)
	local v16 = if not v15.shareLink then v15.placeId and PlaceIdContainer or GameCardContainer else ShareLinkContainer
	local isPending = v14.isPending
	local v18 = useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH)
	local v19 = useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT + Constants.GameCard.FOOTER_HEIGHT)

	v15.isStartOfGroup = v14.hasTail
	v15.isIncoming = v14.isIncoming
	v15.isUnfiltered = v14.isUnfiltered
	v15.isPending = v14.isPending
	v15.isRepliedTo = v14.isRepliedTo

	return Roact.createElement(ChatBubbleContainerAutomaticSize, {
		hasTail = v14.hasTail,
		isIncoming = v14.isIncoming,
		isPending = isPending,
		isUnfiltered = nil,
		isAssetCard = true,
		LayoutOrder = v14.LayoutOrder,
		padding = 0,
		isLastMessageInMessageGroup = v14.isLastMessageInMessageGroup or t1.isLastMessageInMessageGroup,
		[Roact.Change.AbsoluteSize] = v14[Roact.Change.AbsoluteSize]
	}, {
		AssetCard = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v18 or 256, v19 or 208),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Card = Roact.createElement(v16, v15)
		})
	})
end

return AssetCardTemp
