local function isPartySystemMessage(p1) -- line: 50
	local cards = p1.cards

	if type(cards) ~= "table" then
		return false
	end

	for _, v8 in cards do
		if type(v8) == "table" and type(v8.components) == "table" then
			for _, v10 in v8.components do
				if type(v10) ~= "table" then
					continue
				end

				local type2 = v10.type

				if type2 == "group_up" or type2 == "scheduled_group_up" then
					return true
				end
			end
		end
	end

	return false
end
local function getSystemMessageBody(p2) -- line: 74
	local cards = p2.cards
	local v14 = if type(cards) ~= "table" then nil else cards[1]

	if type(v14) == "table" and (type(v14.alt_text) == "string" and v14.alt_text ~= "") then
		return v14.alt_text
	end

	return p2.content or ""
end
local function classifySystemMessage(p3) -- line: 83
	-- upvalues: isPartySystemMessage (copy)
	local t1 = {
		kind = "systemMessage"
	}
	local cards = p3.cards
	local v18 = if type(cards) ~= "table" then nil else cards[1]

	t1.body = if type(v18) ~= "table" or (type(v18.alt_text) ~= "string" or v18.alt_text == "") then p3.content or "" else v18.alt_text
	t1.variant = not isPartySystemMessage(p3) and "default" or "party"

	return t1
end
local function classifyMessage(p4) -- line: 91
	-- upvalues: isPartySystemMessage (copy)
	if p4.type == "system" or p4.sender_user_id == nil then
		local t2 = {}
		local t3 = {
			kind = "systemMessage"
		}
		local cards = p4.cards
		local v23 = if type(cards) ~= "table" then nil else cards[1]

		t3.body = if type(v23) ~= "table" or (type(v23.alt_text) ~= "string" or v23.alt_text == "") then p4.content or "" else v23.alt_text
		t3.variant = not isPartySystemMessage(p4) and "default" or "party"
		t2[1] = t3

		return t2
	end

	local sender_user_id = p4.sender_user_id
	local t4 = {}
	local replies_to = p4.replies_to

	if type(replies_to) == "table" and replies_to.sender_user_id ~= nil then
		table.insert(t4, {
			kind = "replyHeader",
			senderUserId = sender_user_id,
			repliedToUserId = replies_to.sender_user_id
		})
	end

	local status = p4.status
	local v28 = status == "Moderated" or status == "Failed"

	if p4.visibility == "hidden" then
		table.insert(t4, {
			kind = "hiddenUser",
			senderUserId = sender_user_id
		})
	else
		table.insert(t4, {
			kind = "userText",
			senderUserId = sender_user_id,
			body = p4.content or "",
			moderated = v28
		})
	end

	if v28 then
		table.insert(t4, {
			kind = "moderationNotice"
		})
	end

	return t4
end

return classifyMessage
