local parent = script:FindFirstAncestor("ShareSheet").Parent

require(parent.AppChat.GetConversationListStore)
local ConversationUtils = {}

function ConversationUtils.getDisplayName(p)
	local titleForViewer = p.titleForViewer

	if titleForViewer and titleForViewer ~= "" then
		return titleForViewer
	end

	return p.title or ""
end

function ConversationUtils.getParticipantUserIds(p, p2: string)
	local participants = {}
	local participants2 = p.participants

	if participants2 then
		for _, participant in participants2 do
			if participant ~= p2 then
				table.insert(participants, participant)
			end
		end
	end

	local v = participants[1] or p2

	if #participants >= 2 then
		return v, participants[2]
	end

	return v, nil
end

return ConversationUtils
