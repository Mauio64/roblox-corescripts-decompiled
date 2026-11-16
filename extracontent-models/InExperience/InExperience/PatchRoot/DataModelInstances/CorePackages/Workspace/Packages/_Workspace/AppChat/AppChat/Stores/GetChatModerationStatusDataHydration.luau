local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Players = game:GetService("Players")

local AppChatNetworking = require(parent.AppChatNetworking)
local DataHydration = require(parent.DataHydration)
require(parent.LuauPolyfill)
local Promise = require(parent.Promise)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local getResponseBody = require(AppChat.Stores.Ingestion.getResponseBody)
local serializeChatTimeoutRange = require(AppChat.Utils.serializeChatTimeoutRange)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local v2 = { status = "none" }

local function getLocalPlayerUserId() -- 2 equivalent calls inferred from this helper
	local userId

	if Players.LocalPlayer then
		userId = Players.LocalPlayer.UserId
	end

	if userId == nil or not (userId > 0) then
		return nil
	end

	return userId
end

local function toTimeoutStatus(p) -- 2 equivalent calls inferred from this helper
	local v3 = serializeChatTimeoutRange(p)
	return {
		status = "active",
		endTimestamp = v3.endTimestamp,
		decisionEventId = p.decision_event_id,
		duration = v3.duration or 0,
		requiresAcknowledgement = v3.requiresAcknowledgement
	}
end

local function mapResponseToStatuses(p, p2)
	local responseBody = getResponseBody(p)
	local v3

	if p2.includeUser then
		if responseBody and responseBody.user_timeout_range then
			v3 = toTimeoutStatus(responseBody.user_timeout_range) -- inferred equivalent call
		else
			v3 = v2
		end
	end

	local conversationIdSet = {}
	local result = {}

	for _, conversationId in p2.conversationIds do
		conversationIdSet[conversationId] = true
		result[conversationId] = v2
	end

	if responseBody and responseBody.conversation_timeout_ranges then
		for _, conversation_timeout_range in responseBody.conversation_timeout_ranges do
			if not conversationIdSet[conversation_timeout_range.id] then
				continue
			end

			local id = conversation_timeout_range.id
			result[id] = toTimeoutStatus(conversation_timeout_range.timeout_range) -- inferred equivalent call
		end
	end

	return v3, result
end

local function createChatModerationStatusDataHydrationStore()
	local dataCache = DataHydration.createDataCache()
	local dataCache2 = DataHydration.createDataCache()

	local count = 0
	local v3 = nil
	local v4 = {}

	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p)
			v:warning(`Failed to fetch local-user chat moderation status: {tostring(p)}`)
		end,
		fetchFn = function()
			return AppChatNetworking.http.GetChatModerationStatuses(nil, nil):andThen(function(p)
				return (mapResponseToStatuses(p, { includeUser = true, conversationIds = {} }))
			end)
		end
	})

	local dataResolver2 = DataHydration.createDataResolver({
		cache = dataCache2,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p)
			v:warning(`Failed to fetch conversation chat moderation status: {tostring(p)}`)
		end,
		fetchFn = function(items)
			local conversationIds = {}

			for k in items do
				table.insert(conversationIds, k)
			end

			return AppChatNetworking.http.GetChatModerationStatuses(nil, conversationIds):andThen(function(p)
				local _, v5 = mapResponseToStatuses(p, {
					includeUser = false,
					conversationIds = conversationIds
				})

				return v5
			end)
		end
	})

	local function ingestResponse(p, p2) -- 1 equivalent call inferred from this helper
		local v5, v6 = mapResponseToStatuses(p, p2)

		if v5 then
			dataCache.replaceItem("__local_user__", v5)
		end

		if next(v6) then
			dataCache2.replaceItems(v6)
		end
	end

	local function releaseRefreshOwnership(p: number, items) -- 2 equivalent calls inferred from this helper
		if v3 == p then
			v3 = nil
		end

		for _, item in items do
			if v4[item] == p then
				v4[item] = nil
			end
		end
	end

	return {
		getUserStatus = function()
			return dataResolver.getAndFetchItem("__local_user__")
		end,
		getCachedUserStatus = function()
			return dataCache.getItem("__local_user__")
		end,
		getConversationStatus = function(p: string)
			return dataResolver2.getAndFetchItem(p)
		end,
		getCachedConversationStatus = function(p: string)
			return dataCache2.getItem(p)
		end,
		ingestResponse = ingestResponse,
		refreshStatuses = function(p)
			count += 1
			v3 = count

			local v5 = count
			local localPlayerUserId = getLocalPlayerUserId() -- inferred equivalent call
			local v6 = not p and {} or table.clone(p)

			for _, v7 in v6 do
				v4[v7] = v5
			end

			local v7 = AppChatNetworking.http.GetChatModerationStatuses(nil, p):andThen(function(p2)
				if localPlayerUserId ~= getLocalPlayerUserId() then -- inferred equivalent call
					return p2
				end

				local conversationIds = {}

				for _, v7 in v6 do
					if v4[v7] == v5 then
						table.insert(conversationIds, v7)
					end
				end

				ingestResponse(p2, { -- inferred equivalent call
					includeUser = v3 == v5,
					conversationIds = conversationIds
				})

				return p2
			end)

			local function onSuccess(p2)
				releaseRefreshOwnership(v5, v6) -- inferred equivalent call
				return p2
			end

			local function onFailure(p2)
				releaseRefreshOwnership(v5, v6) -- inferred equivalent call
				return Promise.reject(p2)
			end

			return v7:andThen(onSuccess, onFailure)
		end,
		setConversationStatusNone = function(p: string)
			dataCache2.replaceItem(p, v2)
		end,
		clear = function()
			if FFlagAppChatReactiveFeatureRestrictions then
				v3 = nil
				table.clear(v4)
			end

			dataResolver.clear()
			dataResolver2.clear()
		end
	}
end

local v3 = nil

local function GetChatModerationStatusDataHydration(_)
	local v4 = v3

	if v4 ~= nil then
		return v4
	end

	local chatModerationStatusDataHydrationStore = createChatModerationStatusDataHydrationStore()
	v3 = chatModerationStatusDataHydrationStore
	return chatModerationStatusDataHydrationStore
end

return GetChatModerationStatusDataHydration
