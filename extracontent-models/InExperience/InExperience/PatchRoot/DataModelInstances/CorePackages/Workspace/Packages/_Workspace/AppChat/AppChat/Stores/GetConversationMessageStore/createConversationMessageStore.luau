local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local SignalsExperimental = require(parent.SignalsExperimental)
local createProxy = SignalsExperimental.createProxy

require(AppChat.MessageData.Types)
local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local FFlagAppChatParseMessageTimestampsOnce = require(AppChat.Flags.FFlagAppChatParseMessageTimestampsOnce)
local parseIsoDateUnixMillis = require(AppChat.Utils.parseIsoDateUnixMillis)

local function keepSendingMessageStableKey(p, item)
	if p == nil or p.stableKey == nil or p.stableKey == p.id or item.stableKey ~= nil and item.stableKey ~= item.id then
		return item
	end

	return Cryo.Dictionary.join(item, { stableKey = p.stableKey })
end

local function getCreatedAtUnixMillis(p, p2) -- 2 equivalent calls inferred from this helper
	if p2 == nil or p2.created_at ~= p.created_at or p2.createdAtUnixMillis == nil then
		return parseIsoDateUnixMillis(p.created_at)
	end

	return p2.createdAtUnixMillis
end

local function withCreatedAtUnixMillis(p, p2)
	local v = {}
	local createdAtUnixMillis = getCreatedAtUnixMillis(p, p2) -- inferred equivalent call

	if createdAtUnixMillis ~= p.createdAtUnixMillis then
		if createdAtUnixMillis == nil then
			createdAtUnixMillis = Cryo.None
		end

		v.createdAtUnixMillis = createdAtUnixMillis
	end

	local replies_to = p.replies_to

	if replies_to ~= nil then
		local v2

		if p2 ~= nil then
			v2 = p2.replies_to
		end

		local createdAtUnixMillis2 = getCreatedAtUnixMillis(replies_to, v2) -- inferred equivalent call

		if createdAtUnixMillis2 ~= replies_to.createdAtUnixMillis then
			local join = Cryo.Dictionary.join

			if createdAtUnixMillis2 == nil then
				createdAtUnixMillis2 = Cryo.None
			end

			v.replies_to = join(replies_to, { createdAtUnixMillis = createdAtUnixMillis2 })
		end
	end

	if next(v) == nil then
		return p
	end

	return Cryo.Dictionary.join(p, v)
end

local function createConversationMessageStore()
	local proxy = createProxy({})

	return {
		messages = proxy,
		getMessage = function(p: string, p2)
			return proxy(p2)[p]
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
		updateMessage = function(p: string, p2)
			local v = proxy[p]

			if v ~= nil then
				local joined = Cryo.Dictionary.join(v, p2)

				if FFlagAppChatParseMessageTimestampsOnce then
					joined = withCreatedAtUnixMillis(joined, v)
				end

				proxy[p] = joined
			end
		end,
		removeMessage = function(p: string)
			proxy[p] = nil
		end,
		clear = function()
			for k in proxy do
				proxy[k] = nil
			end
		end
	}
end

return createConversationMessageStore
