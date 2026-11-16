return {
	extractFieldsFromUserEntry = function(p2)
		if p2 then
			return {
				presence = p2.presence and p2.presence.userPresenceType or "",
				friendStatus = p2.isFriend and "friend" or "notFriend",
				presenceUniverseId = (not p2.presence or not p2.presence.universeId or p2.presence.universeId == "") and "-1" or p2.presence.universeId
			}
		end

		return {}
	end
}
