local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local createProxy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental").createProxy

local v5 = {
	"oldestConversationIsFetched",
	"isFetchingConversations",
	"isFetchingNextPage",
	"hasFetchedInitialPage",
	"isExhausted",
	"nextCursor",
	"error"
}

local set = {}
local v6 = {
	oldestConversationIsFetched = false,
	isFetchingConversations = false,
	isFetchingNextPage = false,
	hasFetchedInitialPage = false,
	isExhausted = false,
	nextCursor = nil,
	error = nil
}

for k, v7 in v5 do
	set[v7] = true
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

local function mergePreservedLocalFields(data, p2)
	if data == nil then
		return p2
	end

	return Cryo.Dictionary.join(p2, {
		usersTyping = data.usersTyping,
		isUserLeaving = data.isUserLeaving,
		pinnedGame = data.pinnedGame
	})
end

local function copyListStatus(callback, p2)
	local v7 = callback(p2)
	local result = {}

	for k, v8 in v5 do
		result[v8] = v7[v8]
	end

	return result
end

local function clearProxy(items)
	for k in items do
		items[k] = nil
	end
end

local function createConversationStore()
	local proxy = createProxy({})

	local proxy2 = createProxy({})
	local proxy3 = createProxy(table.clone(v6))
	local v7 = {}

	return {
		getConversation = function(p2, p3)
			return proxy(p3)[p2]
		end,
		getConversations = function(p2)
			local conversations = {}

			for k, v8 in proxy(p2) do
				if v8 ~= nil then
					table.insert(conversations, v8)
				end
			end

			return conversations
		end,
		getParticipantMetadata = function(p2, p3)
			return proxy2(p3)[p2]
		end,
		getListStatus = function(p2)
			local v8 = proxy3(p2)
			local listStatus = {}

			for k, v9 in v5 do
				listStatus[v9] = v8[v9]
			end

			return listStatus
		end,
		listStatus = proxy3,
		addClearListener = function(p2)
			table.insert(v7, p2)
		end,
		upsertConversation = function(p2, p3)
			local conversation = normalizeConversation(p2)

			if conversation == nil then
				return
			end

			local id = conversation.id
			local v8 = proxy

			if p3 ~= false then
				local v9 = proxy[id]

				if v9 ~= nil then
					conversation = Cryo.Dictionary.join(conversation, {
						usersTyping = v9.usersTyping,
						isUserLeaving = v9.isUserLeaving,
						pinnedGame = v9.pinnedGame
					})
				end
			end

			v8[id] = conversation
		end,
		removeConversation = function(p2)
			proxy[p2] = nil
			proxy2[p2] = nil
		end,
		setParticipantMetadata = function(p2, p3)
			proxy2[p2] = p3
		end,
		setUsersTyping = function(p2, p3)
			local v8 = proxy[p2]

			if v8 == nil then
				return
			end

			proxy[p2] = Cryo.Dictionary.join(v8, { usersTyping = p3 })
		end,
		setListStatus = function(items)
			for k, item in items do
				if set[k] ~= true then
					continue
				end

				local v8 = proxy3

				if item == Cryo.None then
					item = nil
				end

				v8[k] = item
			end
		end,
		clear = function()
			local v8 = proxy

			for k in v8 do
				v8[k] = nil
			end

			local v9 = proxy2

			for k in v9 do
				v9[k] = nil
			end

			local v10 = proxy3

			for k in v10 do
				v10[k] = nil
			end

			for k, v11 in v6 do
				if set[k] ~= true then
					continue
				end

				local v12 = proxy3

				if v11 == Cryo.None then
					v11 = nil
				end

				v12[k] = v11
			end

			for k, v11 in v7 do
				v11()
			end
		end
	}
end

return createConversationStore
