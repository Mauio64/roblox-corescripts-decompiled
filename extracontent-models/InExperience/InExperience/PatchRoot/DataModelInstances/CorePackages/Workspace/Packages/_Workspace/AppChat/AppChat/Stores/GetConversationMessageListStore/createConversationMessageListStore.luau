local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local createProxy = require(AppChatParent.SignalsExperimental).createProxy
local ArraySet = require(AppChat.DataStructures.ArraySet)

local function newConversationOrdering() -- line: 90
	-- upvalues: ArraySet (copy)
	return {
		messageIds = ArraySet.new({})
	}
end
local function newMessagePaginationMetadata() -- line: 96
	return {
		nextPageCursor = nil,
		isLoading = false,
		fetchedOldest = false
	}
end
local function createConversationMessageListStore() -- line: 104
	-- upvalues: createProxy (copy), ArraySet (copy), Cryo (copy)
	local v9 = createProxy({})
	local v10 = createProxy({})

	local function getOrDefaultOrdering(s1: string) -- line: 112
		-- upvalues: v9 (copy), ArraySet (copy)
		local v16 = v9[s1]

		if v16 ~= nil then
			return v16
		end

		return {
			messageIds = ArraySet.new({})
		}
	end
	local function getOrDefaultMetadata(s2: string) -- line: 120
		-- upvalues: v10 (copy)
		local v18 = v10[s2]

		if v18 ~= nil then
			return v18
		end

		return {
			nextPageCursor = nil,
			isLoading = false,
			fetchedOldest = false
		}
	end
	local function appendMessages(s3: string, t1: {[any]: any}) -- line: 143
		-- upvalues: v9 (copy), ArraySet (copy)
		local v25 = v9[s3]
		local v26 = if v25 == nil then {
			messageIds = ArraySet.new({})
		} else v25
		local v27 = false

		for _, v29 in t1 do
			if v26.messageIds:add(v29) then
				v27 = true
			end
		end

		if not v27 then
			return
		end

		v9[s3] = table.clone(v26)
	end
	local function updatePagination(s4: string, s5: string?, b1: boolean) -- line: 181
		-- upvalues: v10 (copy), Cryo (copy)
		local v40 = v10[s4]
		local v41 = if v40 == nil then {
			nextPageCursor = nil,
			isLoading = false,
			fetchedOldest = false
		} else v40

		v10[s4] = Cryo.Dictionary.union(v41, {
			isLoading = false,
			nextPageCursor = if not s5 or s5 == "" then v41.nextPageCursor else s5,
			fetchedOldest = b1
		})
	end

	return {
		conversations = v9,
		metadata = v10,
		prependMessages = function(s6: string, t2: {[any]: any}) -- line: 130
			-- upvalues: v9 (copy), ArraySet (copy)
			local v21 = v9[s6]
			local v22 = if v21 == nil then {
				messageIds = ArraySet.new({})
			} else v21

			if not v22.messageIds:prependAll(t2) then
				return
			end

			v9[s6] = table.clone(v22)
		end,
		appendMessages = appendMessages,
		removeMessage = function(s7: string, s8: string) -- line: 161
			-- upvalues: v9 (copy)
			local v32 = v9[s7]

			if v32 == nil then
				return
			end

			if not v32.messageIds:remove(s8) then
				return
			end

			v9[s7] = table.clone(v32)
		end,
		setLoading = function(s9: string, b2: boolean) -- line: 173
			-- upvalues: v10 (copy), Cryo (copy)
			local v35 = v10[s9]
			local v36 = if v35 == nil then {
				nextPageCursor = nil,
				isLoading = false,
				fetchedOldest = false
			} else v35

			v10[s9] = Cryo.Dictionary.union(v36, {
				isLoading = b2
			})
		end,
		updatePagination = updatePagination,
		receivePage = function(s10: string, t3: {[any]: any}, s11: string?) -- line: 191
			-- upvalues: appendMessages (copy), updatePagination (copy)
			appendMessages(s10, t3)
			updatePagination(s10, s11, s11 == nil or s11 == "")
		end,
		clearConversation = function(s12: string) -- line: 196
			-- upvalues: v9 (copy), v10 (copy)
			v9[s12] = nil
			v10[s12] = nil
		end,
		clear = function() -- line: 201
			-- upvalues: v9 (copy), v10 (copy)
			for v46 in v9 do
				v9[v46] = nil
			end

			for v47 in v10 do
				v10[v47] = nil
			end
		end,
		getIndex = function(s13: string, s14: string, p1) -- line: 210
			-- upvalues: v9 (copy)
			local v51 = v9(p1)[s13]

			if v51 == nil then
				return nil
			end

			return v51.messageIds:indexOf(s14)
		end,
		getOrderedIds = function(s15: string, p2) -- line: 218
			-- upvalues: v9 (copy)
			local v54 = v9(p2)[s15]

			if v54 == nil then
				return {}
			end

			return v54.messageIds:values()
		end,
		getPrevId = function(s16: string, s17: string, p3) -- line: 226
			-- upvalues: v9 (copy)
			local v58 = v9(p3)[s16]

			if v58 == nil then
				return nil
			end

			local v59 = v58.messageIds:indexOf(s17)

			if v59 == nil or v59 <= 1 then
				return nil
			end

			return v58.messageIds:at(v59 - 1)
		end,
		getNextId = function(s18: string, s19: string, p4) -- line: 238
			-- upvalues: v9 (copy)
			local v63 = v9(p4)[s18]

			if v63 == nil then
				return nil
			end

			local v64 = v63.messageIds:indexOf(s19)

			if v64 == nil or v64 >= v63.messageIds:size() then
				return nil
			end

			return v63.messageIds:at(v64 + 1)
		end,
		getMetadata = function(s20: string, p5) -- line: 250
			-- upvalues: v10 (copy)
			return v10(p5)[s20]
		end
	}
end

return createConversationMessageListStore
