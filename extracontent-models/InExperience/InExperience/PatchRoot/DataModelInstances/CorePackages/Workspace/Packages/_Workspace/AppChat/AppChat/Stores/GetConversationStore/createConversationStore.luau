local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local SignalsExperimental = require(parent.SignalsExperimental)
local createProxy = SignalsExperimental.createProxy

local v = {
	"oldestConversationIsFetched",
	"isFetchingConversations",
	"isFetchingNextPage",
	"hasFetchedInitialPage",
	"isExhausted",
	"nextCursor",
	"error"
}

local set = {}
local v2 = {
	oldestConversationIsFetched = false,
	isFetchingConversations = false,
	isFetchingNextPage = false,
	hasFetchedInitialPage = false,
	isExhausted = false,
	nextCursor = nil,
	error = nil
}

for _, v3 in v do
	set[v3] = true
end

local function normalizeConversation(data)
	if data == nil or data.id == nil then
		return nil
	end

	return {
		id = tostring(data.id),
		source = data.source,
		type = data.type,
		createdAt = data.createdAt,
		clientId = data.clientId,
		initiator = data.initiator,
		participants = data.participants,
		conversationType = data.conversationType,
		title = data.title,
		titleForViewer = data.titleForViewer,
		isDefaultTitle = data.isDefaultTitle,
		lastUpdated = data.lastUpdated,
		previewMessageId = data.previewMessageId,
		previewContent = data.previewContent,
		hasUnreadMessages = data.hasUnreadMessages,
		hasGroupUp = data.hasGroupUp,
		usersTyping = data.usersTyping,
		isUserLeaving = data.isUserLeaving,
		serverState = data.serverState,
		pinnedGame = data.pinnedGame,
		moderationType = data.moderationType,
		userPendingStatus = data.userPendingStatus,
		participantPendingStatus = data.participantPendingStatus,
		callButtonEligibility = data.callButtonEligibility,
		osaAcknowledgementStatus = data.osaAcknowledgementStatus,
		userOptedIntoChatMessages = data.userOptedIntoChatMessages,
		initialLoadingStatus = data.initialLoadingStatus
	}
end

local function mergePreservedLocalFields(data, conversation) -- 1 equivalent call inferred from this helper
	if data == nil then
		return conversation
	end

	return Cryo.Dictionary.join(conversation, {
		usersTyping = data.usersTyping,
		isUserLeaving = data.isUserLeaving,
		pinnedGame = data.pinnedGame
	})
end

local function copyListStatus(proxy, p) -- 1 equivalent call inferred from this helper
	local v3 = proxy(p)
	local result = {}

	for _, v4 in v do
		result[v4] = v3[v4]
	end

	return result
end

local function clearProxy(proxy) -- 3 equivalent calls inferred from this helper
	for k in proxy do
		proxy[k] = nil
	end
end

local function createConversationStore()
	local proxy = createProxy({})

	local proxy2 = createProxy({})
	local proxy3 = createProxy(table.clone(v2))
	local v3 = {}

	local function setListStatus(items) -- 1 equivalent call inferred from this helper
		for k, item in items do
			if set[k] ~= true then
				continue
			end

			if item == Cryo.None then
				item = nil
			end

			proxy3[k] = item
		end
	end

	return {
		getConversation = function(p: string, p2)
			return proxy(p2)[p]
		end,
		getConversations = function(p)
			local conversations = {}

			for _, v4 in proxy(p), nil, nil do
				if v4 ~= nil then
					table.insert(conversations, v4)
				end
			end

			return conversations
		end,
		getParticipantMetadata = function(p: string, p2)
			return proxy2(p2)[p]
		end,
		getListStatus = function(p)
			return copyListStatus(proxy3, p) -- inferred equivalent call
		end,
		listStatus = proxy3,
		addClearListener = function(callback)
			table.insert(v3, callback)
		end,
		upsertConversation = function(p, flag: boolean?)
			local conversation = normalizeConversation(p)

			if conversation == nil then
				return
			end

			local id = conversation.id

			if flag ~= false then
				conversation = mergePreservedLocalFields(proxy[id], conversation) -- inferred equivalent call
			end

			proxy[id] = conversation
		end,
		removeConversation = function(p: string)
			proxy[p] = nil
			proxy2[p] = nil
		end,
		setParticipantMetadata = function(p: string, p2)
			proxy2[p] = p2
		end,
		setUsersTyping = function(p: string, usersTyping)
			local v4 = proxy[p]

			if v4 == nil then
				return
			end

			proxy[p] = Cryo.Dictionary.join(v4, { usersTyping = usersTyping })
		end,
		setListStatus = setListStatus,
		clear = function()
			clearProxy(proxy) -- inferred equivalent call
			clearProxy(proxy2) -- inferred equivalent call
			clearProxy(proxy3) -- inferred equivalent call
			setListStatus(v2) -- inferred equivalent call

			for _, v4 in v3 do
				v4()
			end
		end
	}
end

return createConversationStore
