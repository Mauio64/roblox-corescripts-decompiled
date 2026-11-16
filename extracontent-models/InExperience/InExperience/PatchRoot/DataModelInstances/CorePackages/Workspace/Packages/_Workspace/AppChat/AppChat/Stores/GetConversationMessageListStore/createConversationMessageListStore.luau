local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local createProxy = SignalsExperimental.createProxy

local ArraySet = require(AppChat.DataStructures.ArraySet)
local FFlagAppChatBatchMessageListPagePublication = require(AppChat.Flags.FFlagAppChatBatchMessageListPagePublication)
local FFlagAppChatIncrementalPaginationProjection = require(AppChat.Flags.FFlagAppChatIncrementalPaginationProjection)
local FFlagAppChatGroupedVariantNeighbourIds = require(AppChat.Flags.FFlagAppChatGroupedVariantNeighbourIds)

local function newConversationOrdering() -- 1 equivalent call inferred from this helper
	return { messageIds = ArraySet.new({}) }
end

local function newMessagePaginationMetadata() -- 1 equivalent call inferred from this helper
	return { nextPageCursor = nil, isLoading = false, fetchedOldest = false }
end

local function createConversationMessageListStore()
	local proxy = createProxy({})

	local proxy2 = createProxy({})

	local proxy3 = createProxy({})
	local proxy4 = createProxy({})

	local signals = {}
	local v = {}
	local count = 0
	local v2 = 0
	local v3 = {}
	local v4 = {}

	local function publishMutation(p: string, operation: string, p2, p3, boundaryMessageId: string?)
		count += 1

		if signals[p] == nil then
			local signal, v5 = Signals.createSignal(nil)
			signals[p] = signal
			v[p] = v5
		end

		local v5 = {
			operation = operation,
			messageIds = table.clone(p2),
			insertedIds = table.clone(p3),
			boundaryMessageId = boundaryMessageId,
			revision = count
		}

		if not (v2 > 0) then
			v[p](v5)
			return
		end

		local v6 = v4[p]

		if v6 == nil then
			v6 = {}
			v4[p] = v6
			table.insert(v3, p)
		end

		table.insert(v6, v5)
	end

	local function publishQueuedMutations()
		local v5 = v3
		local v6 = v4
		v3 = {}
		v4 = {}

		for _, v7 in v5 do
			local mutations = v6[v7]

			if #mutations == 1 then
				v[v7](mutations[1])
			else
				v[v7]({
					operation = "Batch",
					messageIds = {},
					insertedIds = {},
					boundaryMessageId = nil,
					revision = mutations[#mutations].revision,
					mutations = mutations
				})
			end
		end
	end

	local function addTraceback(value)
		if type(value) == "string" then
			return debug.traceback(value, 2)
		end

		return value
	end

	local function batchMutations(callback) -- 2 equivalent calls inferred from this helper
		local success = nil
		local result = nil
		SignalsExperimental.batch(function()
			v2 += 1

			success, result = xpcall(callback, addTraceback)
			v2 -= 1

			if v2 == 0 then
				publishQueuedMutations()
			end
		end)

		if not success then
			error(result, 0)
		end
	end

	local function getOrDefaultOrdering(p: string) -- 2 equivalent calls inferred from this helper
		local v5 = proxy[p]

		if v5 == nil then
			return newConversationOrdering() -- inferred equivalent call
		end

		return v5
	end

	local function getOrDefaultMetadata(p: string) -- 2 equivalent calls inferred from this helper
		local v5 = proxy2[p]

		if v5 == nil then
			return newMessagePaginationMetadata() -- inferred equivalent call
		end

		return v5
	end

	local function getNeighbourKey(p: string, p2: string) -- 3 equivalent calls inferred from this helper
		return p .. "\0" .. p2
	end

	local function writeNeighbourIds(p: string, p2, p3: number, p4: number)
		for i = (math.max)(p3, 1), math.min(p4, p2.messageIds:size()) do
			local neighbourKey = getNeighbourKey(p, p2.messageIds:at(i)) -- inferred equivalent call
			proxy3[neighbourKey] = p2.messageIds:at(i - 1)
			proxy4[neighbourKey] = p2.messageIds:at(i + 1)
		end
	end

	local function clearNeighbourIds(p: string, items) -- 3 equivalent calls inferred from this helper
		for _, item in items do
			local neighbourKey = getNeighbourKey(p, item) -- inferred equivalent call
			proxy3[neighbourKey] = nil
			proxy4[neighbourKey] = nil
		end
	end

	local function runOrderingWrite(callback) -- 5 equivalent calls inferred from this helper
		if not FFlagAppChatGroupedVariantNeighbourIds then
			callback()

			return
		end

		batchMutations(callback) -- inferred equivalent call
	end

	local function prependMessagesInternal(p: string, list)
		local defaultOrdering = getOrDefaultOrdering(p) -- inferred equivalent call
		local size = defaultOrdering.messageIds:size()

		local v5 = {}
		local v6

		if FFlagAppChatIncrementalPaginationProjection then
			v6 = defaultOrdering.messageIds:at(1)
			local set = {}

			for _, item in list do
				if defaultOrdering.messageIds:has(item) or set[item] then
					continue
				end

				set[item] = true
				table.insert(v5, item)
			end
		end

		if defaultOrdering.messageIds:prependAll(list) then
			proxy[p] = table.clone(defaultOrdering)

			if FFlagAppChatGroupedVariantNeighbourIds then
				writeNeighbourIds(p, defaultOrdering, 1, defaultOrdering.messageIds:size() - size + 1)
			end

			if FFlagAppChatIncrementalPaginationProjection then
				publishMutation(p, "Prepend", list, v5, v6)
			end
		elseif FFlagAppChatIncrementalPaginationProjection and #list > 0 then
			publishMutation(p, "Prepend", list, {}, nil)
		end
	end

	local function appendMessagesInternal(p: string, items)
		local defaultOrdering = getOrDefaultOrdering(p) -- inferred equivalent call
		local size = defaultOrdering.messageIds:size()
		local v5 = defaultOrdering.messageIds:at(size)

		local result = {}

		for _, item in items do
			if defaultOrdering.messageIds:add(item) then
				table.insert(result, item)
			end
		end

		if #result > 0 then
			proxy[p] = table.clone(defaultOrdering)
		end

		if FFlagAppChatGroupedVariantNeighbourIds and #result > 0 then
			writeNeighbourIds(p, defaultOrdering, size, defaultOrdering.messageIds:size())
		end

		return result, v5
	end

	local function appendMessagesAndPublish(p: string, list) -- 1 equivalent call inferred from this helper
		local v5, boundaryMessageId = appendMessagesInternal(p, list)

		if FFlagAppChatIncrementalPaginationProjection and #list > 0 then
			publishMutation(p, "Append", list, v5, boundaryMessageId)
		end
	end

	local function removeMessageInternal(p: string, p2: string)
		local v5 = proxy[p]

		if v5 == nil then
			return
		end

		local index = v5.messageIds:indexOf(p2)

		if index == nil or not v5.messageIds:remove(p2) then
			return
		end

		proxy[p] = table.clone(v5)

		if FFlagAppChatGroupedVariantNeighbourIds then
			clearNeighbourIds(p, { p2 }) -- inferred equivalent call

			writeNeighbourIds(p, v5, index - 1, index)
		end

		if FFlagAppChatIncrementalPaginationProjection then
			publishMutation(p, "Remove", { p2 }, {}, nil)
		end
	end

	local function updatePagination(p: string, nextPageCursor: string?, fetchedOldest: boolean)
		local defaultMetadata = getOrDefaultMetadata(p) -- inferred equivalent call
		local union = Cryo.Dictionary.union

		if not nextPageCursor or nextPageCursor == "" then
			nextPageCursor = defaultMetadata.nextPageCursor
		end

		proxy2[p] = union(defaultMetadata, {
			nextPageCursor = nextPageCursor,
			isLoading = false,
			fetchedOldest = fetchedOldest
		})
	end

	local function receivePageInternal(p: string, p2, p3: string?) -- 3 equivalent calls inferred from this helper
		local v5, boundaryMessageId = appendMessagesInternal(p, p2)
		updatePagination(p, p3, p3 == nil or p3 == "")

		if FFlagAppChatIncrementalPaginationProjection then
			publishMutation(p, "AppendAndAdvanceCursor", p2, v5, boundaryMessageId)
		end
	end

	local function clearConversationInternal(p: string)
		if FFlagAppChatGroupedVariantNeighbourIds then
			local v5 = proxy[p]

			if v5 ~= nil then
				clearNeighbourIds(p, v5.messageIds:values()) -- inferred equivalent call
			end
		end

		proxy[p] = nil
		proxy2[p] = nil

		if FFlagAppChatIncrementalPaginationProjection then
			publishMutation(p, "Reset", {}, {}, nil)
		end
	end

	local function clearInternal()
		local v5 = {}
		local set = {}

		for k, v6 in proxy do
			table.insert(v5, k)
			set[k] = true

			if FFlagAppChatGroupedVariantNeighbourIds and v6 ~= nil then
				clearNeighbourIds(k, v6.messageIds:values()) -- inferred equivalent call
			end

			proxy[k] = nil
		end

		for k in proxy2 do
			proxy2[k] = nil
		end

		if FFlagAppChatIncrementalPaginationProjection then
			for k in signals do
				if not set[k] then
					table.insert(v5, k)
				end
			end

			for _, v6 in v5 do
				publishMutation(v6, "Reset", {}, {}, nil)
			end
		end
	end

	return {
		conversations = proxy,
		metadata = proxy2,
		getMutation = function(p: string)
			local v5 = signals[p]

			if v5 ~= nil then
				return v5
			end

			local signal, v6 = Signals.createSignal(nil)
			signals[p] = signal
			v[p] = v6
			return signal
		end,
		batchMutations = batchMutations,
		prependMessages = function(p: string, p2)
			local function fn()
				prependMessagesInternal(p, p2)
			end

			runOrderingWrite(fn) -- inferred equivalent call
		end,
		appendMessages = function(p: string, list)
			local function fn()
				appendMessagesAndPublish(p, list) -- inferred equivalent call
			end

			runOrderingWrite(fn) -- inferred equivalent call
		end,
		removeMessage = function(p: string, p2: string)
			local function fn()
				removeMessageInternal(p, p2)
			end

			runOrderingWrite(fn) -- inferred equivalent call
		end,
		publishMessageUpdates = function(p: string, list)
			if #list > 0 then
				publishMutation(p, "Update", list, {}, nil)
			end
		end,
		setLoading = function(p: string, isLoading: boolean)
			local defaultMetadata = getOrDefaultMetadata(p) -- inferred equivalent call
			proxy2[p] = Cryo.Dictionary.union(defaultMetadata, { isLoading = isLoading })
		end,
		updatePagination = updatePagination,
		receivePage = function(p: string, p2, p3: string?)
			if FFlagAppChatGroupedVariantNeighbourIds then
				local function fn()
					receivePageInternal(p, p2, p3) -- inferred equivalent call
				end

				batchMutations(fn) -- inferred equivalent call
			else
				if FFlagAppChatBatchMessageListPagePublication then
					SignalsExperimental.batch(function()
						receivePageInternal(p, p2, p3) -- inferred equivalent call
					end)
					return
				end

				receivePageInternal(p, p2, p3) -- inferred equivalent call
			end
		end,
		clearConversation = function(p: string)
			local function fn()
				clearConversationInternal(p)
			end

			runOrderingWrite(fn) -- inferred equivalent call
		end,
		clear = function()
			runOrderingWrite(clearInternal) -- inferred equivalent call
		end,
		getIndex = function(p: string, p2: string, p3)
			local v5 = proxy(p3)[p]

			if v5 == nil then
				return nil
			end

			return v5.messageIds:indexOf(p2)
		end,
		getOrderedIds = function(p: string, p2)
			local v5 = proxy(p2)[p]

			if v5 == nil then
				return {}
			end

			return v5.messageIds:values()
		end,
		getPrevId = function(p: string, p2: string, p3)
			local v5 = proxy(p3)[p]

			if v5 == nil then
				return nil
			end

			local index = v5.messageIds:indexOf(p2)

			if index == nil or index <= 1 then
				return nil
			end

			return v5.messageIds:at(index - 1)
		end,
		getNextId = function(p: string, p2: string, p3)
			local v5 = proxy(p3)[p]

			if v5 == nil then
				return nil
			end

			local index = v5.messageIds:indexOf(p2)

			if index == nil or v5.messageIds:size() <= index then
				return nil
			end

			return v5.messageIds:at(index + 1)
		end,
		getNeighbourIds = function(p: string, p2: string, p3)
			local neighbourKey = getNeighbourKey(p, p2) -- inferred equivalent call
			return { prevId = proxy3(p3)[neighbourKey], nextId = proxy4(p3)[neighbourKey] }
		end,
		getMetadata = function(p: string, p2)
			return proxy2(p2)[p]
		end
	}
end

return createConversationMessageListStore
