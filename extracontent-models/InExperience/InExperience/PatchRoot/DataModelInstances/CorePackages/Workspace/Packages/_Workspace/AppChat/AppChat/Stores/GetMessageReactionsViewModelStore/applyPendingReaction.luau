local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.AppChatNetworking)

require(script.Parent.Parent.GetMessageReactionsStore.createMessageReactionsStore)

local function removeViewer(reaction, p: number?)
	local clone = table.clone(reaction)
	clone.count = reaction.count - 1
	clone.has_user_reacted = false

	local reactions_page = reaction.reactions_page

	if reactions_page == nil then
		return clone
	end

	local reactors = {}

	for _, reactor in reactions_page.reactors do
		if reactor.user_id ~= p then
			table.insert(reactors, reactor)
		end
	end

	local clone2 = table.clone(reactions_page)
	clone2.reactors = reactors
	clone.reactions_page = clone2

	return clone
end

local function addViewer(p, user_id: number?)
	local clone = table.clone(p)
	clone.count = p.count + 1
	clone.has_user_reacted = true

	if user_id == nil then
		return clone
	end

	local reactions_page = p.reactions_page
	local reactors = {
		{ user_id = user_id }
	}

	if reactions_page == nil then
		clone.reactions_page = { reactors = reactors }

		return clone
	end

	for _, reactor in reactions_page.reactors do
		table.insert(reactors, reactor)
	end

	local clone2 = table.clone(reactions_page)
	clone2.reactors = reactors
	clone.reactions_page = clone2
	return clone
end

local function applyPendingReaction(p, user_id: number?)
	local pending = p.pending

	if pending == nil then
		return p.reactions
	end

	local emoteId = pending.emoteId

	local result = {}
	local v = false

	for _, reaction in p.reactions do
		local v2 = reaction.emote_id == emoteId
		v = v2 and true or v

		if reaction.has_user_reacted and not v2 then
			if reaction.count > 1 then
				table.insert(result, removeViewer(reaction, user_id))
			end
		elseif v2 and not reaction.has_user_reacted then
			table.insert(result, addViewer(reaction, user_id))
		else
			table.insert(result, reaction)
		end
	end

	if emoteId ~= nil and not v then
		table.insert(result, addViewer({ emote_id = emoteId, count = 0 }, user_id))
	end

	return result
end

return applyPendingReaction
