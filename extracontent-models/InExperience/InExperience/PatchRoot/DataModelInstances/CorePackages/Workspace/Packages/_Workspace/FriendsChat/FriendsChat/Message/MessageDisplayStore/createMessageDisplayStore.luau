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
			name = nil,
			username = nil
		}
	end

	local getCombinedName = p1.names.getCombinedName
	local getDisplayName = p1.names.getDisplayName
	local getUsername = p1.names.getUsername
	local v24 = if not getUsername then nil else getUsername(p2)
	local v25 = if not getCombinedName then nil else getCombinedName(p2)
	local v26 = if not getDisplayName then nil else getDisplayName(p2)

	return {
		name = if v25 == nil or v25 == "" then if v26 == nil or v26 == "" then v24 else v26 else v25,
		username = v24
	}
end
local function resolveNameInfos(t4: {[any]: any}, p3) -- line: 97
	-- upvalues: UserProfileStore (copy), resolveProfileNameInfo (copy)
	local t5 = {}
	local t6 = {}
	local t7 = {}

	for _, v33 in t4 do
		if not t6[v33] then
			t6[v33] = true
			table.insert(t5, v33)
			table.insert(t7, (tostring(v33)))
		end
	end

	local v34 = UserProfileStore.get().fetchNamesByUserIds(t7)(p3)
	local v35 = if not v34 or not v34.data then {} else v34.data
	local t8 = {}

	for v37, v38 in t5 do
		t8[v38] = resolveProfileNameInfo(v35[v37], p3)
	end

	return t8
end
local function createMessageDisplayStore(p4, s1: string?, p5) -- line: 119
	-- upvalues: Signals (copy), GetConversationStore (copy), Conversation (copy), resolveNameInfos (copy), getLocalUserId (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy), shallowArrayEquals (copy), buildRowDisplay (copy)
	local t9 = {}
	local v43 = Signals.createComputed(function(p6) -- line: 126
		-- upvalues: s1 (copy), GetConversationStore (copy), Conversation (copy)
		if s1 == nil then
			return false
		end

		local v48 = GetConversationStore(p6).getConversation(s1, p6)

		return v48 ~= nil and v48.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)

	local function resolveForRowSpec(p7, p8) -- line: 135
		-- upvalues: resolveNameInfos (copy), getLocalUserId (copy), v43 (copy)
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
				isGroup = v43(p8)
			}
		end

		return {}
	end
	local function getMessageRowSpecs(s2: string) -- line: 149
		-- upvalues: t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy)
		local v52 = t9[s2]

		if v52 == nil then
			v52 = Signals.createComputed(function(p9) -- line: 152
				-- upvalues: GetConversationMessageStore (copy), s2 (copy), t1 (copy), classifyMessage (copy)
				local v74 = GetConversationMessageStore(p9).getMessage(s2, p9)

				if v74 == nil then
					return t1
				end

				return classifyMessage(v74)
			end)
			t9[s2] = v52
		end

		return v52
	end

	local v46 = Signals.createComputed(function(p10) -- line: 167
		-- upvalues: p4 (copy), t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy)
		local t10 = {}
		local n1 = 0

		for _, v57 in (p4(p10)) do
			local v58 = t9[v57]

			if v58 == nil then
				v58 = Signals.createComputed(function(p11) -- line: 152
					-- upvalues: GetConversationMessageStore (copy), v57 (copy), t1 (copy), classifyMessage (copy)
					local v76 = GetConversationMessageStore(p11).getMessage(v57, p11)

					if v76 == nil then
						return t1
					end

					return classifyMessage(v76)
				end)
				t9[v57] = v58
			end

			local v59 = #v58(p10)

			if v59 ~= 0 then
				if n1 + v59 > 50 then
					break
				end

				n1 += v59
				table.insert(t10, {
					sourceId = v57,
					count = v59
				})
			end
		end

		local t11 = {}
		local t12 = {}

		for i = #t10, 1, -1 do
			local v63 = t10[i]

			for j = 1, v63.count do
				local v65 = `{ v63.sourceId }_{ j }`

				table.insert(t11, v65)
				t12[v65] = {
					messageId = v63.sourceId,
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
		getDisplayIds = Signals.createComputed(function(p12) -- line: 199
			-- upvalues: v46 (copy)
			return v46(p12).idList
		end, shallowArrayEquals),
		getDisplayFromId = function(s3: string?, p13) -- line: 207
			-- upvalues: v46 (copy), t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy), buildRowDisplay (copy), resolveForRowSpec (copy), p5 (copy)
			if s3 == nil then
				return nil
			end

			local v69 = v46(false).idToHandle[s3]

			if v69 == nil then
				return nil
			end

			local messageId = v69.messageId
			local v71 = t9[messageId]

			if v71 == nil then
				v71 = Signals.createComputed(function(p14) -- line: 152
					-- upvalues: GetConversationMessageStore (copy), messageId (copy), t1 (copy), classifyMessage (copy)
					local v78 = GetConversationMessageStore(p14).getMessage(messageId, p14)

					if v78 == nil then
						return t1
					end

					return classifyMessage(v78)
				end)
				t9[messageId] = v71
			end

			local v72 = v71(p13)[v69.rowIndex]

			if v72 == nil then
				return nil
			end

			return buildRowDisplay(v72, resolveForRowSpec(v72, p13), p5)
		end
	}
end

return createMessageDisplayStore
