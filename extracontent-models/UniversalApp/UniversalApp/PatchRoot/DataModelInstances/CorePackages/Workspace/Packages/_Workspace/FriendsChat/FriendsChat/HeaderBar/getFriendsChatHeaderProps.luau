local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local function getParticipantUserIds(t1: {[any]: any}) -- line: 24
	local t2 = {}
	local participants = t1.participants

	if participants == nil then
		return t2
	end

	for _, v8 in participants do
		local num = tonumber(v8)

		if num ~= nil then
			table.insert(t2, num)
		end
	end

	return t2
end
local function getFriendsChatHeaderProps(t3: {[any]: any}, _: number) -- line: 40
	-- upvalues: getParticipantUserIds (copy), ExpChatConversationListAdapter (copy)
	return {
		participantUserIds = getParticipantUserIds(t3),
		titleText = ExpChatConversationListAdapter.getConversationTitle(t3)
	}
end

return getFriendsChatHeaderProps
