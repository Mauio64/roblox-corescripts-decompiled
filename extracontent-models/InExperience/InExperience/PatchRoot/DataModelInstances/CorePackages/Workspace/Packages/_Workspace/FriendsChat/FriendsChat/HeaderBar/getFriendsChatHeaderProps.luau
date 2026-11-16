local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local function getParticipantUserIds(p)
	local participantUserIds = {}
	local participants = p.participants

	if participants == nil then
		return participantUserIds
	end

	for _, participant in participants do
		local v = tonumber(participant)

		if v ~= nil then
			table.insert(participantUserIds, v)
		end
	end

	return participantUserIds
end

local function getFriendsChatHeaderProps(p, _: number)
	return {
		participantUserIds = getParticipantUserIds(p),
		titleText = ExpChatConversationListAdapter.getConversationTitle(p)
	}
end

return getFriendsChatHeaderProps
