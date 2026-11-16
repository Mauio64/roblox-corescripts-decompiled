local function isPartySystemMessage(p): boolean
	local cards = p.cards

	if type(cards) ~= "table" then
		return false
	end

	for _, card in cards do
		if not (type(card) == "table" and type(card.components) == "table") then
			continue
		end

		for _, component in card.components do
			if type(component) ~= "table" then
				continue
			end

			local kind = component.type

			if kind == "group_up" or kind == "scheduled_group_up" then
				return true
			end
		end
	end

	return false
end

local function getSystemMessageBody(p) -- 1 equivalent call inferred from this helper
	local cards = p.cards
	local v

	if type(cards) == "table" then
		v = cards[1]
	end

	if type(v) == "table" and type(v.alt_text) == "string" and v.alt_text ~= "" then
		return v.alt_text
	end

	return p.content or ""
end

local function classifySystemMessage(data) -- 1 equivalent call inferred from this helper
	return {
		kind = "systemMessage",
		body = getSystemMessageBody(data), -- inferred equivalent call
		variant = isPartySystemMessage(data) and "party" or "default"
	}
end

local function classifyMessage(data)
	if data.type == "system" or data.sender_user_id == nil then
		local v = classifySystemMessage(data) -- inferred equivalent call
		return { v }
	else
		local sender_user_id = data.sender_user_id

		local v = {}

		local replies_to = data.replies_to

		if type(replies_to) == "table" and replies_to.sender_user_id ~= nil then
			table.insert(v, {
				kind = "replyHeader",
				senderUserId = sender_user_id,
				repliedToUserId = replies_to.sender_user_id
			})
		end

		local status = data.status
		local moderated = status == "Moderated" or status == "Failed"

		if data.visibility == "hidden" then
			table.insert(v, { kind = "hiddenUser", senderUserId = sender_user_id })
		else
			table.insert(v, {
				kind = "userText",
				senderUserId = sender_user_id,
				body = data.content or "",
				moderated = moderated,
				messageId = data.id
			})
		end

		if moderated then
			table.insert(v, { kind = "moderationNotice" })
		end

		return v
	end
end

return classifyMessage
