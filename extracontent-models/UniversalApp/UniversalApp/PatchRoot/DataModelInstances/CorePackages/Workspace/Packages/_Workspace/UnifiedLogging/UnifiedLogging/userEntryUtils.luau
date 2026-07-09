return {
	extractFieldsFromUserEntry = function(p1) -- line: 7
		if not p1 then
			return {}
		end

		local v2 = p1.presence and p1.presence.userPresenceType or ""
		local v3 = not p1.isFriend and "notFriend" or "friend"
		local v4 = (not p1.presence or (not p1.presence.universeId or p1.presence.universeId == "")) and "-1" or p1.presence.universeId

		return {
			presence = v2,
			friendStatus = v3,
			presenceUniverseId = v4
		}
	end
}
