local parent = script:FindFirstAncestor("TextChannelWindow").Parent

local Signals = require(parent.Signals)
require(script.Parent.Message)

local function createChannelMessagesStore(p)
	local v = {}

	local function getOrCreate(p2)
		if v[p2] then
			return v[p2]
		end

		local signal, setByMessageId = Signals.createSignal({})
		local signal2, setOrderedIds = Signals.createSignal({})

		v[p2] = {
			getByMessageId = signal,
			setByMessageId = setByMessageId,
			getOrderedIds = signal2,
			setOrderedIds = setOrderedIds,
			getMessages = Signals.createComputed(function(p3)
				local v2 = signal2(p3)
				local v3 = signal(p3)
				local result = table.create(#v2)

				for _, v4 in v2 do
					local v5 = v3[v4]

					if v5 then
						table.insert(result, v5)
					end
				end

				return result
			end),
			messageGetters = {}
		}

		return v[p2]
	end

	local function upsertMessage(p2, p3)
		local v2 = getOrCreate(p2)
		local messageId = p3.messageId

		v2.setByMessageId(function(p4)
			local clone = table.clone(p4)
			clone[messageId] = p3
			return clone
		end)

		local v3 = {}
		v2.setOrderedIds(function(items)
			for _, item in items do
				if item == messageId then
					return items
				end
			end

			local clone = table.clone(items)
			table.insert(clone, messageId)

			if not (#clone > 200) then
				return clone
			end

			local v4 = table.create(200)
			table.move(clone, #clone - 200 + 1, #clone, 1, v4)

			if v3 then
				for i = 1, #clone - 200 do
					table.insert(v3, clone[i])
				end
			end

			return v4
		end)

		if v3 and #v3 > 0 then
			v2.setByMessageId(function(p4)
				local clone = table.clone(p4)

				for _, v4 in v3 do
					clone[v4] = nil
				end

				return clone
			end)

			for _, v4 in v3 do
				v2.messageGetters[v4] = nil
			end
		end
	end

	local function isHistorical(p2): boolean -- 1 equivalent call inferred from this helper
		return p2 ~= nil and p2.isHistorical == true
	end

	return {
		insertHistorical = function(p2, list)
			local v2

			if p and p.getHistoryArm then
				v2 = p.getHistoryArm()
			end

			if not v2 or #list == 0 then
				return
			end

			local v3 = getOrCreate(p2)
			local v4 = v3.getByMessageId(false)
			local orderedIds = v3.getOrderedIds(false)
			local count = 0

			for _, orderedId in orderedIds do
				if not isHistorical(v4[orderedId]) then -- inferred equivalent call
					break
				end

				count += 1
			end

			local v5

			if v2.maxAgeSeconds > 0 then
				v5 = workspace:GetServerTimeNow() - v2.maxAgeSeconds
			end

			local messageIdSet = {}
			local v6 = {}

			for _, item in list do
				local messageId = item.messageId

				if v4[messageId] ~= nil or messageIdSet[messageId] then
					continue
				end

				messageIdSet[messageId] = true

				if item.content == "" or v5 and item.timestamp.UnixTimestamp < v5 then
					continue
				end

				table.insert(v6, item)
			end

			if #v6 == 0 then
				return
			end

			local v7 = #orderedIds - count
			local v8 = math.max(0, (math.min(v2.maxCount, 200 - v7)))
			local messageIds = table.move(orderedIds, 1, count, 1, table.create(count + #v6))

			for _, v9 in v6 do
				table.insert(messageIds, v9.messageId)
			end

			local v9 = math.max(0, #messageIds - v8)
			local v10 = table.move(messageIds, 1, v9, 1, table.create(v9))
			local v11 = table.move(messageIds, v9 + 1, #messageIds, 1, table.create(v8 + v7))
			table.move(orderedIds, count + 1, #orderedIds, #v11 + 1, v11)

			v3.setByMessageId(function(p3)
				local clone = table.clone(p3)

				for _, v12 in v6 do
					clone[v12.messageId] = v12
				end

				for _, v12 in v10 do
					clone[v12] = nil
				end

				return clone
			end)

			v3.setOrderedIds(function()
				return v11
			end)

			for _, v12 in v10 do
				v3.messageGetters[v12] = nil
			end

			if p and p.logHistoryExposure then
				p.logHistoryExposure()
			end
		end,
		upsertMessage = upsertMessage,
		removeMessage = function(p2, p3: string)
			local v2 = getOrCreate(p2)

			v2.setByMessageId(function(p4)
				if p4[p3] == nil then
					return p4
				end

				local clone = table.clone(p4)
				clone[p3] = nil
				return clone
			end)

			v2.setOrderedIds(function(list)
				local index = table.find(list, p3)

				if not index then
					return list
				end

				local clone = table.clone(list)
				table.remove(clone, index)
				return clone
			end)
		end,
		insertIfAbsent = function(p2, p3)
			if getOrCreate(p2).getByMessageId(false)[p3.messageId] ~= nil then
				return
			end

			upsertMessage(p2, p3)
		end,
		removeChannelEntry = function(p2)
			v[p2] = nil
		end,
		clearChannel = function(p2)
			local v2 = v[p2]

			if not v2 then
				return
			end

			v2.setByMessageId(function()
				return {}
			end)

			v2.setOrderedIds(function()
				return {}
			end)

			table.clear(v2.messageGetters)
		end,
		getMessagesForChannel = function(p2)
			return getOrCreate(p2).getMessages
		end,
		getMessageById = function(p2, p3: string)
			local v2 = getOrCreate(p2)

			if not v2.messageGetters[p3] then
				v2.messageGetters[p3] = Signals.createComputed(function(p4)
					return v2.getByMessageId(p4)[p3]
				end)
			end

			return v2.messageGetters[p3]
		end
	}
end

return createChannelMessagesStore
