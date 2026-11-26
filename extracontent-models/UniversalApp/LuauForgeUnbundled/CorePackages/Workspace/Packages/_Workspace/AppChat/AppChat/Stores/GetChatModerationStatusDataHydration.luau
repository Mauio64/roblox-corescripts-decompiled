local Players = game:GetService("Players")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("GetChatModerationStatusDataHydration")
local getResponseBody = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/getResponseBody")
local serializeChatTimeoutRange = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/serializeChatTimeoutRange")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local v6 = { status = "none" }

local function getLocalPlayerUserId()
	local userId = if Players.LocalPlayer then Players.LocalPlayer.UserId else nil

	if userId == nil or not (userId > 0) then
		return nil
	end

	return userId
end

local function toTimeoutStatus(p2)
	local v7 = serializeChatTimeoutRange(p2)
	return {
		status = "active",
		endTimestamp = v7.endTimestamp,
		decisionEventId = p2.decision_event_id,
		duration = v7.duration or 0,
		requiresAcknowledgement = v7.requiresAcknowledgement
	}
end

local function mapResponseToStatuses(p2, p3)
	local v7 = getResponseBody(p2)
	local v8

	if p3.includeUser then
		if v7 and v7.user_timeout_range then
			local user_timeout_range = v7.user_timeout_range
			local v9 = serializeChatTimeoutRange(user_timeout_range)
			v8 = {
				status = "active",
				endTimestamp = v9.endTimestamp,
				decisionEventId = user_timeout_range.decision_event_id,
				duration = v9.duration or 0,
				requiresAcknowledgement = v9.requiresAcknowledgement
			}
		else
			v8 = v6
		end
	end

	local conversationIdSet = {}
	local result = {}

	for k, conversationId in p3.conversationIds do
		conversationIdSet[conversationId] = true
		result[conversationId] = v6
	end

	if v7 and v7.conversation_timeout_ranges then
		for k, conversation_timeout_range in v7.conversation_timeout_ranges do
			if not conversationIdSet[conversation_timeout_range.id] then
				continue
			end

			local id = conversation_timeout_range.id
			local timeout_range = conversation_timeout_range.timeout_range
			local v9 = serializeChatTimeoutRange(timeout_range)
			result[id] = {
				status = "active",
				endTimestamp = v9.endTimestamp,
				decisionEventId = timeout_range.decision_event_id,
				duration = v9.duration or 0,
				requiresAcknowledgement = v9.requiresAcknowledgement
			}
		end
	end

	return v8, result
end

local function createChatModerationStatusDataHydrationStore()
	local dataCache = DataHydration.createDataCache()
	local dataCache2 = DataHydration.createDataCache()

	local count = 0
	local v7 = nil
	local v8 = {}

	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p2)
			v5:warning(`Failed to fetch local-user chat moderation status: {tostring(p2)}`)
		end,
		fetchFn = function()
			return AppChatNetworking.http.GetChatModerationStatuses(nil, nil):andThen(function(p2)
				return (mapResponseToStatuses(p2, {
					includeUser = true,
					conversationIds = {}
				}))
			end)
		end
	})

	local dataResolver2 = DataHydration.createDataResolver({
		cache = dataCache2,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p2)
			v5:warning(`Failed to fetch conversation chat moderation status: {tostring(p2)}`)
		end,
		fetchFn = function(items)
			local v9 = {}

			for k in items do
				table.insert(v9, k)
			end

			return AppChatNetworking.http.GetChatModerationStatuses(nil, v9):andThen(function(p2)
				local v10, v11 = mapResponseToStatuses(p2, {
					includeUser = false,
					conversationIds = v9
				})

				return v11
			end)
		end
	})

	local function releaseRefreshOwnership(p2, items)
		if v7 == p2 then
			v7 = nil
		end

		for k, item in items do
			if v8[item] == p2 then
				v8[item] = nil
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
		getConversationStatus = function(p2)
			return dataResolver2.getAndFetchItem(p2)
		end,
		getCachedConversationStatus = function(p2)
			return dataCache2.getItem(p2)
		end,
		ingestResponse = function(p2, p3)
			local v9, v10 = mapResponseToStatuses(p2, p3)

			if v9 then
				dataCache.replaceItem("__local_user__", v9)
			end

			if next(v10) then
				dataCache2.replaceItems(v10)
			end
		end,
		refreshStatuses = function(p2)
			count += 1
			v7 = count

			local v9 = count
			local userId = if Players.LocalPlayer then Players.LocalPlayer.UserId else nil

			if userId == nil or not (userId > 0) then
				userId = nil
			end

			local v10 = not p2 and {} or table.clone(p2)

			for k, v11 in v10 do
				v8[v11] = v9
			end

			local v11 = AppChatNetworking.http.GetChatModerationStatuses(nil, p2):andThen(function(p3)
				local userId2 = if Players.LocalPlayer then Players.LocalPlayer.UserId else nil

				if userId2 == nil or not (userId2 > 0) then
					userId2 = nil
				end

				if userId ~= userId2 then
					return p3
				end

				local v13 = {}

				for k, v14 in v10 do
					if v8[v14] == v9 then
						table.insert(v13, v14)
					end
				end

				local v15, v16 = mapResponseToStatuses(p3, {
					includeUser = v7 == v9,
					conversationIds = v13
				})

				if v15 then
					dataCache.replaceItem("__local_user__", v15)
				end

				if next(v16) then
					dataCache2.replaceItems(v16)
				end

				return p3
			end)

			local function onSuccess(p3)
				local v12 = v9

				if v7 == v12 then
					v7 = nil
				end

				for k, v14 in v10 do
					if v8[v14] == v12 then
						v8[v14] = nil
					end
				end

				return p3
			end

			local function onFailure(p3)
				local v12 = v9

				if v7 == v12 then
					v7 = nil
				end

				for k, v14 in v10 do
					if v8[v14] == v12 then
						v8[v14] = nil
					end
				end

				return Promise.reject(p3)
			end

			return v11:andThen(onSuccess, onFailure)
		end,
		setConversationStatusNone = function(p2)
			dataCache2.replaceItem(p2, v6)
		end,
		clear = function()
			if fFlagAppChatReactiveFeatureRestrictions then
				v7 = nil
				table.clear(v8)
			end

			dataResolver.clear()
			dataResolver2.clear()
		end
	}
end

local v7 = nil

local function GetChatModerationStatusDataHydration(p2)
	local v8 = v7

	if v8 ~= nil then
		return v8
	end

	local chatModerationStatusDataHydrationStore = createChatModerationStatusDataHydrationStore()
	v7 = chatModerationStatusDataHydrationStore
	return chatModerationStatusDataHydrationStore
end

return GetChatModerationStatusDataHydration
