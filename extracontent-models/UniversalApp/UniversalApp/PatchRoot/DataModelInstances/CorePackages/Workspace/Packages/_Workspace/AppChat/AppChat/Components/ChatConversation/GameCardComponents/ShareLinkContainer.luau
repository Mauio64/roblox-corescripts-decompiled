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

local function ShareLinkContainer(t1: {[any]: any}) -- line: 37
	-- upvalues: GetShareLinkStore (copy), useSignalState (copy), useDispatch (copy), useEffect (copy), v7 (copy), React (copy), GameCardContainer (copy)
	local linkId = t1.shareLink.linkId
	local linkType = t1.shareLink.linkType
	local v15 = GetShareLinkStore(false)
	local v16 = useSignalState(v15.getShareLinkMetadataComputed(linkId))
	local v17 = useDispatch()

	useEffect(function() -- line: 44
		-- upvalues: v16 (copy), v15 (copy), v17 (copy), linkId (copy), linkType (copy), v7 (copy)
		if not v16 then
			v15.fetchShareLinkMetadata(v17, linkId, linkType)

			return
		end

		v7:warning("ShareLinkContainer: Missing linkId or linkType in props.")
	end, {
		linkId,
		linkType,
		v16
	})

	return React.createElement(GameCardContainer, {
		universeId = if not v16 then nil else v16.universeId,
		placeId = if not v16 then nil else v16.placeId,
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

return ShareLinkContainer
