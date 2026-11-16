return {
	extractFieldsFromUserEntry = function(p)
		if p then
			return {
				presence = p.presence and p.presence.userPresenceType or "",
				friendStatus = p.isFriend and "friend" or "notFriend",
				presenceUniverseId = (not p.presence or not p.presence.universeId or p.presence.universeId == "") and "-1" or p.presence.universeId
			}
		end

		return {}
	end
}
