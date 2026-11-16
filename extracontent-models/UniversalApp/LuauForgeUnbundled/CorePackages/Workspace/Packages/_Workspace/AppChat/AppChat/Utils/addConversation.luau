local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Immutable

return function(p2, data)
	if data.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
		local idForFakeOneOnOne = Conversation.IdForFakeOneOnOne(data.participants)

		if p2[idForFakeOneOnOne] ~= nil then
			p2 = immutable.Set(p2, idForFakeOneOnOne, nil)
		end
	end

	if p2[data.id] then
		return p2
	end

	return immutable.Set(p2, data.id, data)
end
