local parent = script:FindFirstAncestor("FriendsChat").Parent

local Signals = require(parent.Signals)
require(parent.ChatUIPrimitives.MessageEnvelopeModel)
local GetConversationMessageStore = require(parent.AppChat.GetConversationMessageStore)

require(script.Parent.Parent.MessageDisplayStore.NameInfo)
local createFrozenSortTimes = require(script.Parent.Parent.MessageDisplayStore.createFrozenSortTimes)
local resolveNameInfos = require(script.Parent.Parent.MessageDisplayStore.resolveNameInfos)
local getLocalUserId = require(script.Parent.Parent.Parent.Utils.getLocalUserId)
require(script.Parent.Parent.Parent.Utils.useLocalize)
local buildMessageEnvelopes = require(script.Parent.buildMessageEnvelopes)
local getReplyQuote = require(script.Parent.getReplyQuote)

local frozen = table.freeze({})

local function currentUnixMilliseconds()
	return DateTime.now().UnixTimestampMillis
end

local function isSameNameInfo(p, p2): boolean
	return p.name == p2.name and p.username == p2.username
end

local function createConversationEnvelopes(callback, data)
	local v = {}
	local frozenSortTimes = createFrozenSortTimes({
		now = data.now or currentUnixMilliseconds
	})

	local v2 = {}
	local function getNameInfo(p: number)
		local v3 = v2[p]

		if v3 ~= nil then
			return v3
		end

		local computed = Signals.createComputed(function(p2)
			return resolveNameInfos({ p }, p2)[p] or { name = nil, username = nil }
		end, isSameNameInfo)

		v2[p] = computed
		return computed
	end

	local function getMessageEnvelopes(p: string)
		local v3 = v[p]

		if v3 ~= nil then
			return v3
		end

		local computed = Signals.createComputed(function(p2)
			local conversationMessageStore = GetConversationMessageStore(p2)
			local message = conversationMessageStore.getMessage(p, p2)

			if message == nil then
				return frozen
			end

			local sender_user_ids = {}

			if message.sender_user_id ~= nil then
				table.insert(sender_user_ids, message.sender_user_id)
			end

			local replies_to = message.replies_to
			local replyQuote

			if replies_to ~= nil then
				if replies_to.sender_user_id ~= nil then
					table.insert(sender_user_ids, replies_to.sender_user_id)
				end

				local v4

				if replies_to.id then
					v4 = conversationMessageStore.getMessage(replies_to.id, p2)
				end

				replyQuote = getReplyQuote(replies_to, v4)
			end

			local namesByUserId = {}

			for _, v4 in sender_user_ids do
				local v5 = v2[v4]

				if v5 == nil then
					v5 = Signals.createComputed(function(p3)
						return resolveNameInfos({ v4 }, p3)[v4] or { name = nil, username = nil }
					end, isSameNameInfo)

					v2[v4] = v5
				end

				namesByUserId[v4] = v5(p2)
			end

			return buildMessageEnvelopes(message, {
				localUserId = getLocalUserId(),
				namesByUserId = namesByUserId,
				sentAtUnixMilliseconds = frozenSortTimes(p, p2),
				replyQuote = replyQuote,
				isGroup = data.getIsGroup(p2),
				localize = data.localize
			})
		end)

		v[p] = computed
		return computed
	end

	return {
		getEnvelopes = Signals.createComputed(function(p)
			local count = 0
			local result = {}

			for _, v3 in callback(p) do
				if data.maxMessages > 0 and data.maxMessages <= count then
					break
				end

				local v4 = v[v3]

				if v4 == nil then
					v4 = Signals.createComputed(function(p2)
						local conversationMessageStore = GetConversationMessageStore(p2)
						local message = conversationMessageStore.getMessage(v3, p2)

						if message == nil then
							return frozen
						end

						local sender_user_ids = {}

						if message.sender_user_id ~= nil then
							table.insert(sender_user_ids, message.sender_user_id)
						end

						local replies_to = message.replies_to
						local replyQuote

						if replies_to ~= nil then
							if replies_to.sender_user_id ~= nil then
								table.insert(sender_user_ids, replies_to.sender_user_id)
							end

							local v5

							if replies_to.id then
								v5 = conversationMessageStore.getMessage(replies_to.id, p2)
							end

							replyQuote = getReplyQuote(replies_to, v5)
						end

						local namesByUserId = {}

						for _, v5 in sender_user_ids do
							local v6 = v2[v5]

							if v6 == nil then
								v6 = Signals.createComputed(function(p3)
									return resolveNameInfos({ v5 }, p3)[v5] or {
										name = nil,
										username = nil
									}
								end, isSameNameInfo)

								v2[v5] = v6
							end

							namesByUserId[v5] = v6(p2)
						end

						return buildMessageEnvelopes(message, {
							localUserId = getLocalUserId(),
							namesByUserId = namesByUserId,
							sentAtUnixMilliseconds = frozenSortTimes(v3, p2),
							replyQuote = replyQuote,
							isGroup = data.getIsGroup(p2),
							localize = data.localize
						})
					end)

					v[v3] = v4
				end

				local v5 = v4(p)

				if not (#v5 > 0) then
					continue
				end

				count += 1

				for _, v6 in v5 do
					table.insert(result, v6)
				end
			end

			return result
		end)
	}
end

return { create = createConversationEnvelopes }
