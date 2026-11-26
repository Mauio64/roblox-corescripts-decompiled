require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore/createMessageReactionsStore")

local function removeViewer(reaction, p2)
	local clone = table.clone(reaction)
	clone.count = reaction.count - 1
	clone.has_user_reacted = false

	local reactions_page = reaction.reactions_page

	if reactions_page == nil then
		return clone
	end

	local reactors = {}

	for k, reactor in reactions_page.reactors do
		if reactor.user_id ~= p2 then
			table.insert(reactors, reactor)
		end
	end

	local clone2 = table.clone(reactions_page)
	clone2.reactors = reactors
	clone.reactions_page = clone2

	return clone
end

local function addViewer(p2, p3)
	local clone = table.clone(p2)
	clone.count = p2.count + 1
	clone.has_user_reacted = true

	if p3 == nil then
		return clone
	end

	local reactions_page = p2.reactions_page
	local reactors = {
		{ user_id = p3 }
	}

	if reactions_page == nil then
		clone.reactions_page = { reactors = reactors }

		return clone
	end

	for k, reactor in reactions_page.reactors do
		table.insert(reactors, reactor)
	end

	local clone2 = table.clone(reactions_page)
	clone2.reactors = reactors
	clone.reactions_page = clone2
	return clone
end

local function applyPendingReaction(p2, p3)
	local pending = p2.pending

	if pending == nil then
		return p2.reactions
	end

	local emoteId = pending.emoteId

	local result = {}
	local v5 = false

	for k, reaction in p2.reactions do
		local v6 = reaction.emote_id == emoteId
		v5 = v6 and true or v5

		if reaction.has_user_reacted and not v6 then
			if reaction.count > 1 then
				table.insert(result, removeViewer(reaction, p3))
			end
		elseif v6 and not reaction.has_user_reacted then
			table.insert(result, addViewer(reaction, p3))
		else
			table.insert(result, reaction)
		end
	end

	if emoteId ~= nil and not v5 then
		table.insert(result, addViewer({ emote_id = emoteId, count = 0 }, p3))
	end

	return result
end

return applyPendingReaction
