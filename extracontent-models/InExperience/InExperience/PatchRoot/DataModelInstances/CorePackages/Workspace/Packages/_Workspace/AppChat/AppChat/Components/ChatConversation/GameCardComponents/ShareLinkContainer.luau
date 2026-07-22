local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local GameCardContainer = require(script.Parent.GameCardContainer)
local v7 = require(AppChat.Logger):new(script.Name)
local useEffect = React.useEffect
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GetShareLinkStore = require(AppChat.Stores.GetShareLinkStore)
local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)

local function ShareLinkV1Container(t1: {[any]: any}) -- line: 39
	-- upvalues: GetShareLinkStore (copy), useSignalState (copy), useDispatch (copy), useEffect (copy), v7 (copy), React (copy), GameCardContainer (copy)
	local linkId = t1.shareLink.linkId
	local linkType = t1.shareLink.linkType
	local v17 = GetShareLinkStore(false)
	local v18 = useSignalState(v17.getShareLinkMetadataComputed(linkId))
	local v19 = useDispatch()

	useEffect(function() -- line: 47
		-- upvalues: v18 (copy), v17 (copy), v19 (copy), linkId (copy), linkType (copy), v7 (copy)
		if not v18 then
			v17.fetchShareLinkMetadata(v19, linkId, linkType)

			return
		end

		v7:warning("ShareLinkContainer: Missing linkId or linkType in props.")
	end, {
		linkId,
		linkType,
		v18
	})

	return React.createElement(GameCardContainer, {
		universeId = if not v18 then nil else v18.universeId,
		placeId = if not v18 then nil else v18.placeId,
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
local function ShareLinkContainer(t2: {[any]: any}) -- line: 74
	-- upvalues: FFlagAppChatResolveShareLinkV2 (copy), React (copy), ShareLinkV1Container (copy)
	if FFlagAppChatResolveShareLinkV2 and t2.shareLink.version == 2 then
		return nil
	end

	return React.createElement(ShareLinkV1Container, t2)
end

return ShareLinkContainer
