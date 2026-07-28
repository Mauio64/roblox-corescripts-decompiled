local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local DataHydration = require(AppChatParent.DataHydration)
local v5 = require(AppChat.Logger):new(script.Name)
local getResponseBody = require(AppChat.Stores.Ingestion.getResponseBody)
local serializeChatTimeoutRange = require(AppChat.Utils.serializeChatTimeoutRange)
local t1 = {
	status = "none"
}

local function toTimeoutStatus(p1) -- line: 38
	-- upvalues: serializeChatTimeoutRange (copy)
	local v15 = serializeChatTimeoutRange(p1)

	return {
		status = "active",
		endTimestamp = v15.endTimestamp,
		decisionEventId = p1.decision_event_id,
		duration = v15.duration or 0
	}
end
local function mapResponseToStatuses(p2, t2: {[any]: any}) -- line: 48
	-- upvalues: getResponseBody (copy), serializeChatTimeoutRange (copy), t1 (copy)
	local v18 = getResponseBody(p2)
	local t3

	if t2.includeUser then
		if v18 and v18.user_timeout_range then
			local user_timeout_range = v18.user_timeout_range
			local v20 = serializeChatTimeoutRange(user_timeout_range)

			t3 = {
				status = "active",
				endTimestamp = v20.endTimestamp,
				decisionEventId = user_timeout_range.decision_event_id,
				duration = v20.duration or 0
			}
		else
			t3 = t1
		end
	else
		t3 = nil
	end

	local t4 = {}
	local t5 = {}

	for _, v25 in t2.conversationIds do
		t5[v25] = true
		t4[v25] = t1
	end

	if v18 and v18.conversation_timeout_ranges then
		for _, v27 in v18.conversation_timeout_ranges do
			if t5[v27.id] then
				local id = v27.id
				local timeout_range = v27.timeout_range
				local v30 = serializeChatTimeoutRange(timeout_range)

				t4[id] = {
					status = "active",
					endTimestamp = v30.endTimestamp,
					decisionEventId = timeout_range.decision_event_id,
					duration = v30.duration or 0
				}
			end
		end
	end

	return t3, t4
end
local function createChatModerationStatusDataHydrationStore() -- line: 78
	-- upvalues: DataHydration (copy), v5 (copy), AppChatNetworking (copy), mapResponseToStatuses (copy), t1 (copy)
	local v31 = DataHydration.createDataCache()
	local v32 = DataHydration.createDataCache()
	local v33 = DataHydration.createDataResolver({
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		cache = v31,
		logError = function(p3) -- line: 87
			-- upvalues: v5 (copy)
			v5:warning(`Failed to fetch local-user chat moderation status: { tostring(p3) }`)
		end,
		fetchFn = function() -- line: 90
			-- upvalues: AppChatNetworking (copy), mapResponseToStatuses (copy)
			return AppChatNetworking.http.GetChatModerationStatuses(nil, nil):andThen(function(p4) -- line: 91
				-- upvalues: mapResponseToStatuses (copy)
				return (mapResponseToStatuses(p4, {
					includeUser = true,
					conversationIds = {}
				}))
			end)
		end
	})
	local v34 = DataHydration.createDataResolver({
		queueProcessDelaySec = 0,
		replaceItems = true,
		cache = v32,
		logError = function(p5) -- line: 105
			-- upvalues: v5 (copy)
			v5:warning(`Failed to fetch conversation chat moderation status: { tostring(p5) }`)
		end,
		fetchFn = function(p6) -- line: 108
			-- upvalues: AppChatNetworking (copy), mapResponseToStatuses (copy)
			local t6 = {}

			for v42 in p6 do
				table.insert(t6, v42)
			end

			return AppChatNetworking.http.GetChatModerationStatuses(nil, t6):andThen(function(p7) -- line: 114
				-- upvalues: mapResponseToStatuses (copy), t6 (copy)
				local _, v52 = mapResponseToStatuses(p7, {
					includeUser = false,
					conversationIds = t6
				})

				return v52
			end)
		end
	})

	return {
		getUserStatus = function() -- line: 135
			-- upvalues: v33 (copy)
			return v33.getAndFetchItem("__local_user__")
		end,
		getConversationStatus = function(s1: string) -- line: 138
			-- upvalues: v34 (copy)
			return v34.getAndFetchItem(s1)
		end,
		ingestResponse = function(p8, t7: {[any]: any}) -- line: 124
			-- upvalues: mapResponseToStatuses (copy), v31 (copy), v32 (copy)
			local v45, v46 = mapResponseToStatuses(p8, t7)

			if v45 then
				v31.replaceItem("__local_user__", v45)
			end

			if next(v46) then
				v32.replaceItems(v46)
			end
		end,
		setConversationStatusNone = function(s2: string) -- line: 142
			-- upvalues: v32 (copy), t1 (copy)
			v32.replaceItem(s2, t1)
		end,
		clear = function() -- line: 145
			-- upvalues: v33 (copy), v34 (copy)
			v33.clear()
			v34.clear()
		end
	}
end

local u12 = nil

local function GetChatModerationStatusDataHydration(_) -- line: 154
	-- upvalues: u12 (ref), createChatModerationStatusDataHydrationStore (copy)
	local v36 = u12

	if v36 ~= nil then
		return v36
	end

	local v37 = createChatModerationStatusDataHydrationStore()

	u12 = v37

	return v37
end

return GetChatModerationStatusDataHydration
