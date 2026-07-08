local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local createProxy = require(Parent.SignalsExperimental).createProxy
local t1 = {
	oldestConversationIsFetched = false,
	isFetchingConversations = false,
	isFetchingNextPage = false,
	hasFetchedInitialPage = false,
	isExhausted = false,
	nextCursor = nil,
	error = nil
}
local t2 = {
	"oldestConversationIsFetched",
	"isFetchingConversations",
	"isFetchingNextPage",
	"hasFetchedInitialPage",
	"isExhausted",
	"nextCursor",
	"error"
}
local t3 = {}

for _, v8 in t2 do
	t3[v8] = true
end

local function normalizeConversation(p1) -- line: 96
	if p1 == nil or p1.id == nil then
		return nil
	end

	return {
		id = tostring(p1.id),
		source = p1.source,
		type = p1.type,
		createdAt = p1.createdAt,
		clientId = p1.clientId,
		initiator = p1.initiator,
		participants = p1.participants,
		conversationType = p1.conversationType,
		title = p1.title,
		titleForViewer = p1.titleForViewer,
		isDefaultTitle = p1.isDefaultTitle,
		lastUpdated = p1.lastUpdated,
		previewMessageId = p1.previewMessageId,
		previewContent = p1.previewContent,
		hasUnreadMessages = p1.hasUnreadMessages,
		hasGroupUp = p1.hasGroupUp,
		usersTyping = p1.usersTyping,
		isUserLeaving = p1.isUserLeaving,
		serverState = p1.serverState,
		pinnedGame = p1.pinnedGame,
		moderationType = p1.moderationType,
		userPendingStatus = p1.userPendingStatus,
		participantPendingStatus = p1.participantPendingStatus,
		osaAcknowledgementStatus = p1.osaAcknowledgementStatus,
		userOptedIntoChatMessages = p1.userOptedIntoChatMessages,
		initialLoadingStatus = p1.initialLoadingStatus
	}
end
local function mergePreservedLocalFields(t4: {[any]: any}?, t5: {[any]: any}) -- line: 131
	-- upvalues: Cryo (copy)
	if t4 == nil then
		return t5
	end

	return Cryo.Dictionary.join(t5, {
		usersTyping = t4.usersTyping,
		isUserLeaving = t4.isUserLeaving,
		pinnedGame = t4.pinnedGame
	})
end
local function copyListStatus(p2, p3) -- line: 143
	-- upvalues: t2 (copy)
	local t6 = {}
	local v20 = p2(p3)

	for _, v22 in t2 do
		t6[v22] = v20[v22]
	end

	return t6
end
local function clearProxy(p4) -- line: 152
	for v24 in p4 do
		p4[v24] = nil
	end
end
local function createConversationStore() -- line: 158
	-- upvalues: createProxy (copy), t1 (copy), t2 (copy), normalizeConversation (copy), Cryo (copy), t3 (copy)
	local v25 = createProxy({})
	local v26 = createProxy({})
	local v27 = createProxy(table.clone(t1))
	local t7 = {}

	return {
		getConversation = function(s1: string, p5) -- line: 166
			-- upvalues: v25 (copy)
			return v25(p5)[s1]
		end,
		getConversations = function(p6) -- line: 170
			-- upvalues: v25 (copy)
			local t8 = {}

			for _, v34 in (v25(p6)) do
				if v34 ~= nil then
					table.insert(t8, v34)
				end
			end

			return t8
		end,
		getParticipantMetadata = function(s2: string, p7) -- line: 180
			-- upvalues: v26 (copy)
			return v26(p7)[s2]
		end,
		getListStatus = function(p8) -- line: 184
			-- upvalues: v27 (copy), t2 (copy)
			local t9 = {}
			local v39 = v27(p8)

			for _, v41 in t2 do
				t9[v41] = v39[v41]
			end

			return t9
		end,
		listStatus = v27,
		addClearListener = function(p9: ((...any) -> ...any)) -- line: 227
			-- upvalues: t7 (copy)
			table.insert(t7, p9)
		end,
		upsertConversation = function(p10, b1: boolean?) -- line: 188
			-- upvalues: normalizeConversation (copy), v25 (copy), Cryo (copy)
			local v44 = normalizeConversation(p10)

			if v44 == nil then
				return
			end

			local id = v44.id
			local v46 = v25

			if b1 == false then
			else
				local v47 = v25[id]

				v44 = if v47 ~= nil then Cryo.Dictionary.join(v44, {
					usersTyping = v47.usersTyping,
					isUserLeaving = v47.isUserLeaving,
					pinnedGame = v47.pinnedGame
				}) else v44
			end

			v46[id] = v44
		end,
		removeConversation = function(s3: string) -- line: 200
			-- upvalues: v25 (copy), v26 (copy)
			v25[s3] = nil
			v26[s3] = nil
		end,
		setParticipantMetadata = function(s4: string, t10: {[any]: any}) -- line: 205
			-- upvalues: v26 (copy)
			v26[s4] = t10
		end,
		setUsersTyping = function(s5: string, t11: {[any]: any}) -- line: 209
			-- upvalues: v25 (copy), Cryo (copy)
			local v53 = v25[s5]

			if v53 == nil then
				return
			end

			v25[s5] = Cryo.Dictionary.join(v53, {
				usersTyping = t11
			})
		end,
		setListStatus = function(t12: {[any]: any}) -- line: 219
			-- upvalues: t3 (copy), v27 (copy), Cryo (copy)
			for v55, v56 in t12 do
				if t3[v55] == true then
					v27[v55] = if v56 ~= Cryo.None then v56 else nil
				end
			end
		end,
		clear = function() -- line: 231
			-- upvalues: v25 (copy), v26 (copy), v27 (copy), t1 (copy), t3 (copy), Cryo (copy), t7 (copy)
			local v58 = v25

			for v59 in v58 do
				v58[v59] = nil
			end

			local v60 = v26

			for v61 in v60 do
				v60[v61] = nil
			end

			local v62 = v27

			for v63 in v62 do
				v62[v63] = nil
			end

			for v64, v65 in t1 do
				if t3[v64] == true then
					v27[v64] = if v65 ~= Cryo.None then v65 else nil
				end
			end

			for _, v67 in t7 do
				v67()
			end
		end
	}
end

return createConversationStore
