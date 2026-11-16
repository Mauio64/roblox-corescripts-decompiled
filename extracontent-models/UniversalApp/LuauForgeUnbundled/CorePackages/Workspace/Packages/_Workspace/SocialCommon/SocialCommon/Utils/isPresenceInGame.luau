return function(p2): boolean
	if not p2 then
		return false
	end

	return p2.userPresenceType == "InGame" and p2.universeId ~= nil and p2.universeId ~= ""
end
