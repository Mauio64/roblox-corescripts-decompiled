local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Conversation = require(AppChat.Models.Conversation)
local Immutable = require(AppChatParent.AppCommonLib).Immutable

return function(p1, p2) -- line: 8
	-- upvalues: Conversation (copy), Immutable (copy)
	if p2.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
		local v7 = Conversation.IdForFakeOneOnOne(p2.participants)

		if p1[v7] ~= nil then
			p1 = Immutable.Set(p1, v7, nil)
		end
	end

	if not p1[p2.id] then
		return Immutable.Set(p1, p2.id, p2)
	end

	return p1
end
