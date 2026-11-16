local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Conversation = require(AppChat.Models.Conversation)
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable

return function(p, data)
	if data.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
		local idForFakeOneOnOne = Conversation.IdForFakeOneOnOne(data.participants)

		if p[idForFakeOneOnOne] ~= nil then
			p = Immutable.Set(p, idForFakeOneOnOne, nil)
		end
	end

	if p[data.id] then
		return p
	end

	return Immutable.Set(p, data.id, data)
end
