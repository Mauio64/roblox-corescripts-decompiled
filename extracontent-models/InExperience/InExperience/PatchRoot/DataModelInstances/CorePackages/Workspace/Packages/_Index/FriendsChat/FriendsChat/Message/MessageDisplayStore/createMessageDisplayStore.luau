local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local UserProfileStore = require(Parent.UserProfiles).Stores.UserProfileStore
local GetConversationMessageStore = require(Parent.AppChat.GetConversationMessageStore)
local GetConversationStore = require(Parent.AppChat.GetConversationStore)
local Conversation = require(Parent.AppChat.Conversation)
local classifyMessage = require(script.Parent.classifyMessage)
local buildRowDisplay = require(script.Parent.buildRowDisplay)
local getLocalUserId = require(script.Parent.Parent.Parent.Utils.getLocalUserId)
local t1 = {}

local function shallowArrayEquals(t2: {[any]: any}?, t3: {[any]: any}?) -- line: 51
	if t2 == t3 then
		return true
	end

	if t2 == nil or t3 == nil or #t2 ~= #t3 then
		return false
	end

	for v17, v18 in t2 do
		if v18 ~= t3[v17] then
			return false
		end
	end

	return true
end
local function resolveProfileNameInfo(p1, p2) -- line: 69
	if p1 == nil or p1.names == nil then
		return {
			displayName = nil,
			username = nil
		}
	end

	local getDisplayName = p1.names.getDisplayName
	local getUsername = p1.names.getUsername

	return {
		displayName = if not getDisplayName then nil else getDisplayName(p2),
		username = if not getUsername then nil else getUsername(p2)
	}
end
local function resolveNameInfos(t4: {[any]: any}, p3) -- line: 86
	-- upvalues: UserProfileStore (copy), resolveProfileNameInfo (copy)
	local t5 = {}
	local t6 = {}
	local t7 = {}

	for _, v29 in t4 do
		if not t6[v29] then
			t6[v29] = true
			table.insert(t5, v29)
			table.insert(t7, (tostring(v29)))
		end
	end

	local v30 = UserProfileStore.get().fetchNamesByUserIds(t7)(p3)
	local v31 = if not v30 or not v30.data then {} else v30.data
	local t8 = {}

	for v33, v34 in t5 do
		t8[v34] = resolveProfileNameInfo(v31[v33], p3)
	end

	return t8
end
local function createMessageDisplayStore(p4, s1: string?, p5) -- line: 108
	-- upvalues: Signals (copy), GetConversationStore (copy), Conversation (copy), resolveNameInfos (copy), getLocalUserId (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy), shallowArrayEquals (copy), buildRowDisplay (copy)
	local t9 = {}
	local v39 = Signals.createComputed(function(p6) -- line: 115
		-- upvalues: s1 (copy), GetConversationStore (copy), Conversation (copy)
		if s1 == nil then
			return false
		end

		local v44 = GetConversationStore(p6).getConversation(s1, p6)

		return v44 ~= nil and v44.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)

	local function resolveForRowSpec(p7, p8) -- line: 124
		-- upvalues: resolveNameInfos (copy), getLocalUserId (copy), v39 (copy)
		if p7.kind == "userText" or p7.kind == "hiddenUser" then
			return {
				namesByUserId = resolveNameInfos({ p7.senderUserId }, p8)
			}
		end

		if p7.kind == "replyHeader" then
			return {
				namesByUserId = resolveNameInfos({
					p7.senderUserId,
					p7.repliedToUserId
				}, p8),
				localUserId = getLocalUserId(),
				isGroup = v39(p8)
			}
		end

		return {}
	end
	local function getMessageRowSpecs(s2: string) -- line: 138
		-- upvalues: t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy)
		local v48 = t9[s2]

		if v48 == nil then
			v48 = Signals.createComputed(function(p9) -- line: 141
				-- upvalues: GetConversationMessageStore (copy), s2 (copy), t1 (copy), classifyMessage (copy)
				local v70 = GetConversationMessageStore(p9).getMessage(s2, p9)

				if v70 == nil then
					return t1
				end

				return classifyMessage(v70)
			end)
			t9[s2] = v48
		end

		return v48
	end

	local v42 = Signals.createComputed(function(p10) -- line: 156
		-- upvalues: p4 (copy), t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy)
		local t10 = {}
		local n1 = 0

		for _, v53 in (p4(p10)) do
			local v54 = t9[v53]

			if v54 == nil then
				v54 = Signals.createComputed(function(p11) -- line: 141
					-- upvalues: GetConversationMessageStore (copy), v53 (copy), t1 (copy), classifyMessage (copy)
					local v72 = GetConversationMessageStore(p11).getMessage(v53, p11)

					if v72 == nil then
						return t1
					end

					return classifyMessage(v72)
				end)
				t9[v53] = v54
			end

			local v55 = #v54(p10)

			if v55 ~= 0 then
				if n1 + v55 > 50 then
					break
				end

				n1 += v55
				table.insert(t10, {
					sourceId = v53,
					count = v55
				})
			end
		end

		local t11 = {}
		local t12 = {}

		for i = #t10, 1, -1 do
			local v59 = t10[i]

			for j = 1, v59.count do
				local v61 = `{ v59.sourceId }_{ j }`

				table.insert(t11, v61)
				t12[v61] = {
					messageId = v59.sourceId,
					rowIndex = j
				}
			end
		end

		return {
			idList = t11,
			idToHandle = t12
		}
	end)

	return {
		getDisplayIds = Signals.createComputed(function(p12) -- line: 188
			-- upvalues: v42 (copy)
			return v42(p12).idList
		end, shallowArrayEquals),
		getDisplayFromId = function(s3: string?, p13) -- line: 196
			-- upvalues: v42 (copy), t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy), buildRowDisplay (copy), resolveForRowSpec (copy), p5 (copy)
			if s3 == nil then
				return nil
			end

			local v65 = v42(false).idToHandle[s3]

			if v65 == nil then
				return nil
			end

			local messageId = v65.messageId
			local v67 = t9[messageId]

			if v67 == nil then
				v67 = Signals.createComputed(function(p14) -- line: 141
					-- upvalues: GetConversationMessageStore (copy), messageId (copy), t1 (copy), classifyMessage (copy)
					local v74 = GetConversationMessageStore(p14).getMessage(messageId, p14)

					if v74 == nil then
						return t1
					end

					return classifyMessage(v74)
				end)
				t9[messageId] = v67
			end

			local v68 = v67(p13)[v65.rowIndex]

			if v68 == nil then
				return nil
			end

			return buildRowDisplay(v68, resolveForRowSpec(v68, p13), p5)
		end
	}
end

return createMessageDisplayStore
