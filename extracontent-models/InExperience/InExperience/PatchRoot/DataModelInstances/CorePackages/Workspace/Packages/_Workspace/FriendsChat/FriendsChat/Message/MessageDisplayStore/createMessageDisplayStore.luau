local parent = script:FindFirstAncestor("FriendsChat").Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local GetConversationMessageStore = require(parent.AppChat.GetConversationMessageStore)

local classifyMessage = require(script.Parent.classifyMessage)
local buildRowDisplay = require(script.Parent.buildRowDisplay)
local createFrozenSortTimes = require(script.Parent.createFrozenSortTimes)
local createGetIsGroup = require(script.Parent.createGetIsGroup)
local resolveNameInfos = require(script.Parent.resolveNameInfos)
local getLocalUserId = require(script.Parent.Parent.Parent.Utils.getLocalUserId)

local v = {}

local function createMessageDisplayStore(callback, p: string?)
	local messageRowSpecs = {}
	local frozenSortTimes = createFrozenSortTimes()

	local getIsGroup = createGetIsGroup(p)

	local function resolveForRowSpec(data, p2)
		if data.kind == "userText" or data.kind == "hiddenUser" then
			return {
				namesByUserId = resolveNameInfos({ data.senderUserId }, p2)
			}
		end

		if data.kind == "replyHeader" then
			return {
				namesByUserId = resolveNameInfos({ data.senderUserId, data.repliedToUserId }, p2),
				localUserId = getLocalUserId(),
				isGroup = getIsGroup(p2)
			}
		end

		return {}
	end

	local function getMessageRowSpecs(p2: string) -- 2 equivalent calls inferred from this helper
		local messageRowSpecs2 = messageRowSpecs[p2]

		if messageRowSpecs2 == nil then
			messageRowSpecs2 = Signals.createComputed(function(p3)
				local message = GetConversationMessageStore(p3).getMessage(p2, p3)

				if message == nil then
					return v
				end

				return classifyMessage(message)
			end)

			messageRowSpecs[p2] = messageRowSpecs2
		end

		return messageRowSpecs2
	end

	local computed = Signals.createComputed(function(p2)
		local v2 = callback(p2)
		local total = 0
		local v3 = {}

		for _, sourceId in v2 do
			local count = #getMessageRowSpecs(sourceId)(p2) -- inferred equivalent call

			if count == 0 then
				continue
			end

			if total + count > 50 then
				break
			end

			total += count
			table.insert(v3, {
				sourceId = sourceId,
				count = count,
				sortTime = frozenSortTimes(sourceId, p2)
			})
		end

		table.sort(v3, function(a, b): boolean
			if a.sortTime == b.sortTime then
				return a.sourceId < b.sourceId
			end

			return a.sortTime < b.sortTime
		end)

		local values = {}
		local idToHandle = {}

		for _, v4 in v3 do
			for i = 1, v4.count do
				local formatted = `{v4.sourceId}_{i}`
				table.insert(values, formatted)
				idToHandle[formatted] = { messageId = v4.sourceId, rowIndex = i }
			end
		end

		return { idList = values, idToHandle = idToHandle }
	end)

	return {
		getDisplayIds = Signals.createComputed(function(p2)
			return computed(p2).idList
		end, Cryo.List.equals),
		getDisplayFromId = function(p2: string?, p3, options)
			if p2 == nil then
				return nil
			end

			local v2 = computed(false).idToHandle[p2]

			if v2 == nil then
				return nil
			end

			local v3 = getMessageRowSpecs(v2.messageId)(p3)[v2.rowIndex] -- inferred equivalent call

			if v3 == nil then
				return nil
			end

			return buildRowDisplay(v3, resolveForRowSpec(v3, p3), options or {})
		end,
		getMessageIdFromDisplayId = function(p2: string?)
			if p2 == nil then
				return nil
			end

			local v2 = computed(false).idToHandle[p2]
			return if v2 then v2.messageId else nil
		end
	}
end

return createMessageDisplayStore
