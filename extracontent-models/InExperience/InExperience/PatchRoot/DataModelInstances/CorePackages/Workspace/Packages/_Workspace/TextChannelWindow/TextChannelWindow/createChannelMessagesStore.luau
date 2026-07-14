local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local Signals = require(Parent.Signals)

require(script.Parent.Message)

local function createChannelMessagesStore() -- line: 42
	-- upvalues: Signals (copy)
	local t1 = {}

	local function getOrCreate(p1) -- line: 46
		-- upvalues: t1 (copy), Signals (copy)
		if not t1[p1] then
			local v8, v9 = Signals.createSignal({})
			local v10, v11 = Signals.createSignal({})
			local v12 = Signals.createComputed(function(p2) -- line: 51
				-- upvalues: v10 (copy), v8 (copy)
				local v27 = v10(p2)
				local v28 = v8(p2)
				local t2 = table.create(#v27)

				for _, v31 in v27 do
					local v32 = v28[v31]

					if v32 then
						table.insert(t2, v32)
					end
				end

				return t2
			end)

			t1[p1] = {
				getByMessageId = v8,
				setByMessageId = v9,
				getOrderedIds = v10,
				setOrderedIds = v11,
				getMessages = v12,
				messageGetters = {}
			}
		end

		return t1[p1]
	end
	local function upsertMessage(p3, p4) -- line: 76
		-- upvalues: getOrCreate (copy)
		local v15 = getOrCreate(p3)
		local messageId = p4.messageId

		v15.setByMessageId(function(p5) -- line: 80
			-- upvalues: messageId (copy), p4 (copy)
			local v34 = table.clone(p5)

			v34[messageId] = p4

			return v34
		end)
		v15.setOrderedIds(function(p6) -- line: 86
			-- upvalues: messageId (copy)
			for _, v37 in p6 do
				if v37 == messageId then
					return p6
				end
			end

			local v38 = table.clone(p6)

			table.insert(v38, messageId)

			if #v38 > 200 then
				local t3 = table.create(200)

				table.move(v38, #v38 - 200 + 1, #v38, 1, t3)

				return t3
			end

			return v38
		end)
	end

	return {
		upsertMessage = upsertMessage,
		removeMessage = function(p7, s1: string) -- line: 103
			-- upvalues: getOrCreate (copy)
			local v19 = getOrCreate(p7)

			v19.setByMessageId(function(p8) -- line: 106
				-- upvalues: s1 (copy)
				if p8[s1] == nil then
					return p8
				end

				local v41 = table.clone(p8)

				v41[s1] = nil

				return v41
			end)
			v19.setOrderedIds(function(p9) -- line: 115
				-- upvalues: s1 (copy)
				local v43 = table.find(p9, s1)

				if not v43 then
					return p9
				end

				local v44 = table.clone(p9)

				table.remove(v44, v43)

				return v44
			end)
		end,
		insertIfAbsent = function(p10, p11) -- line: 126
			-- upvalues: getOrCreate (copy), upsertMessage (copy)
			if getOrCreate(p10).getByMessageId(false)[p11.messageId] ~= nil then
				return
			end

			upsertMessage(p10, p11)
		end,
		getMessagesForChannel = function(p12) -- line: 134
			-- upvalues: getOrCreate (copy)
			return getOrCreate(p12).getMessages
		end,
		getMessageById = function(p13, s2: string) -- line: 138
			-- upvalues: getOrCreate (copy), Signals (copy)
			local v25 = getOrCreate(p13)

			if not v25.messageGetters[s2] then
				v25.messageGetters[s2] = Signals.createComputed(function(p14) -- line: 141
					-- upvalues: v25 (copy), s2 (copy)
					return v25.getByMessageId(p14)[s2]
				end)
			end

			return v25.messageGetters[s2]
		end
	}
end

return createChannelMessagesStore
