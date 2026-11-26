local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")
local createProxy = SignalsExperimental.createProxy

local ArraySet = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/DataStructures/ArraySet")
local FFlagAppChatBatchMessageListPagePublication = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatBatchMessageListPagePublication")
local FFlagAppChatIncrementalPaginationProjection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIncrementalPaginationProjection")
local FFlagAppChatGroupedVariantNeighbourIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGroupedVariantNeighbourIds")

local function newConversationOrdering()
	return { messageIds = ArraySet.new({}) }
end

local function newMessagePaginationMetadata()
	return { nextPageCursor = nil, isLoading = false, fetchedOldest = false }
end

local function createConversationMessageListStore()
	local proxy = createProxy({})

	local proxy2 = createProxy({})

	local proxy3 = createProxy({})
	local proxy4 = createProxy({})

	local signals = {}
	local v5 = {}
	local count = 0
	local v6 = 0
	local v7 = {}
	local v8 = {}

	local function publishMutation(p2, p3, p4, p5, p6)
		count += 1

		if signals[p2] == nil then
			local signal, v9 = Signals.createSignal(nil)
			signals[p2] = signal
			v5[p2] = v9
		end

		local v9 = {
			operation = p3,
			messageIds = table.clone(p4),
			insertedIds = table.clone(p5),
			boundaryMessageId = p6,
			revision = count
		}

		if not (v6 > 0) then
			v5[p2](v9)
			return
		end

		local v10 = v8[p2]

		if v10 == nil then
			v10 = {}
			v8[p2] = v10
			table.insert(v7, p2)
		end

		table.insert(v10, v9)
	end

	local function publishQueuedMutations()
		local v9 = v7
		local v10 = v8
		v7 = {}
		v8 = {}

		for k, v11 in v9 do
			local v12 = v10[v11]

			if #v12 == 1 then
				v5[v11](v12[1])
			else
				v5[v11]({
					operation = "Batch",
					messageIds = {},
					insertedIds = {},
					boundaryMessageId = nil,
					revision = v12[#v12].revision,
					mutations = v12
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

	local function getOrDefaultOrdering(p2)
		local v9 = proxy[p2]

		if v9 == nil then
			return { messageIds = ArraySet.new({}) }
		end

		return v9
	end

	local function getOrDefaultMetadata(p2)
		local v9 = proxy2[p2]

		if v9 == nil then
			return { nextPageCursor = nil, isLoading = false, fetchedOldest = false }
		end

		return v9
	end

	local function getNeighbourKey(p2, p3)
		return p2 .. "\0" .. p3
	end

	local function writeNeighbourIds(p2, p3, p4, p5)
		for i = (math.max)(p4, 1), math.min(p5, p3.messageIds:size()) do
			local v9 = p2 .. "\0" .. p3.messageIds:at(i)
			proxy3[v9] = p3.messageIds:at(i - 1)
			proxy4[v9] = p3.messageIds:at(i + 1)
		end
	end

	local function clearNeighbourIds(p2, items)
		for k, item in items do
			local v9 = p2 .. "\0" .. item

			proxy3[v9] = nil
			proxy4[v9] = nil
		end
	end

	local function runOrderingWrite(callback)
		if not FFlagAppChatGroupedVariantNeighbourIds then
			callback()

			return
		end

		local success = nil
		local result = nil
		SignalsExperimental.batch(function()
			v6 += 1

			success, result = xpcall(callback, addTraceback)
			v6 -= 1

			if v6 == 0 then
				publishQueuedMutations()
			end
		end)

		if not success then
			error(result, 0)
		end
	end

	local function prependMessagesInternal(p2, list)
		local v9 = proxy[p2]
		local v10 = v9 == nil and { messageIds = ArraySet.new({}) } or v9

		local size = v10.messageIds:size()

		local v11 = {}
		local v12

		if FFlagAppChatIncrementalPaginationProjection then
			v12 = v10.messageIds:at(1)
			local set = {}

			for k, item in list do
				if v10.messageIds:has(item) or set[item] then
					continue
				end

				set[item] = true
				table.insert(v11, item)
			end
		end

		if v10.messageIds:prependAll(list) then
			proxy[p2] = table.clone(v10)

			if FFlagAppChatGroupedVariantNeighbourIds then
				writeNeighbourIds(p2, v10, 1, v10.messageIds:size() - size + 1)
			end

			if FFlagAppChatIncrementalPaginationProjection then
				publishMutation(p2, "Prepend", list, v11, v12)
			end
		elseif FFlagAppChatIncrementalPaginationProjection and #list > 0 then
			publishMutation(p2, "Prepend", list, {}, nil)
		end
	end

	local function appendMessagesInternal(p2, items)
		local v9 = proxy[p2]
		local v10 = v9 == nil and { messageIds = ArraySet.new({}) } or v9

		local size = v10.messageIds:size()
		local v11 = v10.messageIds:at(size)

		local result = {}

		for k, item in items do
			if v10.messageIds:add(item) then
				table.insert(result, item)
			end
		end

		if #result > 0 then
			proxy[p2] = table.clone(v10)
		end

		if FFlagAppChatGroupedVariantNeighbourIds and #result > 0 then
			writeNeighbourIds(p2, v10, size, v10.messageIds:size())
		end

		return result, v11
	end

	local function appendMessagesAndPublish(p2, list)
		local v9, v10 = appendMessagesInternal(p2, list)

		if FFlagAppChatIncrementalPaginationProjection and #list > 0 then
			publishMutation(p2, "Append", list, v9, v10)
		end
	end

	local function removeMessageInternal(p2, p3)
		local v9 = proxy[p2]

		if v9 == nil then
			return
		end

		local index = v9.messageIds:indexOf(p3)

		if index == nil or not v9.messageIds:remove(p3) then
			return
		end

		proxy[p2] = table.clone(v9)

		if FFlagAppChatGroupedVariantNeighbourIds then
			for k, v10 in { p3 } do
				local v11 = p2 .. "\0" .. v10

				proxy3[v11] = nil
				proxy4[v11] = nil
			end

			writeNeighbourIds(p2, v9, index - 1, index)
		end

		if FFlagAppChatIncrementalPaginationProjection then
			publishMutation(p2, "Remove", { p3 }, {}, nil)
		end
	end

	local function updatePagination(p2, nextPageCursor, fetchedOldest)
		local v9 = proxy2[p2]
		local v10 = v9 == nil and {
			nextPageCursor = nil,
			isLoading = false,
			fetchedOldest = false
		} or v9

		local v11 = proxy2
		local union = Cryo.Dictionary.union

		if not nextPageCursor or nextPageCursor == "" then
			nextPageCursor = v10.nextPageCursor
		end

		v11[p2] = union(v10, {
			nextPageCursor = nextPageCursor,
			isLoading = false,
			fetchedOldest = fetchedOldest
		})
	end

	local function receivePageInternal(p2, p3, p4)
		local v9, v10 = appendMessagesInternal(p2, p3)
		updatePagination(p2, p4, p4 == nil or p4 == "")

		if FFlagAppChatIncrementalPaginationProjection then
			publishMutation(p2, "AppendAndAdvanceCursor", p3, v9, v10)
		end
	end

	local function clearConversationInternal(p2)
		if FFlagAppChatGroupedVariantNeighbourIds then
			local v9 = proxy[p2]

			if v9 ~= nil then
				local values = v9.messageIds:values()

				for k, value in values do
					local v10 = p2 .. "\0" .. value

					proxy3[v10] = nil
					proxy4[v10] = nil
				end
			end
		end

		proxy[p2] = nil
		proxy2[p2] = nil

		if FFlagAppChatIncrementalPaginationProjection then
			publishMutation(p2, "Reset", {}, {}, nil)
		end
	end

	local function clearInternal()
		local v9 = {}
		local set = {}

		for k, v10 in proxy do
			table.insert(v9, k)
			set[k] = true

			if FFlagAppChatGroupedVariantNeighbourIds and v10 ~= nil then
				local values = v10.messageIds:values()

				for k2, value in values do
					local v11 = k .. "\0" .. value

					proxy3[v11] = nil
					proxy4[v11] = nil
				end
			end

			proxy[k] = nil
		end

		for k in proxy2 do
			proxy2[k] = nil
		end

		if FFlagAppChatIncrementalPaginationProjection then
			for k in signals do
				if not set[k] then
					table.insert(v9, k)
				end
			end

			for k, v10 in v9 do
				publishMutation(v10, "Reset", {}, {}, nil)
			end
		end
	end

	return {
		conversations = proxy,
		metadata = proxy2,
		getMutation = function(p2)
			local v9 = signals[p2]

			if v9 ~= nil then
				return v9
			end

			local signal, v10 = Signals.createSignal(nil)
			signals[p2] = signal
			v5[p2] = v10
			return signal
		end,
		batchMutations = function(callback)
			local success = nil
			local result = nil
			SignalsExperimental.batch(function()
				v6 += 1

				success, result = xpcall(callback, addTraceback)
				v6 -= 1

				if v6 == 0 then
					publishQueuedMutations()
				end
			end)

			if not success then
				error(result, 0)
			end
		end,
		prependMessages = function(p2, p3)
			local function fn()
				prependMessagesInternal(p2, p3)
			end

			if not FFlagAppChatGroupedVariantNeighbourIds then
				prependMessagesInternal(p2, p3)

				return
			end

			local success = nil
			local result = nil
			SignalsExperimental.batch(function()
				v6 += 1

				success, result = xpcall(fn, addTraceback)
				v6 -= 1

				if v6 == 0 then
					publishQueuedMutations()
				end
			end)

			if not success then
				error(result, 0)
			end
		end,
		appendMessages = function(p2, list)
			local function fn()
				local v9 = p2
				local v10 = list
				local v11, v12 = appendMessagesInternal(v9, v10)

				if FFlagAppChatIncrementalPaginationProjection and #v10 > 0 then
					publishMutation(v9, "Append", v10, v11, v12)
				end
			end

			if FFlagAppChatGroupedVariantNeighbourIds then
				local success = nil
				local result = nil
				SignalsExperimental.batch(function()
					v6 += 1

					success, result = xpcall(fn, addTraceback)
					v6 -= 1

					if v6 == 0 then
						publishQueuedMutations()
					end
				end)

				if not success then
					error(result, 0)
				end
			else
				local v9, v10 = appendMessagesInternal(p2, list)

				if FFlagAppChatIncrementalPaginationProjection and #list > 0 then
					publishMutation(p2, "Append", list, v9, v10)
				end
			end
		end,
		removeMessage = function(p2, p3)
			local function fn()
				removeMessageInternal(p2, p3)
			end

			if not FFlagAppChatGroupedVariantNeighbourIds then
				removeMessageInternal(p2, p3)

				return
			end

			local success = nil
			local result = nil
			SignalsExperimental.batch(function()
				v6 += 1

				success, result = xpcall(fn, addTraceback)
				v6 -= 1

				if v6 == 0 then
					publishQueuedMutations()
				end
			end)

			if not success then
				error(result, 0)
			end
		end,
		publishMessageUpdates = function(p2, list)
			if #list > 0 then
				publishMutation(p2, "Update", list, {}, nil)
			end
		end,
		setLoading = function(p2, p3)
			local v9 = proxy2[p2]
			local v10 = v9 == nil and {
					nextPageCursor = nil,
					isLoading = false,
					fetchedOldest = false
				}
				or v9

			proxy2[p2] = Cryo.Dictionary.union(v10, { isLoading = p3 })
		end,
		updatePagination = updatePagination,
		receivePage = function(p2, p3, p4)
			if FFlagAppChatGroupedVariantNeighbourIds then
				local function fn()
					local v9 = p2
					local v10 = p3
					local v11 = p4
					local v12, v13 = appendMessagesInternal(v9, v10)
					updatePagination(v9, v11, v11 == nil or v11 == "")

					if FFlagAppChatIncrementalPaginationProjection then
						publishMutation(v9, "AppendAndAdvanceCursor", v10, v12, v13)
					end
				end

				local success = nil
				local result = nil
				SignalsExperimental.batch(function()
					v6 += 1

					success, result = xpcall(fn, addTraceback)
					v6 -= 1

					if v6 == 0 then
						publishQueuedMutations()
					end
				end)

				if not success then
					error(result, 0)
				end
			else
				if FFlagAppChatBatchMessageListPagePublication then
					SignalsExperimental.batch(function()
						local v9 = p2
						local v10 = p3
						local v11 = p4
						local v12, v13 = appendMessagesInternal(v9, v10)
						updatePagination(v9, v11, v11 == nil or v11 == "")

						if FFlagAppChatIncrementalPaginationProjection then
							publishMutation(v9, "AppendAndAdvanceCursor", v10, v12, v13)
						end
					end)
					return
				end

				local v9, v10 = appendMessagesInternal(p2, p3)
				updatePagination(p2, p4, p4 == nil or p4 == "")

				if FFlagAppChatIncrementalPaginationProjection then
					publishMutation(p2, "AppendAndAdvanceCursor", p3, v9, v10)
				end
			end
		end,
		clearConversation = function(p2)
			local function fn()
				clearConversationInternal(p2)
			end

			if not FFlagAppChatGroupedVariantNeighbourIds then
				clearConversationInternal(p2)

				return
			end

			local success = nil
			local result = nil
			SignalsExperimental.batch(function()
				v6 += 1

				success, result = xpcall(fn, addTraceback)
				v6 -= 1

				if v6 == 0 then
					publishQueuedMutations()
				end
			end)

			if not success then
				error(result, 0)
			end
		end,
		clear = function()
			local v9 = clearInternal

			if not FFlagAppChatGroupedVariantNeighbourIds then
				v9()

				return
			end

			local success = nil
			local result = nil
			SignalsExperimental.batch(function()
				v6 += 1

				success, result = xpcall(v9, addTraceback)
				v6 -= 1

				if v6 == 0 then
					publishQueuedMutations()
				end
			end)

			if not success then
				error(result, 0)
			end
		end,
		getIndex = function(p2, p3, p4)
			local v9 = proxy(p4)[p2]

			if v9 == nil then
				return nil
			end

			return v9.messageIds:indexOf(p3)
		end,
		getOrderedIds = function(p2, p3)
			local v9 = proxy(p3)[p2]

			if v9 == nil then
				return {}
			end

			return v9.messageIds:values()
		end,
		getPrevId = function(p2, p3, p4)
			local v9 = proxy(p4)[p2]

			if v9 == nil then
				return nil
			end

			local index = v9.messageIds:indexOf(p3)

			if index == nil or index <= 1 then
				return nil
			end

			return v9.messageIds:at(index - 1)
		end,
		getNextId = function(p2, p3, p4)
			local v9 = proxy(p4)[p2]

			if v9 == nil then
				return nil
			end

			local index = v9.messageIds:indexOf(p3)

			if index == nil or v9.messageIds:size() <= index then
				return nil
			end

			return v9.messageIds:at(index + 1)
		end,
		getNeighbourIds = function(p2, p3, p4)
			local v9 = p2 .. "\0" .. p3

			return { prevId = proxy3(p4)[v9], nextId = proxy4(p4)[v9] }
		end,
		getMetadata = function(p2, p3)
			return proxy2(p3)[p2]
		end
	}
end

return createConversationMessageListStore
