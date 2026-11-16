local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local DataHydration = require(parent.DataHydration)
local Foundation = require(parent.Foundation)
require(parent.MomentsTypes)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local GameCardContainer = require(script.Parent.GameCardComponents.GameCardContainer)
local GameCardGroupable = require(script.Parent.GameCardComponents.GameCardGroupable)
local MomentShareCardContainer = require(script.Parent.MomentShareCard.MomentShareCardContainer)
local MomentAssetCard = require(script.Parent.MomentShareCard.MomentAssetCard)
local PlusReferralAssetCard = require(script.Parent.PlusReferralAssetCard.PlusReferralAssetCard)
local isAssetCardClassification = require(script.Parent.isAssetCardClassification)
local MessageGroupShape = require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)
local ShareLinkClassification = require(AppChat.Components.ChatConversation.Utils.RobloxUrlUtils.ShareLinkClassification)
local Constants = require(AppChat.Constants)
local ShareLinkV2Presentation = require(script.Parent.ShareLinkV2Presentation)
local getShareLinkV2Presentation = require(script.Parent.getShareLinkV2Presentation)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local useEffect = React.useEffect
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useScaledValue = Foundation.Hooks.useScaledValue

local GetShareLinkStore = require(AppChat.Stores.GetShareLinkStore)

local GetShareLinkV2Store = require(AppChat.Stores.GetShareLinkV2Store)

local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)
local FFlagAppChatMomentShareCard = require(AppChat.Flags.FFlagAppChatMomentShareCard)
local FFlagAppChatIntrinsicAssetCardHeight = require(AppChat.Flags.FFlagAppChatIntrinsicAssetCardHeight)
local FFlagAppChatShareLinkV2Fallbacks = require(AppChat.Flags.FFlagAppChatShareLinkV2Fallbacks)

local frozen = table.freeze({
	direction = MessageGroupShape.Direction.Incoming,
	position = MessageGroupShape.Position.Only
})

local function ShareLinkV1Container(props)
	local linkId = props.shareLink.linkId

	local linkType = props.shareLink.linkType
	local shareLinkStore = GetShareLinkStore(false)
	local v2 = useSignalState(shareLinkStore.getShareLinkMetadataComputed(linkId))

	local v3 = useDispatch()
	useEffect(function()
		if v2 then
			v:warning("ShareLinkContainer: Missing linkId or linkType in props.")
		else
			shareLinkStore.fetchShareLinkMetadata(v3, linkId, linkType)
		end
	end, { linkId, linkType, v2 })

	local createElement = React.createElement
	local universeId

	if v2 then
		universeId = v2.universeId
	end

	local placeId

	if v2 then
		placeId = v2.placeId
	end

	return createElement(GameCardContainer, {
		universeId = universeId,
		placeId = placeId,
		conversationId = props.conversationId,
		senderUserId = props.senderUserId,
		onDetailsOpened = props.onDetailsOpened,
		openGameDetailsPage = props.openGameDetailsPage,
		networkImpl = props.networkImpl,
		eventStream = props.eventStream,
		eventIngest = props.eventIngest,
		luaChatPlayTogetherEnabled = props.luaChatPlayTogetherEnabled,
		isStartOfGroup = props.isStartOfGroup,
		isIncoming = props.isIncoming,
		isUnfiltered = props.isUnfiltered,
		isPending = props.isPending,
		isRepliedTo = props.isRepliedTo,
		groupShape = props.groupShape,
		mediaRef = props.mediaRef
	})
end

local function ShareLinkV2Container(props)
	local linkId = props.shareLink.linkId
	local shareLinkV2Store = GetShareLinkV2Store(false)
	local v2 = React.useMemo(function()
		return shareLinkV2Store.getAndFetchClassification(linkId)
	end, { shareLinkV2Store, linkId })
	local v3 = useSignalState(v2.data)
	local v4

	if FFlagAppChatIntrinsicAssetCardHeight and FFlagAppChatMomentShareCard then
		v4 = useSignalState(v2.status)
	end

	local v5

	if FFlagAppChatIntrinsicAssetCardHeight and FFlagAppChatMomentShareCard then
		v5 = useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT + Constants.GameCard.FOOTER_HEIGHT)
	end

	local v6

	if FFlagAppChatShareLinkV2Fallbacks then
		v6 = useSignalState(v2.status)
	end

	if isAssetCardClassification(v3) then
		local groupShape = props.groupShape or frozen

		if v3 and v3.type == ShareLinkClassification.PlusReferral then
			return React.createElement(PlusReferralAssetCard, {
				referrerId = v3.referrerId,
				groupShape = groupShape,
				mediaRef = props.mediaRef
			})
		end

		if v3 and v3.type == ShareLinkClassification.Moment then
			return React.createElement(MomentAssetCard, {
				momentId = v3.momentId,
				targetIdType = v3.targetIdType,
				openMomentsDeepLink = props.openMomentsDeepLink,
				groupShape = groupShape,
				mediaRef = props.mediaRef
			})
		end
	end

	if FFlagAppChatMomentShareCard and v3 and v3.type == ShareLinkClassification.Moment then
		return React.createElement(MomentShareCardContainer, {
			momentId = v3.momentId,
			targetIdType = v3.targetIdType,
			openMomentsDeepLink = props.openMomentsDeepLink,
			isStartOfGroup = props.isStartOfGroup,
			isIncoming = props.isIncoming,
			LayoutOrder = props.LayoutOrder
		})
	end

	if FFlagAppChatShareLinkV2Fallbacks and getShareLinkV2Presentation(v3, v6) == ShareLinkV2Presentation.Loading then
		return React.createElement(GameCardGroupable, {
			isLoading = true,
			gameName = "",
			gameThumbnail = ""
		})
	end

	if
		FFlagAppChatIntrinsicAssetCardHeight
		and FFlagAppChatMomentShareCard
		and v4 == DataHydration.DataStatus.NotReady
	then
		return React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(0, v5),
			testId = "ShareLinkPendingCard",
			LayoutOrder = props.LayoutOrder
		})
	end

	return nil
end

local function ShareLinkContainer(p)
	if FFlagAppChatResolveShareLinkV2 and p.shareLink.version == 2 then
		return React.createElement(ShareLinkV2Container, p)
	end

	return React.createElement(ShareLinkV1Container, p)
end

return ShareLinkContainer
