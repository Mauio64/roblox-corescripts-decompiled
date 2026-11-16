require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetConversationListStore")

return {
	getDisplayName = function(p2)
		local titleForViewer = p2.titleForViewer

		if titleForViewer and titleForViewer ~= "" then
			return titleForViewer
		end

		return p2.title or ""
	end,
	getParticipantUserIds = function(p2, p3)
		local participants = {}
		local participants2 = p2.participants

		if participants2 then
			for k, participant in participants2 do
				if participant ~= p3 then
					table.insert(participants, participant)
				end
			end
		end

		local v5 = participants[1] or p3

		if #participants >= 2 then
			return v5, participants[2]
		end

		return v5, nil
	end
}
