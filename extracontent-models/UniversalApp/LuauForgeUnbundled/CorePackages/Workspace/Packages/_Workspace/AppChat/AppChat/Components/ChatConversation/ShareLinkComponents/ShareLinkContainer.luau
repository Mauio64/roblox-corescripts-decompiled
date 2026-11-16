local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local GameCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardContainer")
local GameCardGroupable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardGroupable")
local MomentShareCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentShareCardContainer")
local MomentAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentAssetCard")
local PlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/PlusReferralAssetCard/PlusReferralAssetCard")
local isAssetCardClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/isAssetCardClassification")
local MessageGroupShape = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")
local ShareLinkClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/ShareLinkClassification")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local ShareLinkV2Presentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/ShareLinkV2Presentation")
local getShareLinkV2Presentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/getShareLinkV2Presentation")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ShareLinkContainer")

local useEffect = React.useEffect
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useScaledValue = Foundation.Hooks.useScaledValue

local GetShareLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkStore")

local GetShareLinkV2Store = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkV2Store")

local FFlagAppChatResolveShareLinkV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatResolveShareLinkV2")
local FFlagAppChatMomentShareCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCard")
local FFlagAppChatIntrinsicAssetCardHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIntrinsicAssetCardHeight")
local FFlagAppChatShareLinkV2Fallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatShareLinkV2Fallbacks")

local frozen = table.freeze({
	direction = MessageGroupShape.Direction.Incoming,
	position = MessageGroupShape.Position.Only
})

local function ShareLinkV1Container(props)
	local linkId = props.shareLink.linkId

	local linkType = props.shareLink.linkType
	local v6 = GetShareLinkStore(false)
	local v7 = useSignalState(v6.getShareLinkMetadataComputed(linkId))

	local v8 = useDispatch()
	useEffect(function()
		if v7 then
			v5:warning("ShareLinkContainer: Missing linkId or linkType in props.")
		else
			v6.fetchShareLinkMetadata(v8, linkId, linkType)
		end
	end, { linkId, linkType, v7 })

	local createElement = React.createElement
	local v11 = if v7 then v7.universeId else nil
	local v12 = if v7 then v7.placeId else nil
	return createElement(GameCardContainer, {
		universeId = v11,
		placeId = v12,
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
	local v6 = GetShareLinkV2Store(false)
	local v7 = React.useMemo(function()
		return v6.getAndFetchClassification(linkId)
	end, { v6, linkId })
	local v8 = useSignalState(v7.data)

	local v9 = if FFlagAppChatIntrinsicAssetCardHeight and FFlagAppChatMomentShareCard then useSignalState(v7.status) else nil
	local v10

	if FFlagAppChatIntrinsicAssetCardHeight and FFlagAppChatMomentShareCard then
		v10 = useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT + Constants.GameCard.FOOTER_HEIGHT)
	end

	local v11 = if FFlagAppChatShareLinkV2Fallbacks then useSignalState(v7.status) else nil

	if isAssetCardClassification(v8) then
		local groupShape = props.groupShape or frozen

		if v8 and v8.type == ShareLinkClassification.PlusReferral then
			return React.createElement(PlusReferralAssetCard, {
				referrerId = v8.referrerId,
				groupShape = groupShape,
				mediaRef = props.mediaRef
			})
		end

		if v8 and v8.type == ShareLinkClassification.Moment then
			return React.createElement(MomentAssetCard, {
				momentId = v8.momentId,
				targetIdType = v8.targetIdType,
				openMomentsDeepLink = props.openMomentsDeepLink,
				groupShape = groupShape,
				mediaRef = props.mediaRef
			})
		end
	end

	if FFlagAppChatMomentShareCard and v8 and v8.type == ShareLinkClassification.Moment then
		return React.createElement(MomentShareCardContainer, {
			momentId = v8.momentId,
			targetIdType = v8.targetIdType,
			openMomentsDeepLink = props.openMomentsDeepLink,
			isStartOfGroup = props.isStartOfGroup,
			isIncoming = props.isIncoming,
			LayoutOrder = props.LayoutOrder
		})
	end

	if FFlagAppChatShareLinkV2Fallbacks and getShareLinkV2Presentation(v8, v11) == ShareLinkV2Presentation.Loading then
		return React.createElement(GameCardGroupable, {
			isLoading = true,
			gameName = "",
			gameThumbnail = ""
		})
	end

	if FFlagAppChatIntrinsicAssetCardHeight and FFlagAppChatMomentShareCard and v9 == DataHydration.DataStatus.NotReady then
		return React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(0, v10),
			testId = "ShareLinkPendingCard",
			LayoutOrder = props.LayoutOrder
		})
	end

	return nil
end

local function ShareLinkContainer(p2)
	if FFlagAppChatResolveShareLinkV2 and p2.shareLink.version == 2 then
		return React.createElement(ShareLinkV2Container, p2)
	end

	return React.createElement(ShareLinkV1Container, p2)
end

return ShareLinkContainer
