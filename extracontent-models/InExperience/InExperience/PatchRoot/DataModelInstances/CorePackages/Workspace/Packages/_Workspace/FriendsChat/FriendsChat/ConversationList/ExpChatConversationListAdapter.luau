local parent = script:FindFirstAncestor("FriendsChat").Parent

local AppChat = require(parent.AppChat)
local AppChatNetworking = require(parent.AppChatNetworking)
local ConversationChannels = require(parent.AppChat.ConversationChannels)
local createConversationFromFriendPlaceholder = require(parent.AppChat.createConversationFromFriendPlaceholder)
local fetchConversationDetailsToSignals = require(parent.AppChat.fetchConversationDetailsToSignals)
local fetchConversationListPageToSignals = require(parent.AppChat.fetchConversationListPageToSignals)
local getConversationTitle = require(parent.AppChat.getConversationTitle)
local GetConversationStore = require(parent.AppChat.GetConversationStore)
local logger = AppChat.Components.ChatConversation.logger

local function getConversationStore() -- 4 equivalent calls inferred from this helper
	return GetConversationStore(false)
end

local function getMessageTimestamp(p)
	if type(p.created_at) == "string" then
		local success, result = pcall(function()
			return DateTime.fromIsoDate(p.created_at)
		end)

		if success then
			return result
		end
	end

	return nil
end

local function getUnixTime(value) -- 2 equivalent calls inferred from this helper
	if value == nil then
		return nil
	end

	if typeof(value) == "DateTime" then
		return value.UnixTimestamp
	end

	if type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return value:GetUnixTimestamp()
	end

	return nil
end

local function getPreviewContent(p) -- 2 equivalent calls inferred from this helper
	return p.preview_content or p.content
end

local function getMessageUnixTime(item) -- 2 equivalent calls inferred from this helper
	local result

	if type(item.created_at) == "string" then
		local success
		success, result = pcall(function()
			return DateTime.fromIsoDate(item.created_at)
		end)

		if not success then
			result = nil
		end
	end

	return if result ~= nil then result.UnixTimestamp else nil
end

local function isPreviewableMessage(item): boolean -- 1 equivalent call inferred from this helper
	return item ~= nil and item.id ~= nil and item.is_previewable == true and getPreviewContent(item) ~= nil -- inferred equivalent call
end

local function getNewestPreviewableMessage(items)
	local newestPreviewableMessage = nil
	local v = nil

	for _, item in items do
		if not isPreviewableMessage(item) then -- inferred equivalent call
			continue
		end

		local messageUnixTime = getMessageUnixTime(item) -- inferred equivalent call

		if newestPreviewableMessage == nil then
			v = messageUnixTime
			newestPreviewableMessage = item
		elseif messageUnixTime ~= nil and (v == nil or v < messageUnixTime) then
			v = messageUnixTime
			newestPreviewableMessage = item
		end
	end

	return newestPreviewableMessage
end

local function shouldUpdatePreview(conversation, result): boolean -- 1 equivalent call inferred from this helper
	if result == nil then
		return true
	end

	local unixTime = getUnixTime(conversation.lastUpdated) -- inferred equivalent call
	return unixTime == nil or unixTime <= result.UnixTimestamp
end

local function isUnreadCandidateMessage(item, p): boolean -- 1 equivalent call inferred from this helper
	if item == nil or item.is_badgeable ~= true then
		return false
	end

	local sender_user_id = item.sender_user_id

	if sender_user_id == nil then
		return false
	end

	return p == nil or p.localUserId == nil or tostring(sender_user_id) ~= tostring(p.localUserId)
end

local function hasNewerUnreadMessage(items, p): boolean
	if p == nil or p.hasUnreadMessages ~= true then
		return false
	end

	local v = getUnixTime(p.unreadFreshnessLastUpdated) or 0 -- inferred equivalent call

	for _, item in items do
		if not isUnreadCandidateMessage(item, p) then -- inferred equivalent call
			continue
		end

		local messageUnixTime = getMessageUnixTime(item) -- inferred equivalent call

		if messageUnixTime ~= nil and v < messageUnixTime then
			return true
		end
	end

	return false
end

local ExpChatConversationListAdapter = {}
ExpChatConversationListAdapter.ConversationSource = ConversationChannels.Source
ExpChatConversationListAdapter.createConversationFromFriendPlaceholder = createConversationFromFriendPlaceholder
ExpChatConversationListAdapter.fetchConversationDetailsToSignals = fetchConversationDetailsToSignals
ExpChatConversationListAdapter.fetchConversationListPageToSignals = fetchConversationListPageToSignals
ExpChatConversationListAdapter.getConversationStore = getConversationStore
ExpChatConversationListAdapter.getConversationTitle = getConversationTitle

function ExpChatConversationListAdapter.isFriendPlaceholder(value: string?, p): boolean
	if value == nil or value == "" then
		return false
	end

	local conversation = getConversationStore().getConversation(value, p or false) -- inferred equivalent call

	if conversation == nil then
		return string.sub(value, 1, 8) == "friends:"
	end

	return conversation.source == ConversationChannels.Source.Friends
end

function ExpChatConversationListAdapter.markConversationRead(p: string, flag: boolean?)
	local conversationStore = getConversationStore() -- inferred equivalent call
	local conversation = conversationStore.getConversation(p, false)
	local v = flag == true

	if conversation == nil then
		if not v then
			return
		end
	elseif conversation.hasUnreadMessages == true then
		local clone = table.clone(conversation)
		clone.hasUnreadMessages = false
		conversationStore.upsertConversation(clone, false)
		v = true
	end

	if v then
		return AppChatNetworking.http.MarkConversationRead(nil, p):catch(function(p2)
			logger:warning(`Failed to mark conversation read for {p}: {tostring(p2)}`)
		end)
	end
end

function ExpChatConversationListAdapter.removeConversation(p: string)
	getConversationStore().removeConversation(p) -- inferred equivalent call
end

function ExpChatConversationListAdapter.updateConversationPreviewFromMessages(p: string, p2, p3)
	local conversationStore = getConversationStore() -- inferred equivalent call
	local conversation = conversationStore.getConversation(p, false)

	if conversation == nil then
		if p3 ~= nil and p3.refreshListOnMissingConversation == true then
			fetchConversationListPageToSignals():catch(function(p4)
				logger:warning(`Failed to refresh conversation list after realtime update: {tostring(p4)}`)
			end)
		end

		return false, hasNewerUnreadMessage(p2, p3)
	else
		local v = nil

		local newestPreviewableMessage = getNewestPreviewableMessage(p2)

		if newestPreviewableMessage ~= nil then
			local result

			if type(newestPreviewableMessage.created_at) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(newestPreviewableMessage.created_at)
				end)

				if not success then
					result = nil
				end
			end

			if shouldUpdatePreview(conversation, result) then -- inferred equivalent call
				v = table.clone(conversation)
				v.previewMessageId = tostring(newestPreviewableMessage.id)
				v.previewContent = getPreviewContent(newestPreviewableMessage) -- inferred equivalent call
				v.lastUpdated = result or DateTime.now()
			end
		end

		local newerUnreadMessage = hasNewerUnreadMessage(p2, p3)

		if conversation.hasUnreadMessages ~= true and newerUnreadMessage then
			v = v or table.clone(conversation)
			v.hasUnreadMessages = true
		end

		if v == nil then
			return false, newerUnreadMessage
		end

		conversationStore.upsertConversation(v, false)
		return true, newerUnreadMessage
	end
end

return ExpChatConversationListAdapter
