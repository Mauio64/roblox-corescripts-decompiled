local parent = script:FindFirstAncestor("TextChannelWindow").Parent

local Signals = require(parent.Signals)
require(script.Parent.Message)

local function createChannelMessagesStore()
	local v = {}

	local function getOrCreate(p)
		if not v[p] then
			local signal, setByMessageId = Signals.createSignal({})
			local signal2, setOrderedIds = Signals.createSignal({})

			v[p] = {
				getByMessageId = signal,
				setByMessageId = setByMessageId,
				getOrderedIds = signal2,
				setOrderedIds = setOrderedIds,
				getMessages = Signals.createComputed(function(p2)
					local v2 = signal2(p2)
					local v3 = signal(p2)
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
		end

		return v[p]
	end

	local function upsertMessage(p, p2)
		local v2 = getOrCreate(p)
		local messageId = p2.messageId

		v2.setByMessageId(function(p3)
			local clone = table.clone(p3)
			clone[messageId] = p2
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
			v2.setByMessageId(function(p3)
				local clone = table.clone(p3)

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

	return {
		upsertMessage = upsertMessage,
		removeMessage = function(p, p2: string)
			local v2 = getOrCreate(p)

			v2.setByMessageId(function(p3)
				if p3[p2] == nil then
					return p3
				end

				local clone = table.clone(p3)
				clone[p2] = nil
				return clone
			end)

			v2.setOrderedIds(function(list)
				local index = table.find(list, p2)

				if not index then
					return list
				end

				local clone = table.clone(list)
				table.remove(clone, index)
				return clone
			end)
		end,
		insertIfAbsent = function(p, p2)
			if getOrCreate(p).getByMessageId(false)[p2.messageId] ~= nil then
				return
			end

			upsertMessage(p, p2)
		end,
		removeChannelEntry = function(p)
			v[p] = nil
		end,
		clearChannel = function(p)
			local v2 = v[p]

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
		getMessagesForChannel = function(p)
			return getOrCreate(p).getMessages
		end,
		getMessageById = function(p, p2: string)
			local v2 = getOrCreate(p)

			if not v2.messageGetters[p2] then
				v2.messageGetters[p2] = Signals.createComputed(function(p3)
					return v2.getByMessageId(p3)[p2]
				end)
			end

			return v2.messageGetters[p2]
		end
	}
end

return createChannelMessagesStore
