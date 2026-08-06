local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local GameCardContainer = require(script.Parent.GameCardComponents.GameCardContainer)
local v7 = require(AppChat.Logger):new(script.Name)
local useEffect = React.useEffect
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GetShareLinkStore = require(AppChat.Stores.GetShareLinkStore)
local GetShareLinkV2Store = require(AppChat.Stores.GetShareLinkV2Store)
local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)

local function ShareLinkV1Container(t1: {[any]: any}) -- line: 41
	-- upvalues: GetShareLinkStore (copy), useSignalState (copy), useDispatch (copy), useEffect (copy), v7 (copy), React (copy), GameCardContainer (copy)
	local linkId = t1.shareLink.linkId
	local linkType = t1.shareLink.linkType
	local v19 = GetShareLinkStore(false)
	local v20 = useSignalState(v19.getShareLinkMetadataComputed(linkId))
	local v21 = useDispatch()

	useEffect(function() -- line: 49
		-- upvalues: v20 (copy), v19 (copy), v21 (copy), linkId (copy), linkType (copy), v7 (copy)
		if not v20 then
			v19.fetchShareLinkMetadata(v21, linkId, linkType)

			return
		end

		v7:warning("ShareLinkContainer: Missing linkId or linkType in props.")
	end, {
		linkId,
		linkType,
		v20
	})

	return React.createElement(GameCardContainer, {
		universeId = if not v20 then nil else v20.universeId,
		placeId = if not v20 then nil else v20.placeId,
		conversationId = t1.conversationId,
		senderUserId = t1.senderUserId,
		onDetailsOpened = t1.onDetailsOpened,
		openGameDetailsPage = t1.openGameDetailsPage,
		networkImpl = t1.networkImpl,
		eventStream = t1.eventStream,
		eventIngest = t1.eventIngest,
		luaChatPlayTogetherEnabled = t1.luaChatPlayTogetherEnabled,
		isStartOfGroup = t1.isStartOfGroup,
		isIncoming = t1.isIncoming,
		isUnfiltered = t1.isUnfiltered,
		isPending = t1.isPending,
		isRepliedTo = t1.isRepliedTo
	})
end
local function ShareLinkV2Container(t2: {[any]: any}) -- line: 76
	-- upvalues: GetShareLinkV2Store (copy)
	local linkId = t2.shareLink.linkId

	GetShareLinkV2Store(false).getAndFetchClassification(linkId)

	return nil
end
local function ShareLinkContainer(t3: {[any]: any}) -- line: 85
	-- upvalues: FFlagAppChatResolveShareLinkV2 (copy), React (copy), ShareLinkV2Container (copy), ShareLinkV1Container (copy)
	if FFlagAppChatResolveShareLinkV2 and t3.shareLink.version == 2 then
		return React.createElement(ShareLinkV2Container, t3)
	end

	return React.createElement(ShareLinkV1Container, t3)
end

return ShareLinkContainer
