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

local function shallowArrayEquals(t2: {[any]: any}?, t3: {[any]: any}?) -- line: 52
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
local function resolveProfileNameInfo(p1, p2) -- line: 70
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
local function resolveNameInfos(t4: {[any]: any}, p3) -- line: 98
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
local function createMessageDisplayStore(p4, s1: string?) -- line: 120
	-- upvalues: Signals (copy), GetConversationStore (copy), Conversation (copy), resolveNameInfos (copy), getLocalUserId (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy), shallowArrayEquals (copy), buildRowDisplay (copy)
	local t9 = {}
	local v42 = Signals.createComputed(function(p5) -- line: 126
		-- upvalues: s1 (copy), GetConversationStore (copy), Conversation (copy)
		if s1 == nil then
			return false
		end

		local v47 = GetConversationStore(p5).getConversation(s1, p5)

		return v47 ~= nil and v47.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)

	local function resolveForRowSpec(p6, p7) -- line: 135
		-- upvalues: resolveNameInfos (copy), getLocalUserId (copy), v42 (copy)
		if p6.kind == "userText" or p6.kind == "hiddenUser" then
			return {
				namesByUserId = resolveNameInfos({ p6.senderUserId }, p7)
			}
		end

		if p6.kind == "replyHeader" then
			return {
				namesByUserId = resolveNameInfos({
					p6.senderUserId,
					p6.repliedToUserId
				}, p7),
				localUserId = getLocalUserId(),
				isGroup = v42(p7)
			}
		end

		return {}
	end
	local function getMessageRowSpecs(s2: string) -- line: 149
		-- upvalues: t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy)
		local v51 = t9[s2]

		if v51 == nil then
			v51 = Signals.createComputed(function(p8) -- line: 152
				-- upvalues: GetConversationMessageStore (copy), s2 (copy), t1 (copy), classifyMessage (copy)
				local v74 = GetConversationMessageStore(p8).getMessage(s2, p8)

				if v74 == nil then
					return t1
				end

				return classifyMessage(v74)
			end)
			t9[s2] = v51
		end

		return v51
	end

	local v45 = Signals.createComputed(function(p9) -- line: 167
		-- upvalues: p4 (copy), t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy)
		local t10 = {}
		local n1 = 0

		for _, v56 in (p4(p9)) do
			local v57 = t9[v56]

			if v57 == nil then
				v57 = Signals.createComputed(function(p10) -- line: 152
					-- upvalues: GetConversationMessageStore (copy), v56 (copy), t1 (copy), classifyMessage (copy)
					local v76 = GetConversationMessageStore(p10).getMessage(v56, p10)

					if v76 == nil then
						return t1
					end

					return classifyMessage(v76)
				end)
				t9[v56] = v57
			end

			local v58 = #v57(p9)

			if v58 ~= 0 then
				if n1 + v58 > 50 then
					break
				end

				n1 += v58
				table.insert(t10, {
					sourceId = v56,
					count = v58
				})
			end
		end

		local t11 = {}
		local t12 = {}

		for i = #t10, 1, -1 do
			local v62 = t10[i]

			for j = 1, v62.count do
				local v64 = `{ v62.sourceId }_{ j }`

				table.insert(t11, v64)
				t12[v64] = {
					messageId = v62.sourceId,
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
		getDisplayIds = Signals.createComputed(function(p11) -- line: 199
			-- upvalues: v45 (copy)
			return v45(p11).idList
		end, shallowArrayEquals),
		getDisplayFromId = function(s3: string?, p12, p13) -- line: 207
			-- upvalues: v45 (copy), t9 (copy), Signals (copy), GetConversationMessageStore (copy), t1 (copy), classifyMessage (copy), buildRowDisplay (copy), resolveForRowSpec (copy)
			if s3 == nil then
				return nil
			end

			local v69 = v45(false).idToHandle[s3]

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

			local v72 = v71(p12)[v69.rowIndex]

			if v72 == nil then
				return nil
			end

			return buildRowDisplay(v72, resolveForRowSpec(v72, p12), p13 or {})
		end
	}
end

return createMessageDisplayStore
