local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local createProxy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental").createProxy

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Types")
local SignalsMigrationConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig")
local FFlagAppChatParseMessageTimestampsOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatParseMessageTimestampsOnce")
local parseIsoDateUnixMillis = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/parseIsoDateUnixMillis")

local function keepSendingMessageStableKey(p2, item)
	if
		p2 == nil
		or p2.stableKey == nil
		or p2.stableKey == p2.id
		or item.stableKey ~= nil and item.stableKey ~= item.id
	then
		return item
	end

	return Cryo.Dictionary.join(item, { stableKey = p2.stableKey })
end

local function getCreatedAtUnixMillis(p2, p3)
	if p3 == nil or p3.created_at ~= p2.created_at or p3.createdAtUnixMillis == nil then
		return parseIsoDateUnixMillis(p2.created_at)
	end

	return p3.createdAtUnixMillis
end

local function withCreatedAtUnixMillis(data, data2)
	local v5 = {}
	local v6

	if data2 == nil or data2.created_at ~= data.created_at or data2.createdAtUnixMillis == nil then
		v6 = parseIsoDateUnixMillis(data.created_at)
	else
		v6 = data2.createdAtUnixMillis
	end

	if v6 ~= data.createdAtUnixMillis then
		if v6 == nil then
			v6 = Cryo.None
		end

		v5.createdAtUnixMillis = v6
	end

	local replies_to = data.replies_to

	if replies_to ~= nil then
		local replies_to2 = if data2 ~= nil then data2.replies_to else nil
		local v7

		if
			replies_to2 == nil
			or replies_to2.created_at ~= replies_to.created_at
			or replies_to2.createdAtUnixMillis == nil
		then
			v7 = parseIsoDateUnixMillis(replies_to.created_at)
		else
			v7 = replies_to2.createdAtUnixMillis
		end

		if v7 ~= replies_to.createdAtUnixMillis then
			local join = Cryo.Dictionary.join

			if v7 == nil then
				v7 = Cryo.None
			end

			v5.replies_to = join(replies_to, { createdAtUnixMillis = v7 })
		end
	end

	if next(v5) == nil then
		return data
	end

	return Cryo.Dictionary.join(data, v5)
end

local function createConversationMessageStore()
	local proxy = createProxy({})

	return {
		messages = proxy,
		getMessage = function(p2, p3)
			return proxy(p3)[p2]
		end,
		upsertMessages = function(items)
			for k, item in items do
				if SignalsMigrationConfig.shouldUseViewRecyclerMessageList then
					item = keepSendingMessageStableKey(proxy[k], item)
				end

				if FFlagAppChatParseMessageTimestampsOnce then
					item = withCreatedAtUnixMillis(item, proxy[k])
				end

				proxy[k] = item
			end
		end,
		updateMessage = function(p2, p3)
			local v5 = proxy[p2]

			if v5 ~= nil then
				local joined = Cryo.Dictionary.join(v5, p3)

				if FFlagAppChatParseMessageTimestampsOnce then
					joined = withCreatedAtUnixMillis(joined, v5)
				end

				proxy[p2] = joined
			end
		end,
		removeMessage = function(p2)
			proxy[p2] = nil
		end,
		clear = function()
			for k in proxy do
				proxy[k] = nil
			end
		end
	}
end

return createConversationMessageStore
